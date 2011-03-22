Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab1CVP6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 11:58:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53047 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab1CVP6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 11:58:30 -0400
Date: Tue, 22 Mar 2011 08:57:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Zeng Zhaoming <b32542@freescale.com>
Subject: Re: [build failure] Re: [GIT PULL] sound updates for 2.6.39-rc1
Message-Id: <20110322085759.c9f7ab2b.randy.dunlap@oracle.com>
In-Reply-To: <s5hk4frnog6.wl%tiwai@suse.de>
References: <s5hr5a4ttfi.wl%tiwai@suse.de>
	<20110321153719.GA12325@elte.hu>
	<20110321155836.GE2570@opensource.wolfsonmicro.com>
	<20110321161102.GB23614@elte.hu>
	<20110321163849.GF2570@opensource.wolfsonmicro.com>
	<20110321164937.GA6381@elte.hu>
	<20110321165827.GG2570@opensource.wolfsonmicro.com>
	<20110322122436.GA6834@opensource.wolfsonmicro.com>
	<20110322083839.caab0520.randy.dunlap@oracle.com>
	<s5hk4frnog6.wl%tiwai@suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D88C70D.0144,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011 16:51:21 +0100 Takashi Iwai wrote:

> At Tue, 22 Mar 2011 08:38:39 -0700,
> Randy Dunlap wrote:
> > 
> > On Tue, 22 Mar 2011 12:24:36 +0000 Mark Brown wrote:
> > 
> > > On Mon, Mar 21, 2011 at 04:58:27PM +0000, Mark Brown wrote:
> > > > That's the breakage, yes.  It should be very straightforward to make the
> > > > driver build no matter how CONFIG_REGULATOR is set.
> > > 
> > > And indeed it was - in the absence of any response from Zeng I've now
> > > sent a patch for review.
> > > --
> > 
> > Hi,
> > Where was the patch sent, please?
> 
> alsa-devel ML.  Attached below.
> 

Thanks!

> 
> Takashi
> 
> ===
> From: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Subject: [alsa-devel] [PATCH] ASoC: Support !REGULATOR build for sgtl5000
> 
> The regulator is optional depending on board design.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  sound/soc/codecs/sgtl5000.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
> index 1f7217f..ff29380 100644
> --- a/sound/soc/codecs/sgtl5000.c
> +++ b/sound/soc/codecs/sgtl5000.c
> @@ -772,6 +772,7 @@ static int sgtl5000_pcm_hw_params(struct snd_pcm_substream *substream,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_REGULATOR
>  static int ldo_regulator_is_enabled(struct regulator_dev *dev)
>  {
>  	struct ldo_regulator *ldo = rdev_get_drvdata(dev);
> @@ -901,6 +902,19 @@ static int ldo_regulator_remove(struct snd_soc_codec *codec)
>  
>  	return 0;
>  }
> +#else
> +static int ldo_regulator_register(struct snd_soc_codec *codec,
> +				struct regulator_init_data *init_data,
> +				int voltage)
> +{
> +	return -EINVAL;
> +}
> +
> +static int ldo_regulator_remove(struct snd_soc_codec *codec)
> +{
> +	return 0;
> +}
> +#endif
>  
>  /*
>   * set dac bias
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
