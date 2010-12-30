Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab0L3APG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 19:15:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754123Ab0L3APE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 19:15:04 -0500
Date: Wed, 29 Dec 2010 16:14:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: "David S. Miller" <davem@davemloft.net>, Dan Carpenter <error27@gmail.com>,
        balbir@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] taskstats: Use better ifdef for alignment
Message-Id: <20101229161418.d34bf0d4.akpm@linux-foundation.org>
In-Reply-To: <4D1BCE58.4000902@suse.com>
References: <4D1BCE58.4000902@suse.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Dec 2010 19:12:08 -0500 Jeff Mahoney <jeffm@suse.com> wrote:

>  Commit 4be2c95d added a null field to align the taskstats structure but
>  the discussion centered around ia64. The issue exists on other platforms
>  with inefficient unaligned access and adding them piecemeal would be
>  an unmaintainable mess.
> 
>  This patch uses Dave Miller's suggestion of using a combination of
>  CONFIG_64BIT && !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS to determine
>  whether alignment is needed.
> 
>  Note that this will cause breakage on those platforms with applications
>  like iotop which had hard-coded offsets into the packet to access the
>  taskstats structure.

That seems a very good reason to not apply the patch.

Tell us more, please...

>  The message seen on systems without the alignment fixes looks like:
>  kernel unaligned access to 0xe000023879dca9bc, ip=0xa000000100133d10
> 
>  The addresses may vary but resolve to locations inside __delayacct_add_tsk.
> 
> Reported-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  kernel/taskstats.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/kernel/taskstats.c
> +++ b/kernel/taskstats.c
> @@ -349,7 +349,7 @@ static int parse(struct nlattr *na, stru
>  	return ret;
>  }
>  
> -#ifdef CONFIG_IA64
> +#if defined(CONFIG_64BIT) && !defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
>  #define TASKSTATS_NEEDS_PADDING 1
>  #endif
>  
