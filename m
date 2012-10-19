Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161038Ab2JSDeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:34:21 -0400
Received: from mail.kernel.org ([198.145.19.201]:51044 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285Ab2JSCqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:46:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 08/62] ALSA: hda - Fix memory leaks at error path in patch_cirrus.c
Date: Thu, 18 Oct 2012 19:44:36 -0700
Message-Id: <20121019024257.295532635@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c5e0b6dbad9b4d18c561af90b384d02373f1c994 upstream.

The proper destructor should be called at the error path.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_cirrus.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -1427,7 +1427,7 @@ static int patch_cs420x(struct hda_codec
 	return 0;
 
  error:
-	kfree(codec->spec);
+	cs_free(codec);
 	codec->spec = NULL;
 	return err;
 }
@@ -1984,7 +1984,7 @@ static int patch_cs4210(struct hda_codec
 	return 0;
 
  error:
-	kfree(codec->spec);
+	cs_free(codec);
 	codec->spec = NULL;
 	return err;
 }
@@ -2009,7 +2009,7 @@ static int patch_cs4213(struct hda_codec
 	return 0;
 
  error:
-	kfree(codec->spec);
+	cs_free(codec);
 	codec->spec = NULL;
 	return err;
 }


