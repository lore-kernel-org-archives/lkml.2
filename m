Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab1EWAZr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 20:25:47 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:64440 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab1EWAZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 20:25:45 -0400
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        penberg@kernel.org, hpa@zytor.com
In-Reply-To: <BANLkTik1SK_kWVvGsKk0SqdByQ5-0b5nFg@mail.gmail.com>
References: <1305292059.1949.0.camel@dan> <1305293345.1949.22.camel@dan>
	 <20110516153527.GC21107@elte.hu> <1305852966.3005.19.camel@dan>
	 <20110520120750.GJ14745@elte.hu> <1305896093.3005.24.camel@dan>
	 <20110520131108.GA17699@elte.hu> <1306089922.1806.27.camel@dan>
	 <BANLkTik1SK_kWVvGsKk0SqdByQ5-0b5nFg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 May 2011 20:25:36 -0400
Message-ID: <1306110336.25049.7.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-22 at 16:49 -0700, Tony Luck wrote:
> 
> 
> On Sun, May 22, 2011 at 11:45 AM, Dan Rosenberg
> <drosenberg@vsecurity.com> wrote:
>         1. Is it ok to assume the existence of rdtsc?  If not, what
>         are other
>         ways of gathering entropy early in the boot process?  If this
>         is the
>         approach that's going to be taken, system uptime potentially
>         becomes
>         useful for attackers.  Any thoughts on how to address this?
>         
> There is a cpuid bit to tell you whether the processor supports rdtsc.
> 

This might be worth checking, but it also might just be easier to
clearly document in the Kconfig that the feature requires rdtsc.  I'll
play with it a bit.

> In the cold boot case, I'd worry about whether rdtsc was all that
> random,
> it counts from zero when the processors come out of cold reset, and
> things should be quite deterministic up to when the kernel loads;
> especially if you have a solid state boot drive rather than the old
> spinning kind.
> 

The question really becomes whether it's "good enough".  It's certainly
not cryptographic randomness, but it will produce different results on
different boots depending on a variety of factors, including
out-of-order instruction execution, multi-CPU systems, and differences
in CPU models.  Even though a single machine may be slightly more likely
to produce certain offsets more often, it seems to me that it would
still accomplish the goal, because it's highly unlikely that an attacker
would be able to perform the statistical analysis necessary to figure
that out.

> Sometime soon you'll have "rdrand" available (check a different cpuid
> bit).
> 

This of course is highly preferable, but I'd rather implement a solution
that's widely supported in hardware today.  Perhaps further down the
road it could be switched.

> -Tony
> 
> 

Thanks for the feedback.

-Dan

