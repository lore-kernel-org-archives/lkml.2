Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735Ab2HWN1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 09:27:04 -0400
Received: from mail.x86-64.org ([217.9.48.20]:44815 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933605Ab2HWN06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 09:26:58 -0400
Date: Thu, 23 Aug 2012 15:26:46 +0200
From: Borislav Petkov <bp@amd64.org>
To: Lin Ming <minggr@gmail.com>, Len Brown <lenb@kernel.org>
Cc: Aaron Lu <aaron.lu@amd.com>, linux-kernel@vger.kernel.org,
        Aaron Lu <aaron.lwe@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] ACPI: power: Use KERN_DEBUG when no power resources are
 found
Message-ID: <20120823132646.GD18279@aftab.osrc.amd.com>
References: <1344564353-493-1-git-send-email-aaron.lu@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344564353-493-1-git-send-email-aaron.lu@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 10:05:53AM +0800, Aaron Lu wrote:
> commit a606dac368eed5696fb38e16b1394f1d049c09e9 adds support to link
> devices which have _PRx, if a device does not have _PRx, a warning
> message will be printed.
> 
> This commit is for ZPODD on Intel's platform, on AMD's platform, there
> is no _PRx to support ZPODD, we use _PSx.
> 
> So instead of printing a useless warning message on AMD's platform,
> changing the print level to DEBUG to suppress this message.
> 
> Reported-by: Borislav Petkov <borislav.petkov@amd.com>
> Cc: <stable@vger.kernel.org> 3.5+
> Signed-off-by: Aaron Lu <aaron.lu@amd.com>

Ping?

Can we get this applied pls - I still see it on -rc3.

Thanks.

> ---
>  drivers/acpi/power.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> index 215ecd0..e5e01d9 100644
> --- a/drivers/acpi/power.c
> +++ b/drivers/acpi/power.c
> @@ -460,7 +460,7 @@ int acpi_power_resource_register_device(struct device *dev, acpi_handle handle)
>  	return ret;
>  
>  no_power_resource:
> -	printk(KERN_WARNING PREFIX "Invalid Power Resource to register!");
> +	printk(KERN_DEBUG PREFIX "Invalid Power Resource to register!");
>  	return -ENODEV;
>  }
>  EXPORT_SYMBOL_GPL(acpi_power_resource_register_device);
> -- 
> 1.7.11.3
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
