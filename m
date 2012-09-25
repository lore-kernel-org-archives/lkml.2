Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab2IYJTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 05:19:24 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:59369 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab2IYJTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 05:19:22 -0400
Date: Tue, 25 Sep 2012 14:21:29 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] uprobes: Change valid_vma() to demand VM_MAYEXEC
 rather than VM_EXEC
Message-ID: <20120925085129.GB18334@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120916175210.GA32337@redhat.com>
 <20120916175246.GA32370@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120916175246.GA32370@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092509-7408-0000-0000-000008C6759A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-16 19:52:46]:

> uprobe_register() or uprobe_mmap() requires VM_READ | VM_EXEC, this
> is not right. An apllication can do mprotect(PROT_EXEC) later and
> execute this code.
> 
> Change valid_vma(is_register => true) to check VM_MAYEXEC instead.
> No need to check VM_MAYREAD, it is always set.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index fa1579a..b9b50dd 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -106,8 +106,8 @@ static bool valid_vma(struct vm_area_struct *vma, bool is_register)
>  	if (!is_register)
>  		return true;
> 
> -	if ((vma->vm_flags & (VM_HUGETLB|VM_READ|VM_WRITE|VM_EXEC|VM_SHARED))
> -				== (VM_READ|VM_EXEC))
> +	if ((vma->vm_flags & (VM_HUGETLB | VM_WRITE | VM_MAYEXEC | VM_SHARED))
> +				== VM_MAYEXEC)
>  		return true;
> 
>  	return false;
> -- 
> 1.5.5.1
> 

