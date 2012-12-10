Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab2LJG07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 01:26:59 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:33210 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab2LJG06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 01:26:58 -0500
Date: Mon, 10 Dec 2012 11:26:38 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] uprobes: Move __set_bit(UPROBE_SKIP_SSTEP) into
 alloc_uprobe()
Message-ID: <20121210055638.GD22164@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121123202741.GA18858@redhat.com>
 <20121123202800.GA18877@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121123202800.GA18877@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121006-2876-0000-0000-000002F4B7AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Cosmetic. __set_bit(UPROBE_SKIP_SSTEP) is the part of initialization,
> it is not clear why it is set in insert_uprobe().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 5e22faf..e9f22ed 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -430,9 +430,6 @@ static struct uprobe *insert_uprobe(struct uprobe *uprobe)
>  	u = __insert_uprobe(uprobe);
>  	spin_unlock(&uprobes_treelock);
> 
> -	/* For now assume that the instruction need not be single-stepped */
> -	__set_bit(UPROBE_SKIP_SSTEP, &uprobe->flags);
> -
>  	return u;
>  }
> 
> @@ -454,6 +451,8 @@ static struct uprobe *alloc_uprobe(struct inode *inode, loff_t offset)
>  	uprobe->offset = offset;
>  	init_rwsem(&uprobe->consumer_rwsem);
>  	mutex_init(&uprobe->copy_mutex);
> +	/* For now assume that the instruction need not be single-stepped */
> +	__set_bit(UPROBE_SKIP_SSTEP, &uprobe->flags);
> 
>  	/* add to uprobes_tree, sorted on inode:offset */
>  	cur_uprobe = insert_uprobe(uprobe);
> -- 
> 1.5.5.1
> 

