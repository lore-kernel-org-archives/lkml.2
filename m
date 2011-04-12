Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab1DLOh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:37:28 -0400
Received: from kroah.org ([198.145.64.141]:57331 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756637Ab1DLOh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:48 2011
Message-Id: <20110412143548.120693495@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:33:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [002/105] ALSA: hda - Fix SPDIF out regression on ALC889
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 20b67dddcc5f29d3d0c900225d85e0ac655bc69d upstream.

The commit 5a8cfb4e8ae317d283f84122ed20faa069c5e0c4
    ALSA: hda - Use ALC_INIT_DEFAULT for really default initialization
changed to use the default initialization method for ALC889, but
this caused a regression on SPDIF output on some machines.
This seems due to the COEF setup included in the default init procedure.
For making SPDIF working again, the COEF-setup has to be avoided for
the id 0889.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=24342
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1360,7 +1360,7 @@ static void alc_auto_init_amp(struct hda
 		case 0x10ec0883:
 		case 0x10ec0885:
 		case 0x10ec0887:
-		case 0x10ec0889:
+		/*case 0x10ec0889:*/ /* this causes an SPDIF problem */
 			alc889_coef_init(codec);
 			break;
 		case 0x10ec0888:


