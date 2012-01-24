Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab2AXXqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:46:54 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43750 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab2AXXqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:46:53 -0500
Message-ID: <1327448809.14373.6.camel@edumazet-laptop>
Subject: Re: [GIT PULL] RCU changes for v3.3
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 25 Jan 2012 00:46:49 +0100
In-Reply-To: <20120124232911.GA11327@linux.vnet.ibm.com>
References: <20120105135432.GA31450@elte.hu>
	 <1327422312.7231.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20120124165312.GG2531@linux.vnet.ibm.com>
	 <1327425208.7231.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20120124194140.GB2381@linux.vnet.ibm.com>
	 <1327435069.2767.1.camel@edumazet-laptop>
	 <20120124211137.GD2381@linux.vnet.ibm.com>
	 <20120124232911.GA11327@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 24 janvier 2012 à 15:29 -0800, Paul E. McKenney a écrit :

> And here is another version of the patch.
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> x86: Avoid invoking RCU when CPU is idle
> 
> The idle loop is a quiscent state for RCU, which means that RCU ignores
> CPUs that have told RCU that they are idle via rcu_idle_enter().  There
> are nevertheless quite a few places where idle CPUs use RCU, most commonly
> indirectly via tracing.  This patch fixes these problems for x86.
> 
> Many of these bugs have been in the kernel for quite some time, but
> Frederic's recent change now gives warnings.
> 
> This patch takes the straightforward approach of pushing the
> rcu_idle_enter()/rcu_idle_exit() pair further down into the core
> of the idle loop.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 

Oh well, just when I decided to sleep a bit, you send a new patch :)

This seems to remove the warnings at least on my x86_64 server, thanks !

Tested-by: Eric Dumazet <eric.dumazet@gmail.com>



