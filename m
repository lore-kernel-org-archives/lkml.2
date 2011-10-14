Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab1JNTOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:14:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52676 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753562Ab1JNTOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:14:49 -0400
Date: Fri, 14 Oct 2011 20:14:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v3 3/8] ASoC: da7210: Add support for line
 out and DAC
Message-ID: <20111014191445.GC2931@opensource.wolfsonmicro.com>
References: <1318590245.12107.514.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318590245.12107.514.camel@matrix>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 04:34:05PM +0530, Ashish Chavan wrote:

> +	/* Enable Line out amplifiers */
> +	snd_soc_write(codec, DA7210_OUT1_L, DA7210_OUT1_L_EN);
> +	snd_soc_write(codec, DA7210_OUT1_R, DA7210_OUT1_R_EN);
> +	snd_soc_write(codec, DA7210_OUT2, DA7210_OUT2_EN |
> +		     DA7210_OUT2_OUTMIX_L | DA7210_OUT2_OUTMIX_R);
> +

So, part of the reason I was complaining about you having the DAPM
conversion patch last is that in a driver using DAPM I'd really not
expect to see code like this which open codes register writes to enable
outputs, I'd expect the enables to be being done using DAPM.
