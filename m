Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677Ab0C3XUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:20:46 -0400
Received: from kroah.org ([198.145.64.141]:45915 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932483Ab0C3XTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:49 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:46 2010
Message-Id: <20100330224746.173878577@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [040/156] ALSA: hda - Disable MSI for Nvidia controller
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 80c43ed724797627d8f86855248c497a6161a214 upstream.

Judging from the member of enable_msi white-list, Nvidia controller
seems to cause troubles with MSI enabled, e.g. boot hang up or other
serious issue may come up.  It's safer to disable MSI as default for
Nvidia controllers again for now.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2374,6 +2374,13 @@ static void __devinit check_msi(struct a
 		       "hda_intel: msi for device %04x:%04x set to %d\n",
 		       q->subvendor, q->subdevice, q->value);
 		chip->msi = q->value;
+		return;
+	}
+
+	/* NVidia chipsets seem to cause troubles with MSI */
+	if (chip->driver_type == AZX_DRIVER_NVIDIA) {
+		printk(KERN_INFO "hda_intel: Disable MSI for Nvidia chipset\n");
+		chip->msi = 0;
 	}
 }
 


