Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab0ENQ3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:29:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20905 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab0ENQ3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:29:18 -0400
Date: Fri, 14 May 2010 09:29:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Soren Hansen <soren@linux2go.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Make the Xen block device prefix configurable
Message-Id: <20100514092902.ba0f075a.randy.dunlap@oracle.com>
In-Reply-To: <f0020ee67542b6b535372d6a7b217d71a2c7293b.1273825543.git.soren@linux2go.dk>
References: <cover.1273825543.git.soren@linux2go.dk>
	<f0020ee67542b6b535372d6a7b217d71a2c7293b.1273825543.git.soren@linux2go.dk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090205.4BED7A5B.00A6:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010 18:10:48 +0200 Soren Hansen wrote:

> Add a config option to tweak the Xen block device prefix.
> 
> Signed-off-by: Soren Hansen <soren@linux2go.dk>
> Tested-By: Major Hayden <major.hayden@rackspace.com>
> ---
>  drivers/block/Kconfig        |   10 ++++++++++
>  drivers/block/xen-blkfront.c |    2 +-
>  2 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index 1d886e0..89c1887 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -467,6 +467,16 @@ config XEN_BLKDEV_FRONTEND
>  	  block device driver.  It communicates with a back-end driver
>  	  in another domain which drives the actual block device.
>  
> +config XEN_BLKDEV_NAME
> +	string "Base name for Xen block devices"
> +	depends on XEN_BLKDEV_FRONTEND
> +	default "xvd"
> +	help
> +	  Use this as the base name for Xen block devices. This is
> +	  traditionally "xvd", but if you're trying to boot a system
> +	  that expects to find its root device on /dev/sda, you can
> +	  use this setting to accomodate that.

	                      accommodate

> +
>  config VIRTIO_BLK
>  	tristate "Virtio block driver (EXPERIMENTAL)"
>  	depends on EXPERIMENTAL && VIRTIO


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
