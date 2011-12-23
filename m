Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab1LWKiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:38:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33362 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756537Ab1LWKiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:38:15 -0500
Date: Fri, 23 Dec 2011 11:36:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
Message-ID: <20111223103620.GD4749@elte.hu>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>
 <20111219112326.GA15090@elte.hu>
 <87sjke1a53.fsf@abhimanyu.in.ibm.com>
 <4EF1B85F.7060105@redhat.com>
 <877h1o9dp7.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877h1o9dp7.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nikunj A Dadhania <nikunj@linux.vnet.ibm.com> wrote:

> Here some interesting perf reports from inside the guest:
> 
> Baseline:
>   29.79%   ebizzy  [kernel.kallsyms]   [k] native_flush_tlb_others
>   18.70%   ebizzy  libc-2.12.so        [.] __GI_memcpy
>    7.23%   ebizzy  [kernel.kallsyms]   [k] get_page_from_freelist
>    5.38%   ebizzy  [kernel.kallsyms]   [k] __do_page_fault
>    4.50%   ebizzy  [kernel.kallsyms]   [k] ____pagevec_lru_add
>    3.58%   ebizzy  [kernel.kallsyms]   [k] default_send_IPI_mask_logical
>    3.26%   ebizzy  [kernel.kallsyms]   [k] native_flush_tlb_single
>    2.82%   ebizzy  [kernel.kallsyms]   [k] handle_pte_fault
>    2.16%   ebizzy  [kernel.kallsyms]   [k] kunmap_atomic
>    2.10%   ebizzy  [kernel.kallsyms]   [k] _spin_unlock_irqrestore
>    1.90%   ebizzy  [kernel.kallsyms]   [k] down_read_trylock
>    1.65%   ebizzy  [kernel.kallsyms]   [k] __mem_cgroup_commit_charge.clone.4
>    1.60%   ebizzy  [kernel.kallsyms]   [k] up_read
>    1.24%   ebizzy  [kernel.kallsyms]   [k] __alloc_pages_nodemask
> 
> Gang:
>   22.53%   ebizzy  libc-2.12.so       [.] __GI_memcpy
>    9.73%   ebizzy  [kernel.kallsyms]  [k] ____pagevec_lru_add
>    8.22%   ebizzy  [kernel.kallsyms]  [k] get_page_from_freelist
>    7.80%   ebizzy  [kernel.kallsyms]  [k] default_send_IPI_mask_logical
>    7.68%   ebizzy  [kernel.kallsyms]  [k] native_flush_tlb_others
>    6.22%   ebizzy  [kernel.kallsyms]  [k] __do_page_fault
>    5.54%   ebizzy  [kernel.kallsyms]  [k] native_flush_tlb_single
>    4.44%   ebizzy  [kernel.kallsyms]  [k] _spin_unlock_irqrestore
>    2.90%   ebizzy  [kernel.kallsyms]  [k] kunmap_atomic
>    2.78%   ebizzy  [kernel.kallsyms]  [k] __mem_cgroup_commit_charge.clone.4
>    2.76%   ebizzy  [kernel.kallsyms]  [k] handle_pte_fault
>    2.16%   ebizzy  [kernel.kallsyms]  [k] __mem_cgroup_uncharge_common
>    1.59%   ebizzy  [kernel.kallsyms]  [k] down_read_trylock
>    1.43%   ebizzy  [kernel.kallsyms]  [k] up_read
> 
> I see the main difference between both the reports is:
> native_flush_tlb_others.

So it would be important to figure out why ebizzy gets into so 
many TLB flushes and why gang scheduling makes it go away.

Thanks,

	Ingo
