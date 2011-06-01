Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab1FAIOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:14:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:43702 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161772Ab1FAIO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:14:28 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:04:00 2011
Message-Id: <20110601080359.055731498@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:28 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [092/146] ALSA: HDA: Use one dmic only for Dell Studio 1558
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit e033ebfb399227e01686260ac271029011bc6b47 upstream.

There are no signs of a dmic at node 0x0b, so the user is left with
an additional internal mic which does not exist. This commit removes
that non-existing mic.

BugLink: http://bugs.launchpad.net/bugs/731706
Reported-by: James Page <james.page@canonical.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1634,7 +1634,7 @@ static struct snd_pci_quirk stac92hd73xx
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02fe,
 				"Dell Studio XPS 1645", STAC_DELL_M6_BOTH),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0413,
-				"Dell Studio 1558", STAC_DELL_M6_BOTH),
+				"Dell Studio 1558", STAC_DELL_M6_DMIC),
 	{} /* terminator */
 };
 


