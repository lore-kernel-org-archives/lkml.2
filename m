Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab1DHImn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 04:42:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40924 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab1DHImm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 04:42:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [PATCH] mm: Check we have the right vma in __access_remote_vm()
Cc: kosaki.motohiro@jp.fujitsu.com, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <hughd@google.com>, <walken@google.com>,
        <aarcange@redhat.com>, <riel@redhat.com>,
        Andrew Morton <akpm@osdl.org>, <linuxppc-dev@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <10e5cbf67c850b6ae511979bdbad1761236ad9b0.1302247435.git.michael@ellerman.id.au>
References: <10e5cbf67c850b6ae511979bdbad1761236ad9b0.1302247435.git.michael@ellerman.id.au>
Message-Id: <20110408174244.9B6F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Fri,  8 Apr 2011 17:42:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In __access_remote_vm() we need to check that we have found the right
> vma, not the following vma, before we try to access it. Otherwise we
> might call the vma's access routine with an address which does not
> fall inside the vma.
> 
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
> ---
>  mm/memory.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 9da8cab..ce999ca 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3678,7 +3678,7 @@ static int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
>  			 */
>  #ifdef CONFIG_HAVE_IOREMAP_PROT
>  			vma = find_vma(mm, addr);
> -			if (!vma)
> +			if (!vma || vma->vm_start > addr)
>  				break;
>  			if (vma->vm_ops && vma->vm_ops->access)
>  				ret = vma->vm_ops->access(vma, addr, buf,

Looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



