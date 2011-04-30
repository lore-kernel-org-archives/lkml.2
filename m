Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab1D3SXl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 14:23:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029Ab1D3SXh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 14:23:37 -0400
MIME-Version: 1.0
In-Reply-To: <web-516060724@zbackend1.aha.ru>
References: <web-515866242@zbackend1.aha.ru> <BANLkTimfOCwZQP=Hv+NEhFcxMpC51-RhTw@mail.gmail.com>
 <BANLkTinv38NtVQHrayus6v89BocsK6+iQQ@mail.gmail.com> <20110430025545.GI9487@ZenIV.linux.org.uk>
 <20110430030243.GJ9487@ZenIV.linux.org.uk> <BANLkTi=9Zq8AdGMyfwyp1nwyjD+PCGQydA@mail.gmail.com>
 <web-515898476@zbackend1.aha.ru> <BANLkTi=ujRJYG80F=HKqgz2nPeE5Gro+JA@mail.gmail.com>
 <web-515901951@zbackend1.aha.ru> <BANLkTi=o7NynvukkzE5ZhRHPu43=OV0_Ow@mail.gmail.com>
 <web-515904487@zbackend1.aha.ru> <BANLkTimDHTB+NF8EzjvjBvu0e+MHt8tP1Q@mail.gmail.com>
 <web-515907842@zbackend1.aha.ru> <BANLkTimu=XAj5JDewT9OGTCNHZBf2Oa5+Q@mail.gmail.com>
 <web-516060724@zbackend1.aha.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Apr 2011 11:23:12 -0700
Message-ID: <BANLkTimeoufwrjT226bCQnp5jC01GfU0jw@mail.gmail.com>
Subject: Re: 2.6.39-rc5-git2 boot crashs
To: werner <w.landgraf@ru.ru>
Cc: Jens Axboe <jaxboe@fusionio.com>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/30 werner <w.landgraf@ru.ru>:
>
> The reason that I enable everything is, that the kernel packages
> are build for a distro. š There have to be everything enabled,
> because you never know what computer the users have.

I DO NOT CARE WHY YOU ENABLE EVERYTHING.

I want to know what makes it start to fail. We simply don't know why
you see this problem (and apparently your friend too), but one issue
may be a totally unrelated buggy driver.

In order to figure it out, you need to help us. And one thing that is
very odd and wrong about your setup is how you have compiled in
absolutely everything.

And yes, it's wrong, because the way to do distro kernels is to
compile in the sane and common stuff, and load the rest as modules as
required.

And that's exactly because

 (a) some drivers cannot sanely auto-detect if they are needed
(sometimes they are just buggy, but often it's because the hardware
they drive is not sane and doesn't necessarily have any nice
enumeration model)

 (b) bugs happen. They happen especially commonly with rare hardware,
since that by definition gets less testing (that rare hardware can
often be "high-end" hardware - you'd think they are higher quality,
but the reverse is usually true).

Probing absolutely everything at boot-time tends to just be more
dangerous. There's a reason why most distros ask something like "are
you using just standard devices, or specialized storage subsystems",
so that they don't need to worry about the rare and possibly buggy
cases quite as much.

Some drivers you enable tend to be more about embedded systems (ie the
whole MTD layer etc), and there's likely little reason to do that in a
standard distribution kernel at all.

> I'm doing essentially the same since almost 4 years. Sometimes
> it gives problems during -rc1 to -rc4 or so, but at the end always
> everything works.

It's clearly a regression. Nobody disputes that. But you need to help
us find it. So just do a minimal kernel. Please. So that we can say
either "yes, it still shows up even when you only have the normal
drivers", or we can say "ok, it's one of the uncommon drivers that
screws things up".

And it's not just drivers. Please disable things like virtualization
etc kernel features if you don't need it.

We cannot fix it if we cannot pinpoint what the problem is. We won't
ignore it if the problem goes away when you have disabled drivers - at
that point I'm going to ask you to try to enable the drivers and
features until it starts happening again, so that we know _what_
random thing is causing it.

And please stop arguing against people who are trying to help figure
out what is wrong, ok?

> AND: the crashs with the same kernel don't happen only at my computer,
> but also on a laptop of at least one friend, on the same laptop also
> 2.6.38.4 runs normally.

With your "everything enabled" kernel, right?

If you don't want to minimize the configuration, you'll need to at
least bisect _exactly_ where the problem starts. There's about ten
thousand commits, spanning the whole kernel, in between 38 and 39-rc1.
We don't know what's wrong right now. And you are currently the only
one seeing, along with your friend who presumably uses your kernel. So
there's something wrong that is triggered by something specific to
YOUR setup.

See what I'm trying to say here?

                      Linus
