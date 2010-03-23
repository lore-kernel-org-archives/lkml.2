Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab0CWGcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 02:32:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826Ab0CWGcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 02:32:10 -0400
Date: Mon, 22 Mar 2010 23:31:13 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Carpenter <error27@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       WANG Cong <xiyou.wangcong@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] kcore: fix test for end of list
Message-Id: <20100322233113.f17d0e0c.akpm@linux-foundation.org>
In-Reply-To: <20100322120509.GC21571@bicker>
References: <20100322120509.GC21571@bicker>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Mar 2010 15:05:09 +0300 Dan Carpenter <error27@gmail.com> wrote:

> "m" is never NULL here.  We need a different test for the end of list
> condition.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
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

hm, that code's been there for five years.  I wonder if it's actually necessary.
