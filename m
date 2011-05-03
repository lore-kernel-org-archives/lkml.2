Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab1ECTeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:34:07 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36831 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab1ECTeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:34:05 -0400
Date: Tue, 3 May 2011 12:33:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org, kaber@trash.net
Subject: Re: [PATCH tip/core/rcu 1/7] net,rcu: convert
 call_rcu(sk_filter_release_rcu) to kfree_rcu
Message-ID: <20110503193349.GX2294@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110502161321.GA6537@linux.vnet.ibm.com>
 <1304352824-6563-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110502.144156.104049895.davem@davemloft.net>
 <20110502220628.GI2294@linux.vnet.ibm.com>
 <20110503061335.GA7751@elte.hu>
 <20110503061604.GA8611@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503061604.GA8611@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 08:16:04AM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > On Mon, May 02, 2011 at 02:41:56PM -0700, David Miller wrote:
> > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > Date: Mon,  2 May 2011 09:13:38 -0700
> > > > 
> > > > > The RCU callback sk_filter_release_rcu just calls kfree(), so we use
> > > > > kfree_rcu() instead of call_rcu().
> > > > > 
> > > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > 
> > > > I'm fine with all of these net conversions:
> > > > 
> > > > Acked-by: David S. Miller <davem@davemloft.net>
> > > 
> > > Thank you, Dave!
> > 
> > Looking at the networking-only diffstat i suspect the best flow would be if 
> > Dave pulled these from you into the networking tree?
> 
> Oh, but kfree_rcu() is not upstream yet, right? So it has to be in the RCU 
> tree.

Yep!  So I either need to get kfree_rcu() upstream, then push up Dave's
tree, or I need to push them all up -tip.  Either way is fine by me.

							Thanx, Paul
