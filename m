Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab2KZRDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:03:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47326 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab2KZRDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:03:48 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 065/270] ALSA: hda - Fix memory leaks at error path in patch_cirrus.c
Date: Mon, 26 Nov 2012 14:55:55 -0200
Message-Id: <1353949160-26803-66-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c5e0b6dbad9b4d18c561af90b384d02373f1c994 upstream.

The proper destructor should be called at the error path.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/patch_cirrus.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/patch_cirrus.c b/sound/pci/hda/patch_cirrus.c
index 9647ed4..557f27d 100644
--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -1417,7 +1417,7 @@ static int patch_cs420x(struct hda_codec *codec)
 	return 0;
 
  error:
-	kfree(codec->spec);
+	cs_free(codec);
 	codec->spec = NULL;
 	return err;
 }
@@ -1974,7 +1974,7 @@ static int patch_cs4210(struct hda_codec *codec)
 	return 0;
 
  error:
-	kfree(codec->spec);
+	cs_free(codec);
 	codec->spec = NULL;
 	return err;
 }
@@ -1999,7 +1999,7 @@ static int patch_cs4213(struct hda_codec *codec)
 	return 0;
 
  error:
-	kfree(codec->spec);
+	cs_free(codec);
 	codec->spec = NULL;
 	return err;
 }
-- 
1.7.9.5

