Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030450Ab2HGWdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:33:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54025 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030434Ab2HGWc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:32:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 114/122] ALSA: hda - Fix polarity of mute LED on HP Mini 210
Date: Tue,  7 Aug 2012 15:26:42 -0700
Message-Id: <20120807222000.326125448@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ff8a1e274cbc11da6b57849f925b895a212b56c9 upstream.

The commit a3e199732b made the LED working again on HP Mini 210 but
with a wrong polarity.  This patch fixes the polarity for this
machine, and also introduce a new model string "hp-inv-led".

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=772923

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_sigmatel.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -102,6 +102,7 @@ enum {
 	STAC_HP_DV7_4000,
 	STAC_HP_ZEPHYR,
 	STAC_92HD83XXX_HP_LED,
+	STAC_92HD83XXX_HP_INV_LED,
 	STAC_92HD83XXX_MODELS
 };
 
@@ -1677,6 +1678,7 @@ static const char * const stac92hd83xxx_
 	[STAC_HP_DV7_4000] = "hp-dv7-4000",
 	[STAC_HP_ZEPHYR] = "hp-zephyr",
 	[STAC_92HD83XXX_HP_LED] = "hp-led",
+	[STAC_92HD83XXX_HP_INV_LED] = "hp-inv-led",
 };
 
 static const struct snd_pci_quirk stac92hd83xxx_cfg_tbl[] = {
@@ -5561,6 +5563,9 @@ again:
 		spec->init = stac92hd83xxx_hp_zephyr_init;
 		break;
 	case STAC_92HD83XXX_HP_LED:
+		default_polarity = 0;
+		break;
+	case STAC_92HD83XXX_HP_INV_LED:
 		default_polarity = 1;
 		break;
 	}


