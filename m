Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2ARNRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 08:17:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43399 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757410Ab2ARNRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 08:17:34 -0500
Date: Wed, 18 Jan 2012 13:17:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>
Subject: Re: [alsa-devel]  [PATCH] ASoC: da7210: Add support for PLL and SRM
Message-ID: <20120118131731.GO8732@opensource.wolfsonmicro.com>
References: <1326371061.17726.30.camel@matrix>
 <20120112185257.GB9661@sirena.org.uk>
 <1326893178.16299.10.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326893178.16299.10.camel@matrix>
X-Cookie: Bridge ahead.  Pay troll.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 06:56:18PM +0530, Ashish Chavan wrote:

> > > +static int da7210_set_dai_clkdiv(struct snd_soc_dai *codec_dai,
> > > +				 int div_id, int div)

> > Why does the driver need the machine driver to manually configure clock
> > dividers?

> Do you mean that the input mclk value should be passed via platform data
> and driver should use it from there during initialization?

No, it should be configured using set_sysclk() like for all the other
CODEC drivers.  The problem is that everyone using the driver needs to
know all the dividers in the chip.
