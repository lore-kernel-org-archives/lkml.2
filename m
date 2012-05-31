Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab2EaQXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 12:23:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34938 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758035Ab2EaQXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 12:23:49 -0400
Date: Thu, 31 May 2012 18:23:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Bojan Smojver <bojan@rexursive.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
Message-ID: <20120531162342.GA3541@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Bojan Smojver <bojan@rexursive.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Linux PM list <linux-pm@vger.kernel.org>,
	Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org>
 <201205211518.39137.rjw@sisk.pl>
 <882dce83-b79e-4470-af25-edb8429fb7e5@email.android.com>
 <201205212353.42639.rjw@sisk.pl>
 <1337637359.1647.67.camel@shrek.rexursive.com>
 <20120524145122.GA26743@x1.osrc.amd.com>
 <07f1a575-ec44-40b7-bd36-576f883f188d@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <07f1a575-ec44-40b7-bd36-576f883f188d@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 12:02:15PM +1000, Bojan Smojver wrote:
> Sorry. That patch is here (pretty much the original with signed-off):
> 
> http://marc.info/?l=linux-kernel&m=133651588229850&w=2

Ok, I finally gave the above a run, here's the dmesg after a successful
suspend-resume cycle. It looks ok except the funny characters after

"[  380.938864] PM: Compressing and saving image data (75689 pages) ..."

I'll keep running it the next couple of days/weeks and report any
instabilities.

[  372.519343] PM: Syncing filesystems ... done.
[  372.534190] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  372.790881] PM: Preallocating image memory... done (allocated 71296 pages)
[  372.790978] PM: Allocated 285184 kbytes in 0.25 seconds (1140.73 MB/s)
[  372.886000] Freezing remaining freezable tasks ... (elapsed 0.09 seconds) done.
[  372.887203] Suspending console(s) (use no_console_suspend to debug)
[  372.889014] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  372.994022] ACPI handle has no context!
[  373.654092] PM: freeze of devices complete after 767.177 msecs
[  373.654582] PM: late freeze of devices complete after 0.483 msecs
[  373.655572] PM: noirq freeze of devices complete after 0.987 msecs
[  373.655576] Disabling non-boot CPUs ...
[  373.658524] CPU 1 is now offline
[  373.658529] lockdep: fixing up alternatives.
[  373.659848] PM: Creating hibernation image:
[  373.929896] PM: Need to copy 75541 pages
[  374.779946] PM: Hibernation image created (75541 pages copied)
[  373.660536] Enabling non-boot CPUs ...
[  373.669476] lockdep: fixing up alternatives.
[  373.669489] Booting Node 0 Processor 1 APIC 0x1
[  373.680521] LVT offset 0 assigned for vector 0x400
[  373.684157] CPU1 is up
[  373.685209] PM: noirq thaw of devices complete after 0.670 msecs
[  373.685838] PM: early thaw of devices complete after 0.515 msecs
[  373.701440] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[  373.701756] radeon 0000:00:01.0: WB enabled
[  373.701762] radeon 0000:00:01.0: fence driver on ring 0 use gpu addr 0x0000000018000c00 and cpu addr 0xffff880118850c00
[  373.701985] snd_hda_intel 0000:00:01.1: irq 43 for MSI/MSI-X
[  373.714886] atl1c 0000:02:00.0: irq 44 for MSI/MSI-X
[  373.718033] [drm] ring test on 0 succeeded in 1 usecs
[  373.718083] [drm] ib test on ring 0 succeeded in 0 usecs
[  374.177875] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  374.185096] ata1.00: configured for UDMA/133
[  374.202031] sd 0:0:0:0: [sda] Starting disk
[  375.154008] PM: thaw of devices complete after 1468.985 msecs
[  380.938864] PM: Using 1 thread(s) for compression.
[  380.938864] PM: Compressing and saving image data (75689 pages) ...     \x08\x08\x08\x08  0%\x08\x08\x08\x08  1%\x08\x08\x08\x08  2%\x08\x08\x08\x08  3%\x08\x08\x08\x08  4%\x08\x08\x08\x08  5%\x08\x08\x08\x08  6%\x08\x08\x08\x08  7%\x08\x08\x08\x08  8%\x08\x08\x08\x08  9%\x08\x08\x08\x08 10%\x08\x08\x08\x08 11%\x08\x08\x08\x08 12%\x08\x08\x08\x08 13%\x08\x08\x08\x08 14%\x08\x08\x08\x08 15%\x08\x08\x08\x08 16%\x08\x08\x08\x08 17%\x08\x08\x08\x08 18%\x08\x08\x08\x08 19%\x08\x08\x08\x08 20%\x08\x08\x08\x08 21%\x08\x08\x08\x08 22%\x08\x08\x08\x08 23%\x08\x08\x08\x08 24%\x08\x08\x08\x08 25%\x08\x08\x08\x08 26%\x08\x08\x08\x08 27%\x08\x08\x08\x08 28%\x08\x08\x08\x08 29%\x08\x08\x08\x08 30%\x08\x08\x08\x08 31%\x08\x08\x08\x08 32%\x08\x08\x08\x08 33%\x08\x08\x08\x08 34%\x08\x08\x08\x08 35%\x08\x08\x08\x08 36%\x08\x08\x08\x08 37%\x08\x08\x08\x08 38%\x08\x08\x08\x08 39%\x08\x08\x08\x08 40%\x08\x08\x08\x08 41%\x08\x08\x08\x08 42%\x08\x08\x08\x08 43%\x08\x08\x08\x08 44%\x08\x08\x08\x08 45%\x08\x08\x08\x08 46%\x08\x08\x08\x08 47%\x08\x08\x08\x08 48%\x08\x08\x08\x08 49%\x08\x08\x08\x08 50%\x08\x08\x08\x08 51%\x08\x08\x08\x08 52%\x08\x08\x08\x08 53%\x08\x08\x08\x08 54%\x08\x08\x08\x08 55%\x08\x08\x08\x08 56%\x08\x08\x08\x08 57%\x08\x08\x08\x08 58%\x08\x08\x08\x08 59%\x08\x08\x08\x08 60%\x08\x08\x08\x08 61%\x08\x08\x08\x08 62%\x08\x08\x08\x08 63%\x08\x08\x08\x08 64%\x08\x08\x08\x08 65%\x08\x08\x08\x08 66%\x08\x08\x08\x08 67%\x08\x08\x08\x08 68%\x08\x08\x08\x08 69%\x08\x08\x08\x08 70%\x08\x08\x08\x08 71%\x08\x08\x08\x08 72%\x08\x08\x08\x08 73%\x08\x08\x08\x08 74%\x08\x08\x08\x08 75%\x08\x08\x08\x08 76%\x08\x08\x08\x08 77%\x08\x08\x08\x08 78%\x08\x08\x08\x08 79%\x08\x08\x08\x08 80%\x08\x08\x08\x08 81%\x08\x08\x08\x08 82%\x08\x08\x08\x08 83%\x08\x08\x08\x08 84%\x08\x08\x08\x08 85%\x08\x08\x08\x08 86%\x08\x08\x08\x08 87%\x08\x08\x08\x08 88%\x08\x08\x08\x08 89%\x08\x08\x08\x08 90%\x08\x08\x08\x08 91%\x08\x08\x08\x08 92%\x08\x08\x08\x08 93%\x08\x08\x08\x08 94%\x08\x08\x08\x08 95%\x08\x08\x08\x08 96%\x08\x08\x08\x08 97%\x08\x08\x08\x08 98%\x08\x08\x08\x08 99%\x08\x08\x08\x08100%\x08\x08\x08\x08done
[  380.939433] PM: Wrote 302756 kbytes in 5.78 seconds (52.37 MB/s)
[  380.960456] PM: S|
[  381.025137] Suspending console(s) (use no_console_suspend to debug)
[  381.175895] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  381.176891] sd 0:0:0:0: [sda] Stopping disk
[  381.369937] ACPI handle has no context!
[  381.749872] PM: suspend of devices complete after 724.410 msecs
[  381.750731] PM: late suspend of devices complete after 0.849 msecs
[  381.781749] ohci_hcd 0000:00:13.0: wake-up capability enabled by ACPI
[  381.781940] ehci_hcd 0000:00:12.2: wake-up capability enabled by ACPI
[  381.797738] ohci_hcd 0000:00:12.0: wake-up capability enabled by ACPI
[  381.798159] PM: noirq suspend of devices complete after 47.444 msecs
[  381.798225] ACPI: Preparing to enter system sleep state S3
[  381.849919] PM: Saving platform NVS memory
[  381.857244] Disabling non-boot CPUs ...
[  381.961329] CPU 1 is now offline
[  381.961335] lockdep: fixing up alternatives.
[  381.962531] ACPI: Low-level resume complete
[  381.962633] PM: Restoring platform NVS memory
[  381.963384] Enabling non-boot CPUs ...
[  381.972265] lockdep: fixing up alternatives.
[  381.972273] Booting Node 0 Processor 1 APIC 0x1
[  381.983298] LVT offset 0 assigned for vector 0x400
[  381.986425] CPU1 is up
[  381.987320] ACPI: Waking up from system sleep state S3
[  382.155684] ohci_hcd 0000:00:12.0: wake-up capability disabled by ACPI
[  382.170656] ehci_hcd 0000:00:12.2: wake-up capability disabled by ACPI
[  382.170844] ohci_hcd 0000:00:13.0: wake-up capability disabled by ACPI
[  382.187755] PM: noirq resume of devices complete after 32.977 msecs
[  382.188346] PM: early resume of devices complete after 0.476 msecs
[  382.189442] snd_hda_intel 0000:00:01.1: irq 43 for MSI/MSI-X
[  382.211320] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[  382.211700] radeon 0000:00:01.0: WB enabled
[  382.211706] radeon 0000:00:01.0: fence driver on ring 0 use gpu addr 0x0000000018000c00 and cpu addr 0xffff880118850c00
[  382.224190] atl1c 0000:02:00.0: irq 44 for MSI/MSI-X
[  382.228088] [drm] ring test on 0 succeeded in 1 usecs
[  382.228145] [drm] ib test on ring 0 succeeded in 0 usecs
[  384.361199] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  384.527745] ata1.00: configured for UDMA/133
[  384.541619] sd 0:0:0:0: [sda] Starting disk
[  384.587970] PM: resume of devices complete after 2400.966 msecs
[  384.672413] Restarting tasks ... done.
[  384.720985] video LNXVIDEO:01: Restoring backlight state
[  432.813112] atl1c 0000:02:00.0: atl1c: eth0 NIC Link is Up<100 Mbps Full Duplex>

-- 
Regards/Gruss,
Boris.
