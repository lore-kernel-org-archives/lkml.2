Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab1DKJUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 05:20:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52847 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab1DKJUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 05:20:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=j008bXnw0J9y7mCS1u1L9nbjdbuDDKLZ1COqVDYbsQyr8pxnvZS3pFB14Ug5V+tD4l
         js8WjVu02hHxhTPXxVBmFYLieJYlj72hZqouEKHHk6akc8IN/kDqeu0fRp24IKT+Ylnd
         GIhI37xSVw0XpE1QC0DiTSEcdosaRycnHIAms=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1104081444020.1992-100000@iolanthe.rowland.org>
References: <BANLkTikwsDtEgA4c55BSFcvh=kjM84c7JQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1104081444020.1992-100000@iolanthe.rowland.org>
Date: Mon, 11 Apr 2011 11:20:50 +0200
Message-ID: <BANLkTimh+k+m1Mw9k6cAWDwZ1nUwBJ=Byw@mail.gmail.com>
Subject: Re: Endless print of uhci_result_common: failed with status 440000
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/8 Alan Stern <stern@rowland.harvard.edu>:
> On Fri, 8 Apr 2011, Zdenek Kabelac wrote:
>
>> Most probably because I've run  in the loop
>>
>> while : ; do pm-suspend ; sleep 5; done
>>
>> for debug purposes...
>>
>>
>> >> [   53.851937] btusb_intr_complete: hci0 urb ffff88011735c300 failed
>> >> to resubmit (19)
>> >> [   53.855223] btusb_bulk_complete: hci0 urb ffff88011735c540 failed
>> >> to resubmit (19)
>> >> [   53.867211] btusb_bulk_complete: hci0 urb ffff88011735c9c0 failed
>> >> to resubmit (19)
>> >> [   53.875279] btusb_send_frame: hci0 urb ffff880117204d80 submission failed
>> >> [   54.127633] systemd[1]: Service bluetooth.target is not needed
>> >> anymore. Stopping.
>> >> [   54.205292] PM: Syncing filesystems ... done.
>> >> [   54.216056] PM: Preparing system for mem sleep
>> >>
>> >> And system was 'dead' - (Moon sign on laptop was already blinking at
>> >> this moment)
>> >
>> > Why did the system suspend like this?  A software undock shouldn't
>> > cause a suspend.
>>
>> pm-suspend - with  script executed on suspend which undocks laptop
>> (otherwise when I'd forget to press button on docking station before
>> suspend - it would stay 'red' mode - thus all buses are connected -
>> and as I've noticed in past - it's not working well, when I unplug
>> laptop in this 'still connected'  mode - so this software 'undock'
>> solved this problem)
>
> All right.  It looks like there are two possible sources of problems
> here: the undock and the suspend.  It would be best to debug them
> separately.
>
> For example, if you change the loop above to just do the undock and
> redock without suspending, do the problems still occur?
>
> Another thing to try: Suspend by doing "echo ram >/sys/power/state"
> instead of running pm_suspend.

hmm - using   "echo mem >/sys/power/state" revealed probably
completely new problem - unsure how this is related to this USB
problem - but it leaves the machine in completely 'frozen' picture on
desktop after resume.

So here is cut&paste captured on serial console:
(Kernel without USB_DEBUG - bluetooth enabled)


[   69.823480] usb 1-1: new full speed USB device number 4 using uhci_hcd
[   69.988817] usb 1-1: New USB device found, idVendor=0a5c, idProduct=2110
[   69.996003] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   70.003598] usb 1-1: Product: BCM2045B
[   70.007502] usb 1-1: Manufacturer: Broadcom Corp
[   70.195677] [drm:drm_mode_addfb], [FB:20]
[   70.835976] [drm:intel_crtc_cursor_set],
[   70.840222] [drm:intel_crtc_cursor_set], cursor off
[   83.104217] PM: Syncing filesystems ... done.
[   83.123943] PM: Preparing system for mem sleep
[   83.487149] [drm:drm_crtc_helper_set_config],
[   83.487159] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9]
#connectors=1 (x y) (0 0)
[   83.487184] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1]
to [CRTC:4]
[   83.487199] [drm:intel_pipe_set_base_atomic], Writing base 00040000
00000000 0 0 6720
[   83.487210] [drm:intel_update_fbc],
[   83.487215] [drm:intel_update_fbc], framebuffer not tiled,
disabling compression
[   83.540219] [drm:intel_wait_for_vblank], vblank wait timed out
[   83.549459] [drm:drm_crtc_helper_set_config],
[   83.549461] [drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[   83.549466] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1]
to [CRTC:4]
[   83.549470] [drm:drm_crtc_helper_set_config],
[   83.549472] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9]
#connectors=1 (x y) (0 0)
[   83.549476] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1]
to [CRTC:4]
[   83.549480] [drm:drm_crtc_helper_set_config],
[   83.549482] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9]
#connectors=1 (x y) (0 0)
[   83.549487] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1]
to [CRTC:4]
[   83.549496] [drm:drm_crtc_helper_set_config],
[   83.549498] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9]
#connectors=1 (x y) (0 0)
[   83.549503] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1]
to [CRTC:4]
[   83.677743] Freezing user space processes ... (elapsed 0.01 seconds) done.
[   83.699503] Freezing remaining freezable tasks ... (elapsed 0.01
seconds) done.
[   83.719492] PM: Entering mem sleep
[   83.907367] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   83.913525] sd 0:0:0:0: [sda] Stopping disk
[   83.966276] ACPI handle has no context!
[   83.970256] sdhci-pci 0000:15:00.3: PCI INT C disabled
[   83.970908] ACPI handle has no context!
[   83.970920] sdhci-pci 0000:15:00.2: PCI INT C disabled
[   83.970932] ACPI handle has no context!
[   83.971441] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[   83.971471] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[   83.971493] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[   83.971513] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[   83.983368] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[   83.983390] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[   83.983412] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[   84.024003] ACPI handle has no context!
[   84.027316] [drm:i915_get_vblank_counter], trying to get vblank
count for disabled pipe A
[   84.040136] i915 0000:00:02.0: power state changed by ACPI to D3
[   84.048371] ata_piix 0000:00:1f.1: PCI INT C disabled
[   84.140794] HDA Intel 0000:00:1b.0: PCI INT B disabled
[   84.232367] e1000e 0000:00:19.0: PCI INT A disabled
[   84.239070] e1000e 0000:00:19.0: PME# enabled
[   84.244989] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[   84.266888] PM: suspend of devices complete after 542.028 msecs
[   84.303506] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[   84.312368] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D3
[   84.321188] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[   84.340108] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[   84.363514] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D3
[   84.372737] PM: late suspend of devices complete after 97.756 msecs
[   84.382329] ACPI: Preparing to enter system sleep state S3
[   84.537222] PM: Saving platform NVS memory
[   84.546195] Disabling non-boot CPUs ...
[   84.696852] CPU 1 is now offline
[   84.701290] lockdep: fixing up alternatives.
[   84.708954] Extended CMOS year: 2000
[   84.710427] ACPI: Low-level resume complete
[   84.710427] PM: Restoring platform NVS memory
[   84.710427] Extended CMOS year: 2000
[   84.713945] Enabling non-boot CPUs ...
[   84.726051] lockdep: fixing up alternatives.
[   84.731868] Booting Node 0 Processor 1 APIC 0x1
[   84.738016] smpboot cpu 1: start_ip = 98000
[   84.840023] Switched to NOHz mode on CPU #1
[   84.961171] NMI watchdog enabled, takes one hw-pmu counter.
[   85.080214] CPU1 is up
[   85.163401] ACPI: Waking up from system sleep state S3
[   85.577324] i915 0000:00:02.0: restoring config space at offset 0x1
(was 0x900007, writing 0x900407)
[   85.668051] pci 0000:00:02.1: restoring config space at offset 0x1
(was 0x900000, writing 0x900007)
[   85.760192] uhci_hcd 0000:00:1a.0: restoring config space at offset
0x1 (was 0x2800005, writing 0x2800001)
[   85.870193] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
[   85.960397] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
[   86.049873] uhci_hcd 0000:00:1a.1: restoring config space at offset
0x1 (was 0x2800005, writing 0x2800001)
[   86.145114] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
[   86.237067] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
[   86.328166] ehci_hcd 0000:00:1a.7: restoring config space at offset
0x1 (was 0x2900106, writing 0x2900102)
[   86.424842] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[   86.518539] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[   86.611050] HDA Intel 0000:00:1b.0: restoring config space at
offset 0x1 (was 0x100106, writing 0x100102)
[   86.709495] pcieport 0000:00:1c.0: restoring config space at offset
0x7 (was 0x20002020, writing 0x2020)
[   86.809512] pcieport 0000:00:1c.0: restoring config space at offset
0x1 (was 0x100107, writing 0x100507)
[   86.909370] pcieport 0000:00:1c.1: restoring config space at offset
0x1 (was 0x100107, writing 0x100507)
[   87.008236] pcieport 0000:00:1c.2: restoring config space at offset
0x7 (was 0x20004040, writing 0x4040)
[   87.105678] pcieport 0000:00:1c.2: restoring config space at offset
0x1 (was 0x100107, writing 0x100507)
[   87.202295] pcieport 0000:00:1c.3: restoring config space at offset
0x7 (was 0x20005050, writing 0x5050)
[   87.297636] pcieport 0000:00:1c.3: restoring config space at offset
0x1 (was 0x100107, writing 0x100507)
[   87.392524] pcieport 0000:00:1c.4: restoring config space at offset
0x7 (was 0x20006060, writing 0x6060)
[   87.487333] pcieport 0000:00:1c.4: restoring config space at offset
0x1 (was 0x100107, writing 0x100507)
[   87.582082] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   87.673588] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   87.764008] uhci_hcd 0000:00:1d.0: restoring config space at offset
0x1 (was 0x2800005, writing 0x2800001)
[   87.859792] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   87.952042] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   88.043192] uhci_hcd 0000:00:1d.1: restoring config space at offset
0x1 (was 0x2800005, writing 0x2800001)
[   88.140915] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[   88.236178] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[   88.331564] uhci_hcd 0000:00:1d.2: restoring config space at offset
0x1 (was 0x2800005, writing 0x2800001)
[   88.432971] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[   88.531873] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[   88.630812] ehci_hcd 0000:00:1d.7: restoring config space at offset
0x1 (was 0x2900106, writing 0x2900102)
[   88.734966] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[   88.834679] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[   88.932211] pci 0000:00:1e.0: restoring config space at offset 0x1
(was 0x100005, writing 0x100007)
[   89.034469] ata_piix 0000:00:1f.1: restoring config space at offset
0x1 (was 0x2800005, writing 0x2880005)
[   89.138911] ahci 0000:00:1f.2: restoring config space at offset 0x1
(was 0x2b00007, writing 0x2b00407)
[   89.244561] iwl3945 0000:03:00.0: restoring config space at offset
0x1 (was 0x100106, writing 0x100506)
[   89.363389] sdhci-pci 0000:15:00.2: BAR 0: set to [mem
0xf8301000-0xf83010ff] (PCI address [0xf8301000-0xf83010ff])
[   89.474415] sdhci-pci 0000:15:00.2: restoring config space at
offset 0x3 (was 0x800000, writing 0x804000)
[   89.584892] sdhci-pci 0000:15:00.2: restoring config space at
offset 0x1 (was 0x2100000, writing 0x2100006)
[   89.706740] sdhci-pci 0000:15:00.3: BAR 0: set to [mem
0xf8301400-0xf83014ff] (PCI address [0xf8301400-0xf83014ff])
[   89.819749] sdhci-pci 0000:15:00.3: restoring config space at
offset 0x3 (was 0x800000, writing 0x804000)
[   89.934115] sdhci-pci 0000:15:00.3: restoring config space at
offset 0x1 (was 0x2100000, writing 0x2100006)
[   90.049768] PM: early resume of devices complete after 4472.864 msecs
[   90.163120] i915 0000:00:02.0: power state changed by ACPI to D0
[   90.171119] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[   90.179436] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   90.188527] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
[   90.196863] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[   90.205181] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
[   90.205504] i915 0000:00:02.0: power state changed by ACPI to D0
[   90.205513] i915 0000:00:02.0: setting latency timer to 64
[   90.206741] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[   90.206751] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[   90.206761] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   90.206789] e1000e 0000:00:19.0: PME# disabled
[   90.206929] e1000e 0000:00:19.0: irq 48 for MSI/MSI-X
[   90.210156] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
[   90.210163] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[   90.210174] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   90.210218] usb usb3: root hub lost power or was reset
[   90.210354] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   90.210360] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   90.210367] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   90.210377] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   90.210415] usb usb4: root hub lost power or was reset
[   90.210440] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   90.210452] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   90.210490] usb usb5: root hub lost power or was reset
[   90.210512] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[   90.210518] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[   90.210524] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   90.210537] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   90.210575] usb usb7: root hub lost power or was reset
[   90.210600] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[   90.210609] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[   90.210621] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[   90.210632] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   90.210751] pci 0000:00:1e.0: setting latency timer to 64
[   90.210781] ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
[   90.210791] ata_piix 0000:00:1f.1: setting latency timer to 64
[   90.210869] ata5: port disabled. ignoring.
[   90.210912] ahci 0000:00:1f.2: setting latency timer to 64
[   90.211116] sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
[   90.211122] sdhci-pci 0000:15:00.2: Will use DMA mode even though
HW doesn't fully claim to support it.
[   90.211159] sdhci-pci 0000:15:00.3: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
[   90.211176] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   90.211215] usb usb1: root hub lost power or was reset
[   90.211426] sd 0:0:0:0: [sda] Starting disk
[   90.273703] [drm:intel_opregion_setup], graphic opregion physical
addr: 0xbf6ce61a
[   90.273745] [drm:intel_opregion_setup], Public ACPI methods supported
[   90.273748] [drm:intel_opregion_setup], SWSCI supported
[   90.273750] [drm:intel_opregion_setup], ASLE supported
[   90.276201] [drm:drm_crtc_helper_set_mode], [CRTC:4]
[   90.276206] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00
           (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[   90.282069] [drm:intel_sdvo_read_response], SDVOB: R: (Success)
[   90.284026] [drm:i915_get_vblank_counter], trying to get vblank
count for disabled pipe B
[   90.284033] [drm:i915_get_crtc_scanoutpos], trying to get
scanoutpos for disabled pipe B
[   90.284039] [drm:i915_get_vblank_counter], trying to get vblank
count for disabled pipe B
[   90.284049] [drm:intel_update_fbc],
[   90.284051] [drm:intel_update_fbc], framebuffer not tiled,
disabling compression
[   90.284055] [drm:i965_update_wm], self-refresh entries: 105, wm: 407
[   90.284058] [drm:i965_update_wm], self-refresh watermark: display
plane 407 cursor 32
[   90.284061] [drm:i965_update_wm], Setting FIFO watermarks - A: 8,
B: 8, C: 8, SR 407
[   90.284069] [drm:intel_crtc_mode_set], using SSC reference clock of 100 MHz
[   90.284205] [drm:intel_crtc_mode_set], Mode for pipe B:
[   90.284208] [drm:drm_mode_debug_printmodeline], Modeline
8:"1680x1050" 60 120600 1680 1712 1760 1888 1050 1051 1054 1065 0x48
0xa
[   90.340218] [drm:intel_pipe_set_base_atomic], Writing base 00040000
00000000 0 0 6720
[   90.340232] [drm:intel_update_fbc],
[   90.340238] [drm:intel_update_fbc], framebuffer not tiled,
disabling compression
[   90.712447] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   90.715400] [drm:i965_update_wm], self-refresh entries: 105, wm: 407
[   90.715404] [drm:i965_update_wm], self-refresh watermark: display
plane 407 cursor 32
[   90.715409] [drm:i965_update_wm], Setting FIFO watermarks - A: 8,
B: 8, C: 8, SR 407
[   90.715414] [drm:drm_crtc_helper_set_mode], [ENCODER:6:LVDS-6] set
[MODE:8:1680x1050]
[   90.715418] [drm:i965_update_wm], self-refresh entries: 105, wm: 407
[   90.715421] [drm:i965_update_wm], self-refresh watermark: display
plane 407 cursor 32
[   90.715425] [drm:i965_update_wm], Setting FIFO watermarks - A: 8,
B: 8, C: 8, SR 407
[   90.715947] [drm:intel_update_fbc],
[   90.715949] [drm:intel_update_fbc], framebuffer not tiled,
disabling compression
[   90.715957] [drm:intel_panel_set_backlight], set backlight PWM = 12056400
[   90.715961] [drm:intel_panel_get_max_backlight], max backlight PWM = 12056655
[   90.715971] [drm:i915_driver_irq_handler], pipe B underrun
[   90.715975] [drm:intel_opregion_asle_intr], non asle set request??
[   90.715991] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00
           (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[   90.721822] [drm:intel_sdvo_read_response], SDVOB: R: (Success)
[   90.851051] HDA Intel 0000:00:1b.0: irq 49 for MSI/MSI-X
[   90.851262] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   90.851311] ata3: SATA link down (SStatus 0 SControl 300)
[   90.874395] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   90.883416] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[   90.893217] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[   90.904213] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   90.913208] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[   90.923136] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[   90.932873] ata1.00: configured for UDMA/100
[   91.083474] usb 1-2: reset full speed USB device number 2 using uhci_hcd
[   91.098920] [drm:intel_panel_get_max_backlight], max backlight PWM = 12056655
[   91.104116] ata4.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES)
filtered out
[   91.104126] ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES)
filtered out
[   91.104628] ata4.00: ACPI cmd e3/00:10:00:00:00:a0 (IDLE) succeeded
[   91.105134] ata4.00: ACPI cmd e3/00:03:00:00:00:a0 (IDLE) succeeded
[   91.120777] ata4.00: configured for UDMA/33
[   91.150057] [drm:intel_panel_set_backlight], set backlight PWM = 12056655
[   91.150057] [drm:intel_panel_get_max_backlight], max backlight PWM = 12056655
[   91.150057] [drm:intel_opregion_asle_intr], non asle set request??
[   91.150057] [drm:intel_opregion_asle_intr], non asle set request??
[   91.164389] thinkpad_acpi: ACPI backlight control delay disabled
[   91.337039] usb 1-1: reset full speed USB device number 4 using uhci_hcd
[   91.493268] btusb 1-1:1.0: no reset_resume for driver btusb?
[   91.503555] btusb 1-1:1.1: no reset_resume for driver btusb?
[   91.765796] PM: resume of devices complete after 1602.764 msecs
[   91.778515] PM: Finishing wakeup.
[   91.784420] Restarting tasks ... done.
[   91.847367] systemd[1]: Service bluetooth.target is not needed
anymore. Stopping.
[   91.859726] video LNXVIDEO:00: Restoring backlight state
[   91.869611] [drm:intel_panel_get_max_backlight], max backlight PWM = 12056655
[   91.874455] [drm:intel_panel_set_backlight], set backlight PWM = 12056655
[   91.874455] [drm:intel_panel_get_max_backlight], max backlight PWM = 12056655
[   91.874455] [drm:intel_opregion_asle_intr], non asle set request??
[   91.874455] [drm:intel_opregion_asle_intr], non asle set request??
[   91.874455] [drm:intel_opregion_asle_intr], non asle set request??
[   91.943715] [drm:drm_mode_setcrtc], [CRTC:4]
[   91.948282] [drm:drm_mode_setcrtc], [CONNECTOR:5:LVDS-1]
[   91.953874] [drm:drm_crtc_helper_set_config],
[   91.958817] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:20]
#connectors=1 (x y) (0 0)
[   91.967466] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1]
to [CRTC:4]
[   91.975357] [drm:intel_pipe_set_base_atomic], Writing base 02992000
00000000 0 0 7168
[   91.984015] [drm:intel_update_fbc],
[   91.987789] [drm:intel_update_fbc], framebuffer too large,
disabling compression
[   92.006896] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   92.012550] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:5:LVDS-1]
[   92.020257] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:5:LVDS-1] probed modes :
[   92.029180] [drm:drm_mode_debug_printmodeline], Modeline
16:"1680x1050" 60 120600 1680 1712 1760 1888 1050 1051 1054 1065 0x48
0xa
[   92.041151] [drm:drm_mode_debug_printmodeline], Modeline
17:"1680x1050" 50 100530 1680 1712 1760 1888 1050 1051 1054 1065 0x40
0xa
[   92.053237] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   92.060445] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   92.065928] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:12:VGA-1]
[   92.081276] [drm:intel_crt_detect], CRT not detected via hotplug
[   92.088039] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:12:VGA-1] disconnected
[   92.097419] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   92.103017] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:12:VGA-1]
[   92.120081] [drm:intel_crt_detect], CRT not detected via hotplug
[   92.127465] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:12:VGA-1] disconnected
[   92.138993] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[   92.144629] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:15:DVI-D-1]
[   92.153455] [drm:intel_sdvo_debug_write], SDVOB: W: 0B
           (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   92.167960] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[   92.180699] [drm:intel_sdvo_detect], SDVO response 0 0 [1]
[   92.186348] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:15:DVI-D-1] disconnected
[   92.195865] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[   92.201469] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:15:DVI-D-1]
[   92.209019] [drm:intel_sdvo_debug_write], SDVOB: W: 0B
           (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   92.222524] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[   92.234736] [drm:intel_sdvo_detect], SDVO response 0 0 [1]
[   92.240592] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:15:DVI-D-1] disconnected
[   92.516709] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[   92.520001] IP: [<          (null)>]           (null)
[   92.520001] PGD 0
[   92.520001] Oops: 0010 [#1] PREEMPT SMP
[   92.520001] last sysfs file:
/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/PNP0C09:00/PNP0C0A:00/power_supply/BAT0/voltage_now
[   92.520001] CPU 0
[   92.520001] Modules linked in: ip6_tables ebtable_nat ebtables
iptable_mangle xt_tcpudp tun bridge ipv6 stp llc sunrpc ipt_REJECT
xt_physdev xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables
dm_mirror dm_region_hash dm_log dm_mod snd_hda_codec_analog btusb
bluetooth virtio_net kvm_intel kvm arc4 ecb crypto_blkcipher cryptomgr
aead crypto_algapi snd_hda_intel iwl3945 snd_hda_codec snd_seq
snd_seq_device iwl_legacy snd_pcm wmi psmouse mac80211 serio_raw
e1000e thinkpad_acpi snd_timer iTCO_wdt cfg80211 snd i2c_i801
soundcore snd_page_alloc iTCO_vendor_support nvram evdev i915
drm_kms_helper drm i2c_algo_bit i2c_core uinput autofs4 usbhid hid
pcmcia sdhci_pci ehci_hcd uhci_hcd sdhci sr_mod mmc_core yenta_socket
cdrom usbcore video backlight [last unloaded: scsi_wait_scan]
[   92.520001]
[   92.520001] Pid: 0, comm: swapper Not tainted
2.6.39-rc2-00005-gf04d4dc #120 LENOVO 6464CTO/6464CTO
[   92.520001] RIP: 0010:[<0000000000000000>]  [<          (null)>]
       (null)
[   92.520001] RSP: 0018:ffff88013ba03de8  EFLAGS: 00010246
[   92.520001] RAX: ffffffff8180b020 RBX: ffff8801318d6350 RCX: 0000000000000000
[   92.520001] RDX: 0000000000000025 RSI: 0000000000000000 RDI: 0000000000000000
[   92.520001] RBP: ffff88013ba03ec0 R08: 0000000000000000 R09: 0000000000000000
[   92.520001] R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff81b72340
[   92.520001] R13: ffff88013ba03e80 R14: 0000000000000102 R15: ffffffff81801fd8
[   92.520001] FS:  0000000000000000(0000) GS:ffff88013ba00000(0000)
knlGS:0000000000000000
[   92.520001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   92.520001] CR2: 0000000000000000 CR3: 0000000001803000 CR4: 00000000000006f0
[   92.520001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   92.520001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   92.520001] Process swapper (pid: 0, threadinfo ffffffff81800000,
task ffffffff8180b020)
[   92.520001] Stack:
[   92.520001]  ffffffff81061b36 ffffffff81061aa1 0000000000000000
ffffffff8107a50f
[   92.520001]  ffff880100000000 ffff880139195900 ffffffff81801fd8
ffff88013ba0e0d8
[   92.520001]  ffff88013ba03f50 ffffffff81801fd8 ffffffff81801fd8
0000000000000000
[   92.520001] Call Trace:
[   92.520001]  <IRQ>
[   92.520001]  [<ffffffff81061b36>] ? run_timer_softirq+0x186/0x6c0
[   92.520001]  [<ffffffff81061aa1>] ? run_timer_softirq+0xf1/0x6c0
[   92.520001]  [<ffffffff8107a50f>] ? __run_hrtimer+0x7f/0x370
[   92.520001]  [<ffffffff8105870c>] __do_softirq+0xbc/0x3e0
[   92.520001]  [<ffffffff8149d2cc>] call_softirq+0x1c/0x30
[   92.520001]  [<ffffffff8100433d>] do_softirq+0x8d/0xc0
[   92.520001]  [<ffffffff81058d86>] irq_exit+0x96/0xd0
[   92.520001]  [<ffffffff8149daad>] smp_apic_timer_interrupt+0x6d/0x9a
[   92.520001]  [<ffffffff8149ce53>] apic_timer_interrupt+0x13/0x20
[   92.520001]  <EOI>
[   92.520001]  [<ffffffff810886cf>] ? tick_nohz_stop_sched_tick+0x2af/0x400
[   92.520001]  [<ffffffff8100119d>] cpu_idle+0x2d/0xd0
[   92.520001]  [<ffffffff81474e7c>] rest_init+0xd0/0xe4
[   92.520001]  [<ffffffff81474dac>] ? csum_partial_copy_generic+0x16c/0x16c
[   92.520001]  [<ffffffff81a6eb84>] start_kernel+0x388/0x393
[   92.520001]  [<ffffffff81a6e322>] x86_64_start_reservations+0x132/0x136
[   92.520001]  [<ffffffff81a6e416>] x86_64_start_kernel+0xf0/0xf7
[   92.520001] Code:  Bad RIP value.
[   92.520001] RIP  [<          (null)>]           (null)
[   92.520001]  RSP <ffff88013ba03de8>
[   92.520001] CR2: 0000000000000000
[   92.520001] [drm:drm_crtc_helper_set_config],
[   92.520001] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:9]
#connectors=1 (x y) (0 0)
[   92.520001] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:LVDS-1]
to [CRTC:4]
[   92.520001] BUG: scheduling while atomic: swapper/0/0x00000103
[   92.520001] INFO: lockdep is turned off.
[   92.520001] Modules linked in: ip6_tables ebtable_nat ebtables
iptable_mangle xt_tcpudp tun bridge ipv6 stp llc sunrpc ipt_REJECT
xt_physdev xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables
dm_mirror dm_region_hash dm_log dm_mod snd_hda_codec_analog btusb
bluetooth virtio_net kvm_intel kvm arc4 ecb crypto_blkcipher cryptomgr
aead crypto_algapi snd_hda_intel iwl3945 snd_hda_codec snd_seq
snd_seq_device iwl_legacy snd_pcm wmi psmouse mac80211 serio_raw
e1000e thinkpad_acpi snd_timer iTCO_wdt cfg80211 snd i2c_i801
soundcore snd_page_alloc iTCO_vendor_support nvram evdev i915
drm_kms_helper drm i2c_algo_bit i2c_core uinput autofs4 usbhid hid
pcmcia sdhci_pci ehci_hcd uhci_hcd sdhci sr_mod mmc_core yenta_socket
cdrom usbcore video backlight [last unloaded: scsi_wait_scan]
[   92.520001] irq event stamp: 3031954
[   92.520001] hardirqs last  enabled at (3031954):
[<ffffffff81498217>] do_page_fault+0x2a7/0x550
[   92.520001] hardirqs last disabled at (3031953):
[<ffffffff81495843>] error_sti+0x5/0x6
[   92.520001] softirqs last  enabled at (3031948):
[<ffffffff810575c3>] _local_bh_enable+0x13/0x20
[   92.520001] softirqs last disabled at (3031949):
[<ffffffff8149d2cc>] call_softirq+0x1c/0x30
[   92.520001] CPU 0
[   92.520001] Modules linked in: ip6_tables ebtable_nat ebtables
iptable_mangle xt_tcpudp tun bridge ipv6 stp llc sunrpc ipt_REJECT
xt_physdev xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables
dm_mirror dm_region_hash dm_log dm_mod snd_hda_codec_analog btusb
bluetooth virtio_net kvm_intel kvm arc4 ecb crypto_blkcipher cryptomgr
aead crypto_algapi snd_hda_intel iwl3945 snd_hda_codec snd_seq
snd_seq_device iwl_legacy snd_pcm wmi psmouse mac80211 serio_raw
e1000e thinkpad_acpi snd_timer iTCO_wdt cfg80211 snd i2c_i801
soundcore snd_page_alloc iTCO_vendor_support nvram evdev i915
drm_kms_helper drm i2c_algo_bit i2c_core uinput autofs4 usbhid hid
pcmcia sdhci_pci ehci_hcd uhci_hcd sdhci sr_mod mmc_core yenta_socket
cdrom usbcore video backlight [last unloaded: scsi_wait_scan]
[   92.520001]
[   92.520001] Pid: 0, comm: swapper Not tainted
2.6.39-rc2-00005-gf04d4dc #120 LENOVO 6464CTO/6464CTO
[   92.520001] RIP: 0010:[<ffffffff810886cf>]  [<ffffffff810886cf>]
tick_nohz_stop_sched_tick+0x2af/0x400
[   92.520001] RSP: 0018:ffffffff81801eb8  EFLAGS: 00000202
[   92.520001] RAX: 00000000002e4389 RBX: 0000000000000001 RCX: 0000000000000000
[   92.520001] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff8180b020
[   92.520001] RBP: ffffffff81801f08 R08: 0000000000000000 R09: 0000000000000000
[   92.520001] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff8149ce4e
[   92.520001] R13: 000000158a6c17fe R14: 0000000100000001 R15: 00000000ffff0cda
[   92.520001] FS:  0000000000000000(0000) GS:ffff88013ba00000(0000)
knlGS:0000000000000000
[   92.520001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   92.520001] CR2: ffffffffffffffd5 CR3: 0000000001803000 CR4: 00000000000006f0
[   92.520001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   92.520001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   92.520001] Process swapper (pid: 0, threadinfo ffffffff81800000,
task ffffffff8180b020)
[   92.520001] Stack:
[   92.520001]  00000021d451b4ce 00000000ffff0cda 000000158a394c32
00000000ffff0cda
[   92.520001]  ffffffffffffffff ffffffff81801fd8 ffffffff818945c8
ffff88013bf8b880
[   92.520001]  ffffffffffffffff 0000000000000000 ffffffff81801f28
ffffffff8100119d
[   92.520001] Call Trace:
[   92.520001]  [<ffffffff8100119d>] cpu_idle+0x2d/0xd0
[   92.520001]  [<ffffffff81474e7c>] rest_init+0xd0/0xe4
[   92.520001]  [<ffffffff81474dac>] ? csum_partial_copy_generic+0x16c/0x16c
[   92.520001]  [<ffffffff81a6eb84>] start_kernel+0x388/0x393
[   92.520001]  [<ffffffff81a6e322>] x86_64_start_reservations+0x132/0x136
[   92.520001]  [<ffffffff81a6e416>] x86_64_start_kernel+0xf0/0xf7
[   92.520001] Code: 00 48 8b 45 c8 48 89 83 d0 00 00 00 49 8b 47 70
4c 29 f0 48 89 83 c8 00 00 00 41 f7 c5 00 02 00 00 74 21 e8 04 7f 00
00 41 55 9d
[   92.520001]  8b 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9
[   92.520001] Call Trace:
[   92.520001]  [<ffffffff8100119d>] cpu_idle+0x2d/0xd0
[   92.520001]  [<ffffffff81474e7c>] rest_init+0xd0/0xe4
[   92.520001]  [<ffffffff81474dac>] ? csum_partial_copy_generic+0x16c/0x16c
[   92.520001]  [<ffffffff81a6eb84>] start_kernel+0x388/0x393
[   92.520001]  [<ffffffff81a6e322>] x86_64_start_reservations+0x132/0x136
[   92.520001]  [<ffffffff81a6e416>] x86_64_start_kernel+0xf0/0xf7
[   93.421820] bad: scheduling from the idle thread!
[   93.423405] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: None




>
>> >> I've strong believe - it's the moment  where USB_DEBUG version was
>> >> printing those lines in endless loop.
>> >> (Or let say it this way:   More then few minutes loop  - as maybe it
>> >> will end within a week - but I don't have that much time to wait ;))
>> >
>> > Those debugging messages will continue for as long as the hardware
>> > fails to respond properly.
>>
>> Which is probably 'forever' when the machine is suspending.
>> (note - even SysRq+B  no longer works at this moment)
>
> No, when the machine is suspending there should not be any errors
> because there should not be any USB traffic.  All the ongoing transfers
> are cancelled as part of the suspend transition, and they start up
> again during resume.

Hmm so there could be some difference between  pm-suspend - and 'echo mem'
but why pm-suspend should initiate any USB traffic ??

Anyway I think current OOPS needs to be fixed first before any futher
debug could be done.

Zdenek
