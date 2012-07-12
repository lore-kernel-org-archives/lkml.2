Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934134Ab2GLQ5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:57:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:51040 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932521Ab2GLQ5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:57:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="176557223"
Date: Fri, 13 Jul 2012 00:57:38 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: rcu_dyntick and suspicious RCU usage
Message-ID: <20120712165738.GA21630@localhost>
References: <20120709135637.GA26040@localhost>
 <20120709145724.GA27095@localhost>
 <20120710044700.GA9462@localhost>
 <20120711074924.GD3819@linux.vnet.ibm.com>
 <20120712164308.GA31584@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120712164308.GA31584@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 09:43:08AM -0700, Paul E. McKenney wrote:
> On Wed, Jul 11, 2012 at 12:49:24AM -0700, Paul E. McKenney wrote:
> > On Tue, Jul 10, 2012 at 12:47:00PM +0800, Fengguang Wu wrote:
> > > Hi Paul,
> > > 
> > > Fortunately this bug is bisectable and the first bad commit is:
> > > 
> > >         commit 9b2e4f1880b789be1f24f9684f7a54b90310b5c0
> > >         Author: Paul E. McKenney <paul.mckenney@linaro.org>
> > >         Date:   Fri Sep 30 12:10:22 2011 -0700
> > > 
> > >             rcu: Track idleness independent of idle tasks
> > 
> > OK, there is a problem in TINY_RCU's handling of dyntick-idle: it
> > traces while in idle.  The confusion on my part was that in TREE_RCU,
> > the nesting and dyntick-idle indication are different, while in
> > TINY_RCU they are one and the same.
> > 
> > Does the following patch help?
> 
> This one failed in my testing.  Please see the end for the fixed
> version, with on small but important change.

It worked, thanks!

Tested-by: Fengguang Wu <wfg@linux.intel.com>

