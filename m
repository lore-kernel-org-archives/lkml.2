Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab1JODWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 23:22:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40328 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab1JODWL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 23:22:11 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20111014191000.GB2931@opensource.wolfsonmicro.com>
References: <1318582919.19976.1.camel@phoenix> <1318582987.19976.2.camel@phoenix>
 <20111014191000.GB2931@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Sat, 15 Oct 2011 11:21:49 +0800
Message-ID: <CAF+7xWmdNqEuVCNB=53FftFm_Ds-=o5DwVa41MDq8m0DTZnzxg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ASoC: ad193x: Use snd_soc_update_bits for read-modify-write
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Barry Song <21cnbao@gmail.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/15 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Fri, Oct 14, 2011 at 05:03:07PM +0800, Axel Lin wrote:
>
>>       reg = snd_soc_read(codec, AD193X_DAC_CTRL2);
>> -     reg = (mute > 0) ? reg | AD193X_DAC_MASTER_MUTE : reg &
>> -             (~AD193X_DAC_MASTER_MUTE);
>> +     if (mute)
>> +             reg |= AD193X_DAC_MASTER_MUTE;
>> +     else
>> +             reg &= ~AD193X_DAC_MASTER_MUTE;
>>       snd_soc_write(codec, AD193X_DAC_CTRL2, reg);
>
> This is still using snd_soc_read() and snd_soc_write() (though it is a
> cleanup).
>
hi Mark,
One of the major reason that I do the convert to snd_soc_update_bits
is for better readability.
In this case, it seems ok to me with this change.
But if you prefer also convert it to snd_soc_update_bits, I can do it.
Let me know if I need to send a v2 for it.

Thanks,
Axel
