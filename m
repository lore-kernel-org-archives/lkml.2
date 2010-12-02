Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab0LBIUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 03:20:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:58730 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab0LBIUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 03:20:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,287,1288594800"; 
   d="scan'208";a="632311550"
Subject: Re: [RFC] persistent store (version 2) (part 2 of 2)
From: Huang Ying <ying.huang@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
In-Reply-To: <4cf594eb167978312c@agluck-desktop.sc.intel.com>
References: <4cf594eb167978312c@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 16:20:46 +0800
Message-ID: <1291278046.12648.561.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Tony,

On Wed, 2010-12-01 at 08:20 +0800, Luck, Tony wrote:
> Here are the changes to ERST to use the persistent store.
> 
> -Tony
> 
> ---
> 
> diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
> index fca34cc..e91680c 100644
> --- a/drivers/acpi/apei/Kconfig
> +++ b/drivers/acpi/apei/Kconfig
> @@ -1,5 +1,6 @@
>  config ACPI_APEI
>  	bool "ACPI Platform Error Interface (APEI)"
> +	select PSTORE
>  	depends on X86
>  	help
>  	  APEI allows to report errors (for example from the chipset)
> diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
> index 1211c03..2a49015 100644
> --- a/drivers/acpi/apei/erst.c
> +++ b/drivers/acpi/apei/erst.c
> @@ -34,6 +34,7 @@
>  #include <linux/cper.h>
>  #include <linux/nmi.h>
>  #include <linux/hardirq.h>
> +#include <linux/pstore.h>
>  #include <acpi/apei.h>
>  
>  #include "apei-internal.h"
> @@ -781,6 +782,111 @@ static int erst_check_table(struct acpi_table_erst *erst_tab)
>  	return 0;
>  }
>  
> +#define CPER_CREATOR_MCE						\
> +	UUID_LE(0x75a574e3, 0x5052, 0x4b29, 0x8a, 0x8e, 0xbe, 0x2c,	\
> +		0x64, 0x90, 0xb8, 0x9d)

How about rename this to CPER_CREATOR_LINUX or CPER_CREATOR_PSTORE?

> +#define CPER_SECTION_TYPE_DMESG						\
> +	UUID_LE(0xc197e04e, 0xd545, 0x4a70, 0x9c, 0x17, 0xa5, 0x54,	\
> +		0x94, 0x19, 0xeb, 0x12)
> +#define CPER_SECTION_TYPE_MCE						\
> +	UUID_LE(0xfe08ffbe, 0x95e4, 0x4be7, 0xbc, 0x73, 0x40, 0x96,	\
> +		0x04, 0x4a, 0x38, 0xfc)
> +
> +struct cper_mce_record {
> +	struct cper_record_header hdr;
> +	struct cper_section_descriptor sec_hdr;
> +	char data[];
> +} __packed;

Renamed to cper_pstore_record?

[...]

Best Regards,
Huang Ying


