Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab2KYQca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 11:32:30 -0500
Received: from bootes.telenet.ru ([94.31.183.22]:40399 "EHLO bootes"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753111Ab2KYQc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 11:32:28 -0500
X-Greylist: delayed 1526 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Nov 2012 11:32:28 EST
From: Alex Volkov <alex@bootes.telenet.ru>
To: linux-media@vger.kernel.org
Subject: [PATCH/RFC] remote control type initialization in saa7134-input.c
Date: Sun, 25 Nov 2012 22:06:56 +0600
User-Agent: KMail/1.13.7 (Linux/3.2.32-custom1-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, michael@mihu.de,
        Jonathan Nieder <jrnieder@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201211252206.57134.alex@bootes.telenet.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function saa7134_probe_i2c_ir(..) in saa7134-input.c does not set any RC type
for Pinnacle PCTV 110i (and perhaps other) remote controls. For some other RCs
the setting (assinging some value to "type" member of the device structure)
is done either in this function or elsewhere (AFAIR), but not for PCTV.

This renders PCTV's remote control unavailable as input device in all kernels
since 2.6.37 to the 3.2.32 at least (which I tested), and I believe this
remains this way in current 3.6.x too.

The patch attached here (made against 3.2.32) puts RC's type initialization
(to RC_TYPE_OTHER) before board type testing "switch". (Perhaps, putting it
to 110i's "case" would be more correct, but it seem to work anyway.)

Signed-off-by: Alex Volkov <alex@bootes.telenet.ru>

--- 
--- a/drivers/media/video/saa7134/saa7134-input.c	2012-10-17 08:50:15.000000000 +0600
+++ b/drivers/media/video/saa7134/saa7134-input.c	2012-11-25 21:49:42.000000000 +0600
@@ -858,6 +858,7 @@ void saa7134_probe_i2c_ir(struct saa7134
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	memset(&dev->init_data, 0, sizeof(dev->init_data));
 	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
+	dev->init_data.type = RC_TYPE_OTHER;
 
 	switch (dev->board) {
 	case SAA7134_BOARD_PINNACLE_PCTV_110i:
