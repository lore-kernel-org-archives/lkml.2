Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1LHKhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 05:37:32 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:54472 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab1LHKhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 05:37:31 -0500
Message-ID: <0b79f774eeb89b67073e93fcc5db8c55.squirrel@webmail.sf-mail.de>
In-Reply-To: <1323274574-22863-1-git-send-email-kys@microsoft.com>
References: <1323274574-22863-1-git-send-email-kys@microsoft.com>
Date: Thu, 8 Dec 2011 11:37:28 +0100
Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of
 the staging area
From: "Rolf Eike Beer" <eike-kernel@sf-tec.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        james.bottomley@hansenpartnership.com, hch@infradead.org,
        linux-scsi@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The storage driver (storvsc_drv.c) handles all block storage devices
> assigned to Linux guests hosted on Hyper-V. This driver has been in the
> staging tree for a while and this patch moves it out of the staging area.
> As per Greg's recommendation, this patch makes no changes to the
> staging/hv
> directory. Once the driver moves out of staging, we will cleanup the
> staging/hv directory.
>
> This patch includes all the patches that I have sent against the
> staging/hv
> tree to address the comments I have gotten to date on this storage driver.
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/scsi/Kconfig       |    7 +
>  drivers/scsi/Makefile      |    3 +
>  drivers/scsi/storvsc_drv.c | 1586
> ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1596 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/scsi/storvsc_drv.c
>
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 06ea3bc..4910269 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -662,6 +662,13 @@ config VMWARE_PVSCSI
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called vmw_pvscsi.
>
> +config HYPERV_STORAGE
> +	tristate "Microsoft Hyper-V virtual storage driver"
> +	depends on SCSI && HYPERV
> +	default HYPERV
> +	help
> +	  Select this option to enable the Hyper-V virtual storage driver.
> +
>  config LIBFC
>  	tristate "LibFC module"
>  	select SCSI_FC_ATTRS

Maybe that help text could be slightly more verbose? Like "This is only
necessary if you plan to run this kernel as a guest on Microsoft Hyper-V"?
And I would welcome the usual "the module will be called" text for this
driver, too. See the first 2 lines of context of think hunk for a
copy&paste source of this text.

Eike
