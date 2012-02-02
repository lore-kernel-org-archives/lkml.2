Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab2BBRxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:53:45 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:50565 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab2BBRxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:53:44 -0500
Date: Thu, 2 Feb 2012 09:16:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 17/41] rcu: Remove single-rcu_node
 optimization in rcu_start_gp()
Message-ID: <20120202171643.GQ2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-17-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202021314.GM29058@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202021314.GM29058@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020217-1780-0000-0000-000002D25AE5
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000245; HX=3.00000181; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00110329; UDB=6.00027425; UTC=2012-02-02
 17:53:40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 06:13:14PM -0800, Josh Triplett wrote:
> On Wed, Feb 01, 2012 at 11:41:35AM -0800, Paul E. McKenney wrote:
> > The grace-period initialization sequence in rcu_start_gp() has a special
> > case for systems where the rcu_node tree is a single rcu_node structure.
> > This made sense some years ago when systems were smaller and up to 64
> > CPUs could share a single rcu_node structure, but now that large systems
> > are common and a given leaf rcu_node structure can support only 16 CPUs
> > (due to lock contention on the rcu_node's ->lock field), this optimization
> > is almost never taken.  And even the small mobile platforms that might
> > make use of it might rather have the kernel text reduction.
> > 
> > Therefore, this commit removes the check for single-rcu_node trees.
> 
> This optimization would continue to work on laptops for a while longer.
> :)

How many more months?  ;-)

> That said, I do agree that reducing code size and complexity seems
> preferable.  If someone wants an optimization like this, they'd probably
> do better to compile RCU with a low compile-time limit on the number of
> CPUs, which would at least theoretically allow the compiler to get
> similar results through optimization.  (I don't know if that works in
> practice with the current code structure and the current intelligence of
> GCC.)
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Thank you for all your reviews -- as always, very helpful!!!

							Thanx, Paul

