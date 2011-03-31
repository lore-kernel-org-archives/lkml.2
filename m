Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964831Ab1CaLcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 07:32:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57911 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab1CaLcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 07:32:16 -0400
Subject: Re: [RFC PATCH 1/5] Move task's RCU code to rcupdate.h
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
        Jan Beulich <jbeulich@novell.com>, David Howells <dhowells@redhat.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <clameter@sgi.com>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <4D8FF93B.7010109@cn.fujitsu.com>
References: <4D8FF8AD.5080607@cn.fujitsu.com>
	 <4D8FF93B.7010109@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 31 Mar 2011 13:31:36 +0200
Message-ID: <1301571096.4859.243.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-28 at 10:58 +0800, Lai Jiangshan wrote:
> +struct task_rcu_struct {
> +#ifdef CONFIG_PREEMPT_RCU
> +       int rcu_read_lock_nesting;
> +       char rcu_read_unlock_special;

Is there a good reason that's a char? It'll leave a 3 byte hole in this
location.

> +       struct list_head rcu_node_entry;
> +#ifdef CONFIG_TREE_PREEMPT_RCU
> +       struct rcu_node *rcu_blocked_node;
> +#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> +#ifdef CONFIG_RCU_BOOST
> +       struct rt_mutex *rcu_boost_mutex;
> +#endif /* #ifdef CONFIG_RCU_BOOST */
> +#endif /* #ifdef CONFIG_PREEMPT_RCU */
> +}; 
