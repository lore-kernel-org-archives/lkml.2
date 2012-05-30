Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab2E3Kub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 06:50:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36590 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab2E3Ku3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 06:50:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120527221956.GB25019@opensource.wolfsonmicro.com>
References: <1332158459-14880-1-git-send-email-tomoya.rohm@gmail.com>
	<20120321160913.GF3226@opensource.wolfsonmicro.com>
	<CANKRQnjoGN=uvej8B1BxPHAx7NQtOORD9yJRPUc134DrVmPzNg@mail.gmail.com>
	<20120326154009.GA17506@sirena.org.uk>
	<CANKRQnhn=ALR0ucv5gnvwnxwxBQX4ajm9Jo5qC0fL-EFjDdoZg@mail.gmail.com>
	<20120523093857.GC4085@opensource.wolfsonmicro.com>
	<CANKRQnhNWC2F6zKgBMJY7HnipJbA5p-=6Lz4uGZqBKNQ688Z3w@mail.gmail.com>
	<20120524100742.GH5361@opensource.wolfsonmicro.com>
	<CANKRQnj_LdGQPYPV7d5NNZBx8oM5aAGHu4qZidiiS6C4eNtNJQ@mail.gmail.com>
	<1337941231.1580.19.camel@vkoul-udesk3>
	<20120527221956.GB25019@opensource.wolfsonmicro.com>
Date: Wed, 30 May 2012 19:50:28 +0900
Message-ID: <CANKRQnhwkhGUHi6WQhw-sRJuKari3SLcipCJXVp27OZ29=Vxkw@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v5] sound/soc/lapis: add platform driver for ML7213
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>, alsa-devel@alsa-project.org,
        lars@metafoo.de, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 7:19 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>> > I'm not so familiar with Linux's DMA idea.
>> > So we don't know whether non-cyclic dmaengine has problem or not.
>
> Nobody has written the code, this is the problem!  If the code is not
> there, you should try to write it.  If there is some great problem
> writing the code then you should t

The latter of the above seems dropped...

>> First you should not be writing your own dma driver, it *needs* to use
>> dmaenegine. We already have bunch of driver supported, so there may be a
>
> He's already done that, their current code is all open coded dmaengine
> stuff.

I don't understand why you say so ?
I don't use any own dma driver, right ? I use only dmaengine's.
If there is own, let me show.

>> > As you said, common code for DMA code can be best solution.
>> > However, currently, the code is nothing.
>> > So, I want you to accept our driver as first step.
>> > Because I think supporting new device is more important for linux than
>> > dmaengine common.
>
> The existing code is far from nothing, there is a fairly substantial
> dmaengine library there already which should share a big chunk of code
> with any cyclic support.  If you were saying "this is too hard for
> $REASON" that'd be one thing but that's not what you're saying here.

If our ASoC supports cyclic dma mode, we must modify both pch_dma
driver and our ASoC driver.
I don't want to do this.
Because I can't understand the merit. In plain words, to me, this
looks insignificant things.
In fact, current all applied ASoC drivers use dmaengine don't use
cyclic mode, right ?

> It's possible that there is actually some substantial difficult but
> my first instinct would be that it should be relatively straightforward.

Let me clarify your saying again.
Which do you want ?
  1) pch_dma must support cyclic dma mode and our ASoC driver must use
the cyclic dma function.
  2) Non-cyclic dma engine should be added to alsa-dmaengine by myself.
  3) Other

Thanks

-- 
ROHM Co., Ltd.
tomoya
