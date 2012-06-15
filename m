Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab2FOGbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 02:31:35 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33937 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2FOGbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 02:31:34 -0400
Date: Fri, 15 Jun 2012 11:55:34 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] uprobes: __copy_insn() should ensure
 a_ops->readpage	!= NULL
Message-ID: <20120615062534.GB3811@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120607165942.GA31966@redhat.com>
 <20120607170018.GB31974@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120607170018.GB31974@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061506-1780-0000-0000-000006761ADB
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000281; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00148183; UDB=6.00033786; UTC=2012-06-15
 06:31:32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-06-07 19:00:18]:

> __copy_insn() blindly calls read_mapping_page(), this will crash
> the kernel if ->readpage == NULL, add the necessary check. For
> example, hugetlbfs_aops->readpage is NULL. Perhaps we should change
> read_mapping_page() instead.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/events/uprobes.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 48d53af..9c53bc2 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -616,6 +616,8 @@ __copy_insn(struct address_space *mapping, struct vm_area_struct *vma, char *ins
> 
>  	if (!filp)
>  		return -EINVAL;
> +	if (!mapping->a_ops->readpage)
> +		return -EIO;

Nit: Should there be a blank line before the if. Ingo had insisted on
these coding style changes.

>  	idx = (unsigned long)(offset >> PAGE_CACHE_SHIFT);
>  	off1 = offset &= ~PAGE_MASK;

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

-- 
Thanks and Regards
Srikar

