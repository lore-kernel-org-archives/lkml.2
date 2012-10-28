Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab2J1XuG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:50:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41767 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756269Ab2J1X1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:00 -0400
Message-Id: <20121028231538.953434444@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:15:42 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 006/105] ALSA: hda - Fix oops caused by recent commit "Fix internal mic for
 Lenovo Ideapad U300s"
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 83b0c6ba999643ee8ad6329f26e1cdc870e1a920 upstream.

Make sure we don't dereference the "quirk" pointer when it is null.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_conexant.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index cbe115b..abb59f4 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4441,7 +4441,9 @@ static void apply_fixup(struct hda_codec *codec,
 	struct conexant_spec *spec = codec->spec;
 
 	quirk = snd_pci_quirk_lookup(codec->bus->pci, quirk);
-	if (quirk && table[quirk->value]) {
+	if (!quirk)
+		return;
+	if (table[quirk->value]) {
 		snd_printdd(KERN_INFO "hda_codec: applying pincfg for %s\n",
 			    quirk->name);
 		apply_pincfg(codec, table[quirk->value]);


