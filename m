Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab2JKAOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:14:05 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49008 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757956Ab2JKANz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:13:55 -0400
X-Sasl-enc: 95biG+3oxCgKcviozUkl0yu2nWgxgpEK9wjcrDIG2SuO 1349914434
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Marko Friedemann <mfr@bmx-chemnitz.de>, Takashi Iwai <tiwai@suse.de>
Subject: [ 091/133] ALSA: USB: Support for (original) Xbox Communicator
Date: Thu, 11 Oct 2012 07:51:57 +0900
Message-Id: <20121010224910.876338547@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marko Friedemann <mfr@bmx-chemnitz.de>

commit c05fce586d4da2dfe0309bef3795a8586e967bc3 upstream.

Added support for Xbox Communicator to USB quirks.

Signed-off-by: Marko Friedemann <mfr@bmx-chemnitz.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks-table.h |   53 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2781,6 +2781,59 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 
+/* Microsoft XboxLive Headset/Xbox Communicator */
+{
+	USB_DEVICE(0x045e, 0x0283),
+	.bInterfaceClass = USB_CLASS_PER_INTERFACE,
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.vendor_name = "Microsoft",
+		.product_name = "XboxLive Headset/Xbox Communicator",
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = &(const struct snd_usb_audio_quirk[]) {
+			{
+				/* playback */
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S16_LE,
+					.channels = 1,
+					.iface = 0,
+					.altsetting = 0,
+					.altset_idx = 0,
+					.attributes = 0,
+					.endpoint = 0x04,
+					.ep_attr = 0x05,
+					.rates = SNDRV_PCM_RATE_CONTINUOUS,
+					.rate_min = 22050,
+					.rate_max = 22050
+				}
+			},
+			{
+				/* capture */
+				.ifnum = 1,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S16_LE,
+					.channels = 1,
+					.iface = 1,
+					.altsetting = 0,
+					.altset_idx = 0,
+					.attributes = 0,
+					.endpoint = 0x85,
+					.ep_attr = 0x05,
+					.rates = SNDRV_PCM_RATE_CONTINUOUS,
+					.rate_min = 16000,
+					.rate_max = 16000
+				}
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
+
 {
 	/*
 	 * Some USB MIDI devices don't have an audio control interface,


