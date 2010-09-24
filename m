Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab0IXG5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 02:57:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62872 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab0IXG5U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 02:57:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JVTh2SnA9aOsZrQC4gxlo37xOy7PFaikpW2auGN9eieq4fzD23VFDbvdyjeBxar2/a
         dUbNvvFTgfXRMQ811WR/n/2EKGjbdr+0gLlEQn/JJdvOtyMss9XintHYZpOuaYns6Zyf
         y7Ts1TbI/GuX0JN+xnN0QOHlIe5Bapv7iMxm0=
MIME-Version: 1.0
In-Reply-To: <4C9BE577.4050504@fluff.org>
References: <20100923190212.18863.25678.stgit@darius-desktop>
	<4C9BE577.4050504@fluff.org>
Date: Fri, 24 Sep 2010 09:57:19 +0300
Message-ID: <AANLkTi=S8v19iT1DC=6Nh9BEgRvKzyzKTKoJmS0Bw1Fb@mail.gmail.com>
Subject: Re: [RESEND PATCH] serial: samsung: fix device name
From: Darius Augulis <augulis.darius@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        linux-kernel@vger.kernel.org, paulius.zaleckas@gmail.com,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 24, 2010 at 2:40 AM, Ben Dooks <ben-linux@fluff.org> wrote:
> On 23/09/10 20:15, Darius Augulis wrote:
>> Swap device and driver names in serial/samsung.c
>
> This is far too short, please see the notes below on trying
> to make this more informative.
>
>> Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
>> ---
>>
>> This patch was submitted about 3 months ago, but still not merged.
>> There was another similar patch from Joonyoung Shim
>> <jy0922.shim@samsung.com> and was discussed here:
>> http://marc.info/?l=linux-serial&m=127416101222281&w=2.
>> Joonyoung Shim acked my patch and other people on ARM mailing list
>> acked it. The maintainer, Ben Dooks, still not responding for
>> a long time. Another maintainer, Kukjin Kim, refused to merge
>> it without Ben's review.
>> I would like to ask somebody pick up this bugfix.
>
> I belive last time this was brought up I asked about the affect
> this has on the userspace. The following issues would be helpful
> or essential to have noted in the header about the effect of this.
>
> - Does it change the /dev name of the device? if so I would thinl
>  carefully about applying it, as it would be a change in the way
>  that userspace sees the kernel.

It does - now devices are named /dev/s3c2410_serial, and patch changes
its name to /dev/ttySAC

>
> - Does it change the kernel output itself? A note on what diffeences
>  can be seen in things like dmesg would be helpful.

It does. Serial driver reports device names when probing, so there
will appear ttySACx instead of
s3c2410_serialx.

>
> - Are there any other side effects
>
> - Why is this a bug? Maybe the previous points will explain what is
>  going on, but if not, then a reasonably concise description of
>  what is going on here.

This is bug, because of several points:

1. Because it contradicts kernel documentation. Please read
Documentation/arm/Samsung-S3C24XX/Overview.txt line 196.
This should be enough to apply this patch.

2. Because s3c2410_serial isn't correct name for serial device node.
It's name of Samsung serial driver.

3. Because now almost all userspace systems workaround it by creating symlink
/dev/ttySACx > /dev/s3c2410_serialx and only then put some getty on
created symlink, not on original device.
Systems which don't create this symlink, fail to boot at all, because
of wrong console name. Good example is Buildroot.

>
>>  drivers/serial/samsung.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/serial/samsung.c b/drivers/serial/samsung.c
>> index b1156ba..25c0d0f 100644
>> --- a/drivers/serial/samsung.c
>> +++ b/drivers/serial/samsung.c
>> @@ -883,10 +883,10 @@ static struct uart_ops s3c24xx_serial_ops = {
>>
>>  static struct uart_driver s3c24xx_uart_drv = {
>>       .owner          = THIS_MODULE,
>> -     .dev_name       = "s3c2410_serial",
>> +     .driver_name    = "s3c2410_serial",
>>       .nr             = CONFIG_SERIAL_SAMSUNG_UARTS,
>>       .cons           = S3C24XX_SERIAL_CONSOLE,
>> -     .driver_name    = S3C24XX_SERIAL_NAME,
>> +     .dev_name       = S3C24XX_SERIAL_NAME,
>>       .major          = S3C24XX_SERIAL_MAJOR,
>>       .minor          = S3C24XX_SERIAL_MINOR,
>>  };
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
>
