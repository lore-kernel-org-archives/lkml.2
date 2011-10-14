Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab1JNTf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:35:56 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36172 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab1JNTfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:35:55 -0400
Subject: Re: [PATCH] staging: hv: move hv_netvsc out of staging area
From: Sasha Levin <levinsasha928@gmail.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        Mike Sterling <Mike.Sterling@microsoft.com>,
        NetDev <netdev@vger.kernel.org>
In-Reply-To: <1318620026-8349-1-git-send-email-haiyangz@microsoft.com>
References: <1318620026-8349-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 14 Oct 2011 21:35:50 +0200
Message-ID: <1318620950.31522.9.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 12:20 -0700, Haiyang Zhang wrote:
> hv_netvsc has been reviewed on netdev mailing list on 6/09/2011.
> All recommended changes have been made. We are requesting to move
> it out of staging area.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: KY Srinivasan <kys@microsoft.com>
> Signed-off-by: Mike Sterling <Mike.Sterling@microsoft.com>
> Cc: NetDev <netdev@vger.kernel.org>
> 
> ---
>  drivers/net/Kconfig                               |    2 ++
>  drivers/net/Makefile                              |    2 ++
>  drivers/net/hyperv/Kconfig                        |    5 +++++
>  drivers/net/hyperv/Makefile                       |    3 +++
>  drivers/{staging/hv => net/hyperv}/hyperv_net.h   |    0
>  drivers/{staging/hv => net/hyperv}/netvsc.c       |    0
>  drivers/{staging/hv => net/hyperv}/netvsc_drv.c   |    0
>  drivers/{staging/hv => net/hyperv}/rndis_filter.c |    0
>  drivers/staging/hv/Kconfig                        |    6 ------
>  drivers/staging/hv/Makefile                       |    2 --
>  drivers/staging/hv/TODO                           |    1 -
>  11 files changed, 12 insertions(+), 9 deletions(-)
>  create mode 100644 drivers/net/hyperv/Kconfig
>  create mode 100644 drivers/net/hyperv/Makefile
>  rename drivers/{staging/hv => net/hyperv}/hyperv_net.h (100%)
>  rename drivers/{staging/hv => net/hyperv}/netvsc.c (100%)
>  rename drivers/{staging/hv => net/hyperv}/netvsc_drv.c (100%)
>  rename drivers/{staging/hv => net/hyperv}/rndis_filter.c (100%)
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 8d0314d..088c330 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -3451,4 +3451,6 @@ config VMXNET3
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called vmxnet3.
>  
> +source "drivers/net/hyperv/Kconfig"
> +
>  endif # NETDEVICES
> diff --git a/drivers/net/Makefile b/drivers/net/Makefile
> index e1eca2a..647c878 100644
> --- a/drivers/net/Makefile
> +++ b/drivers/net/Makefile
> @@ -306,3 +306,5 @@ obj-$(CONFIG_CAIF) += caif/
>  obj-$(CONFIG_OCTEON_MGMT_ETHERNET) += octeon/
>  obj-$(CONFIG_PCH_GBE) += pch_gbe/
>  obj-$(CONFIG_TILE_NET) += tile/
> +
> +obj-$(CONFIG_HYPERV_NET) += hyperv/
> diff --git a/drivers/net/hyperv/Kconfig b/drivers/net/hyperv/Kconfig
> new file mode 100644
> index 0000000..936968d
> --- /dev/null
> +++ b/drivers/net/hyperv/Kconfig
> @@ -0,0 +1,5 @@
> +config HYPERV_NET
> +	tristate "Microsoft Hyper-V virtual network driver"
> +	depends on HYPERV

It doesn't depend on NET anymore?

-- 

Sasha.

