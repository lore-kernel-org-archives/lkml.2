Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab1GMWGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 18:06:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:32869 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1GMWGP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 18:06:15 -0400
MIME-Version: 1.0
In-Reply-To: <20110713150023.0dde9ef4.rdunlap@xenotime.net>
References: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
	<CACqU3MWBb4J8rmaRv23=-_=GXppGSUdqmOqeXoqWi4ZJ7ZYewg@mail.gmail.com>
	<20110713150023.0dde9ef4.rdunlap@xenotime.net>
Date: Wed, 13 Jul 2011 18:06:15 -0400
Message-ID: <CACqU3MVh+4JMX5ywPgWrrXXuAcAYtHJyumXGDcteageJAG12wA@mail.gmail.com>
Subject: Re: [PATCH 1/9] stringify: add HEX_STRING()
From: Arnaud Lacombe <lacombar@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
        linux-media@vger.kernel.org, mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 13, 2011 at 6:00 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Wed, 13 Jul 2011 17:49:48 -0400 Arnaud Lacombe wrote:
>
>> Hi,
>>
>> On Sun, Jul 10, 2011 at 3:51 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> > From: Randy Dunlap <rdunlap@xenotime.net>
>> >
>> > Add HEX_STRING(value) to stringify.h so that drivers can
>> > convert kconfig hex values (without leading "0x") to useful
>> > hex constants.
>> >
>> > Several drivers/media/radio/ drivers need this.  I haven't
>> > checked if any other drivers need to do this.
>> >
>> > Alternatively, kconfig could produce hex config symbols with
>> > leading "0x".
>> >
>> Actually, I used to have a patch to make hex value have a mandatory
>> "0x" prefix, in the Kconfig. I even fixed all the issue in the tree,
>> it never make it to the tree (not sure why). Here's the relevant
>> thread:
>>
>> https://patchwork.kernel.org/patch/380591/
>> https://patchwork.kernel.org/patch/380621/
>> https://patchwork.kernel.org/patch/380601/
>>
>
> I prefer that this be fixed in kconfig, so long as it won't cause
> any other issues.  That's why I mentioned it.
>
>>
>> > Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>> > ---
>> >  include/linux/stringify.h |    7 +++++++
>> >  1 file changed, 7 insertions(+)
>> >
>> > NOTE: The other 8 patches are on lkml and linux-media mailing lists.
>> >
>> > --- linux-next-20110707.orig/include/linux/stringify.h
>> > +++ linux-next-20110707/include/linux/stringify.h
>> > @@ -9,4 +9,11 @@
>> >  #define __stringify_1(x...)    #x
>> >  #define __stringify(x...)      __stringify_1(x)
>> >
>> > +/*
>> > + * HEX_STRING(value) is useful for CONFIG_ values that are in hex,
>> > + * but kconfig does not put a leading "0x" on them.
>> > + */
>> > +#define HEXSTRINGVALUE(h, value)       h##value
>> > +#define HEX_STRING(value)              HEXSTRINGVALUE(0x, value)
>> > +
>> that seems hackish...
>
> It's a common idiom for concatenating strings in the kernel.
>
I meant hackish not because *how* it is done, but because *why* it has
to be done, that is, because the Kconfig miss the prefix, which is
really no big deal.

> How would you do it without (instead of) a kconfig fix/patch?
>
have the Kconfig use the "0x" prefix since the beginning.

 - Arnaud

>> >  #endif /* !__LINUX_STRINGIFY_H */
>> > --
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
