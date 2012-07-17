Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab2GQU7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 16:59:10 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58929 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab2GQU7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 16:59:08 -0400
Date: Tue, 17 Jul 2012 13:58:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <wfg@linux.intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: rcu_dyntick and suspicious RCU usage
Message-ID: <20120717205856.GF11150@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120709135637.GA26040@localhost>
 <20120709145724.GA27095@localhost>
 <20120710044700.GA9462@localhost>
 <20120711074924.GD3819@linux.vnet.ibm.com>
 <20120712164308.GA31584@linux.vnet.ibm.com>
 <20120712165738.GA21630@localhost>
 <20120712170242.GB31396@linux.vnet.ibm.com>
 <20120713091230.GA20208@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120713091230.GA20208@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071720-6148-0000-0000-000007BF4925
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 05:12:30PM +0800, Fengguang Wu wrote:
> On Thu, Jul 12, 2012 at 10:02:42AM -0700, Paul E. McKenney wrote:
> > On Fri, Jul 13, 2012 at 12:57:38AM +0800, Fengguang Wu wrote:
> > > On Thu, Jul 12, 2012 at 09:43:08AM -0700, Paul E. McKenney wrote:
> > > > On Wed, Jul 11, 2012 at 12:49:24AM -0700, Paul E. McKenney wrote:
> > > > > On Tue, Jul 10, 2012 at 12:47:00PM +0800, Fengguang Wu wrote:
> > > > > > Hi Paul,
> > > > > > 
> > > > > > Fortunately this bug is bisectable and the first bad commit is:
> > > > > > 
> > > > > >         commit 9b2e4f1880b789be1f24f9684f7a54b90310b5c0
> > > > > >         Author: Paul E. McKenney <paul.mckenney@linaro.org>
> > > > > >         Date:   Fri Sep 30 12:10:22 2011 -0700
> > > > > > 
> > > > > >             rcu: Track idleness independent of idle tasks
> > > > > 
> > > > > OK, there is a problem in TINY_RCU's handling of dyntick-idle: it
> > > > > traces while in idle.  The confusion on my part was that in TREE_RCU,
> > > > > the nesting and dyntick-idle indication are different, while in
> > > > > TINY_RCU they are one and the same.
> > > > > 
> > > > > Does the following patch help?
> > > > 
> > > > This one failed in my testing.  Please see the end for the fixed
> > > > version, with on small but important change.
> > > 
> > > It worked, thanks!
> > > 
> > > Tested-by: Fengguang Wu <wfg@linux.intel.com>
> > 
> > Very good!  (And please ignore my resend of the same patch.)
> > 
> > I will queue this.
> 
> Will you recommend it for -stable? It impacts 3.3/3.4. I tested it on
> 3.4 and it works fine. However for 3.3, the patch cannot apply cleanly.

If someone hits it in a real workload, I might consider it.  I currently
have it queued for 3.7.

							Thanx, Paul

