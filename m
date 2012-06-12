Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab2FLPUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:20:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:44378 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab2FLPUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:20:16 -0400
Date: Tue, 12 Jun 2012 17:20:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: rcu,sched: spinlock recursion on 3.5-rc2
In-Reply-To: <1339514114.31548.78.camel@twins>
Message-ID: <alpine.LFD.2.02.1206121716370.3086@ionos>
References: <1339500907.4999.99.camel@lappy>  <alpine.LFD.2.02.1206121535180.3086@ionos>  <20120612144705.GB2423@linux.vnet.ibm.com>  <alpine.LFD.2.02.1206121701350.3086@ionos> <1339514114.31548.78.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2012, Peter Zijlstra wrote:

> On Tue, 2012-06-12 at 17:07 +0200, Thomas Gleixner wrote:
> > Hmm, not sure. The deadlock was not triggered in switch_to. It was
> > just at the beginning of __schedule()
> > 
> > 
> How can you tell? switch_to() is a macro not a function, it won't ever
> show up on a stack-trace.. but I think you meant context_switch() but
> that typically gets inlined, similar problem.

Bah, I misread the trace and the rcu code. :(

So, yes the revert should solve the problem. Looks like I need more
coffee, not Paul :)

Thanks,

	tglx
