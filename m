Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab2JPE1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 00:27:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:15632 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631Ab2JPE1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 00:27:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="235520155"
Date: Tue, 16 Oct 2012 12:27:13 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: fix the wrong #ifdef for acpi_no_s4_hw_signature
Message-ID: <20121016042713.GA21841@localhost>
References: <1350360303-14883-1-git-send-email-yuanhan.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350360303-14883-1-git-send-email-yuanhan.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The title could be made more descriptive:

ACPI: move acpi_no_s4_hw_signature() declaration into #ifdef CONFIG_HIBERNATION

On Tue, Oct 16, 2012 at 12:05:03PM +0800, Yuanhan Liu wrote:
> acpi_no_s4_hw_signature is defined in #ifdef CONFIG_HIBERNATION block,
> but the current code put the declare in #ifdef CONFIG_PM_SLEEP block.
 
And it's better to always include the original build error/warning
messages when fixing build problems.

Otherwise looks good to me.

Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>

> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> ---
>  include/linux/acpi.h |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index 90be989..a468429 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -257,8 +257,11 @@ int acpi_check_region(resource_size_t start, resource_size_t n,
>  
>  int acpi_resources_are_enforced(void);
>  
> -#ifdef CONFIG_PM_SLEEP
> +#ifdef CONFIG_HIBERNATION
>  void __init acpi_no_s4_hw_signature(void);
> +#endif
> +
> +#ifdef CONFIG_PM_SLEEP
>  void __init acpi_old_suspend_ordering(void);
>  void __init acpi_nvs_nosave(void);
>  #endif /* CONFIG_PM_SLEEP */
> -- 
> 1.7.7.6
