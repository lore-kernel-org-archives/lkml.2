Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab1LASQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:16:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59272 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab1LASQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:16:22 -0500
X-Authority-Analysis: v=2.0 cv=dOUkaZlb c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=s3E4aK5dlEwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=8BoZUBE7HJ_yRN8PDWgA:9 a=QEXdDO2ut3YA:10 a=wmWGQMuq4MAVcsRq:21 a=yBaABaIA3EqwFvnf:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: Suspend and resume on ASUS Laptops
From: Steven Rostedt <rostedt@goodmis.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <4ED796AF.60606@linux.vnet.ibm.com>
References: <1322712689.30977.11.camel@frodo>
	 <201112011248.44449.oneukum@suse.de> <1322749734.30977.16.camel@frodo>
	 <201112011538.06912.oneukum@suse.de>  <4ED796AF.60606@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Dec 2011 13:16:19 -0500
Message-ID: <1322763379.30977.33.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 20:31 +0530, Srivatsa S. Bhat wrote:

> 
> Hi Steven,
> Since without the script your system refuses to suspend, you could also use the
> 'pm_test' framework (documented in Documentation/power/basic-pm-debugging.txt)
> to find out more about the failing step when suspend is attempted without using
> the script. Trying 'echo devices > /sys/power/pm_test' might be helpful in your
> case.

Interesting, all the pm_tests work. Even core. But when I switch it to
'none' it locks up.

If I just remove the ehci_hcd module, it suspends fine, so the issue is
with this module (or some usb device). There seems to be two devices
under ehci_hcd, and I played with the script to only unbind one at a
time. If I only unbind one (either one) it still hangs. I need to unbind
both for the suspend to work.

Without the script, here's the dmesg from the suspend to resume using
pm_test == core.

[  143.866718] PM: Syncing filesystems ... done.
[  143.867508] PM: Preparing system for mem sleep
[  143.867573] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  143.882142] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  143.898124] PM: Entering mem sleep
[  143.898235] Suspending console(s) (use no_console_suspend to debug)
[  143.898423] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  143.934860] snd_hda_intel 0000:00:1b.0: PCI INT A disabled
[  143.949557] sd 0:0:0:0: [sda] Stopping disk
[  143.949981] ehci_hcd 0000:00:1a.0: PCI INT A disabled
[  144.005897] ehci_hcd 0000:00:1d.0: PCI INT A disabled
[  144.373349] PM: suspend of devices complete after 475.751 msecs
[  144.437292] PM: late suspend of devices complete after 64.034 msecs
[  144.437491] ACPI: Preparing to enter system sleep state S3
[  145.931187] PM: Saving platform NVS memory
[  145.932381] Disabling non-boot CPUs ...
[  146.034855] CPU 1 is now offline
[  146.138709] CPU 2 is now offline
[  146.242558] CPU 3 is now offline
[  146.242778] Extended CMOS year: 2000
[  146.242854] suspend debug: Waiting for 5 seconds.
[  151.195310] Extended CMOS year: 2000
[  151.195339] Enabling non-boot CPUs ...
[  151.199375] Booting Node 0 Processor 1 APIC 0x2
[  151.199376] smpboot cpu 1: start_ip = 99000
[  151.210396] Calibrating delay loop (skipped) already calibrated this CPU
[  151.230638] NMI watchdog enabled, takes one hw-pmu counter.
[  151.230829] CPU1 is up
[  151.230872] Booting Node 0 Processor 2 APIC 0x1
[  151.230873] smpboot cpu 2: start_ip = 99000
[  151.231034] Switched to NOHz mode on CPU #1
[  151.241885] Calibrating delay loop (skipped) already calibrated this CPU
[  151.262176] NMI watchdog enabled, takes one hw-pmu counter.
[  151.262428] CPU2 is up
[  151.262474] Booting Node 0 Processor 3 APIC 0x3
[  151.262476] smpboot cpu 3: start_ip = 99000
[  151.262986] Switched to NOHz mode on CPU #2
[  151.273489] Calibrating delay loop (skipped) already calibrated this CPU
[  151.293822] NMI watchdog enabled, takes one hw-pmu counter.
[  151.294063] CPU3 is up
[  151.295563] Switched to NOHz mode on CPU #3
[  151.295859] ACPI: Waking up from system sleep state S3
[  151.382813] i915 0000:00:02.0: BAR 0: set to [mem 0xdd000000-0xdd3fffff 64bit] (PCI address [0xdd000000-0xdd3fffff])
[  151.382819] i915 0000:00:02.0: BAR 2: set to [mem 0xc0000000-0xcfffffff 64bit pref] (PCI address [0xc0000000-0xcfffffff])
[  151.382822] i915 0000:00:02.0: BAR 4: set to [io  0xe000-0xe03f] (PCI address [0xe000-0xe03f])
[  151.382834] i915 0000:00:02.0: restoring config space at offset 0x1 (was 0x900403, writing 0x900407)
[  151.398789] ehci_hcd 0000:00:1a.0: BAR 0: set to [mem 0xdfc08000-0xdfc083ff] (PCI address [0xdfc08000-0xdfc083ff])
[  151.398802] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  151.398822] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
[  151.414767] snd_hda_intel 0000:00:1b.0: BAR 0: set to [mem 0xdfc00000-0xdfc03fff 64bit] (PCI address [0xdfc00000-0xdfc03fff])
[  151.414780] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
[  151.414796] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[  151.414802] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
[  151.430746] ehci_hcd 0000:00:1d.0: BAR 0: set to [mem 0xdfc07000-0xdfc073ff] (PCI address [0xdfc07000-0xdfc073ff])
[  151.430759] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
[  151.430779] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
[  151.446740] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, writing 0x2b00407)
[  151.462704] xhci_hcd 0000:03:00.0: BAR 0: set to [mem 0xdde00000-0xdde07fff 64bit] (PCI address [0xdde00000-0xdde07fff])
[  151.478790] PM: early resume of devices complete after 111.626 msecs
[  151.478873] i915 0000:00:02.0: setting latency timer to 64
[  151.478876] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  151.478879] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[  151.478882] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[  151.478886] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[  151.478940] snd_hda_intel 0000:00:1b.0: irq 50 for MSI/MSI-X
[  151.478942] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  151.478950] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[  151.478978] ahci 0000:00:1f.2: setting latency timer to 64
[  151.478997] xhci_hcd 0000:03:00.0: setting latency timer to 64
[  151.479020] usb usb3: root hub lost power or was reset
[  151.479021] usb usb4: root hub lost power or was reset
[  151.488652] sd 0:0:0:0: [sda] Starting disk
[  151.488946] xhci_hcd 0000:03:00.0: irq 45 for MSI/MSI-X
[  151.488952] xhci_hcd 0000:03:00.0: irq 46 for MSI/MSI-X
[  151.488957] xhci_hcd 0000:03:00.0: irq 47 for MSI/MSI-X
[  151.488962] xhci_hcd 0000:03:00.0: irq 48 for MSI/MSI-X
[  151.488967] xhci_hcd 0000:03:00.0: irq 49 for MSI/MSI-X
[  151.524742] Extended CMOS year: 2000
[  151.798256] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  151.806242] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  151.809758] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  151.819268] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[  151.819271] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  151.821084] ata3.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[  151.821094] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  151.850068] ata3.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[  151.850078] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  151.862944] ata3.00: configured for UDMA/100
[  153.738354] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  153.738642] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[  153.738652] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  153.739521] ata1.00: configured for UDMA/133
[  153.771247] PM: resume of devices complete after 2295.808 msecs
[  153.771418] PM: Finishing wakeup.
[  153.771420] Restarting tasks ... done.
[  153.774966] video LNXVIDEO:00: Restoring backlight state
[  153.810988] atl1c 0000:04:00.0: irq 51 for MSI/MSI-X
[  153.892934] ADDRCONF(NETDEV_UP): eth0: link is not ready

Thanks,

-- Steve


