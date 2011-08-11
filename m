Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab1HKNQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:16:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35881 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755888Ab1HKNQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:16:52 -0400
Subject: Re: [PATCH 2/4] ASoC: Add ADAU1373 codec support
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
In-Reply-To: <4E43AACF.5060701@metafoo.de>
References: <1312948364-2587-1-git-send-email-lars@metafoo.de>
	 <1312948364-2587-2-git-send-email-lars@metafoo.de>
	 <20110811092702.GA18454@opensource.wolfsonmicro.com>
	 <4E43AACF.5060701@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Wolfson Microelectronics
Date: Thu, 11 Aug 2011 22:16:30 +0900
Message-ID: <1313068590.19990.2.camel@finisterre.wolfsonmicro.main>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 12:11 +0200, Lars-Peter Clausen wrote:
> >> +	SOC_ENUM("Lineout1 Mono Stereo", adau1373_lineout1_mode_enum),
> >> +	SOC_ENUM("Speaker Mono Stereo", adau1373_speaker_mode_enum),

> > I'd expect these to be platform data/machine data rather than user
> > control?  The speaker wiring isn't going to vary dynamically...

> You still might want to switch, for whatever particular reason, between mono
> and stereo at runtime.

Sorry, what does this actually control? I guess I've been mislead but
from the name of the control I'd expect it to control if the outputs
were physically connected as mono or stereo outputs.

> >> +	switch (freq / params_rate(params)) {
> >> +	case 1024: /* fs */
> >> +		div = 0;
> >> +		break;
> >> +	case 1536: /* 2/3 fs */
> >> +		div = 1;
> >> +		break;

> > These comments look inaccuate, fs is the sample rate so a divide of 1
> > would be fs.

> div contains the register value representation of that particular divider.

div isn't the issue here. The comments seem to indicate that the result
of the divisions are some multiple of fs but fs usually means some
multiple of the sample rate. For example 2/3fs for 44.1kHz would be
29.4kHz.

