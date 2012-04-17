Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab2DPWB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 18:01:27 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:35960 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755482Ab2DPWBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 18:01:24 -0400
Message-ID: <4F8CC0E9.3010407@xenotime.net>
Date: Mon, 16 Apr 2012 18:01:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] soc: fix printk format in soc-dapm.c
References: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au>
In-Reply-To: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning for 'formats':

sound/soc/soc-dapm.c:2913:5: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'u64'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Liam Girdwood <lrg@ti.com>
Cc:	Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc:	alsa-devel@alsa-project.org
---
 sound/soc/soc-dapm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120416.orig/sound/soc/soc-dapm.c
+++ linux-next-20120416/sound/soc/soc-dapm.c
@@ -2909,7 +2909,7 @@ static int snd_soc_dai_link_event(struct
 	if (config->formats) {
 		fmt = ffs(config->formats) - 1;
 	} else {
-		dev_warn(w->dapm->dev, "Invalid format %lx specified\n",
+		dev_warn(w->dapm->dev, "Invalid format %llx specified\n",
 			 config->formats);
 		fmt = 0;
 	}
