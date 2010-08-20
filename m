Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab0HTJkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:40:10 -0400
Received: from mailhost-p3-m2.mangoosta.org ([78.40.49.190]:54110 "EHLO
	smtp-delay2.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752787Ab0HTJkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:40:06 -0400
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Aug 2010 05:40:06 EDT
Date: Fri, 20 Aug 2010 11:32:26 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Zeno Davatz <zdavatz@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        mingo@elte.hu, yinghai@kernel.org
Subject: Re: kmemleak, cpu usage jump out of nowhere
Message-ID: <20100820093226.GA7371@brouette>
References: <AANLkTikJeA-bZEk652QwwT4iY21v5tr6RCzcZAZGgS8D@mail.gmail.com>
 <4C3F2F52.2050101@cs.helsinki.fi>
 <20100715162805.GA10240@brouette>
 <20100715191638.GA3694@brouette>
 <AANLkTim7SURv8DPTLC2JwOJvv1WMAR4mmyBp9XqXw_Py@mail.gmail.com>
 <20100715200012.GA4175@brouette>
 <AANLkTilnLXVSkWfnaPtpzxH-C3-5h1mnBz3O0vAFHG32@mail.gmail.com>
 <1280826359.1923.440.camel@laptop>
 <AANLkTi=VuLwcmjTpOeK-OzgiWeycu14hJpfUuH9cKnUj@mail.gmail.com>
 <1280826924.4c57de2c3a6b0@imp.free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280826924.4c57de2c3a6b0@imp.free.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > > Vacation.. but now I'm back ;-)

> > > Even something simple as: perf top -r 1 (make sure you're root in
> > > order to run with real-time prios) could give a clue as to what is
> > > consuming all your cpu-time.

> > > Or did the issue get sorted already?

> > Thank you for the hint.

> > I am on 2.6.35 now and all seems to be fine again.

> Are you 100% sure you compiled it with CONFIG_NO_BOOTMEM enabled?

> I did not test 2.6.35 yet but I did not see anything related to this
> bug commited since the discussion so I am very surprised the problem
> disappeared by itself...

> Will be on vacation very soon, so not sure I will have time to test 2.6.35
> before leaving.

After a few days of running 2.6.35.2 without problem, I got the same
huge slowness for a few tens of seconds yesterday. Did not have time to
run perf (and the system was almost unresponsive), but I will try to do
so if the problem occurs again. Anyway, even if less frequent than
during the -rcs, and as nothing had been commited to fix it before
final, the problem is still there...

It seems that the problem occurs after some CPU intensive tasks have
been run for some time (ie compiling a kernel) and only on Core i7
machines with NO_BOOTMEM. I am surprised so few people reported it and
that it has not been seen on test machines running CPU/scheduler
benchmark tools.

-- 
Damien Wyart
