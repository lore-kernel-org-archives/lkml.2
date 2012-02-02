Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab2BBCNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 21:13:39 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47072 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab2BBCNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 21:13:37 -0500
X-Originating-IP: 217.70.178.130
X-Originating-IP: 50.43.15.19
Date: Wed, 1 Feb 2012 18:13:14 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 17/41] rcu: Remove single-rcu_node
 optimization in rcu_start_gp()
Message-ID: <20120202021314.GM29058@leaf>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-17-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328125319-5205-17-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 11:41:35AM -0800, Paul E. McKenney wrote:
> The grace-period initialization sequence in rcu_start_gp() has a special
> case for systems where the rcu_node tree is a single rcu_node structure.
> This made sense some years ago when systems were smaller and up to 64
> CPUs could share a single rcu_node structure, but now that large systems
> are common and a given leaf rcu_node structure can support only 16 CPUs
> (due to lock contention on the rcu_node's ->lock field), this optimization
> is almost never taken.  And even the small mobile platforms that might
> make use of it might rather have the kernel text reduction.
> 
> Therefore, this commit removes the check for single-rcu_node trees.

This optimization would continue to work on laptops for a while longer.
:)

That said, I do agree that reducing code size and complexity seems
preferable.  If someone wants an optimization like this, they'd probably
do better to compile RCU with a low compile-time limit on the number of
CPUs, which would at least theoretically allow the compiler to get
similar results through optimization.  (I don't know if that works in
practice with the current code structure and the current intelligence of
GCC.)

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
