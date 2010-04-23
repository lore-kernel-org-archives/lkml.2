Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab0DWIuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:50:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:56118 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab0DWIuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:50:01 -0400
Date: Fri, 23 Apr 2010 16:49:26 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: John Kacur <jkacur@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH] lockdep: Add nr_save_trace_invocations counter
Message-ID: <20100423084926.GE21328@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <alpine.LFD.2.00.1004222208310.3155@localhost>
 <20100423025850.GA21328@windriver.com>
 <alpine.LFD.2.00.1004230907050.4151@localhost>
 <1272009915.1646.25.camel@laptop>
 <w2v520f0cf11004230131i743c596emfd0e5b8870330a8b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <w2v520f0cf11004230131i743c596emfd0e5b8870330a8b@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 23 Apr 2010 08:49:28.0790 (UTC) FILETIME=[E25EA760:01CAE2C1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 10:31:16AM +0200, John Kacur wrote:
> > 8752+871+8+95+5+28+543+28+543+15=10888
> >
> > So you get a stack-trace for each direct-dependency, and you get a
> > stack-trace for each LOCK_state, the sum seems to match the total
> > invocations.
> >
> > Non of these numbers look strange..
> >
> 
> As I told Peter privately the laptop that triggered the
> MAX_STACK_TRACE_ENTRIES every time, has met an
> unfortunate early demise. However, I think it was the config - not the
> hardware. On this machine where the above
> numbers come from, I believe I have less debug options configured -
> but it is running the exact same kernel as
> the laptop was. (2.6.33.2-rt13)

Through a rough computation:
MAX_STACK_TRACE_ENTRIES/10888 = 24
That means the average stack deepth is about 24.
So I'm thinking if we can take a check on the biggest deepth?
Could this make sense?

Thanks,
Yong

