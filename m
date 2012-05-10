Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125Ab2EJR3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:29:07 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:41215 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab2EJR3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:29:05 -0400
Message-ID: <1336670790.16730.215.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 1/7] ACPI: Add CONFIG_HOTPLUG_OST option
From: Toshi Kani <toshi.kani@hp.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, bhelgaas@google.com,
        shuahkhan@gmail.com, linux-kernel@vger.kernel.org
Date: Thu, 10 May 2012 11:26:30 -0600
In-Reply-To: <4FABEF90.4040602@gmail.com>
References: <1336507944-10219-1-git-send-email-toshi.kani@hp.com>
	 <1336507944-10219-2-git-send-email-toshi.kani@hp.com>
	 <4FABEF90.4040602@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-11 at 00:40 +0800, Jiang Liu wrote:
> On 05/09/2012 04:12 AM, Toshi Kani wrote:
> > Added CONFIG_ACPI_HOTPLUG_OPT option. When this config option is disabled,
> > this patchset has no effect on the platform. This option is disabled by
> > default. The dependency list assures consistent behavior among CPU, memory
> > and container hotplug operations with regarding the _OST support.
> Seems also need to enhance the acpiphp driver for PCI hotplug operations too.
> acpiphp driver is also based on the ACPI device hotplug model.

Good question.  ACPI PCI hotplug is a legacy method, which is being
replaced by PCI native hotplug.  I expect PCI native hotplug will be
used for any platforms supporting PCI-E.  Since this _OST support is
targeted for new platforms (as _OST is not supported on the current
platforms), I thought that it would be prudent to avoid changing PCI
hotplug code for this.


Thanks,
-Toshi


> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > ---
> >  drivers/acpi/Kconfig |   14 ++++++++++++++
> >  1 files changed, 14 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> > index 47768ff..1e3a756 100644
> > --- a/drivers/acpi/Kconfig
> > +++ b/drivers/acpi/Kconfig
> > @@ -351,6 +351,20 @@ config ACPI_HOTPLUG_MEMORY
> >  	  To compile this driver as a module, choose M here:
> >  	  the module will be called acpi_memhotplug.
> >  
> > +config ACPI_HOTPLUG_OST
> > +	bool "Hotplug Status Indication Support"
> > +	depends on ACPI_HOTPLUG_CPU
> > +	depends on ACPI_HOTPLUG_MEMORY
> > +	depends on ACPI_CONTAINER
> > +	default n
> > +	help
> > +	  This option enables the use of the ACPI OSPM Status Indication
> > +          (_OST), if available, for the platform to determine the status
> > +	  of various hotplug operations. Some platforms may require this
> > +	  option be enabled to track the status of hotplug operations.
> > +	  This option has no effect when the platform does not support
> > +	  _OST.
> > +
> >  config ACPI_SBS
> >  	tristate "Smart Battery System"
> >  	depends on X86
> 


