Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab2J1X2c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:28:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42180 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756982Ab2J1X2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:23 -0400
Message-Id: <20121028231548.137960145@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:12 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 036/105] ALSA: hda - Fix memory leaks at error path in patch_cirrus.c
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c5e0b6dbad9b4d18c561af90b384d02373f1c994 upstream.

The proper destructor should be called at the error path.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.2: drop the change to nonexistent patch_cs4213()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_cirrus.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -1404,7 +1404,7 @@ static int patch_cs420x(struct hda_codec
 	return 0;
 
  error:
-	kfree(codec->spec);
+	cs_free(codec);
 	codec->spec = NULL;
 	return err;
 }
@@ -1949,7 +1949,7 @@ static int patch_cs421x(struct hda_codec
 	return 0;
 
  error:
-	kfree(codec->spec);
+	cs_free(codec);
 	codec->spec = NULL;
 	return err;
 }


