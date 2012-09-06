Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab2IFQSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:18:52 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59510 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758783Ab2IFQSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:18:50 -0400
Date: Thu, 6 Sep 2012 09:18:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 16/23] rcu: Prevent initialization-time
 quiescent-state race
Message-ID: <20120906161815.GE2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-16-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120903093742.GE5574@leaf>
 <20120905181920.GN3308@linux.vnet.ibm.com>
 <1346941290.18408.17.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346941290.18408.17.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090616-7182-0000-0000-00000285A71F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 04:21:30PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-09-05 at 11:19 -0700, Paul E. McKenney wrote:
> > I tried that, and got a surprisingly large set of conflicts.  Ah, OK,
> > the problem is that breaking up rcu_gp_kthread() into subfunctions
> > did enough code motion to defeat straightforward rebasing.  Is there
> > some way to tell "git rebase" about such code motion, or would this
> > need to be carried out carefully by hand? 
> 
> The alternative is doing that rebase by hand and in the process make
> that code movement patch (6) obsolete by making patches (1) and (3)
> introduce the code in the final form :-)
> 
> Yay for less patches :-)

Actually, my original intent was that patches 1-6 be one patch.
The need to locate a nasty bug caused me to split it up.  So the best
approach is to squash patches 1-6 together with the related patches.

							Thanx, paul

