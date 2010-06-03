Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab0FCRht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:37:49 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:51364 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756656Ab0FCRhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:37:47 -0400
Message-ID: <4C07E849.6080202@metafoo.de>
Date: Thu, 03 Jun 2010 19:37:13 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Liam Girdwood <lrg@slimlogic.co.uk>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       alsa-devel@alsa-project.org
Subject: Re: [RFC][PATCH 21/26] alsa: ASoC: Add JZ4740 ASoC support
References: <1275505397-16758-1-git-send-email-lars@metafoo.de>	 <1275505950-17334-5-git-send-email-lars@metafoo.de>	 <1275569309.3593.106.camel@odin>  <4C07DD48.2050503@metafoo.de>	 <1275584609.3118.26.camel@odin>  <4C07E37A.40502@metafoo.de> <1275585900.3118.29.camel@odin>
In-Reply-To: <1275585900.3118.29.camel@odin>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liam Girdwood wrote:
> On Thu, 2010-06-03 at 19:16 +0200, Lars-Peter Clausen wrote:
>   
>> Liam Girdwood wrote:
>>     
>>> On Thu, 2010-06-03 at 18:50 +0200, Lars-Peter Clausen wrote:
>>>   
>>>       
>>>>>> +    config = snd_soc_dai_get_dma_data(rtd->dai->cpu_dai,
>>>>>>         
>>>>>>             
>>>> substream);
>>>>     
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
>>>>>>             
>>>> dma_channel_name);
>>>>     
>>>>         
>>>>>>     
>>>>>>         
>>>>>>             
>>>>> dma_channel_name variable is not required here. Just use the const
>>>>>       
>>>>>           
>>>> char
>>>>     
>>>>         
>>>>> * directly.
>>>>>
>>>>>   
>>>>>       
>>>>>           
>>>> I actually had it like that before, but I think it is much more readable
>>>> in its current form.
>>>>     
>>>>         
>>> I disagree, having the char pointer here just adds an extra level of
>>> indirection and costs an extra two lines of code. 
>>>
>>> Liam 
>>>   
>>>       
>> Hi
>>
>> Could you give an concrete example of how you would code it?
>>
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
>   
And now you have the same statement in two different lines. When it
needs to be changed you have to change both lines.
And furthermore in my opinion it distracts from the reason for the if
statement: We want a different channel name.

But ok, if you insist on it, I can live with changing it.

- Lars

