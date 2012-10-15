Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab2JOQ5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:57:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab2JOQ5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:57:07 -0400
Date: Mon, 15 Oct 2012 18:57:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9] uprobes: flush cache after xol write
Message-ID: <20121015165756.GA11737@redhat.com>
References: <1350242593-17761-1-git-send-email-rabin@rab.in> <1350242593-17761-6-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350242593-17761-6-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14, Rabin Vincent wrote:
>
> Flush the cache so that the instructions written to the XOL area are
> visible.
>
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  kernel/events/uprobes.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index ca000a9..8c52f93 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1246,6 +1246,7 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe, unsigned long slot
>  	offset = current->utask->xol_vaddr & ~PAGE_MASK;
>  	vaddr = kmap_atomic(area->page);
>  	arch_uprobe_xol_copy(&uprobe->arch, vaddr + offset);
> +	flush_dcache_page(area->page);
>  	kunmap_atomic(vaddr);

I agree... but why under kmap_atomic?

Oleg.

