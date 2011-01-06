Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab1AFGAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 01:00:01 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37291 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab1AFGAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 01:00:00 -0500
Date: Wed, 5 Jan 2011 21:59:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: remove SPARSE_RCU_POINTER
Message-ID: <20110106055956.GB2506@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D22DD95.7050308@cn.fujitsu.com>
 <201101041136.02514.arnd@arndb.de>
 <20110104211938.GT2026@linux.vnet.ibm.com>
 <4D23C9B0.9060803@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D23C9B0.9060803@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 09:30:24AM +0800, Lai Jiangshan wrote:
> On 01/05/2011 05:19 AM, Paul E. McKenney wrote:
> > On Tue, Jan 04, 2011 at 11:36:02AM +0100, Arnd Bergmann wrote:
> >> On Tuesday 04 January 2011 09:43:01 Lai Jiangshan wrote:
> >>> As I known, __rcu annotations do not effect the result compiled kernel.
> >>>
> >>> They work only when we use spare("make C=1" or "make C=2"),
> >>> So we don't need another new switch for it since we have one
> >>> for debugging(use spare or not).
> >>>
> >>> signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> >>
> >> The intention of this option was to avoid introducing an excessive
> >> number of false positives when using sparse.
> >>
> >> We should only make that unconditional if we are reasonably convinced
> >> that all the majority of warnings caused by it should actually
> >> lead to changes in the code.
> > 
> > I agree with Arnd here -- the changes required are extensive in many
> > cases, and a number of subsystems are making decent progress.
> > 
> > 							Thanx, Paul
> 
> I also agree. Most guys like to use direct read to the rcu pointer
> on update side or direct read/write when initializing the rcu pointer.
> This causes a lot of false positives.

And it is good to see some people, most notably Eric Dumazet, making
good use of __rcu!  We will learn from the experiences of the early
adopters, and perhaps be more aggressive pushing __rcu out to the rest
of the community in a year or two, depending on how it goes.

It is quite possible that __rcu will be something that only some of the
maintainers make use of for some time -- and that is OK.

							Thanx, Paul
