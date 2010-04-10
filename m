Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab0DJUr1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 16:47:27 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:56960 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751766Ab0DJUr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 16:47:26 -0400
Date: Sat, 10 Apr 2010 22:47:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Chihau Chau <chihau@gmail.com>
Cc: gregkh@suse.de, jochen.maes@sejo.be, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: dream: pmem: fix some code style issues
Message-ID: <20100410204714.GA812@elf.ucw.cz>
References: <1270926878-11272-1-git-send-email-chihau@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270926878-11272-1-git-send-email-chihau@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2010-04-10 15:14:38, Chihau Chau wrote:
> From: Chihau Chau <chihau@gmail.com>
> 
> This fixes some code style issues like prohibited spaces after that open
> parenthesis '(' and before that close parenthesis ')', and lines over 80
> characters.
> 
> Signed-off-by: Chihau Chau <chihau@gmail.com>

ACK.

> ---
>  drivers/staging/dream/pmem.c |   22 +++++++++++-----------
>  1 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/dream/pmem.c b/drivers/staging/dream/pmem.c
> index 503ba21..3e4dd21 100644
> --- a/drivers/staging/dream/pmem.c
> +++ b/drivers/staging/dream/pmem.c
> @@ -37,17 +37,17 @@
>   * the file should not be released until put_pmem_file is called */
>  #define PMEM_FLAGS_BUSY 0x1
>  /* indicates that this is a suballocation of a larger master range */
> -#define PMEM_FLAGS_CONNECTED ( 0x1 << 1 )
> +#define PMEM_FLAGS_CONNECTED (0x1 << 1)
>  /* indicates this is a master and not a sub allocation and that it is mmaped */
> -#define PMEM_FLAGS_MASTERMAP ( 0x1 << 2 )
> +#define PMEM_FLAGS_MASTERMAP (0x1 << 2)
>  /* submap and unsubmap flags indicate:
>   * 00: subregion has never been mmaped
>   * 10: subregion has been mmaped, reference to the mm was taken
>   * 11: subretion has ben released, refernece to the mm still held
>   * 01: subretion has been released, reference to the mm has been released
>   */
> -#define PMEM_FLAGS_SUBMAP ( 0x1 << 3 )
> -#define PMEM_FLAGS_UNSUBMAP ( 0x1 << 4 )
> +#define PMEM_FLAGS_SUBMAP (0x1 << 3)
> +#define PMEM_FLAGS_UNSUBMAP (0x1 << 4)
>  
>  
>  struct pmem_data {
> @@ -152,7 +152,7 @@ struct pmem_info {
>  static struct pmem_info pmem[PMEM_MAX_DEVICES];
>  static int id_count;
>  
> -#define PMEM_IS_FREE(id, index) ( !(pmem[id].bitmap[index].allocated) )
> +#define PMEM_IS_FREE(id, index) (!(pmem[id].bitmap[index].allocated))
>  #define PMEM_ORDER(id, index) pmem[id].bitmap[index].order
>  #define PMEM_BUDDY_INDEX(id, index) (index ^ (1 << PMEM_ORDER(id, index)))
>  #define PMEM_NEXT_INDEX(id, index) (index + (1 << PMEM_ORDER(id, index)))
> @@ -844,8 +844,8 @@ static int pmem_connect(unsigned long connect, struct file *file)
>  	src_data = (struct pmem_data *)src_file->private_data;
>  
>  	if (has_allocation(file) && (data->index != src_data->index)) {
> -		printk(KERN_INFO "pmem: file is already mapped but doesn't match this"
> -		       " src_file!\n");
> +		printk(KERN_INFO "pmem: file is already mapped but doesn't "
> +			"match this src_file!\n");
>  		ret = -EINVAL;
>  		goto err_bad_file;
>  	}
> @@ -934,8 +934,8 @@ int pmem_remap(struct pmem_region *region, struct file *file,
>  	if (unlikely(!PMEM_IS_PAGE_ALIGNED(region->offset) ||
>  		 !PMEM_IS_PAGE_ALIGNED(region->len))) {
>  #if PMEM_DEBUG
> -		printk(KERN_DEBUG "pmem: request for unaligned pmem suballocation "
> -		       "%lx %lx\n", region->offset, region->len);
> +		printk(KERN_DEBUG "pmem: request for unaligned pmem "
> +			"suballocation %lx %lx\n", region->offset, region->len);
>  #endif
>  		return -EINVAL;
>  	}
> @@ -1085,8 +1085,8 @@ static long pmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  				region.offset = pmem_start_addr(id, data);
>  				region.len = pmem_len(id, data);
>  			}
> -			printk(KERN_INFO "pmem: request for physical address of pmem region "
> -					"from process %d.\n", current->pid);
> +			printk(KERN_INFO "pmem: request for physical address "
> +			     "of pmem region from process %d.\n", current->pid);
>  			if (copy_to_user((void __user *)arg, &region,
>  						sizeof(struct pmem_region)))
>  				return -EFAULT;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
