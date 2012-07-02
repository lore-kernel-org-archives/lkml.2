Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab2GBOgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:36:05 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63572 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab2GBOgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:36:03 -0400
Message-ID: <1341239813.2958.7.camel@lappy>
Subject: Re: rcu: BUG: spinlock recursion on CPU#3, trinity-child19/5970
From: Sasha Levin <levinsasha928@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 02 Jul 2012 16:36:53 +0200
In-Reply-To: <20120702142252.GA22868@linux.vnet.ibm.com>
References: <1340964584.2936.40.camel@lappy>
	 <20120629172320.GA2416@linux.vnet.ibm.com> <1341006040.26928.4.camel@lappy>
	 <1341225139.23484.4.camel@twins> <20120702113541.GI2907@linux.vnet.ibm.com>
	 <1341230352.23484.7.camel@twins> <1341234773.2958.4.camel@lappy>
	 <20120702133334.GA2508@linux.vnet.ibm.com>
	 <20120702142252.GA22868@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 07:22 -0700, Paul E. McKenney wrote:
> > OK, so it looks like the context-switch-time call into preemptible RCU
> > needs to be outside of the runqueue-lock critical section.  One way
> > to do this is be reverting 616c310e (Move PREEMPT_RCU preemption to
> > switch_to() invocation).  Sasha, could you please try this out?
> 
> Hmmmm...  Here is a patch for this reversion on top of -rcu with
> conflicts resolved. 

It looks like how I've resolved it.

Just for clarity, the only rcu related patch I have on top of -next is
this reversal one. I've dropped anything we tested before.

Looks like its running fine for a bit now (~10 min). I'll ping if
anything changes, but on the other tests it has usually failed at this
point.

