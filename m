Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1ITMVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 08:21:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:65441 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab1ITMVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 08:21:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,410,1312182000"; 
   d="scan'208";a="50860528"
Message-ID: <4E788555.3040607@intel.com>
Date: Tue, 20 Sep 2011 15:21:41 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Namjae Jeon <linkinjeon@gmail.com>
CC: cjb@laptop.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc : export hw reset function info to user
References: <1316359225-2224-1-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1316359225-2224-1-git-send-email-linkinjeon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/09/11 18:20, Namjae Jeon wrote:
> user app should know whether hw reset function is enable to use it.
> so I try to add sysfs file of hw reset function like enhanced area.

This conflicts with my patches:

http://marc.info/?l=linux-mmc&m=131462534514277&w=2
http://marc.info/?l=linux-mmc&m=131462534614281&w=2
http://marc.info/?l=linux-mmc&m=131462534714284&w=2
http://marc.info/?l=linux-mmc&m=131462534814287&w=2
http://marc.info/?l=linux-mmc&m=131462535014290&w=2
http://marc.info/?l=linux-mmc&m=131462535214297&w=2

>
> Signed-off-by: Namjae Jeon<linkinjeon@gmail.com>
> ---
>   drivers/mmc/core/mmc.c   |    6 ++++++
>   include/linux/mmc/card.h |    1 +
>   include/linux/mmc/mmc.h  |    1 +
>   3 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index 10f5a19..06c3ffc 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -355,6 +355,10 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
>   	card->ext_csd.raw_trim_mult =
>   		ext_csd[EXT_CSD_TRIM_MULT];
>   	if (card->ext_csd.rev>= 4) {
> +		/* HW reset function feature support.
> +		/* user can know it is enable through sysfs interface.
> +		card->ext_csd.raw_hw_reset_function =
> +			ext_csd[EXT_CSD_RST_FUNCTION];
>   		/*
>   		 * Enhanced area feature support -- check whether the eMMC
>   		 * card has the Enhanced area enabled.  If so, export enhanced
> @@ -499,6 +503,7 @@ MMC_DEV_ATTR(serial, "0x%08x\n", card->cid.serial);
>   MMC_DEV_ATTR(enhanced_area_offset, "%llu\n",
>   		card->ext_csd.enhanced_area_offset);
>   MMC_DEV_ATTR(enhanced_area_size, "%u\n", card->ext_csd.enhanced_area_size);
> +MMC_DEV_ATTR(raw_hw_reset_function, "0x%02x\n", card->ext_csd.raw_hw_reset_function);
>
>   static struct attribute *mmc_std_attrs[] = {
>   	&dev_attr_cid.attr,
> @@ -514,6 +519,7 @@ static struct attribute *mmc_std_attrs[] = {
>   	&dev_attr_serial.attr,
>   	&dev_attr_enhanced_area_offset.attr,
>   	&dev_attr_enhanced_area_size.attr,
> +	&dev_attr_raw_hw_reset_function.attr,
>   	NULL,
>   };
>
> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> index b460fc2..237bceb 100644
> --- a/include/linux/mmc/card.h
> +++ b/include/linux/mmc/card.h
> @@ -65,6 +65,7 @@ struct mmc_ext_csd {
>   	unsigned int		enhanced_area_size;	/* Units: KB */
>   	unsigned int		boot_size;		/* in bytes */
>   	u8			raw_partition_support;	/* 160 */
> +	u8                      raw_hw_reset_function;  /* 162 */
>   	u8			raw_erased_mem_count;	/* 181 */
>   	u8			raw_ext_csd_structure;	/* 194 */
>   	u8			raw_card_type;		/* 196 */
> diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
> index 5a794cb..233c932 100644
> --- a/include/linux/mmc/mmc.h
> +++ b/include/linux/mmc/mmc.h
> @@ -272,6 +272,7 @@ struct _mmc_csd {
>
>   #define EXT_CSD_PARTITION_ATTRIBUTE	156	/* R/W */
>   #define EXT_CSD_PARTITION_SUPPORT	160	/* RO */
> +#define EXT_CSD_RST_FUNCTION           162     /* R/W */
>   #define EXT_CSD_WR_REL_PARAM		166	/* RO */
>   #define EXT_CSD_ERASE_GROUP_DEF		175	/* R/W */
>   #define EXT_CSD_PART_CONFIG		179	/* R/W */

