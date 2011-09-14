Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356Ab1INVNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 17:13:08 -0400
Received: from fieldses.org ([174.143.236.118]:35060 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933201Ab1INVNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 17:13:07 -0400
Date: Wed, 14 Sep 2011 17:13:05 -0400
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3]Fix typos in the kernel
Message-ID: <20110914211305.GA6750@fieldses.org>
References: <1316029968-11277-1-git-send-email-justinmattock@gmail.com>
 <1316029968-11277-2-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316029968-11277-2-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 12:52:46PM -0700, Justin P. Mattock wrote:
> @@ -24,7 +24,7 @@
>   *
>   * 1. Kernel uncompress code cannot overlap OMAP_UART_INFO as the
>   *    uncompress code could then partially overwrite itself
> - * 2. We assume printascii is called at least once before paging_init,
> + * 2. We assume print ascii is called at least once before paging_init,

??  There does appear to be a function named printascii....

> diff --git a/arch/powerpc/include/asm/keylargo.h b/arch/powerpc/include/asm/keylargo.h
> index d8520ef..01b1ae4 100644
> --- a/arch/powerpc/include/asm/keylargo.h
> +++ b/arch/powerpc/include/asm/keylargo.h
> @@ -51,7 +51,7 @@
>  
>  #define KL_GPIO_SOUND_POWER		(KEYLARGO_GPIO_0+0x05)
>  
> -/* Hrm... this one is only to be used on Pismo. It seeem to also
> +/* Hrm... this one is only to be used on Pismo. It seem's to also

"seem's"??

> diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
> index 4a442c3..0101eea 100644
> --- a/arch/sparc/kernel/smp_64.c
> +++ b/arch/sparc/kernel/smp_64.c
> @@ -840,9 +840,9 @@ static void tsb_sync(void *info)
>  	struct trap_per_cpu *tp = &trap_block[raw_smp_processor_id()];
>  	struct mm_struct *mm = info;
>  
> -	/* It is not valid to test "currrent->active_mm == mm" here.
> +	/* It is not valid to test "current->active_mm == mm" here.
>  	 *
> -	 * The value of "current" is not changed atomically with
> +	 * The value of "current" is not changed automatically with

Are you sure that's right?  I don't know the code but "atomically" looks
more likely....

Stopping here--you need to review these more carefully.

--b.

>  	 * switch_mm().  But that's OK, we just need to check the
>  	 * current cpu's trap block PGD physical address.
>  	 */
> diff --git a/drivers/acpi/acpica/hwxface.c b/drivers/acpi/acpica/hwxface.c
> index f75f81a..f34ba22 100644
> --- a/drivers/acpi/acpica/hwxface.c
> +++ b/drivers/acpi/acpica/hwxface.c
> @@ -355,7 +355,7 @@ ACPI_EXPORT_SYMBOL(acpi_read_bit_register)
>   *
>   * PARAMETERS:  register_id     - ID of ACPI Bit Register to access
>   *              Value           - Value to write to the register, in bit
> - *                                position zero. The bit is automaticallly
> + *                                position zero. The bit is automatically
>   *                                shifted to the correct position.
>   *
>   * RETURN:      Status
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index 0eef4da..d6217d2 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -309,7 +309,7 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
>  
>  	/*
>  	 * Some buses flag reads by setting the high bits in the
> -	 * register addresss; since it's always the high bits for all
> +	 * register address; since it's always the high bits for all
>  	 * current formats we can do this here rather than in
>  	 * formatting.  This may break if we get interesting formats.
>  	 */
> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> index 3f129b4..c092368 100644
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -582,7 +582,7 @@ static void frontend_changed(struct xenbus_device *dev,
>  	case XenbusStateConnected:
>  		/*
>  		 * Ensure we connect even when two watches fire in
> -		 * close successsion and we miss the intermediate value
> +		 * close succession and we miss the intermediate value
>  		 * of frontend_state.
>  		 */
>  		if (dev->state == XenbusStateConnected)
> diff --git a/drivers/char/ipmi/ipmi_bt_sm.c b/drivers/char/ipmi/ipmi_bt_sm.c
> index 3ed20e8..cdd4c09f 100644
> --- a/drivers/char/ipmi/ipmi_bt_sm.c
> +++ b/drivers/char/ipmi/ipmi_bt_sm.c
> @@ -560,7 +560,7 @@ static enum si_sm_result bt_event(struct si_sm_data *bt, long time)
>  		BT_CONTROL(BT_H_BUSY);		/* set */
>  
>  		/*
> -		 * Uncached, ordered writes should just proceeed serially but
> +		 * Uncached, ordered writes should just proceed serially but
>  		 * some BMCs don't clear B2H_ATN with one hit.  Fast-path a
>  		 * workaround without too much penalty to the general case.
>  		 */
> diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
> index 0de7d87..032a9c6 100644
> --- a/drivers/edac/ppc4xx_edac.c
> +++ b/drivers/edac/ppc4xx_edac.c
> @@ -142,7 +142,7 @@
>  
>  /*
>   * The ibm,sdram-4xx-ddr2 Device Control Registers (DCRs) are
> - * indirectly acccessed and have a base and length defined by the
> + * indirectly accessed and have a base and length defined by the
>   * device tree. The base can be anything; however, we expect the
>   * length to be precisely two registers, the first for the address
>   * window and the second for the data window.
> diff --git a/drivers/media/video/zoran/zoran_driver.c b/drivers/media/video/zoran/zoran_driver.c
> index d4d05d2..c624403 100644
> --- a/drivers/media/video/zoran/zoran_driver.c
> +++ b/drivers/media/video/zoran/zoran_driver.c
> @@ -1550,7 +1550,7 @@ static int zoran_enum_fmt(struct zoran *zr, struct v4l2_fmtdesc *fmt, int flag)
>  		if (zoran_formats[i].flags & flag && num++ == fmt->index) {
>  			strncpy(fmt->description, zoran_formats[i].name,
>  				sizeof(fmt->description) - 1);
> -			/* fmt struct pre-zeroed, so adding '\0' not neeed */
> +			/* fmt struct pre-zeroed, so adding '\0' not need */
>  			fmt->pixelformat = zoran_formats[i].fourcc;
>  			if (zoran_formats[i].flags & ZORAN_FORMAT_COMPRESSED)
>  				fmt->flags |= V4L2_FMT_FLAG_COMPRESSED;
> -- 
> 1.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
