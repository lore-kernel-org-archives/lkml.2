Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab1JMJEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 05:04:50 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:9013
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752295Ab1JMJEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 05:04:49 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-FB-SS: 13,
Subject: Re: [alsa-devel] [PATCH 7/9] ASoC: da7210: Add support for ALC and
 Noise suppression
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20111012150404.GT3647@opensource.wolfsonmicro.com>
References: <1318432070.12107.426.camel@matrix>
	 <20111012150404.GT3647@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Oct 2011 14:45:45 +0530
Message-ID: <1318497345.12107.443.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-12 at 16:04 +0100, Mark Brown wrote:
> On Wed, Oct 12, 2011 at 08:37:50PM +0530, Ashish Chavan wrote:
> 
> > +	if (ucontrol->value.integer.value[0]) {
> > +		/* Check if noise suppression is enabled */
> > +		if (reg_cache[DA7210_CONTROL] & DA7210_NOISE_SUP_EN) {
> 
> No, don't go peering directly into the register cache.  This is going to
> explode if the board configures a different cache style and means you
> can't change the cache type later.  Just read the register and trust
> that the cache will do something sane.

Will update the code to directly read the register. I thought of saving
some io bandwidth and if I remember correctly, I saw few exiting drivers
doing this.

> 
> > +			dev_dbg(codec->dev, "Failed to enable ALC\n");
> > +			return -EPERM;
> > +		}
> 
> Either drop the debug print or make it say what the problem is.

Will add more specific info about error.

> 
> similar problems in the rest of the patch.
> 
> > +	SOC_SINGLE("ALC Capture Max Gain", DA7210_ALC_MAX, 0, 0x3F, 0),
> > +	SOC_SINGLE("ALC Capture Min Gain", DA7210_ALC_MIN, 0, 0x3F, 0),
> > +	SOC_SINGLE("ALC Capture Noise Gain", DA7210_ALC_NOIS, 0, 0x3F, 0),
> 
> Volume.
> 


