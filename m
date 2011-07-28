Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab1G1Xox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:44:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:25230 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155Ab1G1Xon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="33559554"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: kuninori.morimoto.gx@renesas.com, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [38/50] ASoC: ak4642: fixup snd_soc_update_bits mask for PW_MGMT2
Message-Id: <20110728234442.F24AB2403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ upstream commit bd7fdbcaa2d06d446577fd3c9b81847b04469e01 ]

mask didn't cover update-data

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/sound/soc/codecs/ak4642.c
===================================================================
--- linux-2.6.35.y.orig/sound/soc/codecs/ak4642.c
+++ linux-2.6.35.y/sound/soc/codecs/ak4642.c
@@ -319,7 +319,7 @@ static int ak4642_dai_set_fmt(struct snd
 	default:
 		return -EINVAL;
 	}
-	snd_soc_update_bits(codec, PW_MGMT2, MS, data);
+	snd_soc_update_bits(codec, PW_MGMT2, MS | MCKO | PMPLL, data);
 	snd_soc_update_bits(codec, MD_CTL1, BCKO_MASK, bcko);
 
 	return 0;
