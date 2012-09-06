Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997Ab2IFQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:25:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45846 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758451Ab2IFQZ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:25:27 -0400
Message-ID: <1346948545.18408.37.camel@twins>
Subject: Re: [PATCH tip/core/rcu 16/23] rcu: Prevent initialization-time
 quiescent-state race
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Date: Thu, 06 Sep 2012 18:22:25 +0200
In-Reply-To: <20120906161815.GE2448@linux.vnet.ibm.com>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
	 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346350718-30937-16-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20120903093742.GE5574@leaf> <20120905181920.GN3308@linux.vnet.ibm.com>
	 <1346941290.18408.17.camel@twins>
	 <20120906161815.GE2448@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 09:18 -0700, Paul E. McKenney wrote:
> On Thu, Sep 06, 2012 at 04:21:30PM +0200, Peter Zijlstra wrote:
> > On Wed, 2012-09-05 at 11:19 -0700, Paul E. McKenney wrote:
> > > I tried that, and got a surprisingly large set of conflicts.  Ah, OK,
> > > the problem is that breaking up rcu_gp_kthread() into subfunctions
> > > did enough code motion to defeat straightforward rebasing.  Is there
> > > some way to tell "git rebase" about such code motion, or would this
> > > need to be carried out carefully by hand? 
> > 
> > The alternative is doing that rebase by hand and in the process make
> > that code movement patch (6) obsolete by making patches (1) and (3)
> > introduce the code in the final form :-)
> > 
> > Yay for less patches :-)
> 
> Actually, my original intent was that patches 1-6 be one patch.
> The need to locate a nasty bug caused me to split it up.  So the best
> approach is to squash patches 1-6 together with the related patches.

I didn't mind the smaller steps, but patches like 6 which move newly
introduced code around are weird. As are patches fixing bugs introduced
in previous patches (of the same series).
