Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab1LAO27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:28:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57601 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab1LAO26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:28:58 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=s3E4aK5dlEwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=P8TLTODqXzoPeHcuBdoA:9 a=fm2kbEak9NDaS24WNqMA:7 a=QEXdDO2ut3YA:10 a=MXRPAqu3daAu7TwL:21 a=Q5JZSC2so35E-9fN:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: Suspend and resume on ASUS Laptops
From: Steven Rostedt <rostedt@goodmis.org>
To: Oliver Neukum <oneukum@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <201112011248.44449.oneukum@suse.de>
References: <1322712689.30977.11.camel@frodo>
	 <201112011035.57666.rjw@sisk.pl>  <201112011248.44449.oneukum@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Dec 2011 09:28:54 -0500
Message-ID: <1322749734.30977.16.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 12:48 +0100, Oliver Neukum wrote:

> What errors are seen in the kernel log?

Without the script, I don't see any errors. Is there some debug thing
you want me to do? There's no error messages but the system just hangs
on suspend. It never makes it to the suspend state. The only way out of
it is to press and hold the power button for 10 seconds to force a hard
reboot.

Now when I add the script, I get the following messages from the kernel
for a full suspend/resume:

[  153.654339] ehci_hcd 0000:00:1a.0: remove, state 1
[  153.655383] usb usb1: USB disconnect, device number 1
[  153.656305] usb 1-1: USB disconnect, device number 2
[  153.657235] usb 1-1.1: USB disconnect, device number 3
[  153.658259] btusb_intr_complete: hci0 urb ffff8802289f52c0 failed to resubmit (19)
[  153.659469] btusb_bulk_complete: hci0 urb ffff8802289f4180 failed to resubmit (19)
[  153.660499] btusb_bulk_complete: hci0 urb ffff8802289f4540 failed to resubmit (19)
[  153.661485] usb 1-1: clear tt 1 (9032) error -19
[  153.661516] btusb_send_frame: hci0 urb ffff880233697800 submission failed
[  153.911024] usb 1-1.2: USB disconnect, device number 4
[  153.974262] ehci_hcd 0000:00:1a.0: USB bus 1 deregistered
[  153.975382] ehci_hcd 0000:00:1a.0: PCI INT A disabled
[  153.976582] ehci_hcd 0000:00:1d.0: remove, state 4
[  153.977616] usb usb2: USB disconnect, device number 1
[  153.978675] usb 2-1: USB disconnect, device number 2
[  154.038169] ehci_hcd 0000:00:1d.0: USB bus 2 deregistered
[  154.039340] ehci_hcd 0000:00:1d.0: PCI INT A disabled
[  154.043886] xhci_hcd 0000:03:00.0: remove, state 4
[  154.044944] usb usb4: USB disconnect, device number 1
[  154.046171] xHCI xhci_drop_endpoint called for root hub
[  154.046176] xHCI xhci_check_bandwidth called for root hub
[  154.098174] xhci_hcd 0000:03:00.0: USB bus 4 deregistered
[  154.099638] xhci_hcd 0000:03:00.0: remove, state 4
[  154.100785] usb usb3: USB disconnect, device number 1
[  154.102066] xHCI xhci_drop_endpoint called for root hub
[  154.102073] xHCI xhci_check_bandwidth called for root hub
[  154.202467] xhci_hcd 0000:03:00.0: USB bus 3 deregistered
[  154.257840] xhci_hcd 0000:03:00.0: PCI INT A disabled
[  154.789259] PM: Syncing filesystems ... done.
[  154.790059] PM: Preparing system for mem sleep
[  154.790203] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  154.804993] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  154.820979] PM: Entering mem sleep
[  154.821077] Suspending console(s) (use no_console_suspend to debug)
[  154.821365] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  154.927537] sd 0:0:0:0: [sda] Stopping disk
[  155.064782] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  155.352105] PM: suspend of devices complete after 531.680 msecs
[  155.384199] PM: late suspend of devices complete after 32.138 msecs
[  155.384403] ACPI: Preparing to enter system sleep state S3
[  156.878041] PM: Saving platform NVS memory
[  156.879218] Disabling non-boot CPUs ...
[  156.981674] CPU 1 is now offline
[  157.085514] CPU 2 is now offline
[  157.189360] CPU 3 is now offline
[  157.189572] Extended CMOS year: 2000
[  157.189828] ACPI: Low-level resume complete
[  157.189869] PM: Restoring platform NVS memory
[  157.190251] Extended CMOS year: 2000
[  157.190271] Enabling non-boot CPUs ...
[  157.198357] Booting Node 0 Processor 1 APIC 0x2
[  157.198358] smpboot cpu 1: start_ip = 99000
[  157.306126] NMI watchdog enabled, takes one hw-pmu counter.
[  157.306340] CPU1 is up
[  157.306388] Booting Node 0 Processor 2 APIC 0x1
[  157.306389] smpboot cpu 2: start_ip = 99000
[  157.309859] Switched to NOHz mode on CPU #1
[  157.414054] NMI watchdog enabled, takes one hw-pmu counter.
[  157.414331] CPU2 is up
[  157.414381] Booting Node 0 Processor 3 APIC 0x3
[  157.414383] smpboot cpu 3: start_ip = 99000
[  157.417699] Switched to NOHz mode on CPU #2
[  157.521895] NMI watchdog enabled, takes one hw-pmu counter.
[  157.522161] CPU3 is up
[  157.524120] ACPI: Waking up from system sleep state S3
[  157.525542] Switched to NOHz mode on CPU #3
[  157.598005] i915 0000:00:02.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  157.598015] i915 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900407)
[  157.598036] pci 0000:00:16.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  157.598052] pci 0000:00:16.0: restoring config space at offset 0x4 (was 0xfedb0004, writing 0xdfc0b004)
[  157.598059] pci 0000:00:16.0: restoring config space at offset 0x1 (was 0x180006, writing 0x100006)
[  157.598083] pci 0000:00:1a.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[  157.598100] pci 0000:00:1a.0: restoring config space at offset 0x4 (was 0x0, writing 0xdfc08000)
[  157.598108] pci 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
[  157.598137] HDA Intel 0000:00:1b.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
[  157.598152] HDA Intel 0000:00:1b.0: restoring config space at offset 0x4 (was 0x4, writing 0xdfc00004)
[  157.598158] HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[  157.598164] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
[  157.598193] pcieport 0000:00:1c.0: restoring config space at offset 0xf (was 0x100, writing 0x10010b)
[  157.598210] pcieport 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[  157.598217] pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[  157.598263] pcieport 0000:00:1c.1: restoring config space at offset 0xf (was 0x200, writing 0x100205)
[  157.598280] pcieport 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[  157.598287] pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[  157.598331] pcieport 0000:00:1c.3: restoring config space at offset 0xf (was 0x400, writing 0x10040a)
[  157.598348] pcieport 0000:00:1c.3: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[  157.598355] pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[  157.598398] pcieport 0000:00:1c.5: restoring config space at offset 0xf (was 0x200, writing 0x100205)
[  157.598415] pcieport 0000:00:1c.5: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[  157.598422] pcieport 0000:00:1c.5: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
[  157.598465] pci 0000:00:1d.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
[  157.598482] pci 0000:00:1d.0: restoring config space at offset 0x4 (was 0x0, writing 0xdfc07000)
[  157.598490] pci 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
[  157.598564] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[  157.598605] i801_smbus 0000:00:1f.3: restoring config space at offset 0x1 (was 0x2800001, writing 0x2800003)
[  157.598720] iwlagn 0000:02:00.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
[  157.598760] iwlagn 0000:02:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xde800004)
[  157.598770] iwlagn 0000:02:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[  157.598782] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
[  157.598899] pci 0000:03:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[  157.598932] pci 0000:03:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xdde00004)
[  157.598939] pci 0000:03:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[  157.598949] pci 0000:03:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
[  157.599005] atl1c 0000:04:00.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
[  157.599033] atl1c 0000:04:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[  157.599042] atl1c 0000:04:00.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100007)
[  157.599118] PM: early resume of devices complete after 1.154 msecs
[  157.599184] i915 0000:00:02.0: setting latency timer to 64
[  157.599196] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[  157.599210] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  157.599259] ahci 0000:00:1f.2: setting latency timer to 64
[  157.599272] HDA Intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[  157.599338] sd 0:0:0:0: [sda] Starting disk
[  157.635986] Extended CMOS year: 2000
[  157.924972] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  157.952075] ata3.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[  157.952084] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  158.037042] ata3.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[  158.037052] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  158.070553] ata3.00: configured for UDMA/100
[  160.217594] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  160.224697] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  160.225011] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[  160.225020] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  160.226948] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  160.227224] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[  160.227234] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  160.228079] ata1.00: configured for UDMA/133
[  160.252503] PM: resume of devices complete after 2657.291 msecs
[  160.252615] PM: Finishing wakeup.
[  160.252616] Restarting tasks ... done.
[  160.260544] video LNXVIDEO:00: Restoring backlight state
[  160.384782] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  160.386988] atl1c 0000:04:00.0: irq 46 for MSI/MSI-X
[  160.470856] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  160.478772] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  160.480255] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[  160.480263] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[  160.481786] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[  160.483317] ehci_hcd 0000:00:1a.0: debug port 2
[  160.488701] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[  160.488728] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xdfc08000
[  160.505179] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[  160.505716] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[  160.506179] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  160.506654] usb usb1: Product: EHCI Host Controller
[  160.507135] usb usb1: Manufacturer: Linux 3.0.10-custom ehci_hcd
[  160.507629] usb usb1: SerialNumber: 0000:00:1a.0
[  160.508222] hub 1-0:1.0: USB hub found
[  160.508905] hub 1-0:1.0: 2 ports detected
[  160.509615] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  160.510449] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[  160.510453] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[  160.511319] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[  160.512037] ehci_hcd 0000:00:1d.0: debug port 2
[  160.516484] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[  160.516495] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xdfc07000
[  160.529151] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[  160.530648] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[  160.532008] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  160.533400] usb usb2: Product: EHCI Host Controller
[  160.534819] usb usb2: Manufacturer: Linux 3.0.10-custom ehci_hcd
[  160.536192] usb usb2: SerialNumber: 0000:00:1d.0
[  160.537740] hub 2-0:1.0: USB hub found
[  160.539397] hub 2-0:1.0: 2 ports detected
[  160.540968] xhci_hcd 0000:03:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[  160.543013] xhci_hcd 0000:03:00.0: setting latency timer to 64
[  160.543023] xhci_hcd 0000:03:00.0: xHCI Host Controller
[  160.543980] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 3
[  160.549086] xhci_hcd 0000:03:00.0: irq 19, io mem 0xdde00000
[  160.549747] xhci_hcd 0000:03:00.0: irq 47 for MSI/MSI-X
[  160.549751] xhci_hcd 0000:03:00.0: irq 48 for MSI/MSI-X
[  160.549754] xhci_hcd 0000:03:00.0: irq 49 for MSI/MSI-X
[  160.549757] xhci_hcd 0000:03:00.0: irq 50 for MSI/MSI-X
[  160.549761] xhci_hcd 0000:03:00.0: irq 52 for MSI/MSI-X
[  160.549855] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[  160.550449] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  160.551037] usb usb3: Product: xHCI Host Controller
[  160.551629] usb usb3: Manufacturer: Linux 3.0.10-custom xhci_hcd
[  160.552226] usb usb3: SerialNumber: 0000:03:00.0
[  160.552885] xHCI xhci_add_endpoint called for root hub
[  160.552886] xHCI xhci_check_bandwidth called for root hub
[  160.552903] hub 3-0:1.0: USB hub found
[  160.553593] hub 3-0:1.0: 2 ports detected
[  160.554353] xhci_hcd 0000:03:00.0: xHCI Host Controller
[  160.555013] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 4
[  160.555968] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[  160.556656] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  160.557306] usb usb4: Product: xHCI Host Controller
[  160.557958] usb usb4: Manufacturer: Linux 3.0.10-custom xhci_hcd
[  160.558562] usb usb4: SerialNumber: 0000:03:00.0
[  160.559234] xHCI xhci_add_endpoint called for root hub
[  160.559236] xHCI xhci_check_bandwidth called for root hub
[  160.559253] hub 4-0:1.0: USB hub found
[  160.559937] hub 4-0:1.0: 2 ports detected
[  160.820711] usb 1-1: new high speed USB device number 2 using ehci_hcd
[  160.952976] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[  160.955141] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[  160.957992] hub 1-1:1.0: USB hub found
[  160.960907] hub 1-1:1.0: 6 ports detected
[  161.076317] usb 2-1: new high speed USB device number 2 using ehci_hcd
[  161.208585] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[  161.209303] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[  161.210602] hub 2-1:1.0: USB hub found
[  161.211402] hub 2-1:1.0: 6 ports detected
[  161.288236] usb 1-1.1: new full speed USB device number 3 using ehci_hcd
[  161.383792] usb 1-1.1: New USB device found, idVendor=8086, idProduct=0189
[  161.385776] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[  161.388679] bluetoothd[1639]: segfault at 7fd10bc5f4d0 ip 00007fd00a26adf4 sp 00007fff223959a0 error 4 in libc-2.11.2.so[7fd00a1f9000+158000]
[  161.459831] usb 1-1.2: new high speed USB device number 4 using ehci_hcd
[  161.614861] usb 1-1.2: New USB device found, idVendor=13d3, idProduct=5710
[  161.617543] usb 1-1.2: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[  161.620172] usb 1-1.2: Product: USB 2.0 UVC VGA WebCam
[  161.622700] usb 1-1.2: Manufacturer: Azurewave
[  161.625061] usb 1-1.2: SerialNumber: 0x0001
[  161.630485] uvcvideo: Found UVC 1.00 device USB 2.0 UVC VGA WebCam (13d3:5710)
[  161.638614] input: USB 2.0 UVC VGA WebCam as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input13

Let me know if there's any more info you need. I could also perform
other debugging tasks for you too. Just let me know what you want me to
do.

Thanks,


-- Steve

