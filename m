Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab2BUJVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 04:21:40 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:38766 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753047Ab2BUJVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 04:21:38 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19YG29FfwhYF/xcMcuJ7INdbe8Nixyz3sTsM4xj2y
	JtpWIkpQBESFYW
Message-ID: <1329816093.7333.49.camel@marge.simpson.net>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Mike Galbraith <efault@gmx.de>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Date: Tue, 21 Feb 2012 10:21:33 +0100
In-Reply-To: <20120221083241.GC5156@linux.vnet.ibm.com>
References: <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321547917.6308.48.camel@marge.simson.net>
	 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
	 <1321629267.7080.13.camel@marge.simson.net>
	 <1329748861.2293.345.camel@twins>
	 <1329761661.6276.146.camel@marge.simpson.net>
	 <1329764866.2293.376.camel@twins>
	 <1329802998.7333.1.camel@marge.simpson.net>
	 <20120221083241.GC5156@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 14:02 +0530, Srivatsa Vaddagiri wrote: 
> * Mike Galbraith <efault@gmx.de> [2012-02-21 06:43:18]:
> 
> > On Mon, 2012-02-20 at 20:07 +0100, Peter Zijlstra wrote: 
> > > On Mon, 2012-02-20 at 19:14 +0100, Mike Galbraith wrote:
> > > > Enabling SD_BALANCE_WAKE used to be decidedly too expensive to consider.
> > > > Maybe that has changed, but I doubt it.
> > > 
> > > Right, I through I remembered some such, you could see it on wakeup
> > > heavy things like pipe-bench and that java msg passing thing, right?
> > 
> > Yeah, it beat up switch heavy buddies pretty bad.
> 
> Do you have pointer to the java benchmark? Also is pipe-bench the same
> as the one described below?

I use vmark, find it _somewhat_ useful.  Not a lovely benchmark, but it
is highly affinity sensitive, and switches heftily.  I don't put much
value on it though, too extreme for me, but it is a ~decent indicator.

There are no doubt _lots_ better than vmark for java stuff.

I toss a variety pack at the box in obsessive-compulsive man mode when
testing.  Which benchmarks doesn't matter much, just need to be wide
spectrum and consistent.

> http://freecode.com/projects/pipebench

No, I use Ingo's pipe-test, but that to measure fastpath overhead.

-Mike

