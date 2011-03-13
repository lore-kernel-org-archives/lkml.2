Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab1CMXy7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 19:54:59 -0400
Received: from flusers.ccur.com ([173.221.59.2]:39993 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756608Ab1CMXy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 19:54:58 -0400
Date: Sun, 13 Mar 2011 19:53:51 -0400
From: Joe Korty <joe.korty@ccur.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "loic.minier@linaro.org" <loic.minier@linaro.org>,
        "dhaval.giani@gmail.com" <dhaval.giani@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "houston.jim@comcast.net" <houston.jim@comcast.net>,
        "corbet@lwn.net" <corbet@lwn.net>
Subject: Re: JRCU Theory of Operation
Message-ID: <20110313235351.GA15931@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20101116135230.GA5362@nowhere>
 <20101116155104.GB2497@linux.vnet.ibm.com>
 <20101117005229.GC26243@nowhere>
 <20110307203106.GA23002@tsunami.ccur.com>
 <20110309221517.GB24670@tsunami.ccur.com>
 <20110310003419.GE2196@linux.vnet.ibm.com>
 <20110310195045.GA22146@tsunami.ccur.com>
 <20110312143629.GT2234@linux.vnet.ibm.com>
 <20110313004336.GA14518@tsunami.ccur.com>
 <20110313055627.GW2234@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110313055627.GW2234@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 12:56:27AM -0500, Paul E. McKenney wrote:
> > Even though I keep saying 50msecs for everything, I
> > suspect that the Q switching meets all the above quiescent
> > requirements in a few tens of microseconds.  Thus even
> > a 1 msec JRCU sampling period is expected to be safe,
> > at least in regard to Q switching.
> 
> I would feel better about this is the CPU vendors were willing to give
> an upper bound...

I suspect they don't because they don't really know
themselves .. in that whatever it is, it keeps changing
from chip to chip, trying to describe such would be beyond
the english language, and any description would tie them
down on what they could do in future chip designs.

But, there is a hint in current behavior.  It is well known
that many multithreaded apps don't uses barriers at all;
the authors had no idea what they are for.  Yet such apps
largely work.  This implies that the chip designers are
very aggressive in doing implied memory barriers wherever
possible, and they are very aggressive in pushing out
stores to caches very quickly even when memory barriers,
implied or not, are not present.

Joe
