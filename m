Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab1DUSTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 14:19:16 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:53293 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750988Ab1DUSTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 14:19:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PAXrUXzEebhEIR5QVVoCsaoEkLGNJkFN3UL9iLkM7+kbwoznWfDn+39SG6rQTaklUs
         OsXaliU5muOeFQ+8H8Rl4lNDmtqb3ITXB5fXuQd6l5GybkLq4KP5XOLGhf0nQj4F4+WN
         hAcbqPk8c1t4rGVAHVVUSWkZSHm/C6PM1EIa4=
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        James Nuss <jamesnuss@nanometrics.ca>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] davinci-mcasp: use bitfield definitions for PDIR
Date: Thu, 21 Apr 2011 14:19:02 -0400
Message-Id: <2541e7e4e115b2d54a1f785fc0f603b6a6e9a526.1303408522.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1303408522.git.bengardiner@nanometrics.ca>
References: <cover.1303408522.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current driver creates value for set/clr of PDIR using (x<<26) instead
of the #defines that are convieniently made available.

Update the driver to use the bitfield definitions of PDIR. There is no
functional change introduced by this patch.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
Reviewed-by: James Nuss <jamesnuss@nanometrics.ca>
---
 sound/soc/davinci/davinci-mcasp.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index e595756..1aa24a1 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -434,7 +434,8 @@ static int davinci_mcasp_set_dai_fmt(struct snd_soc_dai *cpu_dai,
 		mcasp_set_bits(base + DAVINCI_MCASP_ACLKRCTL_REG, ACLKRE);
 		mcasp_set_bits(base + DAVINCI_MCASP_RXFMCTL_REG, AFSRE);
 
-		mcasp_set_bits(base + DAVINCI_MCASP_PDIR_REG, (0x7 << 26));
+		mcasp_set_bits(base + DAVINCI_MCASP_PDIR_REG,
+				ACLKX | AHCLKX | AFSX);
 		break;
 	case SND_SOC_DAIFMT_CBM_CFS:
 		/* codec is clock master and frame slave */
@@ -444,7 +445,8 @@ static int davinci_mcasp_set_dai_fmt(struct snd_soc_dai *cpu_dai,
 		mcasp_set_bits(base + DAVINCI_MCASP_ACLKRCTL_REG, ACLKRE);
 		mcasp_set_bits(base + DAVINCI_MCASP_RXFMCTL_REG, AFSRE);
 
-		mcasp_set_bits(base + DAVINCI_MCASP_PDIR_REG, (0x2d << 26));
+		mcasp_set_bits(base + DAVINCI_MCASP_PDIR_REG,
+				ACLKX | AFSX | ACLKR | AFSR);
 		break;
 	case SND_SOC_DAIFMT_CBM_CFM:
 		/* codec is clock and frame master */
@@ -454,7 +456,8 @@ static int davinci_mcasp_set_dai_fmt(struct snd_soc_dai *cpu_dai,
 		mcasp_clr_bits(base + DAVINCI_MCASP_ACLKRCTL_REG, ACLKRE);
 		mcasp_clr_bits(base + DAVINCI_MCASP_RXFMCTL_REG, AFSRE);
 
-		mcasp_clr_bits(base + DAVINCI_MCASP_PDIR_REG, (0x3f << 26));
+		mcasp_clr_bits(base + DAVINCI_MCASP_PDIR_REG,
+				ACLKX | AHCLKX | AFSX | ACLKR | AHCLKR | AFSR);
 		break;
 
 	default:
-- 
1.7.1

