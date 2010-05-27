Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869Ab0E0LmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 07:42:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65363 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933763Ab0E0LmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 07:42:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ng+t3d1qNrMQWUEKimGxM0Hu53wG/1ObExDlmPvJiQ8WhmPToAakx6p3f07qhlpOvu
         sUn/2KsjZKZHpBZDcYWWhntfL+4y0u/oeKybbCYSq7P8wBvhDk5p+FhaoRiBMQFHo50p
         QRxG+sL0BV40QOtmpK1/yLqYdX0wr2Cp9UhCA=
From: John Sheehan <john.d.sheehan@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, julia@diku.dk, tj@kernel.org,
       john.d.sheehan@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: fix code style errors in unioxx5.c
Date: Thu, 27 May 2010 12:41:38 +0100
Message-Id: <1274960498-29801-1-git-send-email-john.d.sheehan@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Sheehan <john.d.sheehan@gmail.com>

A patch for unioxx5.c which fixes "trailing statements
should be on next line" errors raised by the
chechpatch.pl tool

Signed-off-by: John Sheehan <john.d.sheehan@gmail.com>
---
 drivers/staging/comedi/drivers/unioxx5.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 16d4c9f..d5f6d75 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -302,7 +302,8 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 		__unioxx5_analog_config(usp, i * 2);
 		outb(i + 1, subdev_iobase + 5);	/* sends channel number to card */
 		outb('H', subdev_iobase + 6);	/* requests EEPROM world */
-		while (!(inb(subdev_iobase + 0) & TxBE)) ;	/* waits while writting will be allowed */
+		while (!(inb(subdev_iobase + 0) & TxBE))
+			;	/* waits while writting will be allowed */
 		outb(0, subdev_iobase + 6);
 
 		/* waits while reading of two bytes will be allowed */
@@ -437,7 +438,8 @@ static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
 
 	/* sending for bytes to module(one byte per cycle iteration) */
 	for (i = 0; i < 4; i++) {
-		while (!((inb(usp->usp_iobase + 0)) & TxBE)) ;	/* waits while writting will be allowed */
+		while (!((inb(usp->usp_iobase + 0)) & TxBE))
+			;	/* waits while writting will be allowed */
 		outb(usp->usp_extra_data[module][i], usp->usp_iobase + 6);
 	}
 
@@ -467,7 +469,8 @@ static int __unioxx5_analog_read(struct unioxx5_subd_priv *usp,
 	control = inb(usp->usp_iobase);	/* get control register byte */
 
 	/* waits while reading four bytes will be allowed */
-	while (!((control = inb(usp->usp_iobase + 0)) & Rx4CA)) ;
+	while (!((control = inb(usp->usp_iobase + 0)) & Rx4CA))
+		;
 
 	/* if four bytes readding error occurs - return 0(false) */
 	if ((control & Rx4CA_ERR_MASK)) {
-- 
1.7.0.4

