Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983Ab2EISna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 14:43:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:18662 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757970Ab2EISn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 14:43:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98208712"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@kernel.org, tglx@linutronix.de
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, joerg.roedel@amd.com,
        paul.gortmaker@windriver.com
Subject: [PATCH 1/2] kconfig: change config_enabled() to accept X instead of CONFIG_X
Date: Wed,  9 May 2012 11:46:35 -0700
Message-Id: <1336589196-14498-1-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <20120509093001.GD8585@gmail.com>
References: <20120509093001.GD8585@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change config_enabled() to use it as config_enabled(SMP) instead of
config_enabled(CONFIG_SMP).

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/kconfig.h |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/kconfig.h b/include/linux/kconfig.h
index be342b9..54c1c4e 100644
--- a/include/linux/kconfig.h
+++ b/include/linux/kconfig.h
@@ -17,10 +17,11 @@
  * the last step cherry picks the 2nd arg, we get a zero.
  */
 #define __ARG_PLACEHOLDER_1 0,
-#define config_enabled(cfg) _config_enabled(cfg)
-#define _config_enabled(value) __config_enabled(__ARG_PLACEHOLDER_##value)
-#define __config_enabled(arg1_or_junk) ___config_enabled(arg1_or_junk 1, 0)
-#define ___config_enabled(__ignored, val, ...) val
+#define config_enabled(cfg)	_config_enabled(CONFIG_##cfg)
+#define _config_enabled(cfg)	__config_enabled(cfg)
+#define __config_enabled(value) ___config_enabled(__ARG_PLACEHOLDER_##value)
+#define ___config_enabled(arg1_or_junk) ____config_enabled(arg1_or_junk 1, 0)
+#define ____config_enabled(__ignored, val, ...) val
 
 /*
  * IS_ENABLED(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y' or 'm',
@@ -28,19 +29,19 @@
  *
  */
 #define IS_ENABLED(option) \
-	(config_enabled(option) || config_enabled(option##_MODULE))
+	(_config_enabled(option) || _config_enabled(option##_MODULE))
 
 /*
  * IS_BUILTIN(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y', 0
  * otherwise. For boolean options, this is equivalent to
  * IS_ENABLED(CONFIG_FOO).
  */
-#define IS_BUILTIN(option) config_enabled(option)
+#define IS_BUILTIN(option) _config_enabled(option)
 
 /*
  * IS_MODULE(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'm', 0
  * otherwise.
  */
-#define IS_MODULE(option) config_enabled(option##_MODULE)
+#define IS_MODULE(option) _config_enabled(option##_MODULE)
 
 #endif /* __LINUX_KCONFIG_H */
-- 
1.7.6.5

