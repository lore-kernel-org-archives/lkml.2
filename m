Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab2BCBWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 20:22:41 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:54322 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757608Ab2BCBWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 20:22:39 -0500
Message-ID: <4F2B4471.8020203@xenotime.net>
Date: Thu, 02 Feb 2012 18:20:33 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>, linux-next@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] jffs2: update to new MTD interface (missed a few)
References: <1328228469-10539-1-git-send-email-computersforpeace@gmail.com>
In-Reply-To: <1328228469-10539-1-git-send-email-computersforpeace@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 04:21 PM, Brian Norris wrote:
> There were a few instances of the old MTD interface remaining for JFFS2. We
> fix one error that shows up (only when CONFIG_JFFS2_FS_WRITEBUFFER is not
> defined) like this:
> 
>   fs/jffs2/read.c: In function 'jffs2_read_dnode':
>   fs/jffs2/read.c:36:8: error: 'struct mtd_info' has no member named 'read'
>   fs/jffs2/read.c:112:8: error: 'struct mtd_info' has no member named 'read'
>   ...
> 
> We also simply remove two macros that are not in use, were not updated to
> the new MTD interface, and don't even utilize the old interface properly.
> (That means they weren't used since commit 8593fbc6, year 2006; almost 6
> years ago, for those who don't want to do the math)
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
> This fixes some linux-next build errors seen by Randy Dunlap
> 
>  fs/jffs2/os-linux.h |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/jffs2/os-linux.h b/fs/jffs2/os-linux.h
> index ab65ee3..1cd3aec 100644
> --- a/fs/jffs2/os-linux.h
> +++ b/fs/jffs2/os-linux.h
> @@ -76,7 +76,7 @@ static inline void jffs2_init_inode_info(struct jffs2_inode_info *f)
>  #define jffs2_write_nand_cleanmarker(c,jeb) (-EIO)
>  
>  #define jffs2_flash_write(c, ofs, len, retlen, buf) jffs2_flash_direct_write(c, ofs, len, retlen, buf)
> -#define jffs2_flash_read(c, ofs, len, retlen, buf) ((c)->mtd->read((c)->mtd, ofs, len, retlen, buf))
> +#define jffs2_flash_read(c, ofs, len, retlen, buf) (mtd_read((c)->mtd, ofs, len, retlen, buf))
>  #define jffs2_flush_wbuf_pad(c) ({ do{} while(0); (void)(c), 0; })
>  #define jffs2_flush_wbuf_gc(c, i) ({ do{} while(0); (void)(c), (void) i, 0; })
>  #define jffs2_write_nand_badblock(c,jeb,bad_offset) (1)
> @@ -108,8 +108,6 @@ static inline void jffs2_init_inode_info(struct jffs2_inode_info *f)
>  
>  #define jffs2_cleanmarker_oob(c) (c->mtd->type == MTD_NANDFLASH)
>  
> -#define jffs2_flash_write_oob(c, ofs, len, retlen, buf) ((c)->mtd->write_oob((c)->mtd, ofs, len, retlen, buf))
> -#define jffs2_flash_read_oob(c, ofs, len, retlen, buf) ((c)->mtd->read_oob((c)->mtd, ofs, len, retlen, buf))
>  #define jffs2_wbuf_dirty(c) (!!(c)->wbuf_len)
>  
>  /* wbuf.c */


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
