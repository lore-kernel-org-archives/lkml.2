Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab2F2O3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 10:29:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab2F2O27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 10:28:59 -0400
Message-ID: <4FEDBB1F.9030001@redhat.com>
Date: Fri, 29 Jun 2012 10:26:39 -0400
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
Subject: Re: [PATCH 05/40] autonuma: define _PAGE_NUMA_PTE and _PAGE_NUMA_PMD
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com> <1340888180-15355-6-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-6-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 08:55 AM, Andrea Arcangeli wrote:

> +/*
> + * Cannot be set on pte. The fact it's in between _PAGE_FILE and
> + * _PAGE_PROTNONE avoids having to alter the swp entries.
> + */
> +#define _PAGE_NUMA_PTE	_PAGE_PSE
> +/*
> + * Cannot be set on pmd, if transparent hugepages will be swapped out
> + * the swap entry offset must start above it.
> + */
> +#define _PAGE_NUMA_PMD	_PAGE_UNUSED2

Those comments only tell us what the flags can NOT be
used for, not what they are actually used for.

That needs to be fixed.

-- 
All rights reversed
