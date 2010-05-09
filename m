Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab0EISYV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 14:24:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57395 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab0EISYT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 14:24:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Z/B8weekTuX2iYW1+dyVHjxnFkKwoO1uALRgm3rfU+93ORMC6y/dlYN+5UkC4lVh6A
         ip6cU4mz8w/Bc17oY3GVslJqNqoTU/mSDVs/P7WtMMZap4+y2vrCtTkWYMJCuIKHSccF
         ndjf1RR9BZ0A8IPQ/NrIze0WIGHp3V+tF4xvc=
MIME-Version: 1.0
In-Reply-To: <20100509113420.GB2589@trinity.fluff.org>
References: <1273403087-3326-1-git-send-email-vapier@gentoo.org> 
	<20100509113420.GB2589@trinity.fluff.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 9 May 2010 14:23:58 -0400
Message-ID: <o2l8bd0f97a1005091123le4e59343j798a70d5db76c66e@mail.gmail.com>
Subject: Re: [PATCH] i2c-bfin-twi: handle faulty slave devices better
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 9, 2010 at 07:34, Ben Dooks wrote:
> On Sun, May 09, 2010 at 07:04:47AM -0400, Mike Frysinger wrote:
>> From: Michael Hennerich <michael.hennerich@analog.com>
>>
>> Faulty slave devices might drive SDA low after a transfer finishes.  So,
>> when this scenario is detected, have the master generate up to 8 extra
>> clocks until the SDA is properly released.
>>
>> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> ---
>> Note: this requires the existing Blackfin TWI patches already sent out
>
> hmm, it is late in the -rc series for anything other than critical
> bugfixes, will update series tomorrow.

this patch is fine for 2.6.35, but the rest of the series should have
been merged for like 2.6.33 ...

>>  drivers/i2c/busses/i2c-bfin-twi.c |   22 ++++++++++++++++++++++
>>  1 files changed, 22 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
>> index fb26e5c..f9c05e1 100644
>> --- a/drivers/i2c/busses/i2c-bfin-twi.c
>> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
>> @@ -20,6 +20,7 @@
>>  #include <linux/completion.h>
>>  #include <linux/interrupt.h>
>>  #include <linux/platform_device.h>
>> +#include <linux/delay.h>
>>
>>  #include <asm/blackfin.h>
>>  #include <asm/portmux.h>
>> @@ -159,6 +160,27 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
>>               if (mast_stat & BUFWRERR)
>>                       dev_dbg(&iface->adap.dev, "Buffer Write Error\n");
>>
>> +             /* Faulty salve devices, may drive SDA low after a transfer
> spello: slave

ok, i'll resend in a bit
-mike
