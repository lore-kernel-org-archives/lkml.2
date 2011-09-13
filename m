Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab1IMQ0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 12:26:44 -0400
Received: from mail.Pager.net ([64.129.32.194]:60380 "EHLO barracuda.pager.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755307Ab1IMQ0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 12:26:43 -0400
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Sep 2011 12:26:43 EDT
X-ASG-Debug-ID: 1315930590-1a51ccda0001-xx1T2L
X-Barracuda-Envelope-From: geoffrey@pager.net
From: Geoffrey Wossum <geoffrey@pager.net>
Organization: Long Range Systems
To: "Girdwood, Liam" <lrg@ti.com>
Subject: Re: [PATCH] ASoC: playpaq_wm8510: Return proper error if clk_get fails
Date: Tue, 13 Sep 2011 11:16:22 -0500
X-ASG-Orig-Subj: Re: [PATCH] ASoC: playpaq_wm8510: Return proper error if clk_get fails
User-Agent: KMail/1.13.7 (Linux/2.6.36-gentoo-r5; KDE/4.6.5; i686; ; )
CC: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geoffrey Wossum <gwossum@acm.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
References: <1315534538.3275.1.camel@phoenix>  <CABS+qY1W5D7_-ourY=kaF2-FADM8EqBRYR2QZa1odpzDiCya9g@mail.gmail.com>
In-Reply-To: <CABS+qY1W5D7_-ourY=kaF2-FADM8EqBRYR2QZa1odpzDiCya9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-ID: <201109131116.23577.geoffrey@pager.net>
X-Barracuda-Connect: lrs-ex2k8.longrangesystems.local[192.168.7.254]
X-Barracuda-Start-Time: 1315930589
X-Barracuda-URL: http://barracuda.pager.net:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.74417
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 09, 2011 11:38:44 AM Girdwood, Liam wrote:


On 9 September 2011 03:15, Axel Lin 
<axel.lin@gmail.com<mailto:axel.lin@gmail.com>> wrote:
Return proper error instead of 0 if clk_get fails.

Signed-off-by: Axel Lin <axel.lin@gmail.com<mailto:axel.lin@gmail.com>>
---
 sound/soc/atmel/playpaq_wm8510.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/sound/soc/atmel/playpaq_wm8510.c 
b/sound/soc/atmel/playpaq_wm8510.c
index 1aac2f4..2909bfa 100644
--- a/sound/soc/atmel/playpaq_wm8510.c
+++ b/sound/soc/atmel/playpaq_wm8510.c
@@ -383,14 +383,17 @@ static int __init playpaq_asoc_init(void)
       _gclk0 = clk_get(NULL, "gclk0");
       if (IS_ERR(_gclk0)) {
               _gclk0 = NULL;
+               ret = PTR_ERR(_gclk0);
               goto err_gclk0;
       }
       _pll0 = clk_get(NULL, "pll0");
       if (IS_ERR(_pll0)) {
               _pll0 = NULL;
+               ret = PTR_ERR(_pll0);
               goto err_pll0;
       }
-       if (clk_set_parent(_gclk0, _pll0)) {
+       ret = clk_set_parent(_gclk0, _pll0);
+       if (ret) {
               pr_warning("snd-soc-playpaq: "
                          "Failed to set PLL0 as parent for DAC clock\n");
               goto err_set_clk;
--
1.7.4.1




Acked-by: Liam Girdwood <lrg@ti.com<mailto:lrg@ti.com>>
Acked-by: Geoffrey Wossum <gwossum@acm.org>

