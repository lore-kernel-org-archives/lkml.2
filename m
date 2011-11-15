Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab1KOHyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 02:54:12 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:58463 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446Ab1KOHyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 02:54:06 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        usb-storage@lists.one-eyed-alien.net,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 10/13] usb: storagE: realtek_cr: fix sparse warnings
Date: Tue, 15 Nov 2011 09:53:37 +0200
Message-Id: <1321343620-10794-11-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1321343620-10794-1-git-send-email-balbi@ti.com>
References: <1321343620-10794-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warnings:

| drivers/usb/storage/realtek_cr.c:821:6: warning: symbol
|	'rts51x_invoke_transport' was not declared. Should
|	it be static?
|
| drivers/usb/storage/realtek_cr.c:980:5: warning: symbol
|	'realtek_cr_suspend' was not declared. Should it
|	be static?
|
| drivers/usb/storage/realtek_cr.c:518:23: warning: cast
|	truncates bits from constant value (fe47 becomes 47)

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/storage/realtek_cr.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index 0ce5f79..30f64bf 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -507,15 +507,14 @@ static int enable_oscillator(struct us_data *us)
 static int __do_config_autodelink(struct us_data *us, u8 *data, u16 len)
 {
 	int retval;
-	u16 addr = 0xFE47;
 	u8 cmnd[12] = {0};
 
-	US_DEBUGP("%s, addr = 0x%x, len = %d\n", __FUNCTION__, addr, len);
+	US_DEBUGP("%s, addr = 0xfe47, len = %d\n", __FUNCTION__, len);
 
 	cmnd[0] = 0xF0;
 	cmnd[1] = 0x0E;
-	cmnd[2] = (u8)(addr >> 8);
-	cmnd[3] = (u8)addr;
+	cmnd[2] = 0xfe;
+	cmnd[3] = 0x47;
 	cmnd[4] = (u8)(len >> 8);
 	cmnd[5] = (u8)len;
 
@@ -818,7 +817,7 @@ static inline int working_scsi(struct scsi_cmnd *srb)
 	return 1;
 }
 
-void rts51x_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
+static void rts51x_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 {
 	struct rts51x_chip *chip = (struct rts51x_chip *)(us->extra);
 	static int card_first_show = 1;
@@ -977,7 +976,7 @@ static void realtek_cr_destructor(void *extra)
 }
 
 #ifdef CONFIG_PM
-int realtek_cr_suspend(struct usb_interface *iface, pm_message_t message)
+static int realtek_cr_suspend(struct usb_interface *iface, pm_message_t message)
 {
 	struct us_data *us = usb_get_intfdata(iface);
 
-- 
1.7.8.rc0

