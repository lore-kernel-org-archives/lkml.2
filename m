Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab2BFQvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:51:04 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:38570 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755156Ab2BFQvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:51:01 -0500
Message-ID: <1328547058.3845.5.camel@odin>
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
From: Liam Girdwood <lrg@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Feb 2012 16:50:58 +0000
In-Reply-To: <20120206122553.e794e84d5f586619d710fdcd@canb.auug.org.au>
References: <20120206122553.e794e84d5f586619d710fdcd@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Btw, I have a new email address at TI now, any chance you could update
your scripts. Thanks !

On Mon, 2012-02-06 at 12:25 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the sound-asoc tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> sound/soc/codecs/max9768.c: In function 'max9768_probe':
> sound/soc/codecs/max9768.c:138:3: error: implicit declaration of function 'snd_soc_add_controls' [-Werror=implicit-function-declaration]
> 
> Caused by commit 022658beab55 ("ASoC: core: Add support for DAI and
> machine kcontrols").
> 
> I have used the sound-asoc tree from next-20120203 for today.

Sorry, this should fix it.

>From e3e06e913cb74a57b603a2e7ac0f08c995af4969 Mon Sep 17 00:00:00 2001
From: Liam Girdwood <lrg@ti.com>
Date: Mon, 6 Feb 2012 16:36:04 +0000
Subject: [PATCH] ASoC: max9768 - Fix build and use new add control API.

Fix build breakage by using the correct API call to add kcontrols.

Signed-off-by: Liam Girdwood <lrg@ti.com>
---
 sound/soc/codecs/max9768.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/max9768.c b/sound/soc/codecs/max9768.c
index 79e9901..17b3ec2 100644
--- a/sound/soc/codecs/max9768.c
+++ b/sound/soc/codecs/max9768.c
@@ -135,7 +135,7 @@ static int max9768_probe(struct snd_soc_codec *codec)
 	}
 
 	if (gpio_is_valid(max9768->mute_gpio)) {
-		ret = snd_soc_add_controls(codec, max9768_mute,
+		ret = snd_soc_add_codec_controls(codec, max9768_mute,
 				ARRAY_SIZE(max9768_mute));
 		if (ret)
 			return ret;
-- 
1.7.5.4


