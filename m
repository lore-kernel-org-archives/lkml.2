Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab2L2Nny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 08:43:54 -0500
Received: from ampleforth.srv.alexanderweb.de ([89.238.79.244]:44437 "EHLO
	ampleforth.srv.alexanderweb.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752916Ab2L2Nnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 08:43:53 -0500
X-Greylist: delayed 1038 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Dec 2012 08:43:52 EST
Message-ID: <50DEEF81.40008@alexanderweb.de>
Date: Sat, 29 Dec 2012 14:26:25 +0100
From: Alexander Schremmer <alex@alexanderweb.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] sound: Add support for Creative BT-D1 via usb sound quirks
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Schremmer <alex@alexanderweb.de>

Support the Creative BT-D1 Bluetooth USB audio device. Before this
patch, Linux had trouble finding the correct USB descriptors and bailed
out with these messages:

 no or invalid class specific endpoint descriptor

Now it still prints these messages on hotplug:

 snd-usb-audio: probe of ...:1.0 failed with error -5
 snd-usb-audio: probe of ...:1.2 failed with error -5
 snd-usb-audio: probe of ...:1.3 failed with error -5

But the device works correctly, including the HID support.

The patch is diff'ed against 3.8-rc1 but should apply to older kernels
as well.

Signed-off-by: Alexander Schremmer <alex@alexanderweb.de>

---
diff -uprN linux-3.8-rc1/sound/usb/quirks-table.h
linux-3.8-rc1-mod/sound/usb/quirks-table.h
--- linux-3.8-rc1/sound/usb/quirks-table.h      2012-12-22
02:19:00.000000000 +0100
+++ linux-3.8-rc1-mod/sound/usb/quirks-table.h  2012-12-26
11:41:28.000000000 +0100
@@ -50,6 +50,28 @@
        }
 },

+{
+       /* Creative BT-D1 */
+       USB_DEVICE(0x041e, 0x0005),
+       .driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+               .ifnum = 1,
+               .type = QUIRK_AUDIO_FIXED_ENDPOINT,
+               .data = &(const struct audioformat) {
+                       .formats = SNDRV_PCM_FMTBIT_S16_LE,
+                       .channels = 2,
+                       .iface = 1,
+                       .altsetting = 1,
+                       .altset_idx = 1,
+                       .endpoint = 0x03,
+                       .ep_attr = USB_ENDPOINT_XFER_ISOC,
+                       .attributes = 0,
+                       .rates = SNDRV_PCM_RATE_CONTINUOUS,
+                       .rate_min = 48000,
+                       .rate_max = 48000,
+               }
+       }
+},
+
 /* Creative/Toshiba Multimedia Center SB-0500 */
 {
        USB_DEVICE(0x041e, 0x3048),
