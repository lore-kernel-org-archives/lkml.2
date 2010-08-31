Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab0HaNEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 09:04:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358Ab0HaNEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 09:04:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100830172631.GA11868@linux.vnet.ibm.com>
References: <20100830172631.GA11868@linux.vnet.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com,
        jslaby@suse.cz, jmorris@namei.org
Subject: Re: [PATCH RFC] pid: make setpgid() system call use RCU read-side critical section
Date: Tue, 31 Aug 2010 14:02:31 +0100
Message-ID: <7899.1283259751@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

>  	write_lock_irq(&tasklist_lock);
>  
>  	err = -ESRCH;
> +	rcu_read_lock();
> ...
> +	rcu_read_unlock();
>  	write_unlock_irq(&tasklist_lock);

I would generally put the rcu lock outside the IRQ disabled section on the
basis that it's better to keep the amount of time we have interrupts disabled
shortest.

> Located-by: Andrew Morton <akpm@linux-foundation.org>

'Reported-by' might be more consistent with what others use.

David
