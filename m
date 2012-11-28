Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab2K1Gtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 01:49:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54382 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab2K1Gtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 01:49:49 -0500
Date: Wed, 28 Nov 2012 07:49:47 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: linux-sh@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        "Koul, Vinod" <vinod.koul@intel.com>
Subject: [PATCH 3.7] dma: sh: Don't use ENODEV for failing slave lookup
Message-ID: <Pine.LNX.4.64.1211280740190.32652@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:M5FNSPNrLGxZn+6nR50pbuOBpLlZaiWTKgJzddjkufG
 Hzx9kA48Bvtx8qMwSKxokYummttH8HbxxnfqMdf9xhy69RBulw
 6SVtumyXepzWhDSWQXBFYUP8qoEtjofrYSdlkGdNCnOAcXphcn
 T/g9San4GNJVI7YOZUodS462lvfMZc+wIDtLu5doHCynoXtuIk
 j9Omh9WzYMNFC46dU66io7WVw1eWd8ePpa5nJhdVunlnpuJKGB
 ireSHD8U+dHlFBvvEM38AGsRQV0d4arZ/lcmgCUt0/YHKIcxyG
 tyl4ttV5JNkBAHxTC8p6QOn5DbUbfrOihM/DnhislvnCs4lVX2
 ckX93iVTT65IaHxA0zW2JySfQNIB+zrPwRYxqpIycax7e8F/7t
 GnbIW5Ku6TwAg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If dmaengine driver's .device_alloc_chan_resources() method returns -ENODEV,
dma_request_channel() will decide, that the driver has been removed and will
remove the device from its list. To prevent this use ENXIO if a slave lookup
fails.

Reported-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Hi Vinod

Could you please push this patch to Linus for 3.7 ASAP? I think, it should 
also go to "stable."

Thanks
Guennadi

 drivers/dma/sh/shdma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
index f41bcc5..910d878 100644
--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdma.c
@@ -326,7 +326,7 @@ static int sh_dmae_set_slave(struct shdma_chan *schan,
 						    shdma_chan);
 	const struct sh_dmae_slave_config *cfg = dmae_find_slave(sh_chan, slave_id);
 	if (!cfg)
-		return -ENODEV;
+		return -ENXIO;
 
 	if (!try)
 		sh_chan->config = cfg;
-- 
1.7.2.5

