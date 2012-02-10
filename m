Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761061Ab2BJXVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:21:23 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50022 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760510Ab2BJWlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:41:04 -0500
MIME-Version: 1.0
Message-Id: <20120210222945.208629723@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [patch 02/86] ALSA: hda - Fix the logic to detect VIA analog low-current mode
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 924339239fd5ba3e505f9420d41f0939196f3530 upstream.

The analog low-current mode must be enabled when the no stream is
running but the current detection checks it in a wrong way.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=741128

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_via.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1041,7 +1041,7 @@ static void analog_low_current_mode(stru
 	bool enable;
 	unsigned int verb, parm;
 
-	enable = is_aa_path_mute(codec) && (spec->opened_streams != 0);
+	enable = is_aa_path_mute(codec) && !spec->opened_streams;
 
 	/* decide low current mode's verb & parameter */
 	switch (spec->codec_type) {


