Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab2JRTur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:50:47 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:35687 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab2JRTuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:50:22 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 3/3] kconfig: get CONFIG_ prefix from the environment
Date: Thu, 18 Oct 2012 21:50:16 +0200
Message-Id: <1350589816-20447-4-git-send-email-yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1350589816-20447-1-git-send-email-yann.morin.1998@free.fr>
References: <1350589816-20447-1-git-send-email-yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the CONFIG_ prefix is hard-coded in the kconfig frontends
executables. This means that two projects that use kconfig with
different prefixes can not share the same kconfig frontends.

Instead of hard-coding the prefix in the frontends, get it from the
environment, and revert back to hard-coded value if not found.

Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
---
 scripts/kconfig/gconf.c |    2 +-
 scripts/kconfig/lkc.h   |    2 +-
 scripts/kconfig/nconf.c |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index adc2306..f2bee70 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -10,6 +10,7 @@
 #  include <config.h>
 #endif
 
+#include <stdlib.h>
 #include "lkc.h"
 #include "images.c"
 
@@ -22,7 +23,6 @@
 #include <string.h>
 #include <unistd.h>
 #include <time.h>
-#include <stdlib.h>
 
 //#define DEBUG
 
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index 25862fd..2faf8ac 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -41,7 +41,7 @@ extern "C" {
 #define __stringify(x...)	__stringify_1(x)
 static inline const char *CONFIG_prefix(void)
 {
-	return __stringify(CONFIG_);
+	return getenv( "CONFIG_" ) ?: __stringify(CONFIG_);
 }
 #ifdef CONFIG_
 #undef CONFIG_
diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 261f926..ce93e87 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -7,6 +7,7 @@
  */
 #define _GNU_SOURCE
 #include <string.h>
+#include <stdlib.h>
 
 #include "lkc.h"
 #include "nconf.h"
-- 
1.7.2.5

