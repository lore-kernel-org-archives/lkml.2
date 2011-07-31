Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab1GaTl5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 15:41:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57205 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab1GaTlv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 15:41:51 -0400
MIME-Version: 1.0
In-Reply-To: <20110731164208.GP15795@trinity.fluff.org>
References: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
	<20110729211430.6c4830bd.rdunlap@xenotime.net>
	<CAP=VYLrtumuSM_ncO6sEr7=HciiKcOsB=yN4NZnAxesjSSOgMw@mail.gmail.com>
	<20110731164208.GP15795@trinity.fluff.org>
Date: Sun, 31 Jul 2011 15:41:50 -0400
X-Google-Sender-Auth: 7Gs6EmAMqJv_u_lsc7udWb3qcn4
Message-ID: <CAP=VYLr=GY1g==cJPnHKoBDBhsRy1am6FFkdJFkoO8HsB+6R2Q@mail.gmail.com>
Subject: Re: [PATCH -next] i2c: i2c-pxa-pci.c needs module.h
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Ben Dooks <ben-i2c@fluff.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-i2c@vger.kernel.org,
        akpm <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, khali@linux-fr.org,
        ben-linux@fluff.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 12:42 PM, Ben Dooks <ben-i2c@fluff.org> wrote:
> On Sat, Jul 30, 2011 at 03:09:32PM -0400, Paul Gortmaker wrote:
>> On Sat, Jul 30, 2011 at 12:14 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> > From: Randy Dunlap <rdunlap@xenotime.net>
>> >
>> > i2c-pxa-pci.c uses interfaces from linux/module.h, so it should
>> > include that file.  This fixes build errors.
>>
>> Applied to module.h-split, thanks.
>
> ok, so I don't need to apply this one?

Nope, I've got it.  There are so many implicit module.h uses, that while
farming them all out to subtrees could in theory be done, it really isn't
all that practical (or timely).

Thanks,
Paul.

> Acked-by: Ben Dooks <ben-linux@fluff.org>
>
>> P.
>>
>> >
>> > Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>> > ---
>> >  drivers/i2c/busses/i2c-pxa-pci.c |    1 +
>> >  1 file changed, 1 insertion(+)
>> >
>> > --- linux-next-20110729.orig/drivers/i2c/busses/i2c-pxa-pci.c
>> > +++ linux-next-20110729/drivers/i2c/busses/i2c-pxa-pci.c
>> > @@ -3,6 +3,7 @@
>> >  * It does not support slave mode, the register slightly moved. This PCI
>> >  * device provides three bars, every contains a single I2C controller.
>> >  */
>> > +#include <linux/module.h>
>> >  #include <linux/pci.h>
>> >  #include <linux/platform_device.h>
>> >  #include <linux/i2c/pxa-i2c.h>
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-next" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/
>
> Large Hadron Colada: A large Pina Colada that makes the universe disappear.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
