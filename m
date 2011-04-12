Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab1DLOwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:52:36 -0400
Received: from kroah.org ([198.145.64.141]:57565 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757227Ab1DLOiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:04 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:52 2011
Message-Id: <20110412143552.433502490@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [042/105] ALSA: HDA: Fix single internal mic on ALC275 (Sony Vaio VPCSB1C5E)
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 262ac22d21ee2bf3e1655b2e5e45cc94b356e62f upstream.

In cases where there is only one internal mic connected to ADC 0x11,
alc275_setup_dual_adc won't handle the case, so we need to add the
ADC node to the array of candidates.

BugLink: http://bugs.launchpad.net/bugs/752792
Reported-by: Vincenzo Pii
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -14191,7 +14191,7 @@ static hda_nid_t alc269vb_capsrc_nids[1]
 };
 
 static hda_nid_t alc269_adc_candidates[] = {
-	0x08, 0x09, 0x07,
+	0x08, 0x09, 0x07, 0x11,
 };
 
 #define alc269_modes		alc260_modes


