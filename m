Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044Ab1ESSIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:08:48 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60550 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934035Ab1ESSIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:45 -0400
X-Sasl-enc: tDoXP+DeLp6uOvQ7d2AxhoiaSu3dZwhvNHhspsX6kUXZ 1305828524
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:58 2011
Message-Id: <20110519180558.052898924@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marek Belisko <marek.belisko@open-nandra.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [39/71] ASoC: UDA134x: Remove POWER_OFF_ON_STANDBY define.
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marek Belisko <marek.belisko@open-nandra.com>

commit bf707de21fec7bb203dace2d0a2bbd124d1b36ca upstream.

Define POWER_OFF_ON_STANDBY cause trobles when trying to get some
sound from codec because code for bias setup was not compiled
(define wasn't defined). This define was removed in commit:
cc3202f5 but again introduced by commit: f0fba2ad1 which then
completely break codec functionality so remove it again.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/uda134x.c |    2 --
 1 file changed, 2 deletions(-)

--- a/sound/soc/codecs/uda134x.c
+++ b/sound/soc/codecs/uda134x.c
@@ -601,9 +601,7 @@ static struct snd_soc_codec_driver soc_c
 	.reg_cache_step = 1,
 	.read = uda134x_read_reg_cache,
 	.write = uda134x_write,
-#ifdef POWER_OFF_ON_STANDBY
 	.set_bias_level = uda134x_set_bias_level,
-#endif
 };
 
 static int __devinit uda134x_codec_probe(struct platform_device *pdev)


