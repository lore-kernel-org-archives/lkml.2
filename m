Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab0ECWAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 18:00:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38673 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756882Ab0ECWA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 18:00:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -next] power: fix block_io.c printk warning
Date: Tue, 4 May 2010 00:00:56 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org
References: <20100503151619.f75e3a80.sfr@canb.auug.org.au> <20100503100611.2ca63b58.randy.dunlap@oracle.com>
In-Reply-To: <20100503100611.2ca63b58.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005040000.56650.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 May 2010, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format warning in block_io.c:
> 
> kernel/power/block_io.c:41: warning: format '%ld' expects type 'long int', but argument 2 has type 'sector_t'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>

Applied to suspend-2.6/linux-next.

Thanks,
Rafael


> ---
>  kernel/power/block_io.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-next-20100503.orig/kernel/power/block_io.c
> +++ linux-next-20100503/kernel/power/block_io.c
> @@ -37,8 +37,8 @@ static int submit(int rw, struct block_d
>  	bio->bi_end_io = end_swap_bio_read;
>  
>  	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
> -		printk(KERN_ERR "PM: Adding page to bio failed at %ld\n",
> -			sector);
> +		printk(KERN_ERR "PM: Adding page to bio failed at %llu\n",
> +			(unsigned long long)sector);
>  		bio_put(bio);
>  		return -EFAULT;
>  	}
> 
> 

