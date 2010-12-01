Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab0LAHKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 02:10:24 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40786 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab0LAHKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 02:10:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=a4yDf0HLRJX++MFbHi3e/5xghWNuzxWmedhyRrRmv/th0ZOJDFFi96cH58osGP0yGP
         uONcTvjrOi3Vzio277y5/ZPqmxxus17vyNjDRrytj//HWHb5vYrxB0pcvjomo7ylAJI2
         4Y5QNxA7NBj9hsdw0tgmt/5/UdgWawsxFncZc=
From: Jarkko Nikula <jhnikula@gmail.com>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Jarkko Nikula <jhnikula@gmail.com>
Subject: [PATCH] ASoC: Fix build failure in soc-core.c
Date: Wed,  1 Dec 2010 09:10:47 +0200
Message-Id: <1291187447-1247-1-git-send-email-jhnikula@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20101201113138.f6146790.sfr@canb.auug.org.au>
References: <20101201113138.f6146790.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2eea392 "ASoC: Add support for optional auxiliary dailess codecs"
causes a build failure in soc-core.c: soc_probe_aux_dev since code tries to
access non-existing struct snd_soc_dapm_context and struct snd_soc_card
members.

Root cause for this was a double accident. Author sent the RFC patch from
top of another patch set and the RFC got committed. Fix the build failure
by removing the code line that depends on that another patch set.

Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
---
 sound/soc/soc-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index a7670d5..eb950f7 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1644,7 +1644,6 @@ static int soc_probe_aux_dev(struct snd_soc_card *card, int num)
 	/* mark codec as probed and add to card codec list */
 	codec->probed = 1;
 	list_add(&codec->card_list, &card->codec_dev_list);
-	list_add(&codec->dapm.list, &card->dapm_list);
 
 	/* now that all clients have probed, initialise the DAI link */
 	if (aux_dev->init) {
-- 
1.7.2.3

