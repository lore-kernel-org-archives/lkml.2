Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab0DFPSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:18:11 -0400
Received: from waste.org ([173.11.57.241]:50069 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab0DFPSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:18:01 -0400
Subject: Re: [patch] proc: copy_to_user() returns unsigned
From: Matt Mackall <mpm@selenic.com>
To: Dan Carpenter <error27@gmail.com>,
       Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <20100406104539.GC21229@bicker>
References: <20100406104539.GC21229@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 10:17:56 -0500
Message-ID: <1270567076.3552.2016.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 13:45 +0300, Dan Carpenter wrote:
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

Acked-by: Matt Mackall <mpm@selenic.com>

Linus, please take this one too.

-- 
http://selenic.com : development and support for Mercurial and Linux


