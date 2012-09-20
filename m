Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2ITLro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:47:44 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:37215
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754004Ab2ITLrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 07:47:43 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zz1432Id6f1izz1202h1d1ah1d2ahzzz2dh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdhbe9i1155h)
Subject: Re: [alsa-devel] [PATCH v2] ASoC: codecs: Add DA9055 codec driver
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20120919025035.GI8832@opensource.wolfsonmicro.com>
References: <1347622057.16763.27.camel@matrix>
	 <20120919025035.GI8832@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Sep 2012 17:28:55 +0530
Message-ID: <1348142335.18996.17.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +	/* DAC Routing control */
> > +	SOC_ENUM("DAC Left Select", da9055_dac_l_select),
> > +	SOC_ENUM("DAC Right Select", da9055_dac_r_select),
> 
> DAPM.  This even says its a routing control...

Yes, let me see if I can make it DAPM based.

> 
> > +	/* To select if MIC Bias powers MIC 1 or MIC 2 */
> > +	SOC_ENUM("Mic Bias Select", da9055_mic_bias_select),
> 
> This would normally be something controlled by the board...  what
> exactly is this doing?  How does the MICBIAS relate to the microphone
> inputs?

Yes, it should be controlled by the board.
This control selects which of the two MIC Bias pins acts as the BIAS
source. Earlier we misinterpreted it because of a hardware modification
which was present on the board without our knowledge.

> 
> > +	case SND_SOC_BIAS_STANDBY:
> > +		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF) {
> > +			/* Enable VMID reference & master bias */
> > +			snd_soc_update_bits(codec, DA9055_REFERENCES,
> > +					    DA9055_VMID_EN | DA9055_BIAS_EN,
> > +					    DA9055_VMID_EN | DA9055_BIAS_EN);
> > +		}
> > +		regcache_sync(da9055->regmap);
> 
> Doing the sync every time is very odd, why is it only done on
> transitions from _OFF?

It was a typo :-( I intend to put the sync inside if().

> Given that there's no regulator support here
> it's also a bit surprising that you need to do a sync outside of system
> suspend...
> 

I am not sure if I understood this fully. Do you mean a sync is not
required here?


> > +	da9055->mclk_rate       = 0;    /* This will be set from set_sysclk() */
> > +	da9055->master          = 0;    /* This will be set from set_fmt() */
> 
> You use kzalloc...
> 

Yeah!


