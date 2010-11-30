Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab0K3VF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:05:56 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:31150 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255Ab0K3VFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:05:54 -0500
Date: Tue, 30 Nov 2010 12:33:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Miao Xie <miaox@cn.fujitsu.com>, Chris Mason <chris.mason@oracle.com>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] btrfs: Correct printing of sector_t
Message-Id: <20101130123309.d84cc69c.randy.dunlap@oracle.com>
In-Reply-To: <alpine.DEB.2.00.1011302128450.6502@ayla.of.borg>
References: <alpine.DEB.2.00.1011302128450.6502@ayla.of.borg>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 21:30:01 +0100 (CET) Geert Uytterhoeven wrote:

> If CONFIG_LBDAF=y, `sector_t' becomes `u64' instead of `unsigned long':
> 
> fs/btrfs/inode.c: In function ‘btrfs_end_dio_bio’:
> fs/btrfs/inode.c:5717: warning: format ‘%lu’ expects type ‘long unsigned int’, but argument 4 has type ‘sector_t’
> 
> Hence always cast it to `unsigned long long' for printing.
> 
> Introduced by commit e65e1535542931e51189832264cd282e5899e4b9 ("btrfs: fix
> panic caused by direct IO")
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> ---
>  fs/btrfs/inode.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 8039390..fbffe5f 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5712,9 +5712,9 @@ static void btrfs_end_dio_bio(struct bio *bio, int err)
>  
>  	if (err) {
>  		printk(KERN_ERR "btrfs direct IO failed ino %lu rw %lu "
> -		      "disk_bytenr %lu len %u err no %d\n",
> -		      dip->inode->i_ino, bio->bi_rw, bio->bi_sector,
> -		      bio->bi_size, err);
> +		      "disk_bytenr %llu len %u err no %d\n",
> +		      dip->inode->i_ino, bio->bi_rw,
> +		      (unsigned long long)bio->bi_sector, bio->bi_size, err);
>  		dip->errors = 1;
>  
>  		/*
> -- 
> 1.7.0.4
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
