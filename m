Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab0HDEo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:44:29 -0400
Received: from imr3.ericy.com ([198.24.6.13]:39212 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab0HDEo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:44:27 -0400
Date: Tue, 3 Aug 2010 21:44:09 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Greg KH <greg@kroah.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Narendra K <Narendra_K@dell.com>,
        Jordan Hargrave <jordan_hargrave@dell.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20100804044409.GA15216@ericsson.com>
References: <20100804142531.aea95c0b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100804142531.aea95c0b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 12:25:31AM -0400, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the driver-core tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/pci/pci-label.c:100: error: unknown field 'owner' specified in initializer
> drivers/pci/pci-label.c:100: warning: initialization from incompatible pointer type
> drivers/pci/pci-label.c:105: error: unknown field 'owner' specified in initializer
> drivers/pci/pci-label.c:105: warning: initialization from incompatible pointer type
> 
> Caused by commit 60cc62ad579afa0eb5bded82e08dd0617d461d52 ("sysfs: Remove
> owner field from sysfs struct attribute") interacting with commit
> 911e1c9b05a8e3559a7aa89083930700a0b9e7ee ("PCI: export SMBIOS provided
> firmware instance and label to sysfs") from the pci tree.
> 
> I applied the following merge fix patch (Jesse, this patch can already be
> applied to the pci tree without problems):
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 4 Aug 2010 14:21:42 +1000
> Subject: [PATCH] pci: update for owner removal from struct device_attribute
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>

Sorry for the trouble. Looks like I missed that by a day.

Guenter

> ---
>  drivers/pci/pci-label.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
> index 111500e..90c0a72 100644
> --- a/drivers/pci/pci-label.c
> +++ b/drivers/pci/pci-label.c
> @@ -97,12 +97,12 @@ smbiosinstance_show(struct device *dev,
>  }
>  
>  static struct device_attribute smbios_attr_label = {
> -	.attr = {.name = "label", .mode = 0444, .owner = THIS_MODULE},
> +	.attr = {.name = "label", .mode = 0444},
>  	.show = smbioslabel_show,
>  };
>  
>  static struct device_attribute smbios_attr_instance = {
> -	.attr = {.name = "index", .mode = 0444, .owner = THIS_MODULE},
> +	.attr = {.name = "index", .mode = 0444},
>  	.show = smbiosinstance_show,
>  };
>  
> -- 
> 1.7.1
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
