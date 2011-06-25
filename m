Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab1FYKkI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 06:40:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:46480 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1FYKkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 06:40:07 -0400
Message-ID: <4E05BAFE.5000501@infradead.org>
Date: Sat, 25 Jun 2011 07:39:58 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        alsa-devel@alsa-project.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] MEDIA: Fix non-ISA_DMA_API link failure
 of	sound code
References: <20110624133009.GA30076@linux-mips.org> <s5hmxh6v0k0.wl%tiwai@suse.de>
In-Reply-To: <s5hmxh6v0k0.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 25-06-2011 04:21, Takashi Iwai escreveu:
> At Fri, 24 Jun 2011 14:30:09 +0100,
> Ralf Baechle wrote:
>>
>> A build with ISA && ISA_DMA && !ISA_DMA_API results in:
>>
>>   CC      sound/isa/es18xx.o
>> sound/isa/es18xx.c: In function ‘snd_es18xx_playback1_prepare’:
>> sound/isa/es18xx.c:501:9: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
>> sound/isa/es18xx.c: In function ‘snd_es18xx_playback_pointer’:
>> sound/isa/es18xx.c:818:3: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>>
>> make[2]: *** [sound/isa/es18xx.o] Error 1
>>   CC      sound/isa/sscape.o
>> sound/isa/sscape.c: In function ‘upload_dma_data’:
>> sound/isa/sscape.c:481:3: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>>
>> make[2]: *** [sound/isa/sscape.o] Error 1
>>   CC      sound/isa/ad1816a/ad1816a_lib.o
>> sound/isa/ad1816a/ad1816a_lib.c: In function ‘snd_ad1816a_playback_prepare’:
>> sound/isa/ad1816a/ad1816a_lib.c:244:2: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
>> sound/isa/ad1816a/ad1816a_lib.c: In function ‘snd_ad1816a_playback_pointer’:
>> sound/isa/ad1816a/ad1816a_lib.c:302:2: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
>> sound/isa/ad1816a/ad1816a_lib.c: In function ‘snd_ad1816a_free’:
>> sound/isa/ad1816a/ad1816a_lib.c:544:3: error: implicit declaration of function ‘snd_dma_disable’ [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>>
>> make[3]: *** [sound/isa/ad1816a/ad1816a_lib.o] Error 1
>> make[3]: Target `__build' not remade because of errors.
>> make[2]: *** [sound/isa/ad1816a] Error 2
>>   CC      sound/isa/es1688/es1688_lib.o
>> sound/isa/es1688/es1688_lib.c: In function ‘snd_es1688_playback_prepare’:
>> sound/isa/es1688/es1688_lib.c:417:2: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
>> sound/isa/es1688/es1688_lib.c: In function ‘snd_es1688_playback_pointer’:
>> sound/isa/es1688/es1688_lib.c:509:2: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>>
>> make[3]: *** [sound/isa/es1688/es1688_lib.o] Error 1
>> make[3]: Target `__build' not remade because of errors.
>> make[2]: *** [sound/isa/es1688] Error 2
>>   CC      sound/isa/gus/gus_dma.o
>> sound/isa/gus/gus_dma.c: In function ‘snd_gf1_dma_program’:
>> sound/isa/gus/gus_dma.c:79:2: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
>> sound/isa/gus/gus_dma.c: In function ‘snd_gf1_dma_done’:
>> sound/isa/gus/gus_dma.c:177:3: error: implicit declaration of function ‘snd_dma_disable’ [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>>
>> make[3]: *** [sound/isa/gus/gus_dma.o] Error 1
>>   CC      sound/isa/gus/gus_pcm.o
>> sound/isa/gus/gus_pcm.c: In function ‘snd_gf1_pcm_capture_prepare’:
>> sound/isa/gus/gus_pcm.c:591:2: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
>> sound/isa/gus/gus_pcm.c: In function ‘snd_gf1_pcm_capture_pointer’:
>> sound/isa/gus/gus_pcm.c:619:2: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>>
>> make[3]: *** [sound/isa/gus/gus_pcm.o] Error 1
>> make[3]: Target `__build' not remade because of errors.
>> make[2]: *** [sound/isa/gus] Error 2
>>   CC      sound/isa/sb/sb16_csp.o
>> sound/isa/sb/sb16_csp.c: In function ‘snd_sb_csp_ioctl’:
>> sound/isa/sb/sb16_csp.c:228:227: error: case label does not reduce to an integer constant
>> make[3]: *** [sound/isa/sb/sb16_csp.o] Error 1
>>   CC      sound/isa/sb/sb16_main.o
>> sound/isa/sb/sb16_main.c: In function ‘snd_sb16_playback_prepare’:
>> sound/isa/sb/sb16_main.c:276:2: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
>> sound/isa/sb/sb16_main.c: In function ‘snd_sb16_playback_pointer’:
>> sound/isa/sb/sb16_main.c:456:2: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>>
>> make[3]: *** [sound/isa/sb/sb16_main.o] Error 1
>>   CC      sound/isa/sb/sb8_main.o
>> sound/isa/sb/sb8_main.c: In function ‘snd_sb8_playback_prepare’:
>> sound/isa/sb/sb8_main.c:172:3: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
>> sound/isa/sb/sb8_main.c: In function ‘snd_sb8_playback_pointer’:
>> sound/isa/sb/sb8_main.c:425:2: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>>
>> make[3]: *** [sound/isa/sb/sb8_main.o] Error 1
>> make[3]: Target `__build' not remade because of errors.
>> make[2]: *** [sound/isa/sb] Error 2
>>   CC      sound/isa/wss/wss_lib.o
>> sound/isa/wss/wss_lib.c: In function ‘snd_wss_playback_prepare’:
>> sound/isa/wss/wss_lib.c:1025:2: error: implicit declaration of function ‘snd_dma_program’ [-Werror=implicit-function-declaration]
>> sound/isa/wss/wss_lib.c: In function ‘snd_wss_playback_pointer’:
>> sound/isa/wss/wss_lib.c:1160:2: error: implicit declaration of function ‘snd_dma_pointer’ [-Werror=implicit-function-declaration]
>> sound/isa/wss/wss_lib.c: In function ‘snd_wss_free’:
>> sound/isa/wss/wss_lib.c:1695:3: error: implicit declaration of function ‘snd_dma_disable’ [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>>
>> make[3]: *** [sound/isa/wss/wss_lib.o] Error 1
>>
>> The root cause for this is hidden in this Kconfig warning:
>>
>> warning: (RADIO_MIROPCM20) selects SND_ISA which has unmet direct dependencies (SOUND && !M68K && SND && ISA && ISA_DMA_API)
>>
>> Adding a dependency on ISA_DMA_API to RADIO_MIROPCM20 fixes these issues.
>>
>> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> 
> Acked-by: Takashi Iwai <tiwai@suse.de>

Ralf,

Do you want do send this patch directly? If so:
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Otherwise, I can just add it into my tree with my SOB.

Both ways work fine for me.

Thanks,
Mauro
> 
> 
> thanks,
> 
> Takashi
> 
>>
>>  drivers/media/radio/Kconfig |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
>> index e4c97fd..0aeed28 100644
>> --- a/drivers/media/radio/Kconfig
>> +++ b/drivers/media/radio/Kconfig
>> @@ -168,7 +168,7 @@ config RADIO_MAXIRADIO
>>  
>>  config RADIO_MIROPCM20
>>  	tristate "miroSOUND PCM20 radio"
>> -	depends on ISA && VIDEO_V4L2 && SND
>> +	depends on ISA && ISA_DMA_API && VIDEO_V4L2 && SND
>>  	select SND_ISA
>>  	select SND_MIRO
>>  	---help---
>> _______________________________________________
>> Alsa-devel mailing list
>> Alsa-devel@alsa-project.org
>> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

