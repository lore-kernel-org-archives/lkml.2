Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab0I3Ucv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:32:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51270 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab0I3Ucu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:32:50 -0400
MIME-Version: 1.0
In-Reply-To: <20100930221426.5d0d3e7d@schatten.dmk.lab>
References: <1284284969.2928.18.camel@maxim-laptop> <1284511071.3551.1.camel@maxim-laptop>
 <AANLkTikF37hN7dFqPbCp-gcim7SarveaTrjXipnGpJM7@mail.gmail.com>
 <20100915132731.GA20558@khazad-dum.debian.net> <AANLkTinGDUxsgaGey7EnYOu3kKP-YRE00gL33hiKvAWj@mail.gmail.com>
 <1284589207.4672.3.camel@maxim-laptop> <AANLkTin37rbEbcGDejhcsnxZNYhhUWGy+x=v4Y=s0_Qx@mail.gmail.com>
 <1285069338.3124.4.camel@maxim-laptop> <1285110590.2822.9.camel@maxim-laptop>
 <4C99B25D.20805@kernel.org> <1285162900.3335.15.camel@maxim-laptop>
 <1285163911.3159.5.camel@maxim-laptop> <4C9B141F.3050908@kernel.org>
 <AANLkTim31g84J6eeuh_6MiEw0w8zOi5sOWrL_WnoaueP@mail.gmail.com>
 <20100930083020.62b56218@schatten.dmk.lab> <AANLkTi=G42-0X0MWsgTaDKEnHocFEa+9Cmw4pfCMAk5=@mail.gmail.com>
 <20100930133823.39353d23@schatten.dmk.lab> <1285856252.26846.12.camel@maxim-laptop>
 <20100930164918.22f40a83@schatten.dmk.lab> <AANLkTim_ZW6D6TKNh9W5Qn2biC0_BQcPuMKKKS6_X-bp@mail.gmail.com>
 <20100930221426.5d0d3e7d@schatten.dmk.lab>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 30 Sep 2010 22:32:33 +0200
Message-ID: <AANLkTinMuLUB-vsiecMYHWv4ZbWE6yGB_K-8XB6GmaOv@mail.gmail.com>
Subject: Re: [REGRESSION] cdrom drive doesn't detect removal
To: Florian Mickler <florian@mickler.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Tejun Heo <tj@kernel.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 22:14, Florian Mickler <florian@mickler.org> wrote:
> On Thu, 30 Sep 2010 21:27:52 +0200 Kay Sievers <kay.sievers@vrfy.org> wrote:

>> I don't think anything needs to be or can really be fixed in the
>> kernel. We need a working O_EXCL, and before Tejun's patch it was
>> broken. That the broken behavior seemed to have some wanted effects on
>> some boxes can't the reason to leave O_EXCL broken.
>
> Ack on this on the technical side.
>
> But we have to look from the user side at this, as bug tracking is
> mostly a tool to get feedback from the users. So if we close this bug,
> we loose valuable feedback on the functioning of the kernel.
>
> So, I can't really close the report if it is not resolved in any way.

As said, it can't be resolved. That it seemed to work was a buggy
O_EXCL, which let stuff through the O_EXCL barrier, which was never
supposed to reach the drive. I can't even reproduce that on older
kernels. It seems like a specific timing problem.

> The issue is that the cdrom drive does not detect removal while it is
> mounted.
>
> Do you see any way, how userspace can change this without kernel help?

Sure, it can open the device without O_EXCL like HAL. But successors
of HAL stopped doing that because it broke too many burning sessions.

>> The current state is the expected behavior.
>
> Expected for a kernel developer who understands the inner workings of
> his system. For a user, I'd argue, this is not expected.

Yeah, might be. There is still nothing I think we can do at the moment
at the kernel side.

>> It all seems more like an
>> issue with current udisks which should be discussed at the freedesktop
>> bugzilla. Udisk's behavior is intended, but there might be no specific
>> reason not to change it to what HAL did.
>
> I think we can close this, as soon as we have an acknowledged bug by
> the udisks maintainer. But not earlier.

It's not a bug of udisks, it's decided to do it that way. It can be
discussed though.

> At the moment, I don't see this issue as resolved.

Sure, no problem. I'm just saying that nobody can fix the problem in
the kernel without adding something completely new like in-kernel
polling. And that might take a longer time to get actually enabled by
default. :)

Kay
