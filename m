Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab2HFX05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 19:26:57 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:39361 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab2HFX04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 19:26:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120806214121.GA26698@opensource.wolfsonmicro.com>
References: <20120805230238.GA1663@lizard> <1344207819-3415-4-git-send-email-anton.vorontsov@linaro.org>
 <CAKGA1bkiHj=zMJXSzoGp3fpLS3POnFXSV5y7sYYFAikqoUT9tQ@mail.gmail.com>
 <20120806154951.GQ16861@opensource.wolfsonmicro.com> <CAKGA1b=_AOub_pEJJGBTb6Y7wLZaSYKQjFTyMVFSr_=9VX4wpg@mail.gmail.com>
 <20120806193734.GA16199@opensource.wolfsonmicro.com> <20120806201609.GX25644@pengutronix.de>
 <CAKGA1bmMqyL4gyLYcanEH=R=HuBjRCNRLjUEWCj8wmpi3HuL0g@mail.gmail.com> <20120806214121.GA26698@opensource.wolfsonmicro.com>
From: Matt Sealey <matt@genesi-usa.com>
Date: Mon, 6 Aug 2012 18:26:34 -0500
Message-ID: <CAKGA1bma1T5NXZgY4XDko0r4o_m1b-JioVjjC8+c4-1PE+r1aw@mail.gmail.com>
Subject: Re: [PATCH 4/9] ASoC: imx: Don't use {en,dis}able_fiq() calls
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 4:41 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Aug 06, 2012 at 03:39:50PM -0500, Matt Sealey wrote:
>> On Mon, Aug 6, 2012 at 3:16 PM, Robert Schwebel
>
>> > That's not true; we still run MX25, MX27, MX35, MX28 on mainline in
>> > active projects.
>
>> I think Shawn Guo (FSL/Linaro) would also disagree, since he's just
>> posted a large amount of MXS patches to fix up the board for device
>> trees, and Arnd is pulling them.
>
> MXS != i.MX.
>
>> As far as I know, the FIQ usage is quite valid for the processor it
>> needs to run on (MX21/27/28, right?) in the modes it runs in (AC97 on
>> these processors, and maybe MX35 too), and I'm just trying to figure
>> out what the steps are for
>
> Oh, ick.  What is the problem that means people want to use the FIQ on
> these processors?  There's been i.MX2x audio DMA since forever, it had
> DMA in mainline before any of the later i.MXs due to them having SDMA.
> The original mainline i.MX audio support was done on i.MX27 and didn't
> have any issue here, this is the fist I've heard of a problem.

For SSI in I2S mode, I think it works great, AC97 not so much. It's
the AC97 mode
the FIQ stuff is there to fix. It seems a bunch of boards use AC97
codecs (for no
good reason)

>> I did note that SND_SOC_EUKREA_TLV320 enables FIQ but it also depends
>> on MX51 which makes me think this need to be split, too, so that MX51
>> boards don't have it but MX2/MX3 do.
>
> Is that not bitrot due to it being there before SDMA support was?

Possibly. I'm going to wait for Sascha to explain it again.. if AC97
was the predicate
for FIQ being required, it doesn't make any sense for a codec that says in it's
description that it's I2S. It may not be bitrot but pure,
unadulterated zeal on the part
of whoever wrote that Kconfig snippet - enable everything, in case it
fails (actually
that kind of thing is why I fear for nuking the building of this
driver since if FIQ stuff
is silently required by something else and all that kept it in there
was some badly
thought out or bitrotted Kconfig entries... I don't want to cause a
world of hurt).

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
