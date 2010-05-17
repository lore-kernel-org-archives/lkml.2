Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab0EQAAm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 20:00:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44820 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab0EQAAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 20:00:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH v2] mm: Consider the entire user address space during node migration
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <1273962913-8950-1-git-send-email-gthelen@google.com>
References: <AANLkTil4zgqBtBAp--P8VdynpbohxVosQ-qFiQQ_c5Bb@mail.gmail.com> <1273962913-8950-1-git-send-email-gthelen@google.com>
Message-Id: <20100517085953.21A2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 17 May 2010 09:00:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Changes since v1:
> - Use mm->task_size rather than TASK_SIZE_MAX to support all platforms.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>

Looks good. Thanks Greg!
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> ---
>  mm/mempolicy.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 9f11728..2fd17e7 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -928,7 +928,7 @@ static int migrate_to_node(struct mm_struct *mm, int source, int dest,
>  	nodes_clear(nmask);
>  	node_set(source, nmask);
>  
> -	check_range(mm, mm->mmap->vm_start, TASK_SIZE, &nmask,
> +	check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
>  			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
>  
>  	if (!list_empty(&pagelist))
> -- 
> 1.7.0.1
> 



