Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab1JQLUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:20:12 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37826 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580Ab1JQLUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:20:09 -0400
Date: Mon, 17 Oct 2011 16:29:54 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/X] uprobes: write_opcode: the new page needs
 PG_uptodate
Message-ID: <20111017105954.GD11831@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20111015190007.GA30243@redhat.com>
 <20111015190037.GB30243@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111015190037.GB30243@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11101711-5930-0000-0000-000000615F31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2011-10-15 21:00:37]:

> write_opcode()->__replace_page() installs the new anonymous page,
> this new_page is PageSwapBacked() and it can be swapped out.
> 
> However it forgets to do SetPageUptodate(), fix write_opcode().
> 
> For example, this is needed if do_swap_page() finds that orginial
> page in the the swap cache (and doesn't try to read it back), in
> this case it returns VM_FAULT_SIGBUS.
> ---
>  kernel/uprobes.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/uprobes.c b/kernel/uprobes.c
> index 3928bcc..52b20c8 100644
> --- a/kernel/uprobes.c
> +++ b/kernel/uprobes.c
> @@ -200,6 +200,8 @@ static int write_opcode(struct task_struct *tsk, struct uprobe * uprobe,
>  		goto put_out;
>  	}
> 
> +	__SetPageUptodate(new_page);
> +

Agree. 

>  	/*
>  	 * lock page will serialize against do_wp_page()'s
>  	 * PageAnon() handling

-- 
Thanks and Regards
Srikar

