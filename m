Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab1BQQdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 11:33:07 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:59237 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab1BQQdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 11:33:01 -0500
Date: Fri, 18 Feb 2011 01:33:00 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: regression 2.6.38-rc4 -> 2.6.38-rc5 suspend fails
Message-ID: <20110217163300.GA7988@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

(please Cc)

I have a regression here sinc e2.6.38-rc5 against -rc4, suspend does
not work anymore.

Suspend in rc5 stops with "some devices cannot be suspend":
[  186.824325] PM: Preparing system for mem sleep
[  187.368534] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  187.384141] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  187.400154] PM: Entering mem sleep
[  187.400217] Suspending console(s) (use no_console_suspend to debug)
[  187.431788] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  187.431895] sd 0:0:0:0: [sda] Stopping disk
[  187.480078] tpm_tis 00:0a: Operation Timed out
[  187.480095] legacy_suspend(): pnp_bus_suspend+0x0/0x6a returns -62
[  187.480101] PM: Device 00:0a failed to suspend: error -62
[  187.919032] PM: Some devices failed to suspend
[  187.919108] sd 0:0:0:0: [sda] Starting disk
[  189.091224] PM: resume of devices complete after 1172.182 msecs
[  189.091687] PM: Finishing wakeup.
[  189.091691] Restarting tasks ... done.
[  189.107075] video LNXVIDEO:00: Restoring backlight state

Interestingly I don't see anything in lspci with 00:0a


On the contrary, a successful suspend wiht rc4:
[  143.048345] PM: Preparing system for mem sleep
[  143.608538] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  143.624140] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  143.640128] PM: Entering mem sleep
[  143.640190] Suspending console(s) (use no_console_suspend to debug)
[  143.683797] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  143.683905] sd 0:0:0:0: [sda] Stopping disk
[  143.768321] ACPI handle has no context!
[  143.768341] sdhci-pci 0000:0b:04.2: PCI INT C disabled
[  143.768352] ACPI handle has no context!
[  143.768388] pci 0000:00:1f.3: PCI INT C disabled
[  143.768440] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[  143.768446] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  143.768456] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  143.768463] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  143.768495] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[  143.768510] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[  143.768533] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[  143.768548] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  143.768754] e1000e 0000:00:19.0: PCI INT A disabled
[  143.768766] e1000e 0000:00:19.0: PME# enabled
[  143.768834] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[  143.776082] ACPI handle has no context!
[  143.784069] i915 0000:00:02.0: power state changed by ACPI to D3
[  143.872147] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  143.872208] ACPI handle has no context!
[  144.180110] PM: suspend of devices complete after 538.964 msecs
[  144.228250] PM: late suspend of devices complete after 48.131 msecs
[  144.230289] ACPI: Preparing to enter system sleep state S3
[  144.328883] PM: Saving platform NVS memory
[  144.330244] Disabling non-boot CPUs ...
[  144.484058] CPU 1 is now offline
[  144.485027] Extended CMOS year: 2000
[  144.485027] Back to C!
[  144.485027] PM: Restoring platform NVS memory
.....


I hope that is enoug information, let me know if you need some
more!

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
HEATON PUNCHARDON (n.) A violent argument which breaks out in the car
on the way home from a party between a couple who have had to be
polite to each other in company all evening.
			--- Douglas Adams, The Meaning of Liff
