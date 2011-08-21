Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab1HUW6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 18:58:49 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:52969 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932077Ab1HUW6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 18:58:43 -0400
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/14] [media] winbond-cir: Use current logging styles
Date: Sun, 21 Aug 2011 15:56:47 -0700
Message-Id: <90e0dd84ad9404a4d6377d05a86c9ae60918ccda.1313966089.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1313966088.git.joe@perches.com>
References: <cover.1313966088.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pr_fmt, convert printks to pr_<level>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/rc/winbond-cir.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index bec8abc..13f54b5 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -41,6 +41,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/pnp.h>
 #include <linux/interrupt.h>
@@ -1155,12 +1157,12 @@ wbcir_init(void)
 	case IR_PROTOCOL_RC6:
 		break;
 	default:
-		printk(KERN_ERR DRVNAME ": Invalid power-on protocol\n");
+		pr_err("Invalid power-on protocol\n");
 	}
 
 	ret = pnp_register_driver(&wbcir_driver);
 	if (ret)
-		printk(KERN_ERR DRVNAME ": Unable to register driver\n");
+		pr_err("Unable to register driver\n");
 
 	return ret;
 }
-- 
1.7.6.405.gc1be0

