Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab1AJWjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:39:16 -0500
Received: from mail-iy0-f194.google.com ([209.85.210.194]:40719 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab1AJWjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:39:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jQs0mW/uHgHAWqyYJhZb/DPpRNeku+SxOF4BxuYxAmishfW/V5vk1p25i8RrJZ/oAk
         ELdDuWIRoLMrobvpg976Oaf+OQk6dqrJ7LuiT1kVRPsMaW2/qCMkJXLKiQhA5wx3wJc+
         eGQ4uAoq+TB/eCEaAJuu9uix6EkP9KVH81F1c=
MIME-Version: 1.0
In-Reply-To: <20110109071459.GA1488@ucw.cz>
References: <20101116090705.GA29337@pma.sysgo.com> <AANLkTin6QAr7=7-59aKzunh6nQGhCKPJ11OspBtC4NHB@mail.gmail.com>
 <20110109071459.GA1488@ucw.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 10 Jan 2011 16:38:54 -0600
Message-ID: <AANLkTi=5gC3ton6tzYqM=NA9j8k37NO=y1QSYb5Oxvik@mail.gmail.com>
Subject: Re: suspicious code in linux/arch/arm/common/sa1111.c
To: Pavel Machek <pavel@ucw.cz>
Cc: Pavel Machek <pma@sysgo.com>, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 9, 2011 at 1:14 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Tue 2010-11-16 17:09:59, Eric Miao wrote:
>> On Tue, Nov 16, 2010 at 5:07 PM, Pavel Machek <pma@sysgo.com> wrote:
>> > Hi!
>> >
>> > Is this good idea?
>> >
>> > Signed-off-by: Pavel Machek <pma@sysgo.com>
>>
>> Yep, obviously was a typo.
>
> Can you apply the patch? Or should I re--generate one with better changelog?

Applied with subject line as below, which I guess is more specific?

Subject: ARM: sa1111: fix typo in sa1111_retrigger_lowirq()


>
>> > diff -ur linux.ofic//arch/arm/common/sa1111.c linux/arch/arm/common/sa1111.c
>> > --- linux.ofic//arch/arm/common/sa1111.c        2010-10-17 20:31:13.000000000 +0200
>> > +++ linux/arch/arm/common/sa1111.c      2010-11-05 10:44:17.000000000 +0100
>> > @@ -282,7 +312,7 @@
>> >        for (i = 0; i < 8; i++) {
>> >                sa1111_writel(ip0 ^ mask, mapbase + SA1111_INTPOL0);
>> >                sa1111_writel(ip0, mapbase + SA1111_INTPOL0);
>> > -               if (sa1111_readl(mapbase + SA1111_INTSTATCLR1) & mask)
>> > +               if (sa1111_readl(mapbase + SA1111_INTSTATCLR0) & mask)
>> >                        break;
>> >        }
>> >
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
