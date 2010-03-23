Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab0CWAWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:22:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34741 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab0CWAWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:22:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 23 Mar 2010 09:18:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       WANG Cong <xiyou.wangcong@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] kcore: fix test for end of list
Message-Id: <20100323091841.dd500a38.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100322120509.GC21571@bicker>
References: <20100322120509.GC21571@bicker>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Mar 2010 15:05:09 +0300
Dan Carpenter <error27@gmail.com> wrote:

> "m" is never NULL here.  We need a different test for the end of list
> condition.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

yes, thank you.
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> ---
> Found with a static checker and compile tested only.  Please review
> carefully.
> 
> diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
> index a44a789..b442dac 100644
> --- a/fs/proc/kcore.c
> +++ b/fs/proc/kcore.c
> @@ -490,7 +490,7 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
>  		}
>  		read_unlock(&kclist_lock);
>  
> -		if (m == NULL) {
> +		if (&m->list == &kclist_head) {
>  			if (clear_user(buffer, tsz))
>  				return -EFAULT;
>  		} else if (is_vmalloc_or_module_addr((void *)start)) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

