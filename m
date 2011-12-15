Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262Ab1LORDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:03:01 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:38792 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759172Ab1LORC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:02:59 -0500
X-SpamScore: -10
X-BigFish: VPS-10(zzzz1202hzz15d4R8275bhz2dh668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LW9881-02-BD4-02
X-M-MSG: 
Date: Thu, 15 Dec 2011 17:52:48 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix compile error in sound/soc/mid-x86/sst_platform.c
Message-ID: <20111215165248.GG2112@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(again with mailing lists on Cc, sorry)

Hi,

I tested current linux-next against my iommu-configs and found a compile
error in sound/soc/mid-x86/sst_platform.c. The variable ret_val in the
sst_platform_open() function is used but not declared. Attached patch
fixes this.

>From d4e6d3b9ff8084c02eaf50e8212f77bcde5dec9d Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Thu, 15 Dec 2011 17:39:31 +0100
Subject: [PATCH] Fix compile error in sound/soc/mid-x86/sst_platform.c

The variable ret_val is used but not declared. Fix this.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 sound/soc/mid-x86/sst_platform.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/mid-x86/sst_platform.c b/sound/soc/mid-x86/sst_platform.c
index 24f9471..11c39c5 100644
--- a/sound/soc/mid-x86/sst_platform.c
+++ b/sound/soc/mid-x86/sst_platform.c
@@ -267,6 +267,7 @@ static int sst_platform_open(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct sst_runtime_stream *stream;
+	int ret_val;
 
 	pr_debug("sst_platform_open called\n");
 
-- 
1.7.5.4

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

