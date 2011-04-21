Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab1DUSTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 14:19:53 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:53257 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090Ab1DUSTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 14:19:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=f/tksR7V2iTL5J2WzzFHItJRJcdJLHIZvcOVSvzhchBw5+6q+DN+/KgUXiuYc8DZT7
         6jBbSXpbCWhXD6bcY8YBTg+DFMFwAV5xWdDmaBZsi5Obm+O4Oyz5wktPm8nM9vdJ7hyI
         +6pPRC+mfOvTfulC/LXo9k7NUZl2y21aKMN0M=
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        James Nuss <jamesnuss@nanometrics.ca>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] davinci-mcasp: correct tdm_slots limit
Date: Thu, 21 Apr 2011 14:19:01 -0400
Message-Id: <e6aa9fd05c44088ab8446f1c60d2056f92929483.1303408522.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1303408522.git.bengardiner@nanometrics.ca>
References: <cover.1303408522.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current check for the number of tdm-slots specified by platform data is
always true (x >= 2 || x <= 32); therefore the else branch that warns of an
incorrect number of slots can never be taken.

Check that the number of tdm slots specified by platform data is between 2
and 32, inclusive.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
Reviewed-by: James Nuss <jamesnuss@nanometrics.ca>
---
 sound/soc/davinci/davinci-mcasp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index fb55d2c..e595756 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -644,7 +644,7 @@ static void davinci_hw_param(struct davinci_audio_dev *dev, int stream)
 		mcasp_set_reg(dev->base + DAVINCI_MCASP_TXTDM_REG, mask);
 		mcasp_set_bits(dev->base + DAVINCI_MCASP_TXFMT_REG, TXORD);
 
-		if ((dev->tdm_slots >= 2) || (dev->tdm_slots <= 32))
+		if ((dev->tdm_slots >= 2) && (dev->tdm_slots <= 32))
 			mcasp_mod_bits(dev->base + DAVINCI_MCASP_TXFMCTL_REG,
 					FSXMOD(dev->tdm_slots), FSXMOD(0x1FF));
 		else
@@ -660,7 +660,7 @@ static void davinci_hw_param(struct davinci_audio_dev *dev, int stream)
 				AHCLKRE);
 		mcasp_set_reg(dev->base + DAVINCI_MCASP_RXTDM_REG, mask);
 
-		if ((dev->tdm_slots >= 2) || (dev->tdm_slots <= 32))
+		if ((dev->tdm_slots >= 2) && (dev->tdm_slots <= 32))
 			mcasp_mod_bits(dev->base + DAVINCI_MCASP_RXFMCTL_REG,
 					FSRMOD(dev->tdm_slots), FSRMOD(0x1FF));
 		else
-- 
1.7.1

