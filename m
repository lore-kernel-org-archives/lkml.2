Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab2I1T6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:58:08 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964794Ab2I1S4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:56:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andrew Shadura <bugzilla@tut.by>, Takashi Iwai <tiwai@suse.de>
Subject: [ 054/262] ALSA: hda - Fix missing Master volume for STAC9200/925x
Date: Fri, 28 Sep 2012 11:49:43 -0700
Message-Id: <20120928183004.309018683@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ab548d2dba63ba947287965e525cc02a15d9853d upstream.

With the commit [2faa3bf: ALSA: hda - Rewrite the mute-LED hook with
vmaster hook in patch_sigmatel.c], the former Master volume control
was converted to PCM.  This was supposed to be covered by the vmaster
control.  But due to the lack of "PCM" slave definition, this didn't
happen properly.  The patch fixes the missing entry.

Reported-by: Andrew Shadura <bugzilla@tut.by>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_sigmatel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1075,7 +1075,7 @@ static struct snd_kcontrol_new stac_smux
 
 static const char * const slave_pfxs[] = {
 	"Front", "Surround", "Center", "LFE", "Side",
-	"Headphone", "Speaker", "IEC958",
+	"Headphone", "Speaker", "IEC958", "PCM",
 	NULL
 };
 


