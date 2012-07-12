Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab2GLPwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 11:52:09 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:54574 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755142Ab2GLPwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 11:52:06 -0400
Message-ID: <4FFEF278.8010700@xenotime.net>
Date: Thu, 12 Jul 2012 08:51:20 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Daniel Drake <dsd@laptop.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] olpc-xo15-sci: Use struct dev_pm_ops for power management
References: <201207121229.24872.rjw@sisk.pl>
In-Reply-To: <201207121229.24872.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 03:29 AM, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make the OLPC XO15 SCI driver define its resume callback through
> a struct dev_pm_ops object rather than by using a legacy PM hook
> in struct acpi_device_ops.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>


Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.


> ---
> 
> This patch was missing from my patchset converting ACPI do the PM handling
> based on struct dev_pm_ops.
> 
> If there are no objections, I'll add it to the pm-acpi branch of the
> linux-pm.git tree so that it goes in along with the other changes in that
> area.
> 
> Thanks,
> Rafael
> 
> ---
>  arch/x86/platform/olpc/olpc-xo15-sci.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Index: linux/arch/x86/platform/olpc/olpc-xo15-sci.c
> ===================================================================
> --- linux.orig/arch/x86/platform/olpc/olpc-xo15-sci.c
> +++ linux/arch/x86/platform/olpc/olpc-xo15-sci.c
> @@ -203,7 +203,7 @@ static int xo15_sci_remove(struct acpi_d
>  	return 0;
>  }
>  
> -static int xo15_sci_resume(struct acpi_device *device)
> +static int xo15_sci_resume(struct device *dev)
>  {
>  	/* Enable all EC events */
>  	olpc_ec_mask_write(EC_SCI_SRC_ALL);
> @@ -215,6 +215,8 @@ static int xo15_sci_resume(struct acpi_d
>  	return 0;
>  }
>  
> +static SIMPLE_DEV_PM_OPS(xo15_sci_pm, NULL, xo15_sci_resume);
> +
>  static const struct acpi_device_id xo15_sci_device_ids[] = {
>  	{"XO15EC", 0},
>  	{"", 0},
> @@ -227,8 +229,8 @@ static struct acpi_driver xo15_sci_drv =
>  	.ops = {
>  		.add = xo15_sci_add,
>  		.remove = xo15_sci_remove,
> -		.resume = xo15_sci_resume,
>  	},
> +	.drv.pm = &xo15_sci_pm,
>  };
>  
>  static int __init xo15_sci_init(void)



-- 
~Randy
