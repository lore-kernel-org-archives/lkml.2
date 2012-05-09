Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253Ab2EIGW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:22:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38900 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756154Ab2EIFxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:16 -0400
Message-Id: <20120509055043.303337476@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:07 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 098/167] [PATCH] ASoC: dapm: Ensure power gets managed for line widgets
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 7e1f7c8a6e517900cd84da1b8ae020f08f286c3b upstream.

Line widgets had not been included in either the power up or power down
sequences so if a widget had an event associated with it that event would
never be run. Fix this minimally by adding them to the sequences, we
should probably be doing away with the specific widget types as they all
have the same priority anyway.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/soc-dapm.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 6241490..dc7dbfe 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -67,6 +67,7 @@ static int dapm_up_seq[] = {
 	[snd_soc_dapm_out_drv] = 10,
 	[snd_soc_dapm_hp] = 10,
 	[snd_soc_dapm_spk] = 10,
+	[snd_soc_dapm_line] = 10,
 	[snd_soc_dapm_post] = 11,
 };
 
@@ -75,6 +76,7 @@ static int dapm_down_seq[] = {
 	[snd_soc_dapm_adc] = 1,
 	[snd_soc_dapm_hp] = 2,
 	[snd_soc_dapm_spk] = 2,
+	[snd_soc_dapm_line] = 2,
 	[snd_soc_dapm_out_drv] = 2,
 	[snd_soc_dapm_pga] = 4,
 	[snd_soc_dapm_mixer_named_ctl] = 5,
-- 
1.7.10



