Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871Ab2C2SKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 14:10:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37954 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759283Ab2C2SKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 14:10:14 -0400
Message-ID: <1333044612.15602.4.camel@joe2Laptop>
Subject: Re: [PATCH] percpu: use KERN_CONT in pcpu_dump_alloc_info()
From: Joe Perches <joe@perches.com>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 29 Mar 2012 11:10:12 -0700
In-Reply-To: <20120329164842.GE28941@google.com>
References: <20120329164842.GE28941@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-29 at 09:48 -0700, Tejun Heo wrote:
> >From cb129820f1e6ccf309510f4eb28df45cb0742005 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Thu, 29 Mar 2012 09:45:58 -0700
> 
> pcpu_dump_alloc_info() was printing continued lines without KERN_CONT.
> Use it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Kay Sievers <kay.sievers@vrfy.org>
> ---
> Committed to percpu/for-3.4-fixes.
> 
> Thanks.
> 
>  mm/percpu.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index f47af91..f921fdf 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -1132,20 +1132,20 @@ static void pcpu_dump_alloc_info(const char *lvl,
>  		for (alloc_end += gi->nr_units / upa;
>  		     alloc < alloc_end; alloc++) {
>  			if (!(alloc % apl)) {
> -				printk("\n");
> +				printk(KERN_CONT "\n");
>  				printk("%spcpu-alloc: ", lvl);
>  			}
> -			printk("[%0*d] ", group_width, group);
> +			printk(KERN_CONT "[%0*d] ", group_width, group);
>  
>  			for (unit_end += upa; unit < unit_end; unit++)
>  				if (gi->cpu_map[unit] != NR_CPUS)
> -					printk("%0*d ", cpu_width,
> +					printk(KERN_CONT "%0*d ", cpu_width,
>  					       gi->cpu_map[unit]);
>  				else
> -					printk("%s ", empty_str);
> +					printk(KERN_CONT "%s ", empty_str);
>  		}
>  	}
> -	printk("\n");
> +	printk(KERN_CONT "\n");
>  }

Perhaps it's better to try to print lines
in fewer printks?  Maybe use a line buffer?

The first line could be newline terminated.
"if (alloc)" tests for the individual newlines could be added.
Why aren't the group widths on separate lines?
All of the cpu_widths are on the same line as the parent group
even if that exceeds apl.  Is that what's desired?


