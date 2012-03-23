Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab2CWMpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 08:45:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41144 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab2CWMpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 08:45:17 -0400
Date: Fri, 23 Mar 2012 13:45:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] uprobes/core: counter to optimize probe hits.
Message-ID: <20120323124507.GI13920@gmail.com>
References: <20120321180811.22773.5801.sendpatchset@srdronam.in.ibm.com>
 <20120321180826.22773.57531.sendpatchset@srdronam.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321180826.22773.57531.sendpatchset@srdronam.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 9ade86e..62d5aeb 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -390,6 +390,7 @@ struct mm_struct {
>  	struct cpumask cpumask_allocation;
>  #endif
>  #ifdef CONFIG_UPROBES
> +	atomic_t mm_uprobes_count;
>  	struct uprobes_xol_area *uprobes_xol_area;
>  #endif

Since mm_types.h includes uprobes.h already it's much better to 
stick this into a 'struct uprobes_state' and thus keep the main 
'struct mm_struct' definition as simple as possible.

Also, your patch titles suck:

  - no proper capitalization like you can observe with previous 
    uprobes commits

  - extra period at the end

  - missing verb from the sentence. Check existing uprobes 
    commits to see the kind of sentences that commit titles are 
    expected to be.

> +	if (!atomic_read(&uprobe_events) || !valid_vma(vma, false))
> +		return;		/* Bail-out */
> +
> +	if (!atomic_read(&vma->vm_mm->mm_uprobes_count))
> +		return;
> +
> +	inode = vma->vm_file->f_mapping->host;
> +	if (!inode)
> +		return;

The 'Bail-out' comment tacked on to one of the returns seems 
entirely superfluous.

> +		if (vaddr >= vma->vm_start && vaddr < vma->vm_end) {
> +
> +			/*

That newline looks superfluous too.

> +	return;
> +}

Please read your own patches more carefully ... this should 
stick out like a sore thumb.

Some of the above comments apply to your other patch as well.

The structure and granularity of the patches looks good 
otherwise.

Thanks,

	Ingo
