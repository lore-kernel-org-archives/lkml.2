Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab0IMUPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:15:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:39660 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab0IMUOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:14:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,360,1280732400"; 
   d="scan'208";a="656856272"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Florian Mickler <florian@mickler.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 1/5] Disallow building with gcc < 3.4
Date: Mon, 13 Sep 2010 13:14:36 -0700
Message-Id: <1284408880-14414-2-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284408880-14414-1-git-send-email-hpa@linux.intel.com>
References: <1284408880-14414-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disallow building the generic kernel code with gcc < 3.4.  Earlier
versions of gcc have known problems, and it appears that anyone who
genuinely needs gcc 3.x can use gcc 3.4 at this point.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/Changes         |    2 +-
 include/linux/compiler-gcc3.h |   15 +--------------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/Documentation/Changes b/Documentation/Changes
index 4fb88f1..0ea8040 100644
--- a/Documentation/Changes
+++ b/Documentation/Changes
@@ -28,7 +28,7 @@ necessary on all systems; obviously, if you don't have any ISDN
 hardware, for example, you probably needn't concern yourself with
 isdn4k-utils.
 
-o  Gnu C                  3.2                     # gcc --version
+o  Gnu C                  3.4                     # gcc --version
 o  Gnu make               3.80                    # make --version
 o  binutils               2.12                    # ld -v
 o  util-linux             2.10o                   # fdformat --version
diff --git a/include/linux/compiler-gcc3.h b/include/linux/compiler-gcc3.h
index b721129..c11d443 100644
--- a/include/linux/compiler-gcc3.h
+++ b/include/linux/compiler-gcc3.h
@@ -2,25 +2,12 @@
 #error "Please don't include <linux/compiler-gcc3.h> directly, include <linux/compiler.h> instead."
 #endif
 
-#if __GNUC_MINOR__ < 2
+#if __GNUC_MINOR__ < 4
 # error Sorry, your compiler is too old - please upgrade it.
 #endif
 
-#if __GNUC_MINOR__ >= 3
 # define __used			__attribute__((__used__))
-#else
-# define __used			__attribute__((__unused__))
-#endif
-
-#if __GNUC_MINOR__ >= 4
 #define __must_check		__attribute__((warn_unused_result))
-#endif
-
-#ifdef CONFIG_GCOV_KERNEL
-# if __GNUC_MINOR__ < 4
-#   error "GCOV profiling support for gcc versions below 3.4 not included"
-# endif /* __GNUC_MINOR__ */
-#endif /* CONFIG_GCOV_KERNEL */
 
 /*
  * A trick to suppress uninitialized variable warning without generating any
-- 
1.7.2.1

