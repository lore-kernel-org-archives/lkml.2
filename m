Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab2F2SyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 14:54:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341Ab2F2Sx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:53:57 -0400
Message-ID: <4FEDF963.9040700@redhat.com>
Date: Fri, 29 Jun 2012 14:52:19 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 19/40] autonuma: alloc/free/init sched_autonuma
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com> <1340888180-15355-20-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-20-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 08:55 AM, Andrea Arcangeli wrote:
> This is where the dynamically allocated sched_autonuma structure is
> being handled.
>
> The reason for keeping this outside of the task_struct besides not
> using too much kernel stack, is to only allocate it on NUMA
> hardware. So the not NUMA hardware only pays the memory of a pointer
> in the kernel stack (which remains NULL at all times in that case).

What is not documented is the reason for keeping it at all.

What is in the data structure?

What is the data structure used for?

How do we use it?

> +	if (unlikely(alloc_task_autonuma(tsk, orig, node)))
> +		/* free_thread_info() undoes arch_dup_task_struct() too */
> +		goto out_thread_info;

Oh, you mean task_autonuma, and not sched_autonuma?

Please fix the commit message and the subject.

-- 
All rights reversed
