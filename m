Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab0IACKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 22:10:52 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55489 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab0IACKv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 22:10:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=aLHv6jJ81EsxaLo0/AJuvBjzJlqZ6Eso3pAQ2E8E9ephmNB3CtmGRA3uFiNnpHW5cF
         XCS2ZF6Aq/UYC4ZPeToHYTK2t8laiDTaA4gN0QInxDydsd17b2lp2o09k6U5ceC/G0+l
         BAwYQlnn8IZ9+/5Sroa94vR8uj3ny9Z46e+rE=
MIME-Version: 1.0
In-Reply-To: <011701cb4967$1ee563c0$5cb02b40$%kim@samsung.com>
References: <20100830114729.GA13150@july>
	<006301cb483c$434f76f0$c9ee64d0$%kim@samsung.com>
	<AANLkTimxhFtfB8G-z=04zj7ZRq+f7GDaVX5mzgCENuvx@mail.gmail.com>
	<011701cb4967$1ee563c0$5cb02b40$%kim@samsung.com>
Date: Wed, 1 Sep 2010 11:10:46 +0900
X-Google-Sender-Auth: DD3IdaoZPWpltr435rV2-akIEFs
Message-ID: <AANLkTinQeBDU=0D1WgBJHHsgtWH3V0w1bdgBWPSVgBb+@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: Samsung S3C: Move/use the S3C common GPIO IRQ type
From: Kyungmin Park <kmpark@infradead.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jy0922.shim@samsung.com, m.szyprowski@samsung.com, ben-linux@fluff.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 1, 2010 at 8:49 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Kyungmin Park wrote:
>>
>> On Mon, Aug 30, 2010 at 9:09 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
>> > Kyungmin Park wrote:
>> >>
>> >> From: Kyungmin Park <kyungmin.park@samsung.com>
>> >>
>> >> Samsung S3C series have the common GPIO IRQ type for all S3C series.
>> >>
>> > I can't agree with your changing name. Why do you want to change the
> name?
>> > If you want to move S3C2410_EXTINT_XXX from regs-irqtype.h, just move
>> > without any changes.
>> As S5P series change the name conversion. I will also modify the s3c
> series.
>>
> I think that we don’t need to change for it.
> And as you see, there is no difference between S3C2410_XXX and S3C_XXX.
>> >
>> > But I'm still thinking why should we move the external interrupt
> definitions
>> > to plat/gpio-core.h...
>>
>> To use the GPIO interrupt. these definitions are used both external
>> interrupt and GPIO interrupt.
>
>
>> >
>> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> >> ---
>
> (snip)
>
>> >>
>> >> +#define S3C_GPIO_LEVEL_LOW           (0x00)
>> >> +#define S3C_GPIO_LEVEL_HIGH          (0x01)
>> >> +#define S3C_GPIO_EDGE_FALLING                (0x02)
>> >> +#define S3C_GPIO_EDGE_RISING         (0x04)
>> >> +#define S3C_GPIO_EDGE_BOTH           (0x06)
>> >> +
>> > GPIO_LELVEL? GPIO_EDGE?...
>> >
>> > I think EXTINT_LEVEL_XXX and EXTINT_EDGE_XXX are more clear.
>>
>>        case IRQ_TYPE_EDGE_BOTH:
>>              newvalue = S3C_GPIO_EDGE_BOTH;
>>
>> Don't you it's more clear?
>>
> I don't think so, I meant that it is used for external interrupt not gpio.
> And it used currently for external interrupt.
I also don't think so. GPIO interrupt has the same function and no
need to bind these name to external interrupt.

At the spec. no difference between external interrupt and gpios. As
you don't use the GPIO interrupts. don't say it's for external
interrupt.

>
> So, I said that no need to change it now.
>
> Thanks.
>
> Best regards,
> Kgene.
> --
> Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
>
>
