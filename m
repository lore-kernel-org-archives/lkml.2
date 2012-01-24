Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab2AXXyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:54:47 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:60865 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab2AXXyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:54:46 -0500
Date: Tue, 24 Jan 2012 15:54:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] RCU changes for v3.3
Message-ID: <20120124235437.GH2381@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120105135432.GA31450@elte.hu>
 <1327422312.7231.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20120124165312.GG2531@linux.vnet.ibm.com>
 <1327425208.7231.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20120124194140.GB2381@linux.vnet.ibm.com>
 <1327435069.2767.1.camel@edumazet-laptop>
 <20120124211137.GD2381@linux.vnet.ibm.com>
 <20120124232911.GA11327@linux.vnet.ibm.com>
 <1327448809.14373.6.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1327448809.14373.6.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012423-1780-0000-0000-00000299C728
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000245; HX=3.00000181; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00107837; UDB=6.00027006; UTC=2012-01-24
 23:54:45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 12:46:49AM +0100, Eric Dumazet wrote:
> Le mardi 24 janvier 2012 à 15:29 -0800, Paul E. McKenney a écrit :
> 
> > And here is another version of the patch.
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > x86: Avoid invoking RCU when CPU is idle
> > 
> > The idle loop is a quiscent state for RCU, which means that RCU ignores
> > CPUs that have told RCU that they are idle via rcu_idle_enter().  There
> > are nevertheless quite a few places where idle CPUs use RCU, most commonly
> > indirectly via tracing.  This patch fixes these problems for x86.
> > 
> > Many of these bugs have been in the kernel for quite some time, but
> > Frederic's recent change now gives warnings.
> > 
> > This patch takes the straightforward approach of pushing the
> > rcu_idle_enter()/rcu_idle_exit() pair further down into the core
> > of the idle loop.
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> 
> Oh well, just when I decided to sleep a bit, you send a new patch :)

;-)  ;-)  ;-)

> This seems to remove the warnings at least on my x86_64 server, thanks !
> 
> Tested-by: Eric Dumazet <eric.dumazet@gmail.com>

Good to hear!  Thank you!!!  I have added your Reported-by and
Tested-by.

							Thanx, Paul

