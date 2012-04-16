Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab2DPVHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 17:07:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46623 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab2DPVHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 17:07:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [RFC PATCH] PCIe: Add PCIe runtime D3cold support
Date: Mon, 16 Apr 2012 23:11:37 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Lin Ming <ming.m.lin@intel.com>, Zhang Rui <rui.zhang@intel.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
References: <4F8790F6.5080408@intel.com> <201204132141.58063.rjw@sisk.pl> <4F8BCF00.3020004@intel.com>
In-Reply-To: <4F8BCF00.3020004@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201204162311.37499.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 16, 2012, Yan, Zheng wrote:
> On 04/14/2012 03:41 AM, Rafael J. Wysocki wrote:
> >> > @@ -296,7 +296,8 @@ static void acpi_pci_propagate_run_wake(struct pci_bus *bus, bool enable)
> >> >  
> >> >  static int acpi_pci_run_wake(struct pci_dev *dev, bool enable)
> >> >  {
> >> > -	if (dev->pme_interrupt)
> >> > +	/* PME interrupt isn't available in the D3cold case */
> >> > +	if (dev->pme_interrupt && !dev->runtime_d3cold)
> >
> > This whole thing is wrong.  First off, I don't think that the runtime_d3cold
> > flag makes any sense.  We already cover that in dev->pme_support.
> > 
> > Second, pme_interrupt means that the _root_ _port_, not the device itself will
> > trigger an interrupt whenever the device sends the PME message to it (which
> > very well may happen for a device in D3_cold woken up by an external signal).
> > 
> 
> I rechecked this. The port does trigger PME interrupt, but after the WAKE# signal
> restores device power. So my comments "PME interrupt isn't available in the D3cold
> case" is wrong, but setup ACPI wakeup is still required.

What exactly do you mean by "setup ACPI wakeup"?

Rafael
