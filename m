Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab1JXMMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:12:52 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:8117 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932130Ab1JXMMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:12:51 -0400
Message-ID: <4EA5563A.10703@dsn.lapis-semi.com>
Date: Mon, 24 Oct 2011 21:12:42 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: perex@perex.cz, linux-kernel@vger.kernel.org,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Clark, Joel" <joel.clark@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] Add SoundCard driver for OKI SEMICONDUCTOR ML7213 IOH
References: <70D251FDDC55405882A8447CC455D56E@hacdom.okisemi.com>	<8486F61FC3B94B908BFE654234DD6C97@hacdom.okisemi.com>	<4E9BAEF7.1080406@dsn.lapis-semi.com> <s5h7h3ysa4l.wl%tiwai@suse.de>
In-Reply-To: <s5h7h3ysa4l.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Iwai,

(2011/10/21 23:16), Takashi Iwai wrote:
> At Mon, 17 Oct 2011 13:28:39 +0900,
> Tomoya MORINAGA wrote:
>>
>> Hi Iwai,
>>
>> We have just started porting to ASoC structure.
>
> Please add ASoC maintainers to Cc if you have questions about ASoC.
>
>> I have a question.
>>
>> As you reviewed before, currently, our driver consists of 2 parts,
>> Soundcard driver and I2S driver.
>>
>> Soundcard consists of 2 parts
>>     - ALSA interface / control part
>>     - CODEC control part
>>
>> I2S driver consists of 4 parts
>>    - HAL
>>    - DMA control / interrupt control
>>    - Soundcard interface part
>>    - PCI interface function
>>
>> According to "soc" Documentation,
>> We must divide to 3 parts, platform driver, machine driver and codec driver.
>>
>> So, I divided like the following parts.
>>
>> platform driver
>>    - ALSA interface / control part
>>    - HAL
>>    - DMA control / interrupt control
>>    - Soundcard interface part
>>    - PCI interface function
>>
>> machine driver
>>    - (none)
>>
>> codec driver
>>     - CODEC control part
>>
>> Is the above dividing true ?
>
> Not really.  ASoC is designed to be much more modular.  Take a look at
> the codes in sound/soc/*.  You'll grasp how the components are split.
> (The documents in Documentation/sound/alsa/soc/ are slightly
>   obsoleted...)

Of course, I read Documentation/sound/alsa/soc/ and sound/soc/*.
However, it's not easy for me.

I have just 2 questions.

1. PCI interface function.
Any current ASoC drivers don't have PCI interface function.
So I don't know where the function should be in machine driver or 
platform driver.

2. Register Access
Can platform driver access register ?
According to the soc document, platform driver must not access hardware,
however, some drivers looks accessing their hardware.

>
> The conversion of PCM part is usually straightforward, as found in
> *-pcm.c.  The DAI setup depends on the hardware implementation.
> That's for machine driver.  But it's hard to tell in more details
> until I see the actual code snippet you are working on...

I understand.
I'm going to send our modified driver soon.

Thanks,

-- 
tomoya
ROHM Co., Ltd.
