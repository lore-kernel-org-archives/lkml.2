Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab1FGEjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 00:39:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54354 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1FGEjf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 00:39:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=kq/Iakg85LI6UnpHd4rlYpCCeUBMhsiI4cRRpIpPOfagvYJ4v72NTPoPQ5STJRGspw
         FChi/DTZdnpEzEnJBpEAljG2XdPmjqkRH7TgCVWEB08ahExXmTfobjw+tKcZZOHBMpq9
         3BkxidZT72j0jYK75DvvpsMGzeMyBULvpb+Zw=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=LXBgyae2Man7PpqCwR7L0=R7pYg@mail.gmail.com>
References: <20110606070553.9829.40823.stgit@ponder> <BANLkTim3RgRJoNY61iRuCELvyuNhm==PtA@mail.gmail.com>
 <BANLkTinxYQa=EU=t4m8VUT4X9h0xvaaXQg@mail.gmail.com> <BANLkTi=LXBgyae2Man7PpqCwR7L0=R7pYg@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 7 Jun 2011 00:39:14 -0400
Message-ID: <BANLkTinOPVo9TL5sgf9qVAjaw=83N2kYKQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: reorganize drivers
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Roland Dreier <roland@purestorage.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 13:37, Grant Likely wrote:
> On Mon, Jun 6, 2011 at 11:33 AM, Grant Likely wrote:
>> On Mon, Jun 6, 2011 at 11:27 AM, Roland Dreier wrote:
>>> On Mon, Jun 6, 2011 at 12:06 AM, Grant Likely wrote:
>>>> Sort the gpio makefile and enforce the naming convention gpio-*.c for
>>>> gpio drivers.
>>>
>>> OK, bikeshed colors here, but... what is the benefit of
>>> 'drivers/gpio/gpio-xxx.c' vs
>>> just 'drivers/gpio/xxx.c'?  Seems like one 'gpio' should be enough for anyone...
>>
>> lsmod
>
> Specifically, module names don't give any clues about which directory
> they were loaded out of, so it is useful to have the module name
> reflect exactly what the module is for.  Second, a lot of these
> gpio/spi/i2c cores end up being stuffed into an integrated chipset
> where they all pretty much share the same name, but the drivers are
> for different functional blocks.  ie. gpio-omap.o, spi-omap.o,
> i2c-omap.o

well, more important is the opposite direction ... if we have
gpio/omap.c and i2c/omap.c and spi/omap.c, which "omap.ko" is
`modprobe` going to load ?

and if you `rmmod omap`, which one is going to be unloaded ?

i wonder if the module core even allows for that ...
-mike
