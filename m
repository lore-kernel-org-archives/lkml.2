Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab2BAVig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:38:36 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44320 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757255Ab2BAVJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:49 -0500
X-Sasl-enc: 6TCz4KUmZFYvf4q9V41UH+DXIrHZ97yfEfmxCFJzsr6y 1328130588
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:46 2012
Message-Id: <20120201210046.302553458@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Gustavo Maciel Dias Vieira <gustavo@sagui.org>,
        Predrag Ivanovic <predivan@open.telekom.rs>,
        Takashi Iwai <tiwai@suse.de>
Subject: [27/89] ALSA: hda: set mute led polarity for laptops with buggy BIOS based on SSID
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Maciel Dias Vieira <gustavo@sagui.org>

commit a6a600d10aaddf1da38053c4c6b64f50f56176e6 upstream.

HP laptop models with buggy BIOS are apparently frequent, including
machines with different codecs. Set the polarity of the mute led based
on the SSID and include an entry for the HP Mini 110-3100.

Signed-off-by: Gustavo Maciel Dias Vieira <gustavo@sagui.org>
Tested-by: Predrag Ivanovic <predivan@open.telekom.rs>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_sigmatel.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4952,7 +4952,14 @@ static int find_mute_led_gpio(struct hda
 			/* BIOS bug: unfilled OEM string */
 			if (strstr(dev->name, "HP_Mute_LED_P_G")) {
 				set_hp_led_gpio(codec);
-				spec->gpio_led_polarity = 1;
+				switch (codec->subsystem_id) {
+				case 0x103c148a:
+					spec->gpio_led_polarity = 0;
+					break;
+				default:
+					spec->gpio_led_polarity = 1;
+					break;
+				}
 				return 1;
 			}
 		}


