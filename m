Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012Ab0EKU7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:59:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59901 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927Ab0EKU7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:59:50 -0400
Subject: Re: [PATCH v3 0/10] Uprobes v3
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
References: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 22:59:45 +0200
Message-ID: <1273611585.1810.132.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-06 at 23:31 +0530, Srikar Dronamraju wrote:
>   - Addressed comments from Oleg, including removal of interrupt context
>     handlers, reverting background page replacement in favour of
>     access_process_vm(). 


> +static int write_opcode(struct task_struct *tsk, unsigned long vaddr,
> +                                               user_bkpt_opcode_t opcode)
> +{
> +       int ret;
> +
> +       if (!tsk)
> +               return -EINVAL;
> +
> +       ret = access_process_vm(tsk, vaddr, &opcode, user_bkpt_opcode_sz, 1);
> +       return (ret == user_bkpt_opcode_sz ? 0 : -EFAULT);
> +}

Why!

That's not not the atomic sequence outlined.

