Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751124Ab0DEEWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 00:22:37 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45099 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab0DEEWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 00:22:31 -0400
Date: Sun, 4 Apr 2010 21:22:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
Message-ID: <20100405042222.GD2644@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100403223328.GA4507@comet.dominikbrodowski.net>
 <Pine.LNX.4.44L0.1004041110010.2750-100000@netrider.rowland.org>
 <20100404163924.GA18428@comet.dominikbrodowski.net>
 <20100404204725.GC2644@linux.vnet.ibm.com>
 <20100404233702.GA24102@linux.vnet.ibm.com>
 <4BB95C85.80205@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB95C85.80205@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 04, 2010 at 08:44:05PM -0700, Arjan van de Ven wrote:
> >And you did mention offlining some CPUs above.  The folloiwng patch
> >(from Lai Jiangshan) is needed to handle this case.
> 
> btw on x86... don't offline CPUs if you want to save power.. it doesn't.
> (at least not during idle.. and when you're busy it might save power,
> but it won't save you energy normally)

Hmmm...  The fact that offlining CPUs doesn't save power could form
the basis of an interesting rationalization for my having ignored
offlined CPUs in my original patch, I suppose.  ;-)

So the proper approach is to affinity everything away from the CPUs
in question so that they stay in dyntick-idle mode?  I must confess
that I find this quite counter-intuitive -- and I suspect that I am
not the only one who would expect offlined CPUs to drop to the
lowest possible power consumption.

							Thanx, Paul
