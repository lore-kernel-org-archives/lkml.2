Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009Ab0JGHiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 03:38:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38926 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759524Ab0JGHiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 03:38:50 -0400
Date: Thu, 7 Oct 2010 09:38:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/4] HWPOISON: Report correct address granuality for AO
 huge page errors
Message-ID: <20101007073848.GG5010@basil.fritz.box>
References: <1286398141-13749-1-git-send-email-andi@firstfloor.org>
 <1286398141-13749-4-git-send-email-andi@firstfloor.org>
 <20101007003120.GB9891@spritzera.linux.bs1.fc.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101007003120.GB9891@spritzera.linux.bs1.fc.nec.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 09:31:20AM +0900, Naoya Horiguchi wrote:
> > @@ -198,7 +199,8 @@ static int kill_proc_ao(struct task_struct *t, unsigned long addr, int trapno,
> >  #ifdef __ARCH_SI_TRAPNO
> >  	si.si_trapno = trapno;
> >  #endif
> > -	si.si_addr_lsb = PAGE_SHIFT;
> > +	order = PageCompound(page) ? huge_page_order(page) : PAGE_SHIFT;
>                                                      ^^^^
>                                      huge_page_order(page_hstate(page)) ?

Ok.

> >  				printk(KERN_ERR
> >  		"MCE %#lx: forcibly killing %s:%d because of failure to unmap corrupted page\n",
> > -					pfn, tk->tsk->comm, tk->tsk->pid);
> > +					pfn,	
> > +					tk->tsk->comm, tk->tsk->pid);
> 
> What's the point of this change?

Probably left over from an earlier version; I will drop that hunk thanks.


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
