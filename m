Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab0DFLcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 07:32:46 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42785 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab0DFLcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 07:32:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dan Carpenter <error27@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, Matt Mackall <mpm@selenic.com>,
       David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] proc: copy_to_user() returns unsigned
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100406104539.GC21229@bicker>
References: <20100406104539.GC21229@bicker>
Message-Id: <20100406202339.7E6F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  6 Apr 2010 20:32:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> copy_to_user() returns the number of bytes left to be copied.
> 
> This was a typo from: d82ef020cf31504c816803b1def94eb5ff173363
> "proc: pagemap: Hold mmap_sem during page walk".
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 0962739..bfb2773 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -799,7 +799,7 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
>  		start_vaddr = end;
>  
>  		len = min(count, PM_ENTRY_BYTES * pm.pos);
> -		if (copy_to_user(buf, pm.buffer, len) < 0) {
> +		if (copy_to_user(buf, pm.buffer, len)) {
>  			ret = -EFAULT;
>  			goto out_free;
>  		}

  Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


However I don't think this patch is kernel-janitors material. it should
be just merged mainline soon.



