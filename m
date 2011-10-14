Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab1JNTUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:20:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36972 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661Ab1JNTUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:20:11 -0400
Date: Fri, 14 Oct 2011 20:20:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v3 2/8] ASoC: da7210: Add support for DAPM
Message-ID: <20111014192008.GD2931@opensource.wolfsonmicro.com>
References: <1318590098.12107.509.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318590098.12107.509.camel@matrix>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 04:31:38PM +0530, Ashish Chavan wrote:

> +	/* ADCs */
> +	SND_SOC_DAPM_ADC("ADC Left", "Capture", DA7210_STARTUP3, 5, 1),
> +	SND_SOC_DAPM_ADC("ADC Right", "Capture", DA7210_STARTUP3, 6, 1),
> +
> +	/* Output Side */
> +	/* DACs */
> +	SND_SOC_DAPM_DAC("DAC Left", "Playback", DA7210_STARTUP2, 5, 1),
> +	SND_SOC_DAPM_DAC("DAC Right", "Playback", DA7210_STARTUP2, 6, 1),

These are also being enabled in the probe() function using completely
different registers - there the registers used are _ADC and _DAC.
What's going on there?  It's good to see the stuff in the startup()
function gone but almost all of the probe() just shouldn't be there in a
properly written driver and much of it looks like stuff that DAPM should
be taking care of.
