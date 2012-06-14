Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab2FNIiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:38:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:54557 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab2FNIhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:37:10 -0400
Date: Thu, 14 Jun 2012 10:37:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
In-Reply-To: <1339661331.2559.5.camel@twins>
Message-ID: <alpine.LFD.2.02.1206141036310.3086@ionos>
References: <20120613102823.373180763@linutronix.de>  <20120613105815.206105518@linutronix.de>  <20120613183301.GE2427@linux.vnet.ibm.com>  <alpine.LFD.2.02.1206132050270.3086@ionos> <1339661331.2559.5.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012, Peter Zijlstra wrote:

> On Wed, 2012-06-13 at 20:56 +0200, Thomas Gleixner wrote:
> > If it's just a spurious wakeup then it goes back to sleep right away
> > as nothing cleared the park bit. 
> 
> Your spurious wakeup will have destroyed the binding though. So you need
> to be careful.

We explicitely rebind it on unpark().
