Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934529Ab2DLRzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 13:55:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108Ab2DLRzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 13:55:48 -0400
Date: Thu, 12 Apr 2012 13:55:36 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, Gabriel Somlo <somlo@cmu.edu>,
        linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org
Subject: [PATCH] ALSA: hda/realtek - Add quirk for Mac Pro 5,1 machines
Message-ID: <20120412175536.GB25425@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A user reported that setting model=imac24 used to allow sound to work on their
Mac Pro 5,1 machine.  Commit 5671087ffa "Move ALC885 macpro and imac24 models
to auto-parser" removed this model option.  All Mac machines are now explicitly
handled with a quirk and the auto-parser.  This adds a quirk for the device
found on the Mac Pro 5,1 machines.

This (partially) fixes https://bugzilla.redhat.com/show_bug.cgi?id=808559

Reported-by: Gabriel Somlo <somlo@cmu.edu>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 9917e55..1e0eea8 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5371,6 +5371,7 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x106b, 0x00a1, "Macbook", ALC889_FIXUP_MBP_VREF),
 	SND_PCI_QUIRK(0x106b, 0x00a4, "MacbookPro 4,1", ALC889_FIXUP_MBP_VREF),
 	SND_PCI_QUIRK(0x106b, 0x0c00, "Mac Pro", ALC885_FIXUP_MACPRO_GPIO),
+	SND_PCI_QUIRK(0x106b, 0x4200,  "Mac Pro 5,1", ALC885_FIXUP_MACPRO_GPIO),
 	SND_PCI_QUIRK(0x106b, 0x1000, "iMac 24", ALC885_FIXUP_MACPRO_GPIO),
 	SND_PCI_QUIRK(0x106b, 0x2800, "AppleTV", ALC885_FIXUP_MACPRO_GPIO),
 	SND_PCI_QUIRK(0x106b, 0x2c00, "MacbookPro rev3", ALC889_FIXUP_MBP_VREF),
-- 
1.7.7.6

