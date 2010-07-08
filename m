Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab0GHGmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 02:42:05 -0400
Received: from smtp.nokia.com ([192.100.105.134]:53835 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab0GHGmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 02:42:03 -0400
Subject: Re: [PATCH] Mtd: fixed coding style issues in afs.c ar7part.c
 cmdlinepart.c inftlcore.c This is a patch to the files afs.c ar7part.c
 cmdlinepart.c inftlcore.c that fixes up warnings found by the checkpatch.pl
 tool Signed-off-by: Neal Buckendahl <nealb001@gmail.com>
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Neal Buckendahl <nealb001@gmail.com>
Cc: dwmw2@infradead.org, rmk+kernel@arm.linux.org.uk, cascardo@holoscopio.com,
       mohanlaljangir@gmail.com, maximlevitsky@gmail.com, julia@diku.dk,
       jkosina@suse.cz, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Neal Buckendahl <nealb@tbcnet.com>
In-Reply-To: <1277020914-10984-1-git-send-email-nealb001@gmail.com>
References: <1277020914-10984-1-git-send-email-nealb001@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Thu, 08 Jul 2010 09:37:01 +0300
Message-ID: <1278571021.12733.47.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Jul 2010 06:41:01.0589 (UTC) FILETIME=[87EA1C50:01CB1E68]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-20 at 03:01 -0500, Neal Buckendahl wrote:
> From: Neal Buckendahl <nealb@tbcnet.com>
> 
> ---
>  drivers/mtd/afs.c         |    9 ++-
>  drivers/mtd/ar7part.c     |    2 +-
>  drivers/mtd/cmdlinepart.c |  167 ++++++++++++++++++++-------------------------
>  drivers/mtd/inftlcore.c   |   47 ++++++++-----
>  4 files changed, 109 insertions(+), 116 deletions(-)

Many fixes are debatable. Could you please split your patch on smaller
patches, at least per-file basis, but also better on per-change-type
basis.

Additionally, please, do not put so much crap into the subject line.

Thanks!

Some comments below.

> diff --git a/drivers/mtd/afs.c b/drivers/mtd/afs.c
> index cec7ab9..d127171 100644
> --- a/drivers/mtd/afs.c
> +++ b/drivers/mtd/afs.c
> @@ -162,8 +162,8 @@ afs_read_iis(struct mtd_info *mtd, struct image_info_struct *iis, u_int ptr)
>  }
>  
>  static int parse_afs_partitions(struct mtd_info *mtd,
> -                         struct mtd_partition **pparts,
> -                         unsigned long origin)
> +			struct mtd_partition **pparts,
> +			unsigned long origin)
>  {
>  	struct mtd_partition *parts;
>  	u_int mask, off, idx, sz;
> @@ -235,11 +235,12 @@ static int parse_afs_partitions(struct mtd_info *mtd,
>  		strcpy(str, iis.name);
>  
>  		parts[idx].name		= str;
> -		parts[idx].size		= (iis.length + mtd->erasesize - 1) & ~(mtd->erasesize - 1);
> +		parts[idx].size		= (iis.length + mtd->erasesize - 1)&
> +						~(mtd->erasesize - 1);

Use ALIGN()

>  		parts[idx].offset	= img_ptr;
>  		parts[idx].mask_flags	= 0;
>  
> -		printk("  mtd%d: at 0x%08x, %5lluKiB, %8u, %s\n",
> +		printk(KERN_INFO "  mtd%d: at 0x%08x, %5lluKiB, %8u, %s\n",
>  			idx, img_ptr, parts[idx].size / 1024,
>  			iis.imageNumber, str);
>  
> diff --git a/drivers/mtd/ar7part.c b/drivers/mtd/ar7part.c
> index 6697a1e..7ccfdca 100644
> --- a/drivers/mtd/ar7part.c
> +++ b/drivers/mtd/ar7part.c
> @@ -148,6 +148,6 @@ static int __init ar7_parser_init(void)
>  module_init(ar7_parser_init);
>  
>  MODULE_LICENSE("GPL");
> -MODULE_AUTHOR(	"Felix Fietkau <nbd@openwrt.org>, "
> +MODULE_AUTHOR("Felix Fietkau <nbd@openwrt.org>, "
>  		"Eugene Konev <ejka@openwrt.org>");
>  MODULE_DESCRIPTION("MTD partitioning for TI AR7");
> diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
> index 1479da6..ef5ea7e 100644
> --- a/drivers/mtd/cmdlinepart.c
> +++ b/drivers/mtd/cmdlinepart.c
> @@ -34,7 +34,8 @@
>  
>  /* debug macro */
>  #if 0
> -#define dbg(x) do { printk("DEBUG-CMDLINE-PART: "); printk x; } while(0)
> +#define dbg(x) do { printk(KERN_DEBUG "DEBUG-CMDLINE-PART: "); printk x;
> +		} while (0)
>  #else
>  #define dbg(x)
>  #endif

Can you just kill this whole dbg() stuff - I t is useless nowadays.

> @@ -56,7 +57,7 @@ static struct cmdline_mtd_partition *partitions;
>  
>  /* the command line passed to mtdpart_setupd() */
>  static char *cmdline;
> -static int cmdline_parsed = 0;
> +static int cmdline_parsed = 1;

1 ?
 
>  /*
>   * Parse one partition definition for an MTD. Since there can be many
> @@ -66,12 +67,12 @@ static int cmdline_parsed = 0;
>   * is allocated upon the last definition being found. At that point the
>   * syntax has been verified ok.
>   */
> -static struct mtd_partition * newpart(char *s,
> -                                      char **retptr,
> -                                      int *num_parts,
> -                                      int this_part,
> -                                      unsigned char **extra_mem_ptr,
> -                                      int extra_mem_size)
> +static struct mtd_partition *newpart(char *s,
> +					char **retptr,
> +					int *num_parts,
> +					int this_part,
> +					unsigned char **extra_mem_ptr,
> +					int extra_mem_size)

Merge some lines

>  {
>  	struct mtd_partition *parts;
>  	unsigned long size;
> @@ -83,17 +84,15 @@ static struct mtd_partition * newpart(char *s,
>  	unsigned int mask_flags;
>  
>  	/* fetch the partition size */
> -	if (*s == '-')
> -	{	/* assign all remaining space to this partition */
> +	if (*s == '-') {
> +		/* assign all remaining space to this partition */
>  		size = SIZE_REMAINING;
>  		s++;
> -	}
> -	else
> -	{
> +	} else {
>  		size = memparse(s, &s);
> -		if (size < PAGE_SIZE)
> -		{
> -			printk(KERN_ERR ERRP "partition size too small (%lx)\n", size);
> +		if (size < PAGE_SIZE) {
> +			printk(KERN_ERR ERRP "partition size too small (%lx)\n"
> +			, size);
>  			return NULL;
>  		}
>  	}
> @@ -101,61 +100,51 @@ static struct mtd_partition * newpart(char *s,
>  	/* fetch partition name and flags */
>  	mask_flags = 0; /* this is going to be a regular partition */
>  	delim = 0;
> -        /* check for offset */
> -        if (*s == '@')
> -	{
> -                s++;
> -                offset = memparse(s, &s);
> -        }
> -        /* now look for name */
> +	/* check for offset */
> +	if (*s == '@') {
> +		s++;
> +		offset = memparse(s, &s);
> +	}
> +	/* now look for name */
>  	if (*s == '(')
> -	{
>  		delim = ')';
> -	}
>  
> -	if (delim)
> -	{
> +	if (delim) {
>  		char *p;
> -
> -	    	name = ++s;
> +		name = ++s;
>  		p = strchr(name, delim);
> -		if (!p)
> -		{
> -			printk(KERN_ERR ERRP "no closing %c found in partition name\n", delim);
> +		if (!p) {
> +			printk(KERN_ERR ERRP
> +			"no closing %c found in partition name\n", delim);
>  			return NULL;
>  		}
>  		name_len = p - name;
>  		s = p + 1;
> -	}
> -	else
> -	{
> -	    	name = NULL;
> +	} else {
> +		name = NULL;
>  		name_len = 13; /* Partition_000 */
>  	}
>  
>  	/* record name length for memory allocation later */
>  	extra_mem_size += name_len + 1;
>  
> -        /* test for options */
> -        if (strncmp(s, "ro", 2) == 0)
> -	{
> +	/* test for options */
> +	if (strncmp(s, "ro", 2) == 0) {
>  		mask_flags |= MTD_WRITEABLE;
>  		s += 2;
> -        }
> +	}
>  
> -        /* if lk is found do NOT unlock the MTD partition*/
> -        if (strncmp(s, "lk", 2) == 0)
> -	{
> +	/* if lk is found do NOT unlock the MTD partition*/
> +	if (strncmp(s, "lk", 2) == 0) {
>  		mask_flags |= MTD_POWERUP_LOCK;
>  		s += 2;
> -        }
> +	}
>  
>  	/* test if more partitions are following */
> -	if (*s == ',')
> -	{
> -		if (size == SIZE_REMAINING)
> -		{
> -			printk(KERN_ERR ERRP "no partitions allowed after a fill-up partition\n");
> +	if (*s == ',') {
> +		if (size == SIZE_REMAINING) {
> +			printk(KERN_ERR ERRP
> +			"no partitions allowed after a fill-up partition\n");
>  			return NULL;
>  		}
>  		/* more partitions follow, parse them */
> @@ -163,34 +152,29 @@ static struct mtd_partition * newpart(char *s,
>  				&extra_mem, extra_mem_size);
>  		if (!parts)
>  			return NULL;
> -	}
> -	else
> -	{	/* this is the last partition: allocate space for all */
> +	} else {
> +		/* this is the last partition: allocate space for all */
>  		int alloc_size;
>  
>  		*num_parts = this_part + 1;
>  		alloc_size = *num_parts * sizeof(struct mtd_partition) +
>  			     extra_mem_size;
>  		parts = kzalloc(alloc_size, GFP_KERNEL);
> -		if (!parts)
> -		{
> +		if (!parts) {
>  			printk(KERN_ERR ERRP "out of memory\n");
>  			return NULL;
>  		}
>  		extra_mem = (unsigned char *)(parts + *num_parts);
>  	}

All the { } stuff should be in a separate patch.

The patch is too large, no one is going to merge it because it is
difficult to get confident it is doing a good thing. Split it.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

