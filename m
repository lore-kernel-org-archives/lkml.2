Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab2BAVTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:19:23 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35998 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932661Ab2BAVTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:17 -0500
X-Sasl-enc: EW1978zOidOH8kz+vHKkHw6EMdVSmVcrL4Xu27XG3rU9 1328131157
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:45 2012
Message-Id: <20120201210045.300858695@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [16/89] ASoC: wm8996: Call _POST_PMU callback for CPVDD
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit a14304edcd5e8323205db34b08f709feb5357e64 upstream.

We should be allowing a 5ms delay after the charge pump is started in
order to ensure it has finished ramping.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8996.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8996.c
+++ b/sound/soc/codecs/wm8996.c
@@ -1049,7 +1049,8 @@ SND_SOC_DAPM_SUPPLY_S("SYSCLK", 1, WM899
 SND_SOC_DAPM_SUPPLY_S("SYSDSPCLK", 2, WM8996_CLOCKING_1, 1, 0, NULL, 0),
 SND_SOC_DAPM_SUPPLY_S("AIFCLK", 2, WM8996_CLOCKING_1, 2, 0, NULL, 0),
 SND_SOC_DAPM_SUPPLY_S("Charge Pump", 2, WM8996_CHARGE_PUMP_1, 15, 0, cp_event,
-		      SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMD),
+		      SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMU |
+		      SND_SOC_DAPM_POST_PMD),
 SND_SOC_DAPM_SUPPLY("Bandgap", SND_SOC_NOPM, 0, 0, bg_event,
 		    SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMD),
 SND_SOC_DAPM_SUPPLY("LDO2", WM8996_POWER_MANAGEMENT_2, 1, 0, NULL, 0),


