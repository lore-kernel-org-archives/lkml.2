Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab0DZXsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 19:48:20 -0400
Received: from fifo99.com ([67.223.236.141]:56550 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab0DZXsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 19:48:19 -0400
Subject: Re: Q: sched_clock() vs. clocksource, how to implement correctly
From: Daniel Walker <dwalker@fifo99.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Johannes Stezenbach <js@sig21.net>, John Stultz <johnstul@us.ibm.com>,
       linux-kernel@vger.kernel.org, Magnus Damm <damm@opensource.se>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100423182933.0df45b53@mschwide.boeblingen.de.ibm.com>
References: <20100423150917.GA25714@sig21.net>
	 <20100423182933.0df45b53@mschwide.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Apr 2010 16:48:14 -0700
Message-ID: <1272325694.32741.16.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-23 at 18:29 +0200, Martin Schwidefsky wrote:
> > Questions:
> > 
> > - Isn't sched_clock() supposed to be extended to 64bit so
> >   that it practically never wraps?
> >   (old implementations use cnt32_to_63())
> 
> Yes, sched_clock() is supposed to return a monotonic timestamp.
>  
> > - What would be the effect on scheduling when sched_clock() wraps?
> 
> It would confuse the process accounting and the scheduling I guess.
> 

Are you sure about this? I'm pretty sure I've seen Ingo say multiple
times that sched_clock can wrap, and can be unstable. For instance
sched_clock is (was?) directly connected to the TSC on x86 ..

If it really can't wrap there must bunches of architectures that would
need to be fixed up.

Daniel

