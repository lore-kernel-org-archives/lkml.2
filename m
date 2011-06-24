Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab1FXLfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 07:35:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:38885 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab1FXLfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 07:35:30 -0400
Message-ID: <4E04767A.5020201@infradead.org>
Date: Fri, 24 Jun 2011 08:35:22 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] SOUND: Fix non-ISA_DMA_API build failure
References: <20110623144750.GA10180@linux-mips.org> <s5hzkl7zlcq.wl%tiwai@suse.de> <20110624111608.GA6327@linux-mips.org>
In-Reply-To: <20110624111608.GA6327@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-06-2011 08:16, Ralf Baechle escreveu:
> On Fri, Jun 24, 2011 at 10:26:13AM +0200, Takashi Iwai wrote:
> 
>> Hrm...  I still don't understand why ES18XX or others were selected at
>> the first place.  Isn't it covered by the conditional in
>> sound/isa/Kconfig like below?
>>
>> ================================================================
>> menuconfig SND_ISA
>> 	bool "ISA sound devices"
>> 	depends on ISA && ISA_DMA_API
>> ...
>> if SND_ISA
>> ...
>> config SND_ES18XX
>> 	tristate "Generic ESS ES18xx driver"
>> ...
>> endif	# SND_ISA
>> ================================================================
>>
>> Isn't SND_ISA=n in your case although ISA_DMA_API=n?
> 
> The answer is hidden in this Kconfig warning:
> 
> warning: (RADIO_MIROPCM20) selects SND_ISA which has unmet direct dependencies (SOUND && !M68K && SND && ISA && ISA_DMA_API)
> 
> This is due to the following in drivers/media/radio/Kconfig:
> 
> config RADIO_MIROPCM20
>         tristate "miroSOUND PCM20 radio"
>         depends on ISA && VIDEO_V4L2 && SND
>         select SND_ISA
>         select SND_MIRO
> 
> So SND_ISA gets forced on even though the dependency on ISA_DMA_API is not
> fulfilled.  That's solved by adding the dependency on ISA_DMA_API to
> RADIO_MIROPCM20.

Another option would be to convert the two above selects into depends on.

Cheers,
Mauro
