Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab0C3XUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:20:14 -0400
Received: from kroah.org ([198.145.64.141]:45644 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932380Ab0C3XTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:16 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:24 2010
Message-Id: <20100330224724.450330148@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:40:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ralf Gerbig <rge@quengel.org>, Takashi Iwai <tiwai@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [006/156] ALSA: hda - Sound MSI fallout on a Asus mobo NVIDIA MCP55
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ralf Gerbig <rge@quengel.org>

commit ecd216260f87dd8c14b2580a16f055554644bbea upstream.

without the following patch audio ssttuutteerrs on
ASUS M2N32-SLI PREMIUM ACPI BIOS Revision 1304
the sound device is:
00:0e.1 Audio device: nVidia Corporation MCP55 High Definition Audio (rev a2)
worked with 2.6.32

Signed-off-by: Ralf Gerbig <rge@quengel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2354,6 +2354,7 @@ static void __devinit check_probe_mask(s
 static struct snd_pci_quirk msi_black_list[] __devinitdata = {
 	SND_PCI_QUIRK(0x1043, 0x81f2, "ASUS", 0), /* Athlon64 X2 + nvidia */
 	SND_PCI_QUIRK(0x1043, 0x81f6, "ASUS", 0), /* nvidia */
+	SND_PCI_QUIRK(0x1043, 0x822d, "ASUS", 0), /* Athlon64 X2 + nvidia MCP55 */
 	{}
 };
 


