Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab1LLRa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:30:57 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:49872 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab1LLRaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:30:55 -0500
Date: Mon, 12 Dec 2011 12:29:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>, liang tang <liang.tang@oracle.com>
Cc: ke.yu@intel.com, kevin.tian@intel.com, stefan.bader@canonical.com,
        Ian.Campbell@citrix.com, mike.mcclurg@citrix.com, jeremy@goop.org,
        konrad@kernel.org, lenb@kernel.org, xen-devel@lists.xensource.com,
        liang.tang@oracle.com, rjw@sisk.pl, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 5/8] ACPI: add processor driver for Xen
 virtual CPUs.
Message-ID: <20111212172941.GA8619@phenom.dumpdata.com>
References: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com>
 <1322673664-14642-6-git-send-email-konrad.wilk@oracle.com>
 <4ED755D70200007800064987@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED755D70200007800064987@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A020209.4EE63A42.0180,ss=2,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 09:24:23AM +0000, Jan Beulich wrote:
> >>> On 30.11.11 at 18:21, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > --- a/drivers/acpi/Makefile
> > +++ b/drivers/acpi/Makefile
> > @@ -66,6 +66,7 @@ obj-$(CONFIG_ACPI_CUSTOM_METHOD)+= custom_method.o
> >  # processor has its own "processor." module_param namespace
> >  processor-y			:= processor_driver.o processor_throttling.o
> >  processor-y			+= processor_idle.o processor_thermal.o
> > +processor-y			+= processor_xen.o
> 
> This should minimally be processor-$(CONFIG_XEN), with other things
> adjusted as necessary.

I was under the impression that this was required to get the processor_xen.ko
to be a module. Otherwise it would only compile as built-in.

Liang, can you chime in please?

> 
> >  processor-$(CONFIG_CPU_FREQ)	+= processor_perflib.o
> >  
> >  obj-$(CONFIG_ACPI_PROCESSOR_AGGREGATOR) += acpi_pad.o
> >...
> > --- a/drivers/xen/Kconfig
> > +++ b/drivers/xen/Kconfig
> > @@ -117,6 +117,11 @@ config XEN_SYS_HYPERVISOR
> >  	 virtual environment, /sys/hypervisor will still be present,
> >  	 but will have no xen contents.
> >  
> > +config ACPI_PROCESSOR_XEN
> > +	tristate
> > +	depends on XEN_DOM0 && ACPI_PROCESSOR && CPU_FREQ
> > +	default m
> 
> default ACPI_PROCESSOR
> 
> > +
> >  config XEN_XENBUS_FRONTEND
> >  	tristate
> >  
> > diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> > index 974fffd..f67450c 100644
> > --- a/drivers/xen/Makefile
> > +++ b/drivers/xen/Makefile
> > @@ -19,6 +19,9 @@ obj-$(CONFIG_XEN_TMEM)			+= tmem.o
> >  obj-$(CONFIG_SWIOTLB_XEN)		+= swiotlb-xen.o
> >  obj-$(CONFIG_XEN_DOM0)			+= pci.o
> >  obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= xen-pciback/
> > +ifdef CONFIG_ACPI_PROCESSOR_XEN
> > +obj-$(CONFIG_ACPI_PROCESSOR)		+= acpi_processor.o
> > +endif
> 
> obj-$(CONFIG_ACPI_PPROCESSOR_XEN)
> 
> Jan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
