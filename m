Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab2HFL6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 07:58:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055Ab2HFL6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 07:58:18 -0400
Message-ID: <1344254271.19356.8.camel@bandura>
Subject: Re: [RESEND PATCH 1/3] uprobes: Remove redundant
 lock_page/unlock_page
From: Anton Arapov <anton@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Mon, 06 Aug 2012 13:57:51 +0200
In-Reply-To: <20120601091950.GF24279@linux.vnet.ibm.com>
References: <20120531114630.23691.33166.sendpatchset@srdronam.in.ibm.com>
	 <1338465518.28384.55.camel@twins>
	 <20120531150756.GC24279@linux.vnet.ibm.com>
	 <1338483372.28384.65.camel@twins>
	 <20120601091950.GF24279@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

  just a "ping" message, so that this change won't be forgotten.
  It was waiting for v3.6: https://lkml.org/lkml/2012/6/6/134

thank you!
Anton.

On Fri, 2012-06-01 at 14:49 +0530, Srikar Dronamraju wrote:
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
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 



