Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581Ab0JUPJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:09:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34986 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758392Ab0JUPJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:09:52 -0400
From: =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@gmail.com>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Cc: David Henningsson <david.henningsson@canonical.com>
Subject: [PATCH] ALSA: HDA: Enable internal mic on Dell E6410 and Dell E6510
Date: Thu, 21 Oct 2010 17:09:49 +0200
Message-Id: <1287673789-13915-1-git-send-email-flameeyes@gmail.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1285726141-26448-2-git-send-email-flameeyes@gmail.com>
References: <1285726141-26448-2-git-send-email-flameeyes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Henningsson <david.henningsson@canonical.com>

(Ported on top of 2.6.36)

BugLink: http://launchpad.net/bugs/628961
BugLink: http://launchpad.net/bugs/605047

CC: Diego Elio Pettenò <flameeyes@gmail.com>
---
 sound/pci/hda/patch_sigmatel.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index c16c5ba..be79c3c 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1633,6 +1633,13 @@ static unsigned int dell_s14_pin_configs[10] = {
 	0x40f000f0, 0x40f000f0,
 };
 
+/* Deliberately turn off 0x0f (Dock Mic) to make it choose Int Mic instead */
+static unsigned int dell_e6410_pin_configs[10] = {
+	0x04a11020, 0x0421101f, 0x400000f0, 0x90170110,
+	0x23011050, 0x40f000f0, 0x400000f0, 0x90a60130,
+	0x40f000f0, 0x40f000f0,
+};
+
 static unsigned int hp_dv7_4000_pin_configs[10] = {
 	0x03a12050, 0x0321201f, 0x40f000f0, 0x90170110,
 	0x40f000f0, 0x40f000f0, 0x90170110, 0xd5a30140,
@@ -1643,6 +1650,7 @@ static unsigned int *stac92hd83xxx_brd_tbl[STAC_92HD83XXX_MODELS] = {
 	[STAC_92HD83XXX_REF] = ref92hd83xxx_pin_configs,
 	[STAC_92HD83XXX_PWR_REF] = ref92hd83xxx_pin_configs,
 	[STAC_DELL_S14] = dell_s14_pin_configs,
+	[STAC_DELL_E6410] = dell_e6410_pin_configs,
 	[STAC_HP_DV7_4000] = hp_dv7_4000_pin_configs,
 };
 
@@ -1651,6 +1659,7 @@ static const char *stac92hd83xxx_models[STAC_92HD83XXX_MODELS] = {
 	[STAC_92HD83XXX_REF] = "ref",
 	[STAC_92HD83XXX_PWR_REF] = "mic-ref",
 	[STAC_DELL_S14] = "dell-s14",
+	[STAC_DELL_E6410] = "dell-e6410",
 	[STAC_92HD83XXX_HP] = "hp",
 	[STAC_HP_DV7_4000] = "hp-dv7-4000",
 };
@@ -1663,6 +1672,10 @@ static struct snd_pci_quirk stac92hd83xxx_cfg_tbl[] = {
 		      "DFI LanParty", STAC_92HD83XXX_REF),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02ba,
 		      "unknown Dell", STAC_DELL_S14),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x040a,
+		      "Dell E6410", STAC_DELL_E6410),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x040b,
+		      "Dell E6510", STAC_DELL_E6410),
 	SND_PCI_QUIRK_MASK(PCI_VENDOR_ID_HP, 0xff00, 0x3600,
 		      "HP", STAC_92HD83XXX_HP),
 	{} /* terminator */
-- 
1.7.3.1

