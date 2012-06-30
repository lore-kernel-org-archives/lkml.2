Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab2F3FMY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 01:12:24 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35761 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2F3FMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 01:12:22 -0400
Date: Sat, 30 Jun 2012 01:12:18 -0400
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
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 20/40] autonuma: alloc/free/init mm_autonuma
Message-ID: <20120630051217.GG3975@localhost.localdomain>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
 <1340888180-15355-21-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340888180-15355-21-git-send-email-aarcange@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 02:56:00PM +0200, Andrea Arcangeli wrote:
> This is where the mm_autonuma structure is being handled. Just like
> sched_autonuma, this is only allocated at runtime if the hardware the
> kernel is running on has been detected as NUMA. On not NUMA hardware

I think the correct wording is "non-NUMA", not "not NUMA".

> the memory cost is reduced to one pointer per mm.
> 
> To get rid of the pointer in the each mm, the kernel can be compiled
> with CONFIG_AUTONUMA=n.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  kernel/fork.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 0adbe09..3e5a0d9 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -527,6 +527,8 @@ static void mm_init_aio(struct mm_struct *mm)
>  
>  static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
>  {
> +	if (unlikely(alloc_mm_autonuma(mm)))
> +		goto out_free_mm;

So reading that I would think that on non-NUMA machines this would fail
(since there is nothing to allocate). But that is not the case
(I hope!?) Perhaps just make the function not return any values?

