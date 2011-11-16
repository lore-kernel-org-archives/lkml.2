Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab1KPDAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 22:00:12 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59618 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1KPDAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 22:00:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAN_1Rdv8SZXu2RSJgXT9KJXp30UKgZGLhOHX7igLQuv92UZ6tA@mail.gmail.com>
References: <1321006467-15824-1-git-send-email-peiyong.feng.kernel@gmail.com>
	<CAJuYYwRueftNrWofo744vWXPa+vkgv3r4CyOr_Q_GNrcfct4YA@mail.gmail.com>
	<CAN_1RdvdeXHdM50utA8objg46Q2GM23pwzAiB7itswrTm1FqSQ@mail.gmail.com>
	<006201cca380$43998e20$caccaa60$%kim@samsung.com>
	<CAN_1Rdv8SZXu2RSJgXT9KJXp30UKgZGLhOHX7igLQuv92UZ6tA@mail.gmail.com>
Date: Wed, 16 Nov 2011 08:30:09 +0530
Message-ID: <CAJuYYwSyatMAvJEZsTdoHf72ivfB1UJdhjnP0qPSH+S3TPuu+A@mail.gmail.com>
Subject: Re: [PATCH] Add dm9000 network support for OK6410 board.
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Peiyong Feng <peiyong.feng.kernel@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 November 2011 07:40, Peiyong Feng <peiyong.feng.kernel@gmail.com> wrote:
> HI Kukjin,
>
> Thanks a lot for your comments and reply.
>
>
> 2011/11/15 Kukjin Kim <kgene.kim@samsung.com>:
>> Peiyong Feng wrote:
>>>
>> Hi Peiyong,
>>
>> Thanks for your submitting and replying.
>> But you need to make sure your e-mail uses text-typed instead of html before
>> replying.
>>
>> And there are comments below.
>>
>>> Well, The OK6410 board is based on smdk6410 board.
>>> And there many other boards that also are based on smdk6410 like mini6410
>> board.
>>>
>>> The reasons why I modified smdk6410 board file are as follows:
>>> A. Almost all the devices on OK6410 is supported in smdk6410, and the
>> device drivers of smdk6410 can work well in OK6410.
>>>
>> Okay, you mean, just your OK6410 can work with smdk6410.
>>
> As far as I know, there are some boards based on smdk6410 with the
> suffix 6410 like OK6410, mini6410, tiny6410, etc.
> The  difference between them is very small.

smdk6410 and ok6410 boards use (based on) Samsung's s3c6410 processor.
Boards based on s3c6410 processor should reuse existing upstream
support available for s3c6410. But, the boards themselves are
different. Both smdk6410 and ok6410 have a common s3c6410, but the
peripherals on the board are all different. So, the statement "there
are some boards based on smdk6410" is not right. The correct one would
be "there are some boards based on s3c6410".

>
> I give two examples:
> 1. The DM9000 network card`s irq  on OK6410  is IRQ_EINT(7)
>    while the SMSC911x network card`s irq on smdk6410 is
>   IRQ_EINT(10), and their CS is the same 0x18000000.

True, but smdk6410 does not have a DM9000 and adding DM9000 device
information in smdk6410 board file is not the right thing.

>
> 2. Another example is the LCD. As we all know, the kernel has
> implemented a very good framework for framebuffer devices.
> different LCD device can work with just the right arguments like
> left_margin, right_margin, hsync_len, vsync_len, xres, yres, etc.
> And their LCD controller is the same.
>>> B. If we just make other board file like mini6410 which is also based on
>> smdk6410, there maybe too many files that are as the same of smdk6410.
>>>
>> Okay, you mean, we don't need duplicated codes.
>>
>> Right, but how do you think that if the dm9000 or something cannot be used
>> on smdk6410?
>> Nevertheless, we _really_ need to add it for other board not smdk6410?
>>
>> Actually, there are codes for SMSC Lan9115 at mach-smdk6410.c......
>>
>> If you want to use mach-smdk6410.c on your ok6410, well, let us think the
>> way.
>
> Well, this is the point. How can we deal with the various boards with
> the little difference and make them work with the kernel.

What is needed is a separate board file ok6410 board. All the s3c6410
related drivers and machine code would be reused, but board specific
data would be contained in the ok6410 board file. You could have a
look at all the arch/arm/mach-s3c64xx/mach-xxx.c files to know how
different boards reuse existing s3c6410 mainline support.

Thanks,
Thomas.

[...]
