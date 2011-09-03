Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab1ICRJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 13:09:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:4114 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095Ab1ICRJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 13:09:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,325,1312182000"; 
   d="scan'208";a="48574013"
Subject: Re: [PATCH] ASoC: sn95031: Fix the logic to find free channel
From: Vinod Koul <vinod.koul@linux.intel.com>
To: "Girdwood, Liam" <lrg@ti.com>
Cc: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harsha Priya <priya.harsha@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
In-Reply-To: <CABS+qY2oOCpusNzRngTWmmcHv=jAkv-3N2rWH=mA8G6CSfYc7g@mail.gmail.com>
References: <1315028507.2268.1.camel@phoenix>
	 <CABS+qY2oOCpusNzRngTWmmcHv=jAkv-3N2rWH=mA8G6CSfYc7g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 03 Sep 2011 22:38:06 +0530
Message-ID: <1315069686.26251.59.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-09-03 at 21:44 +0530, Girdwood, Liam wrote:
> 
> 
> On 3 September 2011 06:41, Axel Lin <axel.lin@gmail.com> wrote:
>         In the case of no free channel available,
>         current implementation returns 0 instead of negative errno.
>         
>         This patch fixes the logic to return -EINVAL if no free
>         channel available.
>         
>         Signed-off-by: Axel Lin <axel.lin@gmail.com>
>         ---
>          sound/soc/codecs/sn95031.c |    8 +++-----
>          1 files changed, 3 insertions(+), 5 deletions(-)
>         
>         diff --git a/sound/soc/codecs/sn95031.c
>         b/sound/soc/codecs/sn95031.c
>         index 84ffdeb..b4f1cb4 100644
>         --- a/sound/soc/codecs/sn95031.c
>         +++ b/sound/soc/codecs/sn95031.c
>         @@ -79,7 +79,7 @@ static void configure_adc(struct
>         snd_soc_codec *sn95031_codec, int val)
>          */
>          static int find_free_channel(struct snd_soc_codec
>         *sn95031_codec)
>          {
>         -       int ret = 0, i, value;
>         +       int i, value;
>         
>                /* check whether ADC is enabled */
>                value = snd_soc_read(sn95031_codec, SN95031_ADC1CNTL1);
>         @@ -91,12 +91,10 @@ static int find_free_channel(struct
>         snd_soc_codec *sn95031_codec)
>                for (i = 0; i < SN95031_ADC_CHANLS_MAX; i++) {
>                        value = snd_soc_read(sn95031_codec,
>                                        SN95031_ADC_CHNL_START_ADDR +
>         i);
>         -               if (value & SN95031_STOPBIT_MASK) {
>         -                       ret = i;
>         +               if (value & SN95031_STOPBIT_MASK)
>                                break;
>         -               }
>                }
>         -       return (ret > SN95031_ADC_LOOP_MAX) ? (-EINVAL) : ret;
>         +       return (i == SN95031_ADC_CHANLS_MAX) ? (-EINVAL) : i;
>          }
>         
>          /* Initialize the ADC for reading micbias values. Can sleep.
>         */
>         --
>         1.7.4.1
>         
>         
>         
> 
> Acked-by: Liam Girdwood <lrg@ti.com>
> 
> Btw, this should be posted to alsa-devel.
Acked-by: Vinod Koul <vinod.koul@linux.intel.com>


-- 
~Vinod

