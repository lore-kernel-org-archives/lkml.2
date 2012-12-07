Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab2LGSSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 13:18:52 -0500
Received: from smarthost02.mail.zen.net.uk ([212.23.1.2]:36943 "EHLO
	smarthost02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755134Ab2LGSSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 13:18:51 -0500
Message-ID: <1354904322.8263.20.camel@linaro1.home>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Rabin Vincent <rabin@rab.in>,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Dec 2012 18:18:42 +0000
In-Reply-To: <1354903568.17101.65.camel@gandalf.local.home>
References: <1354817466.30905.13.camel@linaro1.home>
	 <1354821581.17101.17.camel@gandalf.local.home>
	 <1354872138.3176.15.camel@computer5.home>
	 <1354888985.17101.41.camel@gandalf.local.home>
	 <1354892111.13000.50.camel@linaro1.home>
	 <1354894134.17101.44.camel@gandalf.local.home>
	 <20121207162346.GW14363@n2100.arm.linux.org.uk>
	 <1354898200.17101.50.camel@gandalf.local.home>
	 <20121207164530.GX14363@n2100.arm.linux.org.uk>
	 <1354900436.17101.58.camel@gandalf.local.home>
	 <1354902347.8263.12.camel@linaro1.home>
	 <1354903568.17101.65.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost02-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 13:06 -0500, Steven Rostedt wrote:
> > 
> > However, wouldn't we need any of this breakpoint malarkey, why not just
> > just use a 16-bit branch instruction which branches over the second half
> > of the nop? :-)
> 
> If you can get away with that, sure. Or better yet. If the arch supports
> it, you can do what I did with powerpc. That was just replace the nop
> with the 32bit branch, and the 32bit branch with a 32bit nop. No nops.
> No multiple steps in between. I just did the swap of all function
> tracepoints in one fell swoop, and then did the icache sync.

But that gets back to the original problem that the 32bit instructions
can straddle two cache lines.

> 
> Now that's if the arch doesn't have issues with swapping code like this.
> Can a 32bit branch-and-link be spread across cache lines?

Yes, Thumb2 instructions are either 16 or 32bit and are aligned to 16bit
boundaries. So 16bit instructions never cross cache lines and all 32bit
instructions can.

>  On x86 the
> call is 5 bytes and can be. Thus, we were forced to do the breakpoint
> because we don't know how the instructions are laid out on the cache
> lines.
> 
> If 32bit can't be swapped but 16bit never crosses cache lines, then your
> approach may also work.

It should.

-- 
Tixy

