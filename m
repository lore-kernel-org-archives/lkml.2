Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab0C2Ec0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 00:32:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33726 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab0C2EcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 00:32:25 -0400
Date: Mon, 29 Mar 2010 15:32:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Barry Song <21cnbao@gmail.com>, Yi Li <yi.li@analog.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: linux-next: manual merge of the slabh tree with the sound tree
Message-Id: <20100329153218.155d1b39.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Today's linux-next merge of the slabh tree got a conflict in  between
commit a1533d94c6b930ef4263941adfd1e1132ca95627 ("ASoC: rename ad1938 to
ad193x and add support for ad1936/7/8/9") from the sound tree and commit
869d4cce05404996cc7969a9ffd1da27e65e6630 ("include cleanup: Update gfp.h
and slab.h includes to prepare for breaking implicit slab.h inclusion
from percpu.h") from the slabh tree.

The former renamed a file modified by the latter.  I applied the
following merge fixup patch.  This patch could, I assume, be applied to
the sound tree now, right Tejun?

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 29 Mar 2010 15:23:06 +1100
Subject: [PATCH] sound: update for removeal of slab.h from percpu.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 sound/soc/codecs/ad193x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/ad193x.c b/sound/soc/codecs/ad193x.c
index d034464..e108206 100644
--- a/sound/soc/codecs/ad193x.c
+++ b/sound/soc/codecs/ad193x.c
@@ -12,6 +12,7 @@
 #include <linux/device.h>
 #include <linux/i2c.h>
 #include <linux/spi/spi.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
-- 
1.7.0.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
