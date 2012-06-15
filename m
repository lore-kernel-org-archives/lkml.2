Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab2FOGgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 02:36:05 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58794 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715Ab2FOGgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 02:36:02 -0400
Date: Fri, 15 Jun 2012 11:52:58 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] uprobes: valid_vma() should reject VM_HUGETLB
Message-ID: <20120615062258.GA3811@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120607165942.GA31966@redhat.com>
 <20120607170002.GA31974@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120607170002.GA31974@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061506-5112-0000-0000-0000090DB7F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-06-07 19:00:02]:

> __replace_page() obviously can't work with the hugetlbfs mappings,
> uprobe_register() will likely crash the kernel. Change valid_vma()
> to check VM_HUGETLB as well.
> 
> As for PageTransHuge() no need to worry, vma->vm_file != NULL.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/events/uprobes.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 6e3b181..48d53af 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -105,7 +105,8 @@ static bool valid_vma(struct vm_area_struct *vma, bool is_register)
>  	if (!is_register)
>  		return true;
> 
> -	if ((vma->vm_flags & (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)) == (VM_READ|VM_EXEC))
> +	if ((vma->vm_flags & (VM_HUGETLB|VM_READ|VM_WRITE|VM_EXEC|VM_SHARED))
> +				== (VM_READ|VM_EXEC))
>  		return true;
> 
>  	return false;

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

