Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab2DMMnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 08:43:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932382Ab2DMMnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 08:43:18 -0400
Date: Fri, 13 Apr 2012 08:43:06 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: Thinkpad hda regression in 3.3
Message-ID: <20120413124306.GC25425@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi and Jaroslav,

We've had a number of bugs reported about sound not working correctly on
various models of Thinkpad machines in the 3.3 kernel.  I've listed them
below.

I looked through the commits and found:

    commit 29c5fbbcfefba5225a6783683c46c39e10877703:

    ALSA: HDA: Use model=auto for Thinkpad T510

    The user reports that model=auto works fine for him. Using
    model=auto bring in new features such as jack detection notification
    to userspace.

I did a local build here with that comment reverted and so far most of
the people reported their sound to be working again.  The trivial revert
patch is below in case you want it.

It seems there are multiple models that have PCI ID 17aa:215e and using
model=auto does not work for them all.  It particularly messes with
machines using a docking station for some reason.

Aside from just reverting the above commit, do you have other thoughts
on how to fix this?

josh

https://bugzilla.redhat.com/show_bug.cgi?id=808559
https://bugzilla.redhat.com/show_bug.cgi?id=806217
https://bugzilla.redhat.com/show_bug.cgi?id=810697

-----

From: Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH] ALSA: hda - Use model=thinkpad for PCI ID 17aa:215e

Commit 29c5fb "ALSA: HDA: Use model=auto for Thinkpad T510" switched to
using model=auto for PCI ID 17aa:215e, however that breaks sound on a
number of thinkpads.  Change this back to using model=thinkpad for now.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>

---

--- linux-3.3.noarch.orig/sound/pci/hda/patch_conexant.c
+++ linux-3.3.noarch/sound/pci/hda/patch_conexant.c
@@ -3027,7 +3027,7 @@ static const struct snd_pci_quirk cxt506
 	SND_PCI_QUIRK(0x17aa, 0x20f2, "Lenovo T400s", CXT5066_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21c5, "Thinkpad Edge 13", CXT5066_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21c6, "Thinkpad Edge 13", CXT5066_ASUS),
-	SND_PCI_QUIRK(0x17aa, 0x215e, "Lenovo T510", CXT5066_AUTO),
+	SND_PCI_QUIRK(0x17aa, 0x215e, "Lenovo T510", CXT5066_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21cf, "Lenovo T520 & W520", CXT5066_AUTO),
 	SND_PCI_QUIRK(0x17aa, 0x21da, "Lenovo X220", CXT5066_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21db, "Lenovo X220-tablet", CXT5066_THINKPAD),
