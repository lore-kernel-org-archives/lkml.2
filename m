Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933538Ab0GAWVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:21:21 -0400
Received: from kroah.org ([198.145.64.141]:47169 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932524Ab0GAUtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:35 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:28 2010
Message-Id: <20100701173428.394786405@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 018/164] ALSA: hda: Use LPIB for Acer Aspire 5110
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit 7a68be94e22e7643038726ebc14360752a91800b upstream.

BugLink: https://launchpad.net/bugs/583983

Symptom: on a significant number of hardware, booting from a live cd
results in capture working correctly, but once the distribution is
installed, booting from the install results in capture not working.

Test case: boot from Ubuntu 10.04 LTS live cd; capture works correctly.
Install to HD and reboot; capture does not work. Reproduced with 2.6.32
mainline build (vanilla kernel.org compile).

Resolution: add SSID for Acer Aspire 5110 to the position_fix quirk
table, explicitly specifying the LPIB method.

I'll be sending additional patches for these SSIDs as bug reports are
confirmed.

Reported-and-Tested-By: Leo
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2263,6 +2263,7 @@ static int azx_dev_free(struct snd_devic
  * white/black-listing for position_fix
  */
 static struct snd_pci_quirk position_fix_list[] __devinitdata = {
+	SND_PCI_QUIRK(0x1025, 0x009f, "Acer Aspire 5110", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01cc, "Dell D820", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01de, "Dell Precision 390", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01f6, "Dell Latitude 131L", POS_FIX_LPIB),


