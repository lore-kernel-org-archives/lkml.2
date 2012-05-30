Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab2E3UXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:23:25 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:41473 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2E3UXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:23:24 -0400
Date: Wed, 30 May 2012 16:23:19 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
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
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 06/35] autonuma: generic pte_numa() and pmd_numa()
Message-ID: <20120530202318.GB30148@localhost.localdomain>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
 <1337965359-29725-7-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337965359-29725-7-git-send-email-aarcange@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 07:02:10PM +0200, Andrea Arcangeli wrote:
> Implement generic version of the methods. They're used when
> CONFIG_AUTONUMA=n, and they're a noop.

I think you can roll that in the previous patch.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  include/asm-generic/pgtable.h |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
> index fa596d9..780f707 100644
> --- a/include/asm-generic/pgtable.h
> +++ b/include/asm-generic/pgtable.h
> @@ -521,6 +521,18 @@ static inline int pmd_trans_unstable(pmd_t *pmd)
>  #endif
>  }
>  
> +#ifndef CONFIG_AUTONUMA
> +static inline int pte_numa(pte_t pte)
> +{
> +	return 0;
> +}
> +
> +static inline int pmd_numa(pmd_t pmd)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_AUTONUMA */
> +
>  #endif /* CONFIG_MMU */
>  
>  #endif /* !__ASSEMBLY__ */
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
