Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab1HJJtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 05:49:14 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:46889 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294Ab1HJJtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 05:49:11 -0400
From: Julia Lawall <julia@diku.dk>
To: Jaroslav Kysela <perex@perex.cz>
Cc: kernel-janitors@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Andreas Mohr <andi@lisas.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sound/pci/azt3328.c: adjust error handling code to include debugging code
Date: Wed, 10 Aug 2011 11:49:04 +0200
Message-Id: <1312969744-29659-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

snd_azf3328_dbgcallenter is called at the very beginning of the function,
so it could be useful to call snd_azf3328_dbgcallleave at all exit points.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/pci/azt3328.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/pci/azt3328.c b/sound/pci/azt3328.c
index e4d76a2..579fc0d 100644
--- a/sound/pci/azt3328.c
+++ b/sound/pci/azt3328.c
@@ -2625,16 +2625,19 @@ snd_azf3328_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 	int err;
 
 	snd_azf3328_dbgcallenter();
-	if (dev >= SNDRV_CARDS)
-		return -ENODEV;
+	if (dev >= SNDRV_CARDS) {
+		err = -ENODEV;
+		goto out;
+	}
 	if (!enable[dev]) {
 		dev++;
-		return -ENOENT;
+		err = -ENOENT;
+		goto out;
 	}
 
 	err = snd_card_create(index[dev], id[dev], THIS_MODULE, 0, &card);
 	if (err < 0)
-		return err;
+		goto out;
 
 	strcpy(card->driver, "AZF3328");
 	strcpy(card->shortname, "Aztech AZF3328 (PCI168)");

