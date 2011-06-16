Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab1FPHKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:10:39 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:38577 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756825Ab1FPHKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:10:33 -0400
X-Sasl-enc: AL7UkJ/XNiA6RWeisnneQahGJk0GtPadbCHJHSiHPape 1308208232
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:06 2011
Message-Id: <20110616002906.052222546@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:28:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [23/85] ALSA: HDA: Use one dmic only for Dell Studio 1558
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -1608,7 +1608,7 @@ static struct snd_pci_quirk stac92hd73xx
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02fe,
 				"Dell Studio XPS 1645", STAC_DELL_M6_BOTH),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0413,
-				"Dell Studio 1558", STAC_DELL_M6_BOTH),
+				"Dell Studio 1558", STAC_DELL_M6_DMIC),
 	{} /* terminator */
 };
 


