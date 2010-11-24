Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab0KXI6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:58:11 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57863 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab0KXI6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:58:02 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, kernel@pengutronix.de,
        Arjan van de Ven <arjan@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6/6] tty/vt: add some KERN_CONT markers to continuation lines
Date: Wed, 24 Nov 2010 09:57:50 +0100
Message-Id: <1290589070-854-6-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20101124085645.GW4693@pengutronix.de>
References: <20101124085645.GW4693@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/tty/vt/vt.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index a8ec48e..e4b05ad 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2930,11 +2930,11 @@ static int __init con_init(void)
 	gotoxy(vc, vc->vc_x, vc->vc_y);
 	csi_J(vc, 0);
 	update_screen(vc);
-	printk("Console: %s %s %dx%d",
+	printk(KERN_DEFAULT "Console: %s %s %dx%d",
 		vc->vc_can_do_color ? "colour" : "mono",
 		display_desc, vc->vc_cols, vc->vc_rows);
 	printable = 1;
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	release_console_sem();
 
@@ -3084,11 +3084,11 @@ static int bind_con_driver(const struct consw *csw, int first, int last,
 
 	printk("Console: switching ");
 	if (!deflt)
-		printk("consoles %d-%d ", first+1, last+1);
+		printk(KERN_CONT "consoles %d-%d ", first+1, last+1);
 	if (j >= 0) {
 		struct vc_data *vc = vc_cons[j].d;
 
-		printk("to %s %s %dx%d\n",
+		printk(KERN_CONT "to %s %s %dx%d\n",
 		       vc->vc_can_do_color ? "colour" : "mono",
 		       desc, vc->vc_cols, vc->vc_rows);
 
@@ -3097,7 +3097,7 @@ static int bind_con_driver(const struct consw *csw, int first, int last,
 			update_screen(vc);
 		}
 	} else
-		printk("to %s\n", desc);
+		printk(KERN_CONT "to %s\n", desc);
 
 	retval = 0;
 err:
-- 
1.7.2.3

