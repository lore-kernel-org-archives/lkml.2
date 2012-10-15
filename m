Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab2JOXOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:14:33 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47511 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2JOXOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:14:32 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1210160051100.1682@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.0811091803320.23782@swampdragon.chaosbits.net>
	<CALF0-+Vtmwu9rCc9BYiDx2O2GQWezK40BYR2LP_ve2YjCt=Afg@mail.gmail.com>
	<alpine.LNX.2.00.1210152025300.1038@swampdragon.chaosbits.net>
	<alpine.LNX.2.00.1210160051100.1682@swampdragon.chaosbits.net>
Date: Mon, 15 Oct 2012 20:14:30 -0300
Message-ID: <CALF0-+UuB0y_8+SLE05Sn997HDcP5u=AJsoGvjmfSUBB__DkhQ@mail.gmail.com>
Subject: Re: [PATCH] [media] stk1160: Check return value of stk1160_read_reg()
 in stk1160_i2c_read_reg()
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 7:52 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Mon, 15 Oct 2012, Jesper Juhl wrote:
>
>> On Sat, 13 Oct 2012, Ezequiel Garcia wrote:
>>
>> > On Sun, Nov 9, 2008 at 2:04 PM, Jesper Juhl <jj@chaosbits.net> wrote:
>> > > There are two checks for 'rc' being less than zero with no change to
>> > > 'rc' between the two, so the second is just dead code - remove it.
>> > >
>> > > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>> > > ---
>> > >  drivers/media/usb/stk1160/stk1160-i2c.c |    3 ---
>> > >  1 files changed, 0 insertions(+), 3 deletions(-)
>> > >
>> > > diff --git a/drivers/media/usb/stk1160/stk1160-i2c.c b/drivers/media/usb/stk1160/stk1160-i2c.c
>> > > index 176ac93..035cf8c 100644
>> > > --- a/drivers/media/usb/stk1160/stk1160-i2c.c
>> > > +++ b/drivers/media/usb/stk1160/stk1160-i2c.c
>> > > @@ -117,9 +117,6 @@ static int stk1160_i2c_read_reg(struct stk1160 *dev, u8 addr,
>> > >                 return rc;
>> > >
>> > >         stk1160_read_reg(dev, STK1160_SBUSR_RD, value);
>> > > -       if (rc < 0)
>> > > -               return rc;
>> > > -
>> > >         return 0;
>> > >  }
>> > >
>> >
>> > Thanks for doing this. Wouldn't you like to save stk1160_read_reg
>> > return code to rc, instead of this?
>> >
>> Ahh yes, I guess I was too quick to just assume it was dead code.
>> Looking at it again; what you suggest must have been the original
>> intention. I'll cook up a new patch.
>>
>> Thanks.
>>
> From: Jesper Juhl <jj@chaosbits.net>
> Date: Sat, 13 Oct 2012 00:16:37 +0200
> Subject: [PATCH] [media] stk1160: Check return value of stk1160_read_reg() in stk1160_i2c_read_reg()
>
> Currently there are two checks for 'rc' being less than zero with no
> change to 'rc' between the two, so the second is just dead code.
> The intention seems to have been to assign the return value of
> 'stk1160_read_reg()' to 'rc' before the (currently dead) second check
> and then test /that/. This patch does that.
>


This is an overly complicated explanation for such a small patch.
Can you try to simplify it?


> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/media/usb/stk1160/stk1160-i2c.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/usb/stk1160/stk1160-i2c.c b/drivers/media/usb/stk1160/stk1160-i2c.c
> index 176ac93..a2370e4 100644
> --- a/drivers/media/usb/stk1160/stk1160-i2c.c
> +++ b/drivers/media/usb/stk1160/stk1160-i2c.c
> @@ -116,10 +116,9 @@ static int stk1160_i2c_read_reg(struct stk1160 *dev, u8 addr,
>         if (rc < 0)
>                 return rc;
>
> -       stk1160_read_reg(dev, STK1160_SBUSR_RD, value);
> +       rc = stk1160_read_reg(dev, STK1160_SBUSR_RD, value);
>         if (rc < 0)
>                 return rc;

Why are you removing this line?


> -
>         return 0;
>  }
>


Thanks,

    Ezequiel
