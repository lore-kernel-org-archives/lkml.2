Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab2FLPPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:15:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53426 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2FLPP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:15:29 -0400
Message-ID: <1339514114.31548.78.camel@twins>
Subject: Re: rcu,sched: spinlock recursion on 3.5-rc2
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Date: Tue, 12 Jun 2012 17:15:14 +0200
In-Reply-To: <alpine.LFD.2.02.1206121701350.3086@ionos>
References: <1339500907.4999.99.camel@lappy>
	 <alpine.LFD.2.02.1206121535180.3086@ionos>
	 <20120612144705.GB2423@linux.vnet.ibm.com>
	 <alpine.LFD.2.02.1206121701350.3086@ionos>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 17:07 +0200, Thomas Gleixner wrote:
> Hmm, not sure. The deadlock was not triggered in switch_to. It was
> just at the beginning of __schedule()
> 
> 
How can you tell? switch_to() is a macro not a function, it won't ever
show up on a stack-trace.. but I think you meant context_switch() but
that typically gets inlined, similar problem.
