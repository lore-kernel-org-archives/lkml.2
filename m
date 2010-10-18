Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab0JRKrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 06:47:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:57870 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab0JRKrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 06:47:41 -0400
Date: Mon, 18 Oct 2010 12:46:43 +0200
From: Jan Kara <jack@suse.cz>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 16/22] udf: use little endian bitops
Message-ID: <20101018104643.GG3826@quack.suse.cz>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
 <1287135981-17604-17-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287135981-17604-17-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 15-10-10 18:46:15, Akinobu Mita wrote:
> As a preparation for removing ext2 non-atomic bit operations from
> asm/bitops.h. This converts ext2 non-atomic bit operations to
> little endian bit operations.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
  Acked-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/udf/balloc.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
> index b608efa..e55aff9 100644
> --- a/fs/udf/balloc.c
> +++ b/fs/udf/balloc.c
> @@ -27,11 +27,14 @@
>  #include "udf_i.h"
>  #include "udf_sb.h"
>  
> -#define udf_clear_bit(nr, addr) ext2_clear_bit(nr, addr)
> -#define udf_set_bit(nr, addr) ext2_set_bit(nr, addr)
> -#define udf_test_bit(nr, addr) ext2_test_bit(nr, addr)
> +#define udf_clear_bit(nr, addr)	\
> +	__test_and_clear_le_bit(nr, (unsigned long *)(addr))
> +#define udf_set_bit(nr, addr)	\
> +	__test_and_set_le_bit(nr, (unsigned long *)(addr))
> +#define udf_test_bit(nr, addr)	\
> +	test_le_bit(nr, (unsigned long *)(addr))
>  #define udf_find_next_one_bit(addr, size, offset) \
> -		ext2_find_next_bit(addr, size, offset)
> +	find_next_le_bit((unsigned long *)(addr), size, offset)
>  
>  static int read_block_bitmap(struct super_block *sb,
>  			     struct udf_bitmap *bitmap, unsigned int block,
> -- 
> 1.7.1.231.gd0b16
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
