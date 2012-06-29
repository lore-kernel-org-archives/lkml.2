Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab2F2P3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:29:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761Ab2F2P3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:29:11 -0400
Message-ID: <4FEDC961.1060306@redhat.com>
Date: Fri, 29 Jun 2012 11:27:29 -0400
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
Subject: Re: [PATCH 08/40] autonuma: teach gup_fast about pte_numa
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com> <1340888180-15355-9-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-9-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 08:55 AM, Andrea Arcangeli wrote:
> gup_fast will skip over non present ptes (pte_numa requires the pte to
> be non present). So no explicit check is needed for pte_numa in the
> pte case.
>
> gup_fast will also automatically skip over THP when the trans huge pmd
> is non present (pmd_numa requires the pmd to be non present).
>
> But for the special pmd mode scan of knuma_scand
> (/sys/kernel/mm/autonuma/knuma_scand/pmd == 1), the pmd may be of numa
> type (so non present too), the pte may be present. gup_pte_range
> wouldn't notice the pmd is of numa type. So to avoid losing a NUMA
> hinting page fault with gup_fast we need an explicit check for
> pmd_numa() here to be sure it will fault through gup ->
> handle_mm_fault.
>
> Signed-off-by: Andrea Arcangeli<aarcange@redhat.com>

Assuming pmd_numa will get the documentation I asked for a few
patches back, this patch is fine, since people will just be able
to look at a nice comment above pmd_numa and see what is going on.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
