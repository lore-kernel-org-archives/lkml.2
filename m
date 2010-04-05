Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab0DEQkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 12:40:32 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43394 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289Ab0DEQk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 12:40:26 -0400
Date: Mon, 5 Apr 2010 09:40:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
Message-ID: <20100405164023.GD2525@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100404163924.GA18428@comet.dominikbrodowski.net>
 <20100404204725.GC2644@linux.vnet.ibm.com>
 <20100404233702.GA24102@linux.vnet.ibm.com>
 <4BB95C85.80205@linux.intel.com>
 <20100405042222.GD2644@linux.vnet.ibm.com>
 <4BB9F657.4050901@linux.intel.com>
 <20100405151401.GA2525@linux.vnet.ibm.com>
 <4BBA0AC5.1080905@linux.intel.com>
 <20100405162249.GB2525@linux.vnet.ibm.com>
 <4BBA0E74.2090803@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBA0E74.2090803@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 09:23:16AM -0700, Arjan van de Ven wrote:
> On 4/5/2010 9:22, Paul E. McKenney wrote:
> >On Mon, Apr 05, 2010 at 09:07:33AM -0700, Arjan van de Ven wrote:
> >>On 4/5/2010 8:14, Paul E. McKenney wrote:
> >>>So the main issue is that for many workloads, it is best to run full bore
> >>>and get done quickly, thus allowing the entire machine to be powered down?
> >>
> >>yep
> >>
> >>>If so, it seems likely that there would be some workloads that were sometimes
> >>>unable to use all the CPUs, in which case shutting down (idling, offlining,
> >>>dyntick-idling, whatever) the excess CPUs might nevertheless be the right
> >>>thing to do.
> >>
> >>but the point is that the normal scheduler + idle behavior gives you exactly that
> >>in a natural way !
> >>If you don't have enough work (tasks) to keep all cores busy, the others are and stay idle.
> >
> >So your earlier objection was not to dyntick-idle as such, but rather
> >to artificially constraining the scheduler to induce dyntick-idle?
> 
> my objection was against the notion that offlining cpus helps power/energy ;-)

Fair enough, at least in general.  I should hasten to add that Lai's
patch also helps in the case where NR_CPUS is greater than the number
of CPUs on the system.

							Thanx, Paul
