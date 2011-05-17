Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab1EQQxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 12:53:54 -0400
Received: from mail.bisel.ru ([80.93.56.210]:47906 "EHLO mail.bisel.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317Ab1EQQxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 12:53:52 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 May 2011 12:53:52 EDT
X-Envelope-Recipient: linux-media@vger.kernel.org
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.bisel.ru 36D0F47DB6D
X-Envelope-Recipient: linux-kernel@vger.kernel.org
Message-ID: <4DD2A66C.3070006@novg.net>
Date: Tue, 17 May 2011 20:46:36 +0400
From: Igor Novgorodov <igor@novg.net>
Reply-To: igor@novg.net
Organization: Home
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] cx231xx: Add support for Iconbit U100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Igor Novgorodov <igor@novg.net>

This patch adds support for the "Iconbit Analog Stick U100 FM".
Only composite & s-video inputs, no tuner support now.

Signed-off-by: Igor Novgorodov <igor@novg.net>
---

--- linux-2.6.38.6.orig/drivers/media/video/cx231xx/cx231xx-cards.c     2011-05-10 02:16:23.000000000 +0400
+++ linux-2.6.38.6/drivers/media/video/cx231xx/cx231xx-cards.c          2011-05-17 12:03:11.410810992 +0400
@@ -435,7 +435,33 @@ struct cx231xx_board cx231xx_boards[] =
                         .gpio = 0,
                 } },
         },
+
+       [CX231XX_BOARD_ICONBIT_U100] = {
+               .name = "Iconbit Analog Stick U100 FM",
+               .tuner_type = TUNER_ABSENT,
+               .decoder = CX231XX_AVDECODER,
+               .output_mode = OUT_MODE_VIP11,
+               .demod_xfer_mode = 0,
+               .ctl_pin_status_mask = 0xFFFFFFC4,
+               .agc_analog_digital_select_gpio = 0x1C,
+               .gpio_pin_status_mask = 0x4001000,
+
+               .input = {{
+                       .type = CX231XX_VMUX_COMPOSITE1,
+                       .vmux = CX231XX_VIN_2_1,
+                       .amux = CX231XX_AMUX_LINE_IN,
+                       .gpio = NULL,
+               }, {
+                       .type = CX231XX_VMUX_SVIDEO,
+                       .vmux = CX231XX_VIN_1_1 |
+                               (CX231XX_VIN_1_2 << 8) |
+                               CX25840_SVIDEO_ON,
+                       .amux = CX231XX_AMUX_LINE_IN,
+                       .gpio = NULL,
+               } },
+       },
  };
+
  const unsigned int cx231xx_bcount = ARRAY_SIZE(cx231xx_boards);

  /* table of devices that work with this driver */
@@ -464,6 +490,8 @@ struct usb_device_id cx231xx_id_table[]
          .driver_info = CX231XX_BOARD_HAUPPAUGE_USBLIVE2},
         {USB_DEVICE_VER(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD, 0x4000, 0x4001),
          .driver_info = CX231XX_BOARD_PV_PLAYTV_USB_HYBRID},
+       {USB_DEVICE(0x1f4d, 0x0237),
+        .driver_info = CX231XX_BOARD_ICONBIT_U100},
         {},
  };

--- linux-2.6.38.6.orig/drivers/media/video/cx231xx/cx231xx.h   2011-05-10 02:16:23.000000000 +0400
+++ linux-2.6.38.6/drivers/media/video/cx231xx/cx231xx.h        2011-05-17 09:52:58.067471709 +0400
@@ -64,6 +64,7 @@
  #define CX231XX_BOARD_HAUPPAUGE_EXETER  8
  #define CX231XX_BOARD_HAUPPAUGE_USBLIVE2 9
  #define CX231XX_BOARD_PV_PLAYTV_USB_HYBRID 10
+#define CX231XX_BOARD_ICONBIT_U100 11

  /* Limits minimum and default number of buffers */
  #define CX231XX_MIN_BUF                 4


