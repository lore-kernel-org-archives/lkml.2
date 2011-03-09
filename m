Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614Ab1CIFWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 00:22:10 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53305 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab1CIFWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 00:22:05 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH 4/6] proc: disable mem_write after exec
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Roland McGrath <roland@redhat.com>,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Ingo Molnar <mingo@elte.hu>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1299631343-4499-5-git-send-email-wilsons@start.ca>
References: <1299631343-4499-1-git-send-email-wilsons@start.ca> <1299631343-4499-5-git-send-email-wilsons@start.ca>
Message-Id: <20110309142107.03FA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  9 Mar 2011 14:22:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This change makes mem_write() observe the same constraints as mem_read().  This
> is particularly important for mem_write as an accidental leak of the fd across
> an exec could result in arbitrary modification of the target process' memory.
> IOW, /proc/pid/mem is implicitly close-on-exec.
> 
> Signed-off-by: Stephen Wilson <wilsons@start.ca>
> ---
>  fs/proc/base.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 9d096e8..e52702d 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -848,6 +848,10 @@ static ssize_t mem_write(struct file * file, const char __user *buf,
>  	if (check_mem_permission(task))
>  		goto out;
>  
> +	copied = -EIO;
> +	if (file->private_data != (void *)((long)current->self_exec_id))
> +		goto out;
> +

I agree.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



