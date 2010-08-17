Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab0HQXal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 19:30:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53989 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab0HQXae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 19:30:34 -0400
Subject: Re: linux-next: build warning after merge of the sound-asoc tree
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100817122103.5e14eaeb.sfr@canb.auug.org.au>
References: <20100817122103.5e14eaeb.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 00:30:30 +0100
Message-ID: <1282087830.3095.116.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 12:21 +1000, Stephen Rothwell wrote:
> Hi ,
> 
> After merging the sound-asoc tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> sound/soc/soc-core.c: In function 'snd_soc_register_dais':
> sound/soc/soc-core.c:2919: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'
> 
> Caused by commit f0fba2ad1b6b53d5360125c41953b7afcd6deff0 ("ASoC:
> multi-component - ASoC Multi-Component Support").

Ah, this never showed up on ARM since size_t is 32 bits.

Mark, could you apply this fix.

Thanks

Liam

>From 4c3f9d5fcb46d769f4a52a044fead863419c1d58 Mon Sep 17 00:00:00 2001
From: Liam Girdwood <lrg@slimlogic.co.uk>
Date: Wed, 18 Aug 2010 00:25:12 +0100
Subject: [PATCH] ASoC: core - fix build warning on x86_64

Output size_t type as a "%Zu" to avoid warnings.

Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>
---
 sound/soc/soc-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 3d480eb..7093c17 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2916,7 +2916,7 @@ int snd_soc_register_dais(struct device *dev,
 	struct snd_soc_dai *dai;
 	int i, ret = 0;
 
-	dev_dbg(dev, "dai register %s #%d\n", dev_name(dev), count);
+	dev_dbg(dev, "dai register %s #%Zu\n", dev_name(dev), count);
 
 	for (i = 0; i < count; i++) {
 
-- 
1.7.0.4


