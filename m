Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab2JJKDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 06:03:00 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52745 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab2JJKCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 06:02:52 -0400
Message-ID: <507547C7.4020701@gmail.com>
Date: Wed, 10 Oct 2012 12:02:47 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Kumar, Anil" <anilkumar.v@ti.com>
CC: "Porter, Matt" <mporter@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alsa Devel List <alsa-devel@alsa-project.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>
Subject: Re: [PATCH 0/2] Convert davinci ASoC to genalloc SRAM
References: <1349345745-10584-1-git-send-email-mporter@ti.com> <F3DBB1B3EF102E4994C89758CFCA32412852CA@DBDE01.ent.ti.com> <50751E0F.3010906@gmail.com> <F3DBB1B3EF102E4994C89758CFCA3241285400@DBDE01.ent.ti.com>
In-Reply-To: <F3DBB1B3EF102E4994C89758CFCA3241285400@DBDE01.ent.ti.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.10.2012 11:59, Kumar, Anil wrote:
> On Wed, Oct 10, 2012 at 12:34:47, Daniel Mack wrote:
>> On 10.10.2012 08:54, Kumar, Anil wrote:
>>> On Thu, Oct 04, 2012 at 15:45:43, Porter, Matt wrote:
>>>> This series converts davinci ASoC to use genalloc and enables
>>>> that support on DA850. It applies on top of the uio_pruss/genalloc
>>>> series [1] which allows DaVinci to provide a gen_pool via pdata
>>>> for driver use.
>>>>
>>>> I've tested this on the AM180x EVM. Note that prior to this,
>>>> the SRAM paths in the driver were completely unused. I've only
>>>> enabled ping-pong buffering on the platform I can test as it's
>>>> best to allow those with DM644x and similar platforms to set the
>>>> playback/capture sram size to something that's known to work
>>>> for them.
>>>>
>>>> [1] http://www.spinics.net/lists/arm-kernel/msg198854.html
>>>
>>> Tested on DA850 EVM after applying patches from [1] above.
>>> Tested on Linux-torvalds 3.6-rc6 master branch.
>>> Tested ASoC module (aplay & arecord for various frequencies)
>>>
>>> Acked-by: Kumar, Anil <anilkumar.v@ti.com>
>>
>> As you're on it, could you also quickly merge this branch
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git
>> topic/davinci
>>
>> And see if my recent patches for more McASP flexibility cause any
>> trouble on your hardware?
>>
>>
>> Daniel
>>
>>
> 
> I have merged it with 3.6-rc6 and I have got error at compile time.
> I have fixed this locally with the following patch [1]. 
> Kindly confirm if the patch is correct?

I did the same thing locally, but I considered this a merge conflict.

> With that 
> Tested on DA850 EVM
> Tested on Linux-torvalds 3.6-rc6 master branch merged + [1]
> Tested ASoC module (aplay & arecord for various frequencies)   
> 
> Tested-By: Kumar, Anil <anilkumar.v@ti.com> 

Ok, that's good to hear. Thanks a lot :)


Daniel

> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 09da4e5..9c02a45 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -591,7 +591,7 @@ struct dma_device {
>         struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
>                 struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
>                 size_t period_len, enum dma_transfer_direction direction,
> -               unsigned long flags, void *context);
> +               void *context);
>         struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
>                 struct dma_chan *chan, struct dma_interleaved_template *xt,
>                 unsigned long flags);
> @@ -656,7 +656,7 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_cyclic(
>                 size_t period_len, enum dma_transfer_direction dir)
>  {
>         return chan->device->device_prep_dma_cyclic(chan, buf_addr, buf_len,
> -                                               period_len, dir, flags, NULL);
> +                                               period_len, dir, NULL);
>  }
> 

