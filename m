Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab2EBVWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 17:22:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:53078 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab2EBVW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 17:22:29 -0400
Message-ID: <1335993615.4088.1.camel@pasglop>
Subject: Re: linux-next ppc64: RCU mods cause __might_sleep BUGs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hugh Dickins <hughd@google.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Thu, 03 May 2012 07:20:15 +1000
In-Reply-To: <alpine.LSU.2.00.1205021324430.24246@eggly.anvils>
References: <alpine.LSU.2.00.1204301451270.2986@eggly.anvils>
	 <1335832418.20866.95.camel@pasglop>
	 <alpine.LSU.2.00.1204302142310.27208@eggly.anvils>
	 <20120501142208.GA2441@linux.vnet.ibm.com>
	 <alpine.LSU.2.00.1205011410360.28232@eggly.anvils>
	 <20120501232516.GR2441@linux.vnet.ibm.com>
	 <alpine.LSU.2.00.1205021324430.24246@eggly.anvils>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 13:25 -0700, Hugh Dickins wrote:
> Got it at last.  Embarrassingly obvious.  __rcu_read_lock() and
> __rcu_read_unlock() are not safe to be using __this_cpu operations,
> the cpu may change in between the rmw's read and write: they should
> be using this_cpu operations (or, I put preempt_disable/enable in the
> __rcu_read_unlock below).  __this_cpus there work out fine on x86,
> which was given good instructions to use; but not so well on PowerPC.
> 
> I've been running successfully for an hour now with the patch below;
> but I expect you'll want to consider the tradeoffs, and may choose a
> different solution.

Didn't Linus recently rant about these __this_cpu vs this_cpu nonsense ?

I thought that was going out..

Cheers,
Ben.


