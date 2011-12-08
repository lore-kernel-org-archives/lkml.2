Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab1LHIYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 03:24:53 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:27762 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab1LHIYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 03:24:51 -0500
X-IronPort-AV: E=Sophos;i="4.71,319,1320624000"; 
   d="scan'208";a="9355721"
Subject: Re: [Xen-devel] [PATCH 3/4] xen: Add xenbusd device driver
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Bastian Blank <waldi@debian.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Date: Thu, 8 Dec 2011 08:24:46 +0000
In-Reply-To: <1323292396-19523-4-git-send-email-waldi@debian.org>
References: <1323292396-19523-1-git-send-email-waldi@debian.org>
	 <1323292396-19523-4-git-send-email-waldi@debian.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1323332686.2969.49.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 21:13 +0000, Bastian Blank wrote:
> Access for xenstored to the event channel and pre-allocated ring is
> managed via xenfs.  This adds its own device driver featuring mmap for
> the ring and an ioctl for the event channel.
> 
> Signed-off-by: Bastian Blank <waldi@debian.org>
> ---
>  drivers/xen/xenbus/Makefile             |    1 +
>  drivers/xen/xenbus/xenbus_dev_backend.c |   79 +++++++++++++++++++++++++++++++
>  include/xen/xenbus_dev.h                |   41 ++++++++++++++++
>  3 files changed, 121 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/xen/xenbus/xenbus_dev_backend.c
>  create mode 100644 include/xen/xenbus_dev.h
> 
> diff --git a/drivers/xen/xenbus/Makefile b/drivers/xen/xenbus/Makefile
> index a2ea363..31e2e90 100644
> --- a/drivers/xen/xenbus/Makefile
> +++ b/drivers/xen/xenbus/Makefile
> @@ -10,4 +10,5 @@ xenbus-objs += xenbus_probe.o
>  xenbus-be-objs-$(CONFIG_XEN_BACKEND) += xenbus_probe_backend.o
>  xenbus-objs += $(xenbus-be-objs-y)
>  
> +obj-$(CONFIG_XEN_BACKEND) += xenbus_dev_backend.o

In principal this could be its own module which does not depend on any
of the backend stuff but I think this is fine for now.

> [...]

> +static int __init xenbusd_init(void)
> +{
> +	int err;
> +
> +	if (!xen_initial_domain())
> +		return -ENODEV;
> +
> +	err = misc_register(&xenbusd_dev);
> +	if (err)
> +		printk(KERN_ERR "Could not register xenbus device\n");

"Could not register xenbus backend device" to distinguish from the f.e.
failure message, you could also add "frontend" there I suppose. Other
than that:

Acked-by: Ian Campbell <ian.campbell@citrix.com>


