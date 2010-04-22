Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab0DVTmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:42:06 -0400
Received: from kroah.org ([198.145.64.141]:41324 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756749Ab0DVT3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:24 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:20 2010
Message-Id: <20100422190920.111145973@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Seth Heasley <seth.heasley@intel.com>, Takashi Iwai <tiwai@suse.de>,
       maximilian attems <max@stro.at>
Subject: [143/197] ALSA: hda - enable snoop for Intel Cougar Point
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Seth Heasley <seth.heasley@intel.com>

commit 32679f95cac3b1bdf27dce8b5273e06af186fd91 upstream.

This patch enables snoop, eliminating static during playback.
This patch supersedes the previous Cougar Point audio patch.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -438,6 +438,7 @@ struct azx {
 /* driver types */
 enum {
 	AZX_DRIVER_ICH,
+	AZX_DRIVER_PCH,
 	AZX_DRIVER_SCH,
 	AZX_DRIVER_ATI,
 	AZX_DRIVER_ATIHDMI,
@@ -452,6 +453,7 @@ enum {
 
 static char *driver_short_names[] __devinitdata = {
 	[AZX_DRIVER_ICH] = "HDA Intel",
+	[AZX_DRIVER_PCH] = "HDA Intel PCH",
 	[AZX_DRIVER_SCH] = "HDA Intel MID",
 	[AZX_DRIVER_ATI] = "HDA ATI SB",
 	[AZX_DRIVER_ATIHDMI] = "HDA ATI HDMI",
@@ -1040,6 +1042,7 @@ static void azx_init_pci(struct azx *chi
 				0x01, NVIDIA_HDA_ENABLE_COHBIT);
 		break;
 	case AZX_DRIVER_SCH:
+	case AZX_DRIVER_PCH:
 		pci_read_config_word(chip->pci, INTEL_SCH_HDA_DEVC, &snoop);
 		if (snoop & INTEL_SCH_HDA_DEVC_NOSNOOP) {
 			pci_write_config_word(chip->pci, INTEL_SCH_HDA_DEVC,
@@ -2393,6 +2396,7 @@ static int __devinit azx_create(struct s
 	if (bdl_pos_adj[dev] < 0) {
 		switch (chip->driver_type) {
 		case AZX_DRIVER_ICH:
+		case AZX_DRIVER_PCH:
 			bdl_pos_adj[dev] = 1;
 			break;
 		default:
@@ -2668,7 +2672,7 @@ static struct pci_device_id azx_ids[] =
 	/* PCH */
 	{ PCI_DEVICE(0x8086, 0x3b56), .driver_data = AZX_DRIVER_ICH },
 	/* CPT */
-	{ PCI_DEVICE(0x8086, 0x1c20), .driver_data = AZX_DRIVER_ICH },
+	{ PCI_DEVICE(0x8086, 0x1c20), .driver_data = AZX_DRIVER_PCH },
 	/* SCH */
 	{ PCI_DEVICE(0x8086, 0x811b), .driver_data = AZX_DRIVER_SCH },
 	/* ATI SB 450/600 */


