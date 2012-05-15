Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965166Ab2EOCRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:24 -0400
Received: from mail1.windriver.com ([147.11.146.13]:52869 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964876Ab2EOCQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:14 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 019/179] ALSA: HDA: Use one dmic only for Dell Studio 1558
Date: Mon, 14 May 2012 22:11:55 -0400
Message-ID: <1337048075-6132-20-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Henningsson <david.henningsson@canonical.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e033ebfb399227e01686260ac271029011bc6b47 upstream.

There are no signs of a dmic at node 0x0b, so the user is left with
an additional internal mic which does not exist. This commit removes
that non-existing mic.

BugLink: http://bugs.launchpad.net/bugs/731706
Reported-by: James Page <james.page@canonical.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/hda/patch_sigmatel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 02b813ef6..6c06d17 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1614,7 +1614,7 @@ static struct snd_pci_quirk stac92hd73xx_cfg_tbl[] = {
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02fe,
 				"Dell Studio XPS 1645", STAC_DELL_M6_BOTH),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0413,
-				"Dell Studio 1558", STAC_DELL_M6_BOTH),
+				"Dell Studio 1558", STAC_DELL_M6_DMIC),
 	{} /* terminator */
 };
 
-- 
1.7.9.6

