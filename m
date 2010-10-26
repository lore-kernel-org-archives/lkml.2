Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab0JZTHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:07:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42626 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab0JZTHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:07:51 -0400
Subject: Re: [GIT PULL] sound updates for 2.6.37-rc1
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Arnaud Lacombe <lacombar@gmail.com>, Takashi Iwai <tiwai@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <AANLkTi=DcsSQTeGER5tWjuLV6FpLCizO3ZMajqFCYPGe@mail.gmail.com>
References: <s5haam24bls.wl%tiwai@suse.de>
	 <AANLkTi=DcsSQTeGER5tWjuLV6FpLCizO3ZMajqFCYPGe@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 20:07:43 +0100
Message-ID: <1288120063.18037.64.camel@vega>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 14:20 -0400, Arnaud Lacombe wrote:
> Hi,
> 
> On Mon, Oct 25, 2010 at 9:59 AM, Takashi Iwai <tiwai@suse.de> wrote:
> > Linus,
> >
> > ===
> > [...]
> >
> > Liam Girdwood (3):
> >      ASoC: multi-component - ASoC Multi-Component Support
> >  [...]
> >  include/sound/soc-of-simple.h                      |   25 -
> >  [...]
> >  delete mode 100644 include/sound/soc-of-simple.h
> >
> `sound/soc/fsl/pcm030-audio-fabric.c' still reference
> `sound/soc-of-simple.h', causing the following build error:
> 
> sound/soc/fsl/pcm030-audio-fabric.c:27:33: fatal error:
> sound/soc-of-simple.h: No such file or directory
> 

Gah, missed that one, wonder why -next PPC build did not pick this one
up. Fwiw, I'm on train now to ELC-E now so can't test the following
patch with PPC gcc until the weekend.

Takashi, please apply the following fix.

>From 70c38adabd9380f5351a96f62e615d0e6ec7a533 Mon Sep 17 00:00:00 2001
From: Liam Girdwood <lrg@slimlogic.co.uk>
Date: Tue, 26 Oct 2010 20:00:54 +0100
Subject: [PATCH] ASoC: fsl - fix build error in pcm030-audio-fabric.c

Fix build error:-

sound/soc/fsl/pcm030-audio-fabric.c:27:33: fatal error:
sound/soc-of-simple.h: No such file or directory

Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>
---
 sound/soc/fsl/pcm030-audio-fabric.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/pcm030-audio-fabric.c b/sound/soc/fsl/pcm030-audio-fabric.c
index fe15bb2..25f27ec 100644
--- a/sound/soc/fsl/pcm030-audio-fabric.c
+++ b/sound/soc/fsl/pcm030-audio-fabric.c
@@ -24,7 +24,6 @@
 #include <sound/pcm_params.h>
 #include <sound/initval.h>
 #include <sound/soc.h>
-#include <sound/soc-of-simple.h>
 
 #include "mpc5200_dma.h"
 #include "mpc5200_psc_ac97.h"
@@ -49,7 +48,7 @@ static struct snd_soc_dai_link pcm030_fabric_dai[] = {
 	.codec_dai_name = "wm9712-aux",
 	.cpu_dai_name = "mpc5200-psc-ac97.1",
 	.platform_name = "mpc5200-pcm-audio",
-	..codec_name = "wm9712-codec",
+	.codec_name = "wm9712-codec",
 },
 };
 
-- 
1.7.1

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

