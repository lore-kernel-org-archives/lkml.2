Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477Ab1CaXYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 19:24:09 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34277 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759454Ab1CaXYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 19:24:07 -0400
Date: Thu, 31 Mar 2011 16:24:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Jan Beulich <jbeulich@novell.com>, David Howells <dhowells@redhat.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <clameter@sgi.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC PATCH 1/5] Move task's RCU code to rcupdate.h
Message-ID: <20110331232401.GO2258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D8FF8AD.5080607@cn.fujitsu.com>
 <4D8FF93B.7010109@cn.fujitsu.com>
 <1301571096.4859.243.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301571096.4859.243.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 01:31:36PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-03-28 at 10:58 +0800, Lai Jiangshan wrote:
> > +struct task_rcu_struct {
> > +#ifdef CONFIG_PREEMPT_RCU
> > +       int rcu_read_lock_nesting;
> > +       char rcu_read_unlock_special;
> 
> Is there a good reason that's a char? It'll leave a 3 byte hole in this
> location.

No good reason.  Lai just copied the existing char from the task
struct into his task_rcu_struct, so not his fault.  ;-)

							Thanx, Paul

> > +       struct list_head rcu_node_entry;
> > +#ifdef CONFIG_TREE_PREEMPT_RCU
> > +       struct rcu_node *rcu_blocked_node;
> > +#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> > +#ifdef CONFIG_RCU_BOOST
> > +       struct rt_mutex *rcu_boost_mutex;
> > +#endif /* #ifdef CONFIG_RCU_BOOST */
> > +#endif /* #ifdef CONFIG_PREEMPT_RCU */
> > +}; 
