Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab2KCK7B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 06:59:01 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:11958
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753398Ab2KCK6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 06:58:52 -0400
X-IronPort-AV: E=Sophos;i="4.80,705,1344204000"; 
   d="scan'208";a="161245672"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Arnd Bergmann <arnd@arndb.de>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 11/16] drivers/misc/kgdbts.c: use WARN
Date: Sat,  3 Nov 2012 11:58:32 +0100
Message-Id: <1351940317-14812-12-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use WARN rather than printk followed by WARN_ON(1), for conciseness.

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression list es;
@@

-printk(
+WARN(1,
  es);
-WARN_ON(1);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/misc/kgdbts.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index 3aa9a96..8b367db 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -114,9 +114,8 @@
 		touch_nmi_watchdog();	\
 	} while (0)
 #define eprintk(a...) do { \
-		printk(KERN_ERR a); \
-		WARN_ON(1); \
-	} while (0)
+		WARN(1, KERN_ERR a); \
+		} while (0)
 #define MAX_CONFIG_LEN		40
 
 static struct kgdb_io kgdbts_io_ops;

