Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751041Ab1FGFp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 01:45:57 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60705 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750801Ab1FGFp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 01:45:56 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/GoO5V5ObGLO5VrfvtPFNwj04yH6c1WCNZyTDxQR
	OzU4hjP9UFEwvh
Subject: Re: random hangs during boot in 3.0-rc
From: Mike Galbraith <efault@gmx.de>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20110607034617.GA27980@redhat.com>
References: <20110607034617.GA27980@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 07:45:51 +0200
Message-ID: <1307425551.7472.23.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 23:46 -0400, Dave Jones wrote:
> I have two machines that occasionally (like 1 in 10 boots or so) hang solid
> during boot-up.  Happens in different places, but usually either when loading
> the microcode driver, or while doing a fsck.
> 
> I did a bisect which took a *long* time, since I booted each kernel 10 times
> before pronouncing it 'good'. Once it fingered the bad commit, I started over,
> and arrived at the same conclusion a second time.
> 
> But the actual commit is a merge commit.  What now ?
> 
> commit 42ac9e87fdd89b77fa2ca0a5226023c1c2d83226
> Merge: 057f3fa f0e615c
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Thu Apr 21 11:39:21 2011 +0200
> 
>     Merge commit 'v2.6.39-rc4' into sched/core
>     
>     Merge reason: Pick up upstream fixes.
>     
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> It's possible I just didn't get 'lucky' and marked something as good,
> when it wouldn't have triggered until the 11th boot, which is why I did that
> second bisect run.  Should I bother doing a 3rd try ?
> 
> The kernels have a bunch of debug options turned on, but I don't get anything
> out of the machine at all, it's just wedged solid.

Ditto here using a bug report config.  Seems to be cured now.

> The machines I'm seeing this on are a quad-core AMD Phenom, and a Dual core2duo,
> so quite disparate hardware. (And making me believe it's too coincidental to be a
> hardware problem).
> 
> Anyone else seeing anything like this ?

Maybe this?

https://lkml.org/lkml/2011/6/6/645

	-Mike

