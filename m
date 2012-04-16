Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab2DPAta (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 20:49:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:34619 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab2DPAt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 20:49:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="129930393"
Subject: Re: [RFC PATCH] PCIe: Add PCIe runtime D3cold support
From: Lin Ming <ming.m.lin@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
In-Reply-To: <201204132141.58063.rjw@sisk.pl>
References: <4F8790F6.5080408@intel.com>  <201204132141.58063.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Apr 2012 08:48:31 +0800
Message-ID: <1334537311.11188.118.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-13 at 21:41 +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> On Friday, April 13, 2012, Yan, Zheng wrote:
> > Hi all,
> > 
> > This patch adds PCIe runtime D3cold support, namely cut power supply for functions
> > beneath a PCIe port when they all have entered D3. A device in D3cold can only
> > generate wake event through the WAKE# pin. Because we can not access to a device's
> > configure space while it's in D3cold, pme_poll is disabled for devices in D3cold.
> > 
> > Any comment will be appreciated.
> > 
> > Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
> > ---
> > diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
> > index 0f150f2..e210e8cb 100644
> > --- a/drivers/pci/pci-acpi.c
> > +++ b/drivers/pci/pci-acpi.c
> > @@ -224,7 +224,7 @@ static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
> >  		[PCI_D1] = ACPI_STATE_D1,
> >  		[PCI_D2] = ACPI_STATE_D2,
> >  		[PCI_D3hot] = ACPI_STATE_D3,
> > -		[PCI_D3cold] = ACPI_STATE_D3
> > +		[PCI_D3cold] = ACPI_STATE_D3_COLD
> >  	};
> >  	int error = -EINVAL;
> >  
> 
> Please don't use that ACPI_STATE_D3_COLD thing, it's not defined correctly.
> 
> We should define ACPI_STATE_D3_COLD == ACPI_STATE_D3 and add ACPI_STATE_D3_HOT
> instead.  I'll prepare a patch for that over the weekend if no one has done
> that already.

Hi Rafael,

Have you started to write the patch?

If not, I can do it.

Thanks,
Lin Ming

