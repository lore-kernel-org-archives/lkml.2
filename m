Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab1I2SXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:23:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:21241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab1I2SXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:23:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="58049922"
Date: Thu, 29 Sep 2011 11:23:27 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: PME via interrupt or SCI mechanism?
Message-ID: <20110929182327.GA4979@xanatos>
References: <20110912171003.GA7939@xanatos>
 <201109272254.47232.rjw@sisk.pl>
 <20110927235216.GA5765@xanatos>
 <201109290021.28407.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109290021.28407.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 12:21:28AM +0200, Rafael J. Wysocki wrote:
> On Wednesday, September 28, 2011, Sarah Sharp wrote:
> > On Tue, Sep 27, 2011 at 10:54:47PM +0200, Rafael J. Wysocki wrote:
> > > On Tuesday, September 27, 2011, Sarah Sharp wrote:
> > So it looks like gpe 0xD is enabled when the host goes into D3, and
> > acpi_dev_run_wake is calling acpi_enable_gpe() with GPE 13 (i.e. 0xD),
> > correct?
> 
> Yes, that's correct.
> 
> Moreover, evidently, the event is signaled and it causes pci_acpi_wake_dev()
> to be called for multiple devices, _except_ for the xhci_hcd.  Perhaps
> the notifier is not installed for that device for some reason.
> 
> Please add an additional debug printk()s to pci_acpi_add_pm_notifier()
> for both pci_dev and dev and for the result returned by add_pm_notifier().

dmesg reports success from pci_acpi_add_pm_notifier for all PCI devices,
including the xHCI host (PCI device 0000:00:14.0):

[    0.936882] pci_bus 0000:00: bus scan returning with max=04
[    0.936884] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.936961] pci 0000:00:1f.0: pci_acpi_add_pm_notifier
[    0.936964] acpi device:02: pci_acpi_add_pm_notifier add_pm_notifier returned 0 (success)
[    0.936977] pci 0000:00:19.0: pci_acpi_add_pm_notifier
[    0.936978] acpi device:1f: pci_acpi_add_pm_notifier add_pm_notifier returned 0 (success)
[    0.936981] pci 0000:00:1d.0: pci_acpi_add_pm_notifier
[    0.936983] acpi device:20: pci_acpi_add_pm_notifier add_pm_notifier returned 0 (success)
[    0.936986] pci 0000:00:1a.0: pci_acpi_add_pm_notifier
[    0.936987] acpi device:2b: pci_acpi_add_pm_notifier add_pm_notifier returned 0 (success)
[    0.936990] pci 0000:00:14.0: pci_acpi_add_pm_notifier
[    0.936992] acpi device:34: pci_acpi_add_pm_notifier add_pm_notifier returned 0 (success)
[    0.936995] pci 0000:00:1b.0: pci_acpi_add_pm_notifier
[    0.936996] acpi device:3e: pci_acpi_add_pm_notifier add_pm_notifier returned 0 (success)
[    0.936999] pci 0000:00:1c.0: pci_acpi_add_pm_notifier
[    0.937001] acpi device:3f: pci_acpi_add_pm_notifier add_pm_notifier returned 0 (success)
[    0.937002] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.937033] pci 0000:00:1c.7: pci_acpi_add_pm_notifier
[    0.937035] acpi device:4d: pci_acpi_add_pm_notifier add_pm_notifier returned 0 (success)
[    0.937036] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP08._PRT]
[    0.937056] pci 0000:03:00.0: pci_acpi_add_pm_notifier
[    0.937057] acpi device:4e: pci_acpi_add_pm_notifier add_pm_notifier returned 0 (success)
[    0.937060] pci 0000:00:1f.2: pci_acpi_add_pm_notifier
[    0.937062] acpi device:4f: pci_acpi_add_pm_notifier add_pm_notifier returned 0 (success)
[    0.937066] pci 0000:00:1f.3: pci_acpi_add_pm_notifier
[    0.937068] acpi device:52: pci_acpi_add_pm_notifier add_pm_notifier returned 0 (success)
[    0.937071] pci 0000:00:01.0: pci_acpi_add_pm_notifier
[    0.937072] acpi device:53: pci_acpi_add_pm_notifier add_pm_notifier returned 0 (success)
[    0.937074] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
[    0.937094] pci 0000:01:00.0: pci_acpi_add_pm_notifier
[    0.937095] acpi device:54: pci_acpi_add_pm_notifier add_pm_notifier returned 0 (success)
[    0.937104] acpi_pci_osc_support

This morning, I debugged an issue with the NEC xHCI host controller
issue in Keith Packard's Lenovo x220 machine.  The NEC host was not
giving port status changes when the host controller was suspended, and
it turns out Keith has a boot script that runs `echo auto > power/control`
for all his PCI devices.  When he disabled that script and rebooted, his
NEC host started working again.

So it's possible that other xHCI host controllers are also affected by
this D3 wakeup issue, which makes it less likely to be a hardware bug,
and more likely to be a PCI/ACPI/xHCI driver bug.

Sarah Sharp
