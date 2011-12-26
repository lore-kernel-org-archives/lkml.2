Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272Ab1LZGde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 01:33:34 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60420 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab1LZGda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 01:33:30 -0500
MIME-Version: 1.0
In-Reply-To: <20111222103946.GA4546@opensource.wolfsonmicro.com>
References: <1324349144-12784-1-git-send-email-tomoya.rohm@gmail.com>
	<1324349144-12784-3-git-send-email-tomoya.rohm@gmail.com>
	<20111220132314.GQ2866@opensource.wolfsonmicro.com>
	<CANKRQng8N3oS2o17HPUZeonXB3KLBK9oNQj-zd9+aUUvWcTo0A@mail.gmail.com>
	<20111222005816.GB27144@opensource.wolfsonmicro.com>
	<CANKRQnjCTAX02wJt7StjB0rXkg3Q6bPBRYCbkgq6vS5NFd97Fg@mail.gmail.com>
	<20111222103946.GA4546@opensource.wolfsonmicro.com>
Date: Mon, 26 Dec 2011 15:33:29 +0900
Message-ID: <CANKRQng+H4NxaSLpZpYOCT-CdovxbToT-waz0JNMFT2AcD_gvA@mail.gmail.com>
Subject: Re: [PATCH 3/3 v2] sound/soc/lapis: add platform driver for ML7213
 IOH I2S
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/22 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Thu, Dec 22, 2011 at 05:10:24PM +0900, Tomoya MORINAGA wrote:
>
>> I can understand your saying.
>> However, in case of Tx interrupt, only ALMOST-EMPTY occurs. in case of
>> Rx, only Rx ALMOST-FULL occurs.
>> So as long as a user uses ML7213 I2S, your mentioned behavior is never happened.
>
> That's not what your code says...  it may be that the other interrupts
> are very rare but that's not the same thing.

I'll delete these except initialize() and transfer_complete().

>
>> They have the "filter" function immediately next to the code uses
>> "dma_request_channel".
>
> That's a rather large function...
>
>> Anyway, if you want me to change the name, I can change the name.
>> Please decide it.
>
> Rename.
I'll obey your opinion.

>
>> > You're implementing some sort of custom buffering in your driver?  That
>> > sounds terribly unidiomatic - pretty much all DMA drivers are very thin
>> > and manage to work well, I'd expect this is masking some problems in the
>> > code rather than anything else.  Can you provide more detail on what
>> > this is working around?
>
>> Not sorted but queuing only.
>> In sound/voice control system, queuing is not rare, I think.
>> If necessary, though this method is very common, I can send the method
>> of the queue.
>
> No, please describe the problem you're trying to fix.

When CPU is heavy load, this buffer is useful.
The heavy load causes delaying receiving processing.
If there is no buffer, stream sound/voice can be broken.
If there is the buffer, it can prevent the broken sound.

thanks,
tomoya
