Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab0EJWx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:53:27 -0400
Received: from kroah.org ([198.145.64.141]:33175 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932342Ab0EJWwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:22 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:22 2010
Message-Id: <20100510223322.527541932@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hans de Goede <hdegoede@redhat.com>, Takashi Iwai <tiwai@suse.de>
Subject: [059/117] ALSA: snd-meastro3: Add amp_gpio quirk for Compaq EVO N600C
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 7efbfd1ae98ef9efe06352e2a1ad83e8c14ceeb1 upstream.

Without this quirk sound stops working after suspend resume. With this quirk,
one still needs to manually unmute the master volume control after a suspend /
/ resume cycle. That is fixed in another patch in this set.

Note that this patch was submitted to the alsa bug tracker a long time ago:
https://bugtrack.alsa-project.org/alsa-bug/view.php?id=4319

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/maestro3.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/maestro3.c
+++ b/sound/pci/maestro3.c
@@ -884,6 +884,7 @@ static struct pci_device_id snd_m3_ids[]
 MODULE_DEVICE_TABLE(pci, snd_m3_ids);
 
 static struct snd_pci_quirk m3_amp_quirk_list[] __devinitdata = {
+	SND_PCI_QUIRK(0x0E11, 0x0094, "Compaq Evo N600c", 0x0c),
 	SND_PCI_QUIRK(0x10f7, 0x833e, "Panasonic CF-28", 0x0d),
 	SND_PCI_QUIRK(0x10f7, 0x833d, "Panasonic CF-72", 0x0d),
 	SND_PCI_QUIRK(0x1033, 0x80f1, "NEC LM800J/7", 0x03),


