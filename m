Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab0JGAca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 20:32:30 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:40942 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932573Ab0JGAc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 20:32:29 -0400
Date: Thu, 7 Oct 2010 09:31:20 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/4] HWPOISON: Report correct address granuality for AO
 huge page errors
Message-ID: <20101007003120.GB9891@spritzera.linux.bs1.fc.nec.co.jp>
References: <1286398141-13749-1-git-send-email-andi@firstfloor.org>
 <1286398141-13749-4-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <1286398141-13749-4-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -198,7 +199,8 @@ static int kill_proc_ao(struct task_struct *t, unsigned long addr, int trapno,
>  #ifdef __ARCH_SI_TRAPNO
>  	si.si_trapno = trapno;
>  #endif
> -	si.si_addr_lsb = PAGE_SHIFT;
> +	order = PageCompound(page) ? huge_page_order(page) : PAGE_SHIFT;
                                                     ^^^^
                                     huge_page_order(page_hstate(page)) ?

> +	si.si_addr_lsb = order;
>  	/*
>  	 * Don't use force here, it's convenient if the signal
>  	 * can be temporarily blocked.

...

> @@ -341,7 +343,8 @@ static void kill_procs_ao(struct list_head *to_kill, int doit, int trapno,
>  			if (fail || tk->addr_valid == 0) {
>  				printk(KERN_ERR
>  		"MCE %#lx: forcibly killing %s:%d because of failure to unmap corrupted page\n",
> -					pfn, tk->tsk->comm, tk->tsk->pid);
> +					pfn,	
> +					tk->tsk->comm, tk->tsk->pid);

What's the point of this change?

Thanks,
Naoya Horiguchi
