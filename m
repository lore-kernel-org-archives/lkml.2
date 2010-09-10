Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab0IJPrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:47:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:40193 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab0IJPrN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:47:13 -0400
Subject: Re: [tip:perf/core] perf: Per-pmu-per-cpu contexts
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@redhat.com, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, eranian@googlemail.com,
        yanmin_zhang@linux.intel.com, robert.richter@amd.com,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <20100910153750.GC2400@linux.vnet.ibm.com>
References: <tip-108b02cfce04ee90b0a07ee0b104baffd39f5934@git.kernel.org>
	 <20100910145426.GA5618@nowhere>  <20100910153750.GC2400@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Sep 2010 17:46:34 +0200
Message-ID: <1284133594.402.94.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 08:37 -0700, Paul E. McKenney wrote:
> > So, you say below that it works because synchronize_srcu(), that
> > waits for qs after touching pmus, implies synchronize_sched(), right?
> 
> Ook...  My current plans to fold SRCU into TREE_RCU would invalidate
> this assumption.
> 
> Maybe we need some sort of primitive that concurrently waits for
> multiple types of RCU grace periods? 

Nah, but I was thinking that any kind of preemptible rcu sync would
imply a sched rcu sync.

If not strictly implied I'd have no problem simply writing:

  synchronize_rcu_sched();
  synchronize_srcu();


