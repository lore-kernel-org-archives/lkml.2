Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab1F1GoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 02:44:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54463 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab1F1Gnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 02:43:39 -0400
Date: Tue, 28 Jun 2011 16:43:28 +1000
From: NeilBrown <neilb@suse.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH resend 3/6] md: use proper little-endian bitops
Message-ID: <20110628164328.47c7f099@notabene.brown>
In-Reply-To: <1309067876-3537-4-git-send-email-akinobu.mita@gmail.com>
References: <1309067876-3537-1-git-send-email-akinobu.mita@gmail.com>
	<1309067876-3537-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jun 2011 14:57:53 +0900 Akinobu Mita <akinobu.mita@gmail.com>
wrote:

> Using __test_and_{set,clear}_bit_le() with ignoring its return value
> can be replaced with __{set,clear}_bit_le().
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: NeilBrown <neilb@suse.de>
> Cc: linux-raid@vger.kernel.org
> ---
>  drivers/md/bitmap.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 574b09a..870a7fc 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -932,7 +932,7 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
>  		if (bitmap->flags & BITMAP_HOSTENDIAN)
>  			set_bit(bit, kaddr);
>  		else
> -			__test_and_set_bit_le(bit, kaddr);
> +			__set_bit_le(bit, kaddr);
>  		kunmap_atomic(kaddr, KM_USER0);
>  		PRINTK("set file bit %lu page %lu\n", bit, page->index);
>  	}
> @@ -1304,7 +1304,7 @@ void bitmap_daemon_work(mddev_t *mddev)
>  						clear_bit(file_page_offset(bitmap, j),
>  							  paddr);
>  					else
> -						__test_and_clear_bit_le(file_page_offset(bitmap, j),
> +						__clear_bit_le(file_page_offset(bitmap, j),
>  							       paddr);
>  					kunmap_atomic(paddr, KM_USER0);
>  				} else


Thanks.  I've applied this one to my 'md' tree.

NeilBrown
