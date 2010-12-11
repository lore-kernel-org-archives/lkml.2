Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab0LKCXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 21:23:04 -0500
Received: from relais.videotron.ca ([24.201.245.36]:23988 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab0LKCXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 21:23:03 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 10 Dec 2010 21:23:01 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] sched: Fix the irqtime code to deal with u64 wraps
In-reply-to: <1292013506.13513.78.camel@laptop>
Message-id: <alpine.LFD.2.00.1012102116540.10437@xanadu.home>
References: <1292013506.13513.78.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010, Peter Zijlstra wrote:

> OK, so here's the latest version, using fancy __this_cpu thingies.
> 
> I started a new thread since the old one was quite unwieldy.
> 
> Now, admittedly this patch is a tad large, esp for -rc5. So either we
> need lots of Reviewed-by and such or I need to shrink this patch
> somehow.
> 
> 
> ---
> Subject: sched: Fix the irqtime code to deal with u64 wraps
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu Dec 09 14:15:34 CET 2010
> 
> ARM systems have a 32bit sched_clock() [ which needs to be fixed ],
> but this exposed a bug in the irq_time code as well, it doesn't deal
> with wraps at all.
[...]

That would be more close to reality if you stated "Some ARM systems have 
a 32bit sched_clock() [" above.  Most ARM systems in use today have a 
sched_clock() with more than 32 bits, like 55 bits or so.


Nicolas
