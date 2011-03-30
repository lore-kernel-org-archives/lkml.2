Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428Ab1C3WDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:03:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:15931 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933253Ab1C3VG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447257"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: vapier@gentoo.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [50/275] ASoC: Blackfin AC97: fix build error after multi-component update
Message-Id: <20110330210446.53A9F3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Mike Frysinger <vapier@gentoo.org>

commit e9c2048915048d605fd76539ddd96f00d593e1eb upstream.

We need to tweak how we query the active capture/playback state after
the recent overhauls of common code.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/soc/blackfin/bf5xx-ac97.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/sound/soc/blackfin/bf5xx-ac97.c
===================================================================
--- linux-2.6.35.y.orig/sound/soc/blackfin/bf5xx-ac97.c	2011-03-29 22:51:49.530455809 -0700
+++ linux-2.6.35.y/sound/soc/blackfin/bf5xx-ac97.c	2011-03-29 23:02:59.213320299 -0700
@@ -261,9 +261,9 @@
 	pr_debug("%s : sport %d\n", __func__, dai->id);
 	if (!dai->active)
 		return 0;
-	if (dai->capture.active)
+	if (dai->capture_active)
 		sport_rx_stop(sport);
-	if (dai->playback.active)
+	if (dai->playback_active)
 		sport_tx_stop(sport);
 	return 0;
 }
