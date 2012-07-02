Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab2GBExo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 00:53:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab2GBExn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 00:53:43 -0400
Message-ID: <4FF127F6.9030908@redhat.com>
Date: Mon, 02 Jul 2012 00:47:50 -0400
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
Subject: Re: [PATCH 30/40] autonuma: numa hinting page faults entry points
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com> <1340888180-15355-31-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-31-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 08:56 AM, Andrea Arcangeli wrote:

> +++ b/mm/huge_memory.c
> @@ -1037,6 +1037,23 @@ out:
>   	return page;
>   }
>
> +#ifdef CONFIG_AUTONUMA
> +pmd_t __huge_pmd_numa_fixup(struct mm_struct *mm, unsigned long addr,

This is under CONFIG_AUTONUMA

> +++ b/mm/memory.c

> +static inline pte_t pte_numa_fixup(struct mm_struct *mm,

> +static inline void pmd_numa_fixup(struct mm_struct *mm,

> +static inline pmd_t huge_pmd_numa_fixup(struct mm_struct *mm,

But these are not.  Please fix, or document why this is
not required.

-- 
All rights reversed
