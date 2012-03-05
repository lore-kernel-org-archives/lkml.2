Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab2CEVLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 16:11:34 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:39312 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab2CEVLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:11:33 -0500
Date: Mon, 5 Mar 2012 16:11:12 -0500
From: Chris Mason <chris.mason@oracle.com>
To: David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: sound regression in 3.2-rc3 (lenovo laptops)
Message-ID: <20120305211112.GA4191@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	David Henningsson <david.henningsson@canonical.com>,
	Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F552BF7.0087,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I installed rc6 today on my laptop and discovered sound
no longer works.  I can hear a few clicks from the speakers as it boots,
but nothing else.

After a while I got the internal speaker in the laptop working by
randomly clicking between all the permutations of (mute, speaker,
headphone, main, speaker, beep, alsa, pulseaudio) in my mixer app.  But,
I couldn't get any noise out of the headphone jack.

I took a wild guess based on the changesets to snd-hda-intel and
narrowed it down to the change below.  With this reverted, I don't have
an alsa headphone output anymore (just master, pcm) and everything is
working again.

My laptop is an x201, not a T510...

-chris

commit 29c5fbbcfefba5225a6783683c46c39e10877703
Author: David Henningsson <david.henningsson@canonical.com>
Date:   Mon Jan 23 16:39:55 2012 +0100

    ALSA: HDA: Use model=auto for Thinkpad T510
    
    The user reports that model=auto works fine for him. Using
    model=auto bring in new features such as jack detection notification
    to userspace.
    
    Alsa info is available at http://paste.ubuntu.com/805351/
    
    Signed-off-by: David Henningsson <david.henningsson@canonical.com>
    Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 8a32a69..a7a5733 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3027,7 +3027,7 @@ static const struct snd_pci_quirk cxt5066_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x20f2, "Lenovo T400s", CXT5066_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21c5, "Thinkpad Edge 13", CXT5066_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21c6, "Thinkpad Edge 13", CXT5066_ASUS),
- 	SND_PCI_QUIRK(0x17aa, 0x215e, "Lenovo Thinkpad", CXT5066_THINKPAD),
+	SND_PCI_QUIRK(0x17aa, 0x215e, "Lenovo T510", CXT5066_AUTO),
 	SND_PCI_QUIRK(0x17aa, 0x21cf, "Lenovo T520 & W520", CXT5066_AUTO),
 	SND_PCI_QUIRK(0x17aa, 0x21da, "Lenovo X220", CXT5066_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21db, "Lenovo X220-tablet", CXT5066_THINKPAD),
