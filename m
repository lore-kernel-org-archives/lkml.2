Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761225Ab0HMBnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 21:43:41 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59173 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab0HMBnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 21:43:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vV8IGrbunqXOyiq4bEGU95JaM0LcV2l2lRzwE3tBHnWfeE4bo+R6XC8CbbENKIroEA
         mHWg5tPap7AVFz3Ip4vCm2DtmzQqm5MnO+9g8ugBSOS9v8HBeHGDYey5uhYgIdnnEzxr
         jo8hizHIEI1wBhb/dlcNhCCD+Py0f6Kw3gHuE=
MIME-Version: 1.0
In-Reply-To: <AANLkTin7+UPYJ5tsyrbUhxcEfbHLMVJQOSrV1_3zQ0V3@mail.gmail.com>
References: <201008111659.o7BGxn4g029524@hera.kernel.org>
	<AANLkTin7+UPYJ5tsyrbUhxcEfbHLMVJQOSrV1_3zQ0V3@mail.gmail.com>
Date: Fri, 13 Aug 2010 09:43:38 +0800
Message-ID: <AANLkTimbtkvrE0Lhk4vcq-4N3Sr8T84zD7-pkSotO66L@mail.gmail.com>
Subject: Re: rtc/m41t80: use rtc_valid_tm() to check returned tm
From: Wan ZongShun <mcuos.com@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/13 Geert Uytterhoeven <geert@linux-m68k.org>:
> On Wed, Aug 11, 2010 at 18:59, Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org> wrote:
>> Gitweb:     http://git.kernel.org/linus/b485fe5ea1008db02abff9ef15be4f31b52df4f7
>
>>    rtc/m41t80: use rtc_valid_tm() to check returned tm
>>
>>    Use rtc_valid_tm() to check returned struct rtc_time *tm - it can avoid
>>    returning wrong tm value.
>
>> diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
>> index 6dc4e62..66377f3 100644
>> --- a/drivers/rtc/rtc-m41t80.c
>> +++ b/drivers/rtc/rtc-m41t80.c
>
>> @@ -364,7 +364,7 @@ static int m41t80_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *t)
>>        t->time.tm_isdst = -1;
>>        t->enabled = !!(reg[M41T80_REG_ALARM_MON] & M41T80_ALMON_AFE);
>>        t->pending = !!(reg[M41T80_REG_FLAGS] & M41T80_FLAGS_AF);
>> -       return 0;
>> +       return rtc_valid_tm(t);
>
> warning: passing argument 1 of ‘rtc_valid_tm’ from incompatible pointer type
>
> `t' is of type `struct rtc_wkalrm *', not `struct rtc_time *'.
> Probably the intention was:
>
>        return rtc_valid_tm(&t->time);

Okay, thank you point this warning.

Andrew ,

Could you please fix this warning directly for me?
'return rtc_valid_tm(t)' should be insteaded by 'return
rtc_valid_tm(&t->time);'.

thanks!


>
> ??
>
>>  }
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
>



-- 
*linux-arm-kernel mailing list
mail addr:linux-arm-kernel@lists.infradead.org
you can subscribe by:
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

* linux-arm-NUC900 mailing list
mail addr:NUC900@googlegroups.com
main web: https://groups.google.com/group/NUC900
you can subscribe it by sending me mail:
mcuos.com@gmail.com
