Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab0IYUiz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 16:38:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41376 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab0IYUix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 16:38:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH] PCI / PCIe / AER: Disable native AER service if BIOS has precedence (v2) (was: Re: [PATCH]  PCI / PCIe / AER ...)
Date: Sat, 25 Sep 2010 22:37:52 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Chen Gong <gong.chen@linux.intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <201009200002.15609.rjw@sisk.pl> <201009201850.00626.rjw@sisk.pl> <1285393862.15685.37.camel@yhuang-dev>
In-Reply-To: <1285393862.15685.37.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009252237.52589.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 25, 2010, Huang Ying wrote:
> Hi, Rafael,
> 
> On Tue, 2010-09-21 at 00:50 +0800, Rafael J. Wysocki wrote:
> > --- linux-2.6.orig/drivers/pci/pcie/portdrv_acpi.c
> > +++ linux-2.6/drivers/pci/pcie/portdrv_acpi.c
> > @@ -49,7 +49,7 @@ int pcie_port_acpi_setup(struct pci_dev 
> >  		| OSC_PCI_EXPRESS_PME_CONTROL;
> >  
> >  	if (pci_aer_available()) {
> > -		if (pcie_aer_get_firmware_first(port))
> > +		if (aer_acpi_firmware_first())
> >  			dev_dbg(&port->dev, "PCIe errors handled by BIOS.\n");
> >  		else
> >  			flags |= OSC_PCI_EXPRESS_AER_CONTROL;
> 
> The original per-device firmware_first is overridden by the new global
> firmware_first? If it is, why keep the original per-device
> firmware_first?

I didn't want to remove it just yet, but I do think it should be removed.

Rafael
