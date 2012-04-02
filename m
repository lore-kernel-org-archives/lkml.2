Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab2DBTkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 15:40:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:33041 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab2DBTkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 15:40:11 -0400
References: <1333307374-25848-1-git-send-email-tdent48227@gmail.com> <201204012124.48701.hverkuil@xs4all.nl>
User-Agent: K-9 Mail for Android
In-Reply-To: <201204012124.48701.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] Drivers/media/radio: Fix build error
From: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Mon, 02 Apr 2012 16:39:52 -0300
To: Hans Verkuil <hverkuil@xs4all.nl>, Tracey Dent <tdent48227@gmail.com>
CC: linux-kernel@vger.kernel.org, shea@shealevy.com,
        torvalds@linux-foundation.org, hans.verkuil@cisco.com,
        linux-media@vger.kernel.org
Message-ID: <92eed2c4-aeb6-4b32-b69c-b51238ead440@email.android.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans Verkuil <hverkuil@xs4all.nl> wrote:

>On Sunday, April 01, 2012 21:09:34 Tracey Dent wrote:
>> radio-maxiradio depends on SND_FM801_TEA575X_BOOL to build or will
>> result in an build error such as:
>> 
>> Kernel: arch/x86/boot/bzImage is ready  (#1)
>> ERROR: "snd_tea575x_init" [drivers/media/radio/radio-maxiradio.ko]
>undefined!
>> ERROR: "snd_tea575x_exit" [drivers/media/radio/radio-maxiradio.ko]
>undefined!
>> WARNING: modpost: Found 6 section mismatch(es).
>> To see full details build your kernel with:
>> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>> make[1]: *** [__modpost] Error 1
>> make: *** [modules] Error 2
>> 
>> Select CONFIG_SND_TEA575X to fixes problem and enable
>> the driver to be built as desired.
>> 
>> v2:
>> instead of selecting CONFIG_SND_FM801_TEA575X_BOOL, select
>> CONFIG_SND_TEA575X, which in turns selects
>CONFIG_SND_FM801_TEA575X_BOOL
>> and any other dependencies for it to build.
>
>No, this is the correct patch:
>
>diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
>index 8816804..5ca0939 100644
>--- a/sound/pci/Kconfig
>+++ b/sound/pci/Kconfig
>@@ -2,8 +2,8 @@
> 
> config SND_TEA575X
> 	tristate
>-	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO ||
>RADIO_SF16FMR2
>-	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2
>+	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO ||
>RADIO_SF16FMR2 || RADIO_MAXIRADIO
>+	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2 || RADIO_MAXIRADIO
> 
> menuconfig SND_PCI
> 	bool "PCI sound devices"
>
>RADIO_MAXIRADIO should be treated just like RADIO_SF16FMR2, I just
>didn't
>realize at the time that it had to be added as a SND_TEA575X
>dependency.
>
>Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
>(Sorry for the late reply, I didn't have access to my cisco email for
>the last
>few days).
>
>Regards,
>
>	Hans
>
>> 
>> Reported-by: Shea Levy <shea@shealevy.com>
>> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
>> ---
>>  drivers/media/radio/Kconfig |    1 +
>>  1 file changed, 1 insertion(+)
>> 
>> diff --git a/drivers/media/radio/Kconfig
>b/drivers/media/radio/Kconfig
>> index 8db2d7f..b518ce5 100644
>> --- a/drivers/media/radio/Kconfig
>> +++ b/drivers/media/radio/Kconfig
>> @@ -44,6 +44,7 @@ config USB_DSBR
>>  config RADIO_MAXIRADIO
>>  	tristate "Guillemot MAXI Radio FM 2000 radio"
>>  	depends on VIDEO_V4L2 && PCI && SND
>> +	select SND_TEA575X
>>  	---help---
>>  	  Choose Y here if you have this radio card.  This card may also be
>>  	  found as Gemtek PCI FM.
>> 


Cheers,
Mauro
--
>From my phone
