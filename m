Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab2FFJSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:18:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43230 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab2FFJSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:18:49 -0400
Date: Wed, 6 Jun 2012 11:18:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>
Subject: Re: [RESEND PATCH 1/3] uprobes: Remove redundant
 lock_page/unlock_page
Message-ID: <20120606091844.GA421@gmail.com>
References: <20120531114630.23691.33166.sendpatchset@srdronam.in.ibm.com>
 <1338465518.28384.55.camel@twins>
 <20120531150756.GC24279@linux.vnet.ibm.com>
 <1338483372.28384.65.camel@twins>
 <20120601091950.GF24279@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120601091950.GF24279@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> 
> Since read_opcode() reads from the referenced page and doesnt modify
> the page contents nor the page attributes, there is no need to lock
> the page.
> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
>  Modified changelog based on comments from Peter Zijlstra
> 
>  kernel/events/uprobes.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 42b21eb..b3f3095 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -315,12 +315,10 @@ static int read_opcode(struct mm_struct *mm, unsigned long vaddr, uprobe_opcode_
>  	if (ret <= 0)
>  		return ret;
>  
> -	lock_page(page);
>  	vaddr_new = kmap_atomic(page);
>  	vaddr &= ~PAGE_MASK;
>  	memcpy(opcode, vaddr_new + vaddr, UPROBE_SWBP_INSN_SIZE);
>  	kunmap_atomic(vaddr_new);
> -	unlock_page(page);
>  
>  	put_page(page);

Is this also a bug fix, or can it wait until v3.6?

Thanks,

	Ingo
