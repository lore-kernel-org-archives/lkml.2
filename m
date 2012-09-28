Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032151Ab2I1UYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:24:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63188 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032108Ab2I1UX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:23:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andrew Shadura <bugzilla@tut.by>, Takashi Iwai <tiwai@suse.de>
Subject: [ 047/218] ALSA: hda - Fix missing Master volume for STAC9200/925x
Date: Fri, 28 Sep 2012 13:14:24 -0700
Message-Id: <20120928201506.873806828@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1072,7 +1072,7 @@ static struct snd_kcontrol_new stac_smux
 
 static const char * const slave_pfxs[] = {
 	"Front", "Surround", "Center", "LFE", "Side",
-	"Headphone", "Speaker", "IEC958",
+	"Headphone", "Speaker", "IEC958", "PCM",
 	NULL
 };
 


