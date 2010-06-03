Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab0FCSQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:16:05 -0400
Received: from fbr02.csee.onr.siteprotect.com ([64.26.60.146]:45163 "EHLO
	fbr02.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752291Ab0FCSQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:16:04 -0400
Message-ID: <4C07F0F3.4090201@boundarydevices.com>
Date: Thu, 03 Jun 2010 11:14:11 -0700
From: Troy Kisky <troy.kisky@boundarydevices.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-mips@linux-mips.org,
       alsa-devel@alsa-project.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [alsa-devel] [RFC][PATCH 21/26] alsa: ASoC: Add JZ4740 ASoC	support
References: <1275505397-16758-1-git-send-email-lars@metafoo.de>	<1275505950-17334-5-git-send-email-lars@metafoo.de>	<1275569309.3593.106.camel@odin>  <4C07DD48.2050503@metafoo.de>	<1275584609.3118.26.camel@odin>  <4C07E37A.40502@metafoo.de> <1275585900.3118.29.camel@odin>
In-Reply-To: <1275585900.3118.29.camel@odin>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020206.4C07F103.004F,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liam Girdwood wrote:
> On Thu, 2010-06-03 at 19:16 +0200, Lars-Peter Clausen wrote:
>> Liam Girdwood wrote:
>>> On Thu, 2010-06-03 at 18:50 +0200, Lars-Peter Clausen wrote:
>>>   
>>>>>> +    config = snd_soc_dai_get_dma_data(rtd->dai->cpu_dai,
>>>>>>         
>>>> substream);
>>>>     
>>>>>> +    if (!prtd->dma) {
>>>>>> +            const char *dma_channel_name;
>>>>>> +            if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
>>>>>> +                    dma_channel_name = "PCM Playback";
>>>>>> +            else
>>>>>> +                    dma_channel_name = "PCM Capture";
>>>>>> +
>>>>>> +            prtd->dma = jz4740_dma_request(substream,
>>>>>>         
>>>> dma_channel_name);
>>>>     
>>>>>>     
>>>>>>         
>>>>> dma_channel_name variable is not required here. Just use the const
>>>>>       
>>>> char
>>>>     
>>>>> * directly.
>>>>>
>>>>>   
>>>>>       
>>>> I actually had it like that before, but I think it is much more readable
>>>> in its current form.
>>>>     
>>> I disagree, having the char pointer here just adds an extra level of
>>> indirection and costs an extra two lines of code. 
>>>
>>> Liam 
>>>   
>> Hi
>>
>> Could you give an concrete example of how you would code it?
>>
> 
> Sure,
> 
> if (!prtd->dma) {
>           if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
>                    prtd->dma = jz4740_dma_request(substream, "PCM Playback");
>           else
>                    prtd->dma = jz4740_dma_request(substream, "PCM Capture");
> }
> 
> Liam
> 
or,

if (!prtd->dma)
	prtd->dma = jz4740_dma_request(substream, (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) ?
		 "PCM Playback" : "PCM Capture");

