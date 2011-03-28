Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab1C1WSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 18:18:07 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48984 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002Ab1C1WSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 18:18:05 -0400
Date: Mon, 28 Mar 2011 15:17:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Jan Beulich <jbeulich@novell.com>, David Howells <dhowells@redhat.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <clameter@sgi.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC PATCH 0/5] Add kernel-offset file and make
 rcu_read_[un]lock() included
Message-ID: <20110328221755.GQ2287@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D8FF8AD.5080607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8FF8AD.5080607@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 10:55:41AM +0800, Lai Jiangshan wrote:
> 
> 
> __rcu_read_[un]lock() are so simple functions and called so
> frequent, it is not good that a function call overhead is
> required when use them. It would be better if we declare
> them inline and let the compiler do the choice.
> 
> We add kernel-offset.c for TASK_RCU_OFFSET, which enable we declare
> rcu_read_[un]lock() as inline function.
> 
> Adding kernel-offset.c does not have any effect for the result
> compiled kernel, it just adds a small and fast step in the kbuid stage.

Good stuff, thank you!  It will be really cool to have inlined
rcu_read_lock() and rcu_read_unlock() for TREE_PREEMPT_RCU!

I will queue this up in a few days, currently chasing down a problem
located in the upcoming TREE_RCU softirq-to-kthread commit.

							Thanx, Paul

> Lai Jiangshan (5):
>   task_rcu_struct
>   kbuild_dedumplicated
>   add_kernel_offset
>   access task's task_rcu_struct without include sched.h
>   rcu inline
> 
>  Kbuild                    |   99 ++++++++++++++++---------------
>  include/linux/init_task.h |   25 +--------
>  include/linux/rcupdate.h  |  144 ++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/sched.h     |   39 +------------
>  kernel/kernel-offsets.c   |   17 +++++
>  kernel/rcutiny_plugin.h   |   58 ++++--------------
>  kernel/rcutree_plugin.h   |   69 ++++++----------------
>  7 files changed, 243 insertions(+), 208 deletions(-)
>  create mode 100644 kernel/kernel-offsets.c
> 
> -- 
> 1.7.4
