Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab1LAJYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 04:24:31 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:13146 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab1LAJY3 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:2>);
	Thu, 1 Dec 2011 04:24:29 -0500
Message-Id: <4ED755D70200007800064987@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 01 Dec 2011 09:24:23 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <ke.yu@intel.com>, <kevin.tian@intel.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <stefan.bader@canonical.com>, <Ian.Campbell@citrix.com>,
        <mike.mcclurg@citrix.com>, <jeremy@goop.org>, <konrad@kernel.org>,
        <lenb@kernel.org>, <xen-devel@lists.xensource.com>,
        <liang.tang@oracle.com>, <rjw@sisk.pl>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 5/8] ACPI: add processor driver for Xen
 virtual CPUs.
References: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com>
 <1322673664-14642-6-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1322673664-14642-6-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.11.11 at 18:21, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -66,6 +66,7 @@ obj-$(CONFIG_ACPI_CUSTOM_METHOD)+= custom_method.o
>  # processor has its own "processor." module_param namespace
>  processor-y			:= processor_driver.o processor_throttling.o
>  processor-y			+= processor_idle.o processor_thermal.o
> +processor-y			+= processor_xen.o

This should minimally be processor-$(CONFIG_XEN), with other things
adjusted as necessary.

>  processor-$(CONFIG_CPU_FREQ)	+= processor_perflib.o
>  
>  obj-$(CONFIG_ACPI_PROCESSOR_AGGREGATOR) += acpi_pad.o
>...
> --- a/drivers/xen/Kconfig
> +++ b/drivers/xen/Kconfig
> @@ -117,6 +117,11 @@ config XEN_SYS_HYPERVISOR
>  	 virtual environment, /sys/hypervisor will still be present,
>  	 but will have no xen contents.
>  
> +config ACPI_PROCESSOR_XEN
> +	tristate
> +	depends on XEN_DOM0 && ACPI_PROCESSOR && CPU_FREQ
> +	default m

default ACPI_PROCESSOR

> +
>  config XEN_XENBUS_FRONTEND
>  	tristate
>  
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index 974fffd..f67450c 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -19,6 +19,9 @@ obj-$(CONFIG_XEN_TMEM)			+= tmem.o
>  obj-$(CONFIG_SWIOTLB_XEN)		+= swiotlb-xen.o
>  obj-$(CONFIG_XEN_DOM0)			+= pci.o
>  obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= xen-pciback/
> +ifdef CONFIG_ACPI_PROCESSOR_XEN
> +obj-$(CONFIG_ACPI_PROCESSOR)		+= acpi_processor.o
> +endif

obj-$(CONFIG_ACPI_PPROCESSOR_XEN)

Jan

