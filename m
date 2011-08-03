Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab1HCX3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:29:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33755 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123Ab1HCX2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:28:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:46 2011
Message-Id: <20110803221246.233448186@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [022/102] ASoC: Mark cache as dirty when suspending
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 7be4ba24a3ea53bc8ade841635e4d4a59e98ceb5 upstream.

Since quite a few drivers are not managing to flag the cache as needing
to be resynced after suspend and it's a reasonable thing to do flag the
cache as needing sync automatically when suspending.

The expectation is that systems will mainly only keep the CODEC powered
when doing audio through the CODEC so we won't actually suspend the
device anyway; drivers which want to can override this behaviour when
they resume.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/soc-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1124,6 +1124,7 @@ int snd_soc_suspend(struct device *dev)
 			case SND_SOC_BIAS_OFF:
 				codec->driver->suspend(codec, PMSG_SUSPEND);
 				codec->suspended = 1;
+				codec->cache_sync = 1;
 				break;
 			default:
 				dev_dbg(codec->dev, "CODEC is on over suspend\n");


