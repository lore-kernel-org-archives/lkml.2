Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab1KXOTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 09:19:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52100 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab1KXOTk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 09:19:40 -0500
MIME-Version: 1.0
In-Reply-To: <20111122135922.GA3837@opensource.wolfsonmicro.com>
References: <1321000263-20000-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805B30@HQMAIL01.nvidia.com>
	<CACRpkdYh7+kL-9iy7+VDC82OAkb+-vLiJcv02pappaTeDUriTg@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740D74FD9@HQMAIL01.nvidia.com>
	<CACRpkdaDeK3A-o775LGR9qOSGKkiQtDBuLvadw1zL26E6BgOSQ@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF174F08C2A5@HQMAIL01.nvidia.com>
	<20111122135922.GA3837@opensource.wolfsonmicro.com>
Date: Thu, 24 Nov 2011 15:19:39 +0100
Message-ID: <CACRpkdb78AAM-9JasxQ2pRLwVGj0n64bqo82oVbpaFKsMNqnaA@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: add a generic pin config interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 2:59 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Nov 21, 2011 at 03:22:59PM -0800, Stephen Warren wrote:

>> Equally, I'm not sure the case you mention is what we should be optimizing
>> for. The people who deal with these options most will be FAEs (Field
>> Application Engineers), PCB designers, ... who intimately understand
>> the details of the SoC they're working with. They'll be well-versed in
>> the SoC-specific naming of all these properties. Forcing them to map all
>> that knowledge into an all-encompassing abstraction is only going to make
>> their life harder, and lead to mistakes.
>
> I'd second this - in my experience detailed setup for these settings
> usually comes from hardware engineers in the form of "set register X to
> value Y".  Having to decode the sematics does make things that little
> bit harder.

I'm a bit reluctant, since the above is sometimes referred to as
"throw over the wall engineering" and is generally considered a bad
way of doing things.

But now that you are two smart guys telling me this I gues I'll
just back out a bit, let's say I make the generic pin configs
optional, select HAVE_GENERIC_PINCONF for those who
are convenient with it, will that fit the bill?

(Generics will be a separate patch anyway.)

> [Stephen]
>> [Me]
>>> I also
>>> want to encode some specific electronic attributes to each
>>> state to achieve some correspondance with the thing that
>>> would appear in textbooks about this kind of stuff.
>>
>> Why does that benefit anyone? Surely most people will take a SoC manual,
>> work out the settings they need using the terminology of that manual,
>> and attempt to set them. I don't think it's the domain of the subsystem
>> to teach people about electronics.

You mean for this subsystem I suppose.

Whereas for the regulator subsystem it is indeed necessary
to understand both software and electronics.

As well as for many things in drivers/staging/iio.
I'm not convinced that pins are all that different, but I'll
attempt to make that knowledge lib optional.

> [Stephen]
>> Why would an engineer working on SoC A need to converse with an engineer
>> working on SoC B about the detailed settings of SoC B?

In Linaro, which is my current project office, this is like, what
we're doing all the time. Not just related to pinconfig. Sure at some
level we can cut out details but well, that level is undefined.

> [Stephen]
>> [Me]
>>> Well I'm trying to check in text books. But how many ways of
>>> designing push/pull can there be (practical, not theoretical)?
>>
>>I have no idea at that level of ASIC design. Given neither of us do,
>>I'd suggest we don't rely on obtaining such knowledge.

Well, actually SoC ASIC construction was my major subject when I
left university, so I do think I can obtain that knowledge, my
main problem right now is finding some old textbooks and talking
to the right people.

This slide from the textbook "Digital Integrated Circuits" for example
touches on some of the basic concepts of pad driver stages mixed up
with some other topics:
http://bwrc.eecs.berkeley.edu/icbook/Slides/chapter9.ppt

I have asked some academic contacts to help me out with
reading lists.

(Maybe I'm taking this too seriously I don't know.)

>>> [Me]
>> [Stephen]
> [Mark]
>> > Hm, I don't follow this quite... what is it then? How do you select
>> > the apropriate value in your code?
>
>> I don't; a HW engineer would tell me how to configure it (or I leave it at
>> default).
>
> Or that decision may happen as a result of a dialogue between the
> engineers working on the project, trading off between software and
> hardware behaviours.

That is less throw over the wall so I like the sound of that :-)

Yours,
Linus Walleij
