Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab0GHL6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 07:58:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:47294 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab0GHL6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 07:58:30 -0400
Subject: Re: high power consumption in recent kernels
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm <akpm@linux-foundation.org>
In-Reply-To: <20100708045711.398d4e26@infradead.org>
References: <20100706164539.GA14783@gamma.logic.tuwien.ac.at>
	 <1278579992.1900.17.camel@laptop>  <20100708045711.398d4e26@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 Jul 2010 13:58:23 +0200
Message-ID: <1278590303.1900.91.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 04:57 -0700, Arjan van de Ven wrote:
> On Thu, 08 Jul 2010 11:06:32 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, 2010-07-07 at 01:45 +0900, Norbert Preining wrote:
> > 
> > > it seems that some of the (?)recent(?) changes have increased the
> > > power consumption of my note book considerably.
> > > 
> > > First of all, running powertop with normal programs started, but 
> > > doing nothing, I am still at 14W while I could go down to 9W before
> > > (but the 9W was with dimmed display).
> > > 
> > > In the list of top causes for wakeup I have
> > > Top causes for wakeups:
> > >   34.2% (185.3)   [kernel scheduler] Load balancing tick
> > >   23.9% (129.6)   [extra timer interrupt]
> > >   10.8% ( 58.6)   firefox-bin
> > >    9.2% ( 49.7)   [iwlagn] <interrupt>
> > >    7.2% ( 39.1)   [kernel core] hrtimer_start (tick_sched_timer)
> > >    3.9% ( 20.9)   PS/2 keyboard/mouse/touchpad interrupt
> > > which show one new thing to me I haven't seen before, the Loa
> > > balancing tick.
> > 
> > I think that is what powertop calls our regular tick (Arjan?), and as
> 
> it's "hrtimer_start_range_ns (tick_sched_timer)" if it's done by the
> idle thread.
> 

then wth is "[kernel scheduler] load balancing tick"?
and for that matter, what is "[extra timer interrupt]", surely the timer
hardware doesn't generate spurious interrupts?
