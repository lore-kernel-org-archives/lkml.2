Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab2EJQlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:41:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57467 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2EJQk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:40:59 -0400
Message-ID: <4FABEF90.4040602@gmail.com>
Date: Fri, 11 May 2012 00:40:48 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: lenb@kernel.org, linux-acpi@vger.kernel.org, bhelgaas@google.com,
        shuahkhan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] ACPI: Add CONFIG_HOTPLUG_OST option
References: <1336507944-10219-1-git-send-email-toshi.kani@hp.com> <1336507944-10219-2-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1336507944-10219-2-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 04:12 AM, Toshi Kani wrote:
> Added CONFIG_ACPI_HOTPLUG_OPT option. When this config option is disabled,
> this patchset has no effect on the platform. This option is disabled by
> default. The dependency list assures consistent behavior among CPU, memory
> and container hotplug operations with regarding the _OST support.
Seems also need to enhance the acpiphp driver for PCI hotplug operations too.
acpiphp driver is also based on the ACPI device hotplug model.

> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
>  drivers/acpi/Kconfig |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 47768ff..1e3a756 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -351,6 +351,20 @@ config ACPI_HOTPLUG_MEMORY
>  	  To compile this driver as a module, choose M here:
>  	  the module will be called acpi_memhotplug.
>  
> +config ACPI_HOTPLUG_OST
> +	bool "Hotplug Status Indication Support"
> +	depends on ACPI_HOTPLUG_CPU
> +	depends on ACPI_HOTPLUG_MEMORY
> +	depends on ACPI_CONTAINER
> +	default n
> +	help
> +	  This option enables the use of the ACPI OSPM Status Indication
> +          (_OST), if available, for the platform to determine the status
> +	  of various hotplug operations. Some platforms may require this
> +	  option be enabled to track the status of hotplug operations.
> +	  This option has no effect when the platform does not support
> +	  _OST.
> +
>  config ACPI_SBS
>  	tristate "Smart Battery System"
>  	depends on X86

