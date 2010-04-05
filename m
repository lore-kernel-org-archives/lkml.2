Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab0DEUes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:34:48 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56931 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756352Ab0DEUep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:34:45 -0400
Date: Mon, 5 Apr 2010 13:34:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: david@lang.hm, Dominik Brodowski <linux@dominikbrodowski.net>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
Message-ID: <20100405203441.GG2525@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100404163924.GA18428@comet.dominikbrodowski.net>
 <20100404204725.GC2644@linux.vnet.ibm.com>
 <20100404233702.GA24102@linux.vnet.ibm.com>
 <4BB95C85.80205@linux.intel.com>
 <20100405042222.GD2644@linux.vnet.ibm.com>
 <4BB9F657.4050901@linux.intel.com>
 <20100405151401.GA2525@linux.vnet.ibm.com>
 <4BBA0AC5.1080905@linux.intel.com>
 <alpine.DEB.2.00.1004051137160.12764@asgard.lang.hm>
 <4BBA3EAB.6010800@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBA3EAB.6010800@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 12:48:59PM -0700, Arjan van de Ven wrote:
> On 4/5/2010 11:44, david@lang.hm wrote:
> >On Mon, 5 Apr 2010, Arjan van de Ven wrote:
> >
> >>On 4/5/2010 8:14, Paul E. McKenney wrote:
> >>>So the main issue is that for many workloads, it is best to run full
> >>>bore
> >>>and get done quickly, thus allowing the entire machine to be powered
> >>>down?
> >>
> >>yep
> >
> >Race To Idle works extremely well in a batch type situation where there
> >is not going to be any work to do after you finish what you have.
> >
> >It doesn't work quite as well if you are going to have new work to do in
> >the near future.
> >
> >You cannot power down the entire machine if you have to look for user
> >input.
> >
> >It takes time (and power) to shut down and start back up, if you are
> >going to have more work to do before you can make the complete cycle
> >(and save more power than it costs to make the transitions), it's best
> >to stay at full power, even if you are idle.
> 
> for the things we're talking about here (memory controllers etc) we're talking
> about single to low double digit microseconds (or even less) of time to go up and down.
> Many of the things you talk about are in the millisecond timeframe.

So the decision will depend not only on the workload itself, but also
on the hardware that the workload uses.

							Thanx, Paul
