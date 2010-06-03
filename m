Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab0FCRDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:03:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49864 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab0FCRDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:03:34 -0400
Subject: Re: [RFC][PATCH 21/26] alsa: ASoC: Add JZ4740 ASoC support
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       alsa-devel@alsa-project.org
In-Reply-To: <4C07DD48.2050503@metafoo.de>
References: <1275505397-16758-1-git-send-email-lars@metafoo.de>
	 <1275505950-17334-5-git-send-email-lars@metafoo.de>
	 <1275569309.3593.106.camel@odin>  <4C07DD48.2050503@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 18:03:29 +0100
Message-ID: <1275584609.3118.26.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 18:50 +0200, Lars-Peter Clausen wrote:
> >> +    config = snd_soc_dai_get_dma_data(rtd->dai->cpu_dai,
> substream);
> >> +    if (!prtd->dma) {
> >> +            const char *dma_channel_name;
> >> +            if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
> >> +                    dma_channel_name = "PCM Playback";
> >> +            else
> >> +                    dma_channel_name = "PCM Capture";
> >> +
> >> +            prtd->dma = jz4740_dma_request(substream,
> dma_channel_name);
> >>     
> >
> > dma_channel_name variable is not required here. Just use the const
> char
> > * directly.
> >
> >   
> I actually had it like that before, but I think it is much more readable
> in its current form.

I disagree, having the char pointer here just adds an extra level of
indirection and costs an extra two lines of code. 

Liam 
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

