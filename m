Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab0KODN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:13:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932731Ab0KODNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:13:22 -0500
MIME-Version: 1.0
In-Reply-To: <1289783580.495.58.camel@maggy.simson.net>
References: <1289489200.11397.21.camel@maggy.simson.net> <20101111202703.GA16282@redhat.com>
 <1289514000.21413.204.camel@maggy.simson.net> <20101112181240.GB8659@redhat.com>
 <1289648524.22764.149.camel@maggy.simson.net> <1289755150.3228.44.camel@maggy.simson.net>
 <20101114174921.GA1569@arch.trippelsdorf.de> <1289758238.17491.12.camel@maggy.simson.net>
 <AANLkTimy5DdF8qwGuk09iT3wHfXMjkiwRKxo-LuvEJzW@mail.gmail.com>
 <AANLkTikjSCbcRnKOU=nd4os1sdW-GJkD6QVj=U5zPyu8@mail.gmail.com>
 <20101114202734.GA1627@arch.trippelsdorf.de> <AANLkTimHtjH3YvtX6i542_XjfFeuvG-AnU8i224a1R4j@mail.gmail.com>
 <1289778189.5154.10.camel@maggy.simson.net> <AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com>
 <AANLkTi=fT-DCP40_U24zft-3owseW24px=Zq=LnEJ_FF@mail.gmail.com> <1289783580.495.58.camel@maggy.simson.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 14 Nov 2010 19:12:27 -0800
Message-ID: <AANLkTikp=RJSpL1NYje89URu0St0RprUwR7ad8Q7a=-=@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Mike Galbraith <efault@gmx.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 14, 2010 at 5:13 PM, Mike Galbraith <efault@gmx.de> wrote:
>
> Which is what I just did. If the oddball case isn't a big deal, the
> patch shrinks, which is a good thing. I just wanted to cover all bases.

Yeah. And I have to say that I'm (very happily) surprised by just how
small that patch really ends up being, and how it's not intrusive or
ugly either.

I'm also very happy with just what it does to interactive performance.
Admittedly, my "testcase" is really trivial (reading email in a
web-browser, scrolling around a bit, while doing a "make -j64" on the
kernel at the same time), but it's a test-case that is very relevant
for me. And it is a _huge_ improvement.

It's an improvement for things like smooth scrolling around, but what
I found more interesting was how it seems to really make web pages
load a lot faster. Maybe it shouldn't have been surprising, but I
always associated that with network performance. But there's clearly
enough of a CPU load when loading a new web page that if you have a
load average of 50+ at the same time, you _will_ be starved for CPU in
the loading process, and probably won't get all the http requests out
quickly enough.

So I think this is firmly one of those "real improvement" patches.
Good job. Group scheduling goes from "useful for some specific server
loads" to "that's a killer feature".

           Linus
