Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab0HCJGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:06:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58732 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab0HCJGl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:06:41 -0400
Subject: Re: kmemleak, cpu usage jump out of nowhere
From: Peter Zijlstra <peterz@infradead.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Damien Wyart <damien.wyart@free.fr>, Zeno Davatz <zdavatz@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        mingo@elte.hu, yinghai@kernel.org
In-Reply-To: <AANLkTilnLXVSkWfnaPtpzxH-C3-5h1mnBz3O0vAFHG32@mail.gmail.com>
References: <AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com>
	 <AANLkTimgn1Xa0YIwjC6xOfNDjlqJSQYy65ZvqCtlMWHD@mail.gmail.com>
	 <1279100846.8592.53.camel@e102109-lin.cambridge.arm.com>
	 <4C3D89AC.4040303@cs.helsinki.fi>
	 <1279205891.6664.46.camel@e102109-lin.cambridge.arm.com>
	 <AANLkTikJeA-bZEk652QwwT4iY21v5tr6RCzcZAZGgS8D@mail.gmail.com>
	 <4C3F2F52.2050101@cs.helsinki.fi> <20100715162805.GA10240@brouette>
	 <20100715191638.GA3694@brouette>
	 <AANLkTim7SURv8DPTLC2JwOJvv1WMAR4mmyBp9XqXw_Py@mail.gmail.com>
	 <20100715200012.GA4175@brouette>
	 <AANLkTilnLXVSkWfnaPtpzxH-C3-5h1mnBz3O0vAFHG32@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 03 Aug 2010 11:05:59 +0200
Message-ID: <1280826359.1923.440.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-15 at 23:52 +0300, Pekka Enberg wrote:
> On Thu, Jul 15, 2010 at 11:00 PM, Damien Wyart <damien.wyart@free.fr> wrote:
> >> > For now, I can't reproduce the problem with CONFIG_NO_BOOTMEM disabled ;
> >> > with the option and rc5 the problem was happening quite quickly after
> >> > boot and normal use of the machine. So it seems I can confirme what Zeno
> >> > has seen and I hope this will give a hint to debug the problem. I guess
> >> > this has not been reported that much because many testers might not have
> >> > enabled CONFIG_NO_BOOTMEM... Maybe the scheduler folks could test their
> >> > benchmark with a kernel having this option enabled?
> >
> > * Pekka Enberg <penberg@cs.helsinki.fi> [2010-07-15 22:50]:
> >> To be honest, the bug is bit odd. It's related to boot-time memory
> >> allocator changes but yet it seems to manifest itself as a scheduling
> >> problem. So if you have some spare time and want to speed up the
> >> debugging process, please test v2.6.34 and v2.6.35-rc1 with
> >> CONFIG_NO_BOOTMEM and if former is good and latter is bad, try to see
> >> if you can identify the offending commit with "git bisect."
> >
> > Not sure I will have enough time in the coming days (doing that remotely
> > is fishy since ssh access is almost stuck when the problem occurs); if
> > Zeno can and would like to do it, maybe this could be done faster.
> >
> > As the scheduler is now very well instrumented (many debugging features
> > are available), reproducing the bug on a test platform (it happens quite
> > quickly for me) might also give some hints. So testers, if you have
> > time, please test 2.6.35-rc5 with CONFIG_NO_BOOTMEM on a Core i7 and see
> > if you can reproduce the problem!
> 
> Yeah, there's "perf sched" tool available for that:
> 
>   http://lwn.net/Articles/353295/
> 
> The only problem is that we'd need a scheduler hacker to decipher the
> report and all of them seem to be missing at the moment (probably at
> OLS). Anyway, like I said, git bisect will probably speed up the
> debugging process, that's all.

Vacation.. but now I'm back ;-)

Even something simple as: perf top -r 1 (make sure you're root in order
to run with real-time prios) could give a clue as to what is consuming
all your cpu-time.

Or did the issue get sorted already?
