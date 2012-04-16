Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab2DPQW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:22:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45988 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab2DPQWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:22:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC PATCH] PCIe: Add PCIe runtime D3cold support
Date: Mon, 16 Apr 2012 18:26:51 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
References: <4F8790F6.5080408@intel.com> <201204132141.58063.rjw@sisk.pl> <1334537311.11188.118.camel@minggr>
In-Reply-To: <1334537311.11188.118.camel@minggr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204161826.51743.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 16, 2012, Lin Ming wrote:
> On Fri, 2012-04-13 at 21:41 +0200, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > On Friday, April 13, 2012, Yan, Zheng wrote:
> > > Hi all,
> > > 
> > > This patch adds PCIe runtime D3cold support, namely cut power supply for functions
> > > beneath a PCIe port when they all have entered D3. A device in D3cold can only
> > > generate wake event through the WAKE# pin. Because we can not access to a device's
> > > configure space while it's in D3cold, pme_poll is disabled for devices in D3cold.
> > > 
> > > Any comment will be appreciated.
> > > 
> > > Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
> > > ---
> > > diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
> > > index 0f150f2..e210e8cb 100644
> > > --- a/drivers/pci/pci-acpi.c
> > > +++ b/drivers/pci/pci-acpi.c
> > > @@ -224,7 +224,7 @@ static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
> > >  		[PCI_D1] = ACPI_STATE_D1,
> > >  		[PCI_D2] = ACPI_STATE_D2,
> > >  		[PCI_D3hot] = ACPI_STATE_D3,
> > > -		[PCI_D3cold] = ACPI_STATE_D3
> > > +		[PCI_D3cold] = ACPI_STATE_D3_COLD
> > >  	};
> > >  	int error = -EINVAL;
> > >  
> > 
> > Please don't use that ACPI_STATE_D3_COLD thing, it's not defined correctly.
> > 
> > We should define ACPI_STATE_D3_COLD == ACPI_STATE_D3 and add ACPI_STATE_D3_HOT
> > instead.  I'll prepare a patch for that over the weekend if no one has done
> > that already.
> 
> Hi Rafael,
> 
> Have you started to write the patch?
> 
> If not, I can do it.

Please do if you have the time.  I'd like this one to be cleaned up ASAP,
to reduce the amount of confusion taking place.

Thanks,
Rafael
