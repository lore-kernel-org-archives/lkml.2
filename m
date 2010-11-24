Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab0KXCPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 21:15:30 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39935 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab0KXCP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 21:15:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=YdznasANfyf7wz4+zdithmYOaBvxOyvrBnh/7v0n3u9UE5z27pEbiyRVKE5IRLyAiD
         VdTXMaAz4fg90Hpgs4uXIOdWLyuaFK+JL2n9kkgEEacd5rYG+sgWRDt56xK8Sjt58PEf
         6CrCGU0Dd9hqX4+ZYXxP/v2QFPYZTp7Wqxzjs=
Subject: [PATCH 1/2] ASoC: wm8961 - clear WM8961_DACSLOPE bit for normal
	mode
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Wed, 24 Nov 2010 10:20:33 +0800
Message-Id: <1290565233.5506.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DACSLOPE bit of Register 06h ADC and DAC Control 2:
        0: Normal mode
        1: Sloping stop-band mode

Thus in the case of normal mode, we should clear DACSLOPE bit.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8961.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8961.c b/sound/soc/codecs/wm8961.c
index a0bb972..e4638e6 100644
--- a/sound/soc/codecs/wm8961.c
+++ b/sound/soc/codecs/wm8961.c
@@ -710,7 +710,7 @@ static int wm8961_hw_params(struct snd_pcm_substream *substream,
 	if (fs <= 24000)
 		reg |= WM8961_DACSLOPE;
 	else
-		reg &= WM8961_DACSLOPE;
+		reg &= ~WM8961_DACSLOPE;
 	snd_soc_write(codec, WM8961_ADC_DAC_CONTROL_2, reg);
 
 	return 0;
-- 
1.7.2



