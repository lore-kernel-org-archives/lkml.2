Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab1BWTYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:24:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:43097 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469Ab1BWTYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:24:32 -0500
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
In-Reply-To: <alpine.DEB.2.00.1102231317550.4823@router.home>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
	 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20110223161645.GA1819@nowhere>
	 <1298479302.7666.94.camel@gandalf.stny.rr.com>
	 <BLU0-SMTP65F733B8D1D704C7EA1F8796DB0@phx.gbl>
	 <alpine.DEB.2.00.1102231132140.562@router.home>
	 <1298485027.7666.98.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1102231225330.3906@router.home>
	 <1298485965.7666.102.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1102231317550.4823@router.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 23 Feb 2011 20:23:50 +0100
Message-ID: <1298489030.2217.818.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 13:19 -0600, Christoph Lameter wrote:

> this_cpu_inc is already percpu atomic. On x86 it is an instruction that
> cannot be interrupted nor preempted while in progress.

On x86, yes, but is this true for all architectures? I guess the
fallback is implemented with local_irq_disable() which might be good
enough for some but not for NMI usage.
