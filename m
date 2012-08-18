Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab2HRRcX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:32:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:50329 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827Ab2HRRab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="210330068"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 22/31] sections: Fix section conflicts in drivers/net/hamradio
Date: Sat, 18 Aug 2012 10:30:13 -0700
Message-Id: <1345311022-26328-23-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/net/hamradio/6pack.c    |    2 +-
 drivers/net/hamradio/bpqether.c |    2 +-
 drivers/net/hamradio/mkiss.c    |    6 +++---
 drivers/net/hamradio/scc.c      |    2 +-
 drivers/net/hamradio/yam.c      |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index d225a2a..1450e33 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -829,7 +829,7 @@ static int __init sixpack_init_driver(void)
 	return status;
 }
 
-static const char msg_unregfail[] __exitdata = KERN_ERR \
+static const char msg_unregfail[] = KERN_ERR \
 	"6pack: can't unregister line discipline (err = %d)\n";
 
 static void __exit sixpack_exit_driver(void)
diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 76d5477..c2e5497 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -87,7 +87,7 @@
 
 #include <linux/bpqether.h>
 
-static const char banner[] __initdata = KERN_INFO \
+static const char banner[] __initconst = KERN_INFO \
 	"AX.25: bpqether driver version 004\n";
 
 static char bcast_addr[6]={0xFF,0xFF,0xFF,0xFF,0xFF,0xFF};
diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 2c0894a..8e01c45 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -997,9 +997,9 @@ static struct tty_ldisc_ops ax_ldisc = {
 	.write_wakeup	= mkiss_write_wakeup
 };
 
-static const char banner[] __initdata = KERN_INFO \
+static const char banner[] __initconst = KERN_INFO \
 	"mkiss: AX.25 Multikiss, Hans Albas PE1AYX\n";
-static const char msg_regfail[] __initdata = KERN_ERR \
+static const char msg_regfail[] __initconst = KERN_ERR \
 	"mkiss: can't register line discipline (err = %d)\n";
 
 static int __init mkiss_init_driver(void)
@@ -1015,7 +1015,7 @@ static int __init mkiss_init_driver(void)
 	return status;
 }
 
-static const char msg_unregfail[] __exitdata = KERN_ERR \
+static const char msg_unregfail[] = KERN_ERR \
 	"mkiss: can't unregister line discipline (err = %d)\n";
 
 static void __exit mkiss_exit_driver(void)
diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index efc6c97..1b4a47b 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -182,7 +182,7 @@
 
 #include "z8530.h"
 
-static const char banner[] __initdata = KERN_INFO \
+static const char banner[] __initconst = KERN_INFO \
 	"AX.25: Z8530 SCC driver version "VERSION".dl1bke\n";
 
 static void t_dwait(unsigned long);
diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 5a6412e..c6645f1 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -76,7 +76,7 @@
 /* --------------------------------------------------------------------- */
 
 static const char yam_drvname[] = "yam";
-static const char yam_drvinfo[] __initdata = KERN_INFO \
+static const char yam_drvinfo[] __initconst = KERN_INFO \
 	"YAM driver version 0.8 by F1OAT/F6FBB\n";
 
 /* --------------------------------------------------------------------- */
-- 
1.7.7.6

