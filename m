Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab1KJRZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 12:25:33 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:32948 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab1KJRZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 12:25:32 -0500
Date: Thu, 10 Nov 2011 09:22:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 05/28] lockdep: Update documentation
 for lock-class leak detection
Message-ID: <20111110172256.GD2354@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111102203017.GA3830@linux.vnet.ibm.com>
 <1320265849-5744-5-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111103025716.GA2042@leaf>
 <20111103194226.GG2287@linux.vnet.ibm.com>
 <1320847328.19727.2.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320847328.19727.2.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11111017-8974-0000-0000-000001C82637
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 03:02:08PM +0100, Peter Zijlstra wrote:
> On Thu, 2011-11-03 at 12:42 -0700, Paul E. McKenney wrote:
> > > If so, could we simply arrange to have lockdep scream when it encounters
> > > an uninitialized spinlock?
> > 
> > I reworded to distinguish between compile-time initialization (which will
> > cause lockdep to have a separate class per instance) and run-time
> > initialization (which will cause lockdep to have one class total).
> 
> Right, runtime init will key off of the call-site, compile-time init
> will key off of the static data address.
> 
> > Making lockdep scream in this case might be useful, but if I understand
> > correctly, that would give false positives for compile-time initialized
> > global locks. 
> 
> Yeah, that's going to bring a lot of pain with it, in particular all the
> early stuff like the init task etc. are all statically initialized.

OK, will stick with the current approach, then.

								Thanx, Paul

