Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab1JXMI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:08:27 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56248 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932100Ab1JXMIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:08:25 -0400
Date: Mon, 24 Oct 2011 05:07:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 36/55] rcu: Prevent early boot
 set_need_resched() from __rcu_pending()
Message-ID: <20111024120718.GD2273@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <1315332049-2604-36-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111017014915.GE19421@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017014915.GE19421@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11102412-3534-0000-0000-000000DB4610
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 16, 2011 at 06:49:15PM -0700, Josh Triplett wrote:
> On Tue, Sep 06, 2011 at 11:00:30AM -0700, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paul.mckenney@linaro.org>
> > 
> > There isn't a whole lot of point in poking the scheduler before there
> > are other tasks to switch to.  This commit therefore adds a check
> > for rcu_scheduler_fully_active in __rcu_pending() to suppress any
> > pre-scheduler calls to set_need_resched().  The downside of this approach
> > is additional runtime overhead in a reasonably hot code path.
> 
> If you're concerned about the runtime overhead, this does seem like a
> perfect candidate for jump labels.

I have added this to my todo list, but would welcome a patch.

							Thanx, Paul

