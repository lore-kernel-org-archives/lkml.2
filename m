Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab1CNA6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 20:58:10 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:54787 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab1CNA6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 20:58:04 -0400
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.34
X-Originating-IP: 173.50.155.44
Date: Sun, 13 Mar 2011 17:55:31 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Joe Korty <joe.korty@ccur.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "loic.minier@linaro.org" <loic.minier@linaro.org>,
        "dhaval.giani@gmail.com" <dhaval.giani@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "houston.jim@comcast.net" <houston.jim@comcast.net>,
        "corbet@lwn.net" <corbet@lwn.net>
Subject: Re: JRCU Theory of Operation
Message-ID: <20110314005531.GA25516@feather>
References: <20101117005229.GC26243@nowhere>
 <20110307203106.GA23002@tsunami.ccur.com>
 <20110309221517.GB24670@tsunami.ccur.com>
 <20110310003419.GE2196@linux.vnet.ibm.com>
 <20110310195045.GA22146@tsunami.ccur.com>
 <20110312143629.GT2234@linux.vnet.ibm.com>
 <20110313004336.GA14518@tsunami.ccur.com>
 <20110313055627.GW2234@linux.vnet.ibm.com>
 <20110313235351.GA15931@tsunami.ccur.com>
 <20110314005052.GE2167@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314005052.GE2167@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 05:50:52PM -0700, Paul E. McKenney wrote:
> On Sun, Mar 13, 2011 at 07:53:51PM -0400, Joe Korty wrote:
> > But, there is a hint in current behavior.  It is well known
> > that many multithreaded apps don't uses barriers at all;
> > the authors had no idea what they are for.  Yet such apps
> > largely work.  This implies that the chip designers are
> > very aggressive in doing implied memory barriers wherever
> > possible, and they are very aggressive in pushing out
> > stores to caches very quickly even when memory barriers,
> > implied or not, are not present.
> 
> Ahem.  Or that many barrier-omission failures have a low probability
> of occurring.  One case in point is a bug in RCU a few years back,
> where ten-hour rcutorture runs produced only a handful of errors (see
> http://paulmck.livejournal.com/14639.html).  Other cases are turned up by
> Peter Sewell's work, which tests code sequences with and without memory
> barriers (http://www.cl.cam.ac.uk/~pes20/).  In many cases, broken code
> sequences have failure rates in the parts per billion.

And for that matter, locking primitives tend to necessarily imply
barriers (what good does a lock do if the memory accesses can leak out
of it), and the vast majority of multithreaded code uses locking.  So,
most multithreaded apps implictly get all the barriers they require.

- Josh Triplett
