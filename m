Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391Ab2DJUQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 16:16:22 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37494 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758962Ab2DJUQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 16:16:20 -0400
Date: Tue, 10 Apr 2012 13:15:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Lai Jiangshan <eag0628@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: Re: [RFC PATCH 5/5 single-thread-version] implement per-domain
 single-thread state machine call_srcu()
Message-ID: <20120410201512.GI2428@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
 <1331027858-7648-4-git-send-email-laijs@cn.fujitsu.com>
 <4F56DBDA.1020608@cn.fujitsu.com>
 <20120308203533.GN2348@linux.vnet.ibm.com>
 <CACvQF534RJcu8-yKcByqthifUHCLsggGXuRPAKqf7mZMXT3taA@mail.gmail.com>
 <20120312180321.GG2471@linux.vnet.ibm.com>
 <4F604CFA.9010302@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F604CFA.9010302@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041020-9360-0000-0000-0000054E24B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 03:47:06PM +0800, Lai Jiangshan wrote:
> On 03/13/2012 02:03 AM, Paul E. McKenney wrote:
> 
> >>
> >> In mb()-based srcu, synchronize_srcu() is very fast,
> >> synchronize_srcu_expedited() makes less sense than before.
> > 
> > I am worried about expedited callbacks getting backed up behind
> > non-expedited callbacks (especially given Peter's point about per-VMA
> > SRCU callbacks) and behind other workqueue uses.
> > 
> >> But when wait_srcu_gp() is move back here, I will use
> >> a bigger "trycount" for synchronize_srcu_expedited().
> >>
> >> And any problem for srcu_advance_batches()?
> > 
> > I prefer the use of "return" that you and Peter discussed later.
> > 
> > What sort of testing are you doing?
> 
> rcutorture in my box for several days on my daily used machine.

OK, good!

> What would you prefer for next round of patches, single-thread or per-cpu?
> I will send them soon.
> (per-cpu approach will be also "batches, in-sleepable, reuse rcu_head"....)
> 
> I prefer the single-thread approach until high-callback-rate-per-domain-era
> comes, but I don't know how long when it comes. Peter?

Well, the price for sticking with the single-thread approach is
a commitment on your part to create a high-callback-rate-per-domain
version at a moment's notice, should it be needed.

Can you commit to that?  If not, then the initial version needs to be
able to handle a high callback rate.

							Thanx, Paul

