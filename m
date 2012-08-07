Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab2HGSdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:33:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:35648 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2HGSdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:33:08 -0400
Date: Tue, 7 Aug 2012 14:23:25 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        catalin.marinas@arm.com, arnd@arndb.de
Subject: Re: [PATCH v2 11/23] xen: do not compile manage, balloon, pci, acpi
 and cpu_hotplug on ARM
Message-ID: <20120807182325.GO15053@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
 <1344263246-28036-11-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344263246-28036-11-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 03:27:14PM +0100, Stefano Stabellini wrote:
> Changes in v2:
> 
> - make pci.o depend on CONFIG_PCI and acpi.o depend on CONFIG_ACPI.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Looks good.
> ---
>  drivers/xen/Makefile |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index fc34886..bee02b2 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -1,11 +1,17 @@
> -obj-y	+= grant-table.o features.o events.o manage.o balloon.o
> +ifneq ($(CONFIG_ARM),y)
> +obj-y	+= manage.o balloon.o
> +obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
> +endif
> +obj-y	+= grant-table.o features.o events.o
>  obj-y	+= xenbus/
>  
>  nostackp := $(call cc-option, -fno-stack-protector)
>  CFLAGS_features.o			:= $(nostackp)
>  
> +obj-$(CONFIG_XEN_DOM0)			+= $(dom0-y)
> +dom0-$(CONFIG_PCI) := pci.o
> +dom0-$(CONFIG_ACPI) := acpi.o
>  obj-$(CONFIG_BLOCK)			+= biomerge.o
> -obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
>  obj-$(CONFIG_XEN_XENCOMM)		+= xencomm.o
>  obj-$(CONFIG_XEN_BALLOON)		+= xen-balloon.o
>  obj-$(CONFIG_XEN_SELFBALLOONING)	+= xen-selfballoon.o
> @@ -17,7 +23,6 @@ obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
>  obj-$(CONFIG_XEN_PVHVM)			+= platform-pci.o
>  obj-$(CONFIG_XEN_TMEM)			+= tmem.o
>  obj-$(CONFIG_SWIOTLB_XEN)		+= swiotlb-xen.o
> -obj-$(CONFIG_XEN_DOM0)			+= pci.o acpi.o
>  obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= xen-pciback/
>  obj-$(CONFIG_XEN_PRIVCMD)		+= xen-privcmd.o
>  obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+= xen-acpi-processor.o
> -- 
> 1.7.2.5
