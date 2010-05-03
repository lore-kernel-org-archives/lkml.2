Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab0ECTrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 15:47:01 -0400
Received: from legolas.restena.lu ([158.64.1.34]:40171 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303Ab0ECTq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 15:46:57 -0400
Date: Mon, 3 May 2010 21:46:42 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: s2ram slow (radeon) / failing (usb)
Message-ID: <20100503214642.67577f91@neptune.home>
In-Reply-To: <Pine.LNX.4.44L0.1005030950280.1651-100000@iolanthe.rowland.org>
References: <20100503083449.7355b457@pluto.restena.lu>
	<Pine.LNX.4.44L0.1005030950280.1651-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 May 2010 Alan Stern <stern@rowland.harvard.edu> wrote:
> You might also want to #define VERBOSE_DEBUG at the start of 
> drivers/usb/core/driver.c, before the first #include.

Still no difference... (will retry with own printk's in ohci's suspend
code as suggested in other mail)

Suspend output as it goes:
[  240.799757] PM: Syncing filesystems ... done.
[  240.836295] PM: Preparing system for mem sleep
[  240.841226] PM: Adding info for No Bus:vcs63
[  240.841295] PM: Adding info for No Bus:vcsa63
[  240.856296] Freezing user space processes ... (elapsed 0.02 seconds) done.
[  240.885352] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  240.912898] PM: Entering mem sleep
[  240.916676] pci 0000:00:00.0: preparing suspend
[  240.921565] pci 0000:00:00.0: __pm_runtime_resume()!
[  240.922690] pci 0000:00:00.0: __pm_runtime_resume() returns -11!
[  240.933301] pci 0000:00:01.0: preparing suspend
[  240.938169] pci 0000:00:01.0: __pm_runtime_resume()!
[  240.943294] pci 0000:00:01.0: __pm_runtime_resume() returns -11!
[  240.949932] pcieport 0000:00:04.0: preparing suspend
[  240.955269] pcieport 0000:00:04.0: __pm_runtime_resume()!
[  240.961075] pcieport 0000:00:04.0: __pm_runtime_resume() returns -11!
[  240.967976] pcieport 0000:00:05.0: preparing suspend
[  240.973321] pcieport 0000:00:05.0: __pm_runtime_resume()!
[  240.979144] pcieport 0000:00:05.0: __pm_runtime_resume() returns -11!
[  240.986044] pcieport 0000:00:06.0: preparing suspend
[  240.991390] pcieport 0000:00:06.0: __pm_runtime_resume()!
[  240.996038] pcieport 0000:00:06.0: __pm_runtime_resume() returns -11!
[  241.004046] ahci 0000:00:12.0: preparing suspend
[  241.009011] ahci 0000:00:12.0: __pm_runtime_resume()!
[  241.012784] ahci 0000:00:12.0: __pm_runtime_resume() returns -11!
[  241.020884] ohci_hcd 0000:00:13.0: preparing suspend
[  241.026113] ohci_hcd 0000:00:13.0: __pm_runtime_resume()!
[  241.031739] ohci_hcd 0000:00:13.0: __pm_runtime_resume() returns -11!
[  241.038545] ohci_hcd 0000:00:13.1: preparing suspend
[  241.043779] ohci_hcd 0000:00:13.1: __pm_runtime_resume()!
[  241.049429] ohci_hcd 0000:00:13.1: __pm_runtime_resume() returns -11!
[  241.056232] ohci_hcd 0000:00:13.2: preparing suspend
[  241.061501] ohci_hcd 0000:00:13.2: __pm_runtime_resume()!
[  241.066210] ohci_hcd 0000:00:13.2: __pm_runtime_resume() returns -11!
[  241.073982] ohci_hcd 0000:00:13.3: preparing suspend
[  241.079209] ohci_hcd 0000:00:13.3: __pm_runtime_resume()!
[  241.083978] ohci_hcd 0000:00:13.3: __pm_runtime_resume() returns -11!
[  241.091705] ohci_hcd 0000:00:13.4: preparing suspend
[  241.096954] ohci_hcd 0000:00:13.4: __pm_runtime_resume()!
[  241.102608] ohci_hcd 0000:00:13.4: __pm_runtime_resume() returns -11!
[  241.109401] ehci_hcd 0000:00:13.5: preparing suspend
[  241.114626] ehci_hcd 0000:00:13.5: __pm_runtime_resume()!
[  241.120298] ehci_hcd 0000:00:13.5: __pm_runtime_resume() returns -11!
[  241.127132] pci 0000:00:14.0: preparing suspend
[  241.131878] pci 0000:00:14.0: __pm_runtime_resume()!
[  241.137112] pci 0000:00:14.0: __pm_runtime_resume() returns -11!
[  241.143462] pata_atiixp 0000:00:14.1: preparing suspend
[  241.148974] pata_atiixp 0000:00:14.1: __pm_runtime_resume()!
[  241.153458] pata_atiixp 0000:00:14.1: __pm_runtime_resume() returns -11!
[  241.162017] pci 0000:00:14.3: preparing suspend
[  241.166791] pci 0000:00:14.3: __pm_runtime_resume()!
[  241.172030] pci 0000:00:14.3: __pm_runtime_resume() returns -11!
[  241.178371] pci 0000:00:14.4: preparing suspend
[  241.183180] pci 0000:00:14.4: __pm_runtime_resume()!
[  241.188425] pci 0000:00:14.4: __pm_runtime_resume() returns -11!
[  241.194795] ATI IXP AC97 controller 0000:00:14.5: preparing suspend
[  241.201407] ATI IXP AC97 controller 0000:00:14.5: __pm_runtime_resume()!
[  241.204791] ATI IXP AC97 controller 0000:00:14.5: __pm_runtime_resume() returns -11!
[  241.216634] pci 0000:00:18.0: preparing suspend
[  241.221378] pci 0000:00:18.0: __pm_runtime_resume()!
[  241.226595] pci 0000:00:18.0: __pm_runtime_resume() returns -11!
[  241.232937] pci 0000:00:18.1: preparing suspend
[  241.237713] pci 0000:00:18.1: __pm_runtime_resume()!
[  241.242914] pci 0000:00:18.1: __pm_runtime_resume() returns -11!
[  241.249257] pci 0000:00:18.2: preparing suspend
[  241.254040] pci 0000:00:18.2: __pm_runtime_resume()!
[  241.259258] pci 0000:00:18.2: __pm_runtime_resume() returns -11!
[  241.265596] k8temp 0000:00:18.3: preparing suspend
[  241.270630] k8temp 0000:00:18.3: __pm_runtime_resume()!
[  241.275592] k8temp 0000:00:18.3: __pm_runtime_resume() returns -11!
[  241.282736] radeon 0000:01:05.0: preparing suspend
[  241.287782] radeon 0000:01:05.0: __pm_runtime_resume()!
[  241.292731] radeon 0000:01:05.0: __pm_runtime_resume() returns -11!
[  241.299889] tg3 0000:02:00.0: preparing suspend, may wakeup
[  241.305772] tg3 0000:02:00.0: __pm_runtime_resume()!
[  241.310981] tg3 0000:02:00.0: __pm_runtime_resume() returns -11!
[  241.317342] tg3 0000:03:00.0: preparing suspend, may wakeup
[  241.323224] tg3 0000:03:00.0: __pm_runtime_resume()!
[  241.328427] tg3 0000:03:00.0: __pm_runtime_resume() returns -11!
[  241.334806] platform pcspkr: preparing suspend
[  241.339497] platform microcode: preparing suspend
[  241.344506] serial8250 serial8250: preparing suspend
[  241.349717] i8042 i8042: preparing suspend
[  241.354050] it87 it87.3712: preparing suspend
[  241.358651] usb usb1: preparing type suspend, may wakeup
[  241.364247] usb usb2: preparing type suspend, may wakeup
[  241.369847] usb usb3: preparing type suspend, may wakeup
[  241.375443] usb usb4: preparing type suspend, may wakeup
[  241.381044] usb usb5: preparing type suspend, may wakeup
[  241.386643] usb usb6: preparing type suspend, may wakeup
[  241.392244] usb 1-2: preparing type suspend, may wakeup
[  241.397762] usb 1-2.1: preparing type suspend, may wakeup
[  241.403489] input input3: type suspend
[  241.407449] ac97 0-0:ALC655: legacy suspend
[  241.407504] usbhid 1-2.1:1.1: suspend
[  241.407511] usbhid 1-2.1:1.0: suspend
[  241.407516] usb 1-2.1: type suspend, may wakeup
[  241.424326] it87 it87.3712: suspend
[  241.427983] input input2: type suspend
[  241.431940] rtc rtc0: legacy class suspend
[  241.436286] serio serio1: suspend
[  241.439780] atkbd serio0: suspend
[  241.443340] hub 1-2:1.0: suspend
[  241.446753] i8042 i8042: suspend
[  241.450182] serial8250 serial8250: suspend
[  241.454544] drm card0-HDMI Type A-1: legacy class suspend
[  241.460195] i2c i2c-2: suspend
[  241.463426] drm card0-DVI-D-1: legacy class suspend
[  241.468569] i2c i2c-1: suspend
[  241.471778] drm card0-SVIDEO-1: legacy class suspend
[  241.477014] drm card0-VGA-1: legacy class suspend
[  241.481966] i2c i2c-0: suspend
[  241.485216] drm card0: legacy class suspend
[  241.489630] drm controlD64: legacy class suspend
[  241.494495] drm ttm: legacy class suspend
[  241.498731] input input1: type suspend
[  241.502694] input input0: type suspend
[  241.506655] platform microcode: suspend
[  241.510684] platform pcspkr: suspend
[  241.514454] system 00:11: legacy suspend
[  241.518563] system 00:10: legacy suspend
[  241.522713] ACPI handle has no context!
[  241.526767] system 00:0f: legacy suspend
[  241.530894] system 00:0e: legacy suspend
[  241.535049] system 00:0d: legacy suspend
[  241.539187] pnp 00:0c: legacy suspend
[  241.543048] pnp 00:0b: legacy suspend
[  241.546900] system 00:0a: legacy suspend
[  241.551020] pnp 00:09: legacy suspend
[  241.554904] pnp 00:08: legacy suspend
[  241.558730] pnp 00:07: legacy suspend
[  241.562590] pnp 00:06: legacy suspend
[  241.566468] i8042 aux 00:05: legacy suspend
[  241.570893] i8042 kbd 00:04: legacy suspend
[  241.575315] rtc_cmos 00:03: legacy suspend, may wakeup
[  241.580736] pnp 00:02: legacy suspend
[  241.584616] system 00:01: legacy suspend
[  241.588742] pnp 00:00: legacy suspend
[  241.592651] button LNXPWRBN:00: legacy suspend
[  241.597321] acpi LNXTHERM:00: legacy suspend
[  241.601786] pci_link PNP0C0F:07: legacy suspend
[  241.606563] pci_link PNP0C0F:06: legacy suspend
[  241.611325] pci_link PNP0C0F:05: legacy suspend
[  241.616114] pci_link PNP0C0F:04: legacy suspend
[  241.620885] pci_link PNP0C0F:03: legacy suspend
[  241.625667] pci_link PNP0C0F:02: legacy suspend
[  241.630426] pci_link PNP0C0F:01: legacy suspend
[  241.635217] pci_link PNP0C0F:00: legacy suspend
[  241.639987] button PNP0C0C:00: legacy suspend
[  241.644575] acpi PNP0C01:00: legacy suspend
[  241.648965] acpi device:24: legacy suspend
[  241.653303] acpi device:23: legacy suspend
[  241.657614] acpi device:22: legacy suspend
[  241.661925] acpi device:21: legacy suspend
[  241.666251] acpi device:20: legacy suspend
[  241.670537] acpi device:1f: legacy suspend
[  241.674874] acpi device:1e: legacy suspend
[  241.679168] acpi device:1d: legacy suspend
[  241.683463] acpi device:1c: legacy suspend
[  241.687791] acpi device:1b: legacy suspend
[  241.692102] acpi device:1a: legacy suspend
[  241.696438] acpi device:19: legacy suspend
[  241.700767] acpi device:18: legacy suspend
[  241.705095] acpi device:17: legacy suspend
[  241.709415] acpi device:16: legacy suspend
[  241.713773] acpi device:15: legacy suspend
[  241.718047] acpi device:14: legacy suspend
[  241.722330] acpi device:13: legacy suspend
[  241.726651] acpi device:12: legacy suspend
[  241.730925] acpi PNP0C02:05: legacy suspend
[  241.735369] acpi PNP0C02:04: legacy suspend
[  241.739767] acpi PNP0C02:03: legacy suspend
[  241.744198] acpi PNP0C02:02: legacy suspend
[  241.748597] acpi PNP0501:03: legacy suspend
[  241.753032] acpi PNP0501:02: legacy suspend
[  241.757420] acpi PNP0C02:01: legacy suspend
[  241.761808] acpi PNP0501:01: legacy suspend
[  241.766239] acpi PNP0501:00: legacy suspend
[  241.770636] acpi PNP0C04:00: legacy suspend
[  241.775052] acpi PNP0800:00: legacy suspend
[  241.779443] acpi PNP0F03:00: legacy suspend
[  241.783857] acpi PNP0303:00: legacy suspend
[  241.788320] acpi PNP0B00:00: legacy suspend
[  241.792746] acpi PNP0100:00: legacy suspend
[  241.797121] acpi PNP0200:00: legacy suspend
[  241.801558] acpi PNP0000:00: legacy suspend
[  241.805973] acpi device:11: legacy suspend
[  241.810262] acpi device:10: legacy suspend
[  241.814600] acpi device:0f: legacy suspend
[  241.818883] acpi device:0e: legacy suspend
[  241.823213] acpi device:0d: legacy suspend
[  241.827524] acpi device:0c: legacy suspend
[  241.831825] acpi device:0b: legacy suspend
[  241.836163] acpi device:0a: legacy suspend
[  241.840464] acpi device:09: legacy suspend
[  241.844814] acpi device:08: legacy suspend
[  241.849113] acpi device:07: legacy suspend
[  241.853434] acpi device:06: legacy suspend
[  241.857754] acpi device:05: legacy suspend
[  241.862064] acpi device:04: legacy suspend
[  241.866399] acpi device:03: legacy suspend
[  241.870737] acpi device:02: legacy suspend
[  241.875066] acpi device:01: legacy suspend
[  241.879386] acpi PNP0C02:00: legacy suspend
[  241.883820] acpi device:00: legacy suspend
[  241.888135] pci_root PNP0A03:00: legacy suspend
[  241.892920] acpi LNXSYBUS:00: legacy suspend
[  241.897412] processor LNXCPU:01: legacy suspend
[  241.902183] processor LNXCPU:00: legacy suspend
[  241.906968] acpi LNXSYSTM:00: legacy suspend
[  241.911502] hub 6-0:1.0: suspend
[  241.914928] usb usb6: type suspend, may wakeup
[  241.919583] usb usb6: usb_suspend_both: status 0
[  241.924448] usb usb6: suspend, may wakeup
[  241.928663] hub 5-0:1.0: suspend
[  241.932082] usb usb5: type suspend, may wakeup
[  241.936794] usb usb5: usb_suspend_both: status 0
[  241.941669] usb usb5: suspend, may wakeup
[  241.945888] hub 4-0:1.0: suspend
[  241.949294] usb usb4: type suspend, may wakeup
[  241.953966] usb usb4: usb_suspend_both: status 0
[  241.958814] usb usb4: suspend, may wakeup
[  241.963069] hub 3-0:1.0: suspend
[  241.966452] usb usb3: type suspend, may wakeup
[  241.971126] usb usb3: usb_suspend_both: status 0
[  241.976015] usb usb3: suspend, may wakeup
[  241.980232] hub 2-0:1.0: suspend
[  241.983662] usb usb2: type suspend, may wakeup
[  241.988316] usb usb2: usb_suspend_both: status 0
[  241.993192] usb usb2: suspend, may wakeup
[  241.997418] hub 1-0:1.0: suspend
[  242.000845] scsi host5: legacy suspend
[  242.004816] scsi host4: legacy suspend
[  242.008763] sd 2:0:0:0: legacy suspend
[  242.012724] sd 2:0:0:0: [sdc] Synchronizing SCSI cache
[  242.018225] sd 1:0:0:0: legacy suspend
[  242.022183] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
[  242.027659] sd 2:0:0:0: [sdc] Stopping disk
[  242.032043] sd 1:0:0:0: [sdb] Stopping disk
[  242.036463] sd 0:0:0:0: legacy suspend
[  242.040388] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  242.045841] scsi host3: legacy suspend
[  242.049785] sd 0:0:0:0: [sda] Stopping disk
[  242.054264] tg3 0000:03:00.0: suspend, may wakeup
[  242.059237] tg3 0000:02:00.0: suspend, may wakeup
[  242.064265] radeon 0000:01:05.0: suspend
[  242.069414] radeon 0000:01:05.0: PCI INT A disabled
[  242.074573] k8temp 0000:00:18.3: suspend
[  242.078705] pci 0000:00:18.2: suspend
[  242.082574] pci 0000:00:18.1: suspend
[  242.086415] pci 0000:00:18.0: suspend
[  242.090250] ATI IXP AC97 controller 0000:00:14.5: suspend
[  242.096176] ATI IXP AC97 controller 0000:00:14.5: PCI INT B disabled
[  242.102879] pci 0000:00:14.4: suspend
[  242.106732] pci 0000:00:14.3: suspend
[  242.110584] pata_atiixp 0000:00:14.1: suspend
[  242.115193] pata_atiixp 0000:00:14.1: Suspending ATA host device ...
[  242.121882] pci 0000:00:14.0: suspend
[  242.125768] ehci_hcd 0000:00:13.5: suspend
[  242.130076] ehci_hcd 0000:00:13.5: PCI INT D disabled
[  242.135410] ohci_hcd 0000:00:13.4: suspend
[  242.139696] ohci_hcd 0000:00:13.4: PCI INT C disabled
[  242.145035] ohci_hcd 0000:00:13.3: suspend
[  242.149348] ohci_hcd 0000:00:13.3: PCI INT B disabled
[  242.154705] ohci_hcd 0000:00:13.2: suspend
[  242.159012] ohci_hcd 0000:00:13.2: PCI INT C disabled
[  242.164342] ohci_hcd 0000:00:13.1: suspend
[  242.168676] ohci_hcd 0000:00:13.1: PCI INT B disabled
[  242.174066] pata_atiixp 0000:00:14.1: Saving PCI state ...
[  242.179885] pata_atiixp 0000:00:14.1: Disabling PCI device ...
[  242.186031] pata_atiixp 0000:00:14.1: PCI INT A disabled
[  242.191624] pata_atiixp 0000:00:14.1: Switching PCI device to D3hot...
[  242.198489] pata_atiixp 0000:00:14.1: Done suspending :)
[  242.204075] pcieport 0000:00:06.0: suspend
[  242.208357] pcieport 0000:00:05.0: suspend
[  242.212693] pci 0000:00:01.0: suspend
[  242.216521] pci 0000:00:00.0: suspend
[  242.985841] scsi target1:0:0: legacy suspend
[  242.990342] scsi host1: legacy suspend
[  243.025081] scsi target0:0:0: legacy suspend
[  243.029566] scsi host0: legacy suspend
[  243.061680] scsi target2:0:0: legacy suspend
[  243.066199] scsi host2: legacy suspend
[  243.070126] ahci 0000:00:12.0: suspend
[  243.173296] ahci 0000:00:12.0: PCI INT A disabled
    ^ blocked here for already over 15 minutes

I guess here PM is waiting for ohci_hcd 0000:00:13.0 to suspend
and disable its interrupt.
(and that last ohci device would match the usbhid_resume thread that's
frozen...)

Note, that same keyboard connected to a single-code VIA system
(!CONFIG_SMP) does not prevent suspend over there.


For keyboard details, see http://lkml.org/lkml/2010/2/8/211


At this point I can toggle caps LED via USB keyboard but PS2 keyboard
is already suspended and does not respond anymore.

A dump of all processes that I think are pertinent (sysrq-t via the
USB keyboard):
[ 1777.641295] khubd         D 0000000000000004     0   922      2 0x00000000
[ 1777.641295]  ffff88007a21dcd0 0000000000000046 ffff88007a21dfd8 ffff8800798de820
[ 1777.641295]  ffff88007a21dfd8 ffff88007a21dfd8 00000000000129c0 00000000000129c0
[ 1777.641295]  ffff8800798de820 ffff88007cebe820 ffff88007a21dfd8 ffff88007a21dfd8
[ 1777.641295] Call Trace:
[ 1777.641295]  [<ffffffff8105d765>] refrigerator+0x95/0xf0
[ 1777.641295]  [<ffffffffa004cb39>] hub_thread+0xa9/0x1720 [usbcore]
[ 1777.641295]  [<ffffffff8103a179>] ? select_task_rq_fair+0x509/0x7f0
[ 1777.641295]  [<ffffffff81055e90>] ? autoremove_wake_function+0x0/0x40
[ 1777.641295]  [<ffffffffa004ca90>] ? hub_thread+0x0/0x1720 [usbcore]
[ 1777.641295]  [<ffffffff810559be>] kthread+0x8e/0xa0
[ 1777.641295]  [<ffffffff81003a94>] kernel_thread_helper+0x4/0x10
[ 1777.641295]  [<ffffffff81055930>] ? kthread+0x0/0xa0
[ 1777.641295]  [<ffffffff81003a90>] ? kernel_thread_helper+0x0/0x10
[ 1777.641295] usbhid_resume D ffff88007a0f7fd8     0  1148      2 0x00000000
[ 1777.641295]  ffff88007a0f7e20 0000000000000046 ffff88007a0f7fd8 ffff88007cec8040
[ 1777.641295]  ffff88007a0f7fd8 ffff88007a0f7fd8 00000000000129c0 00000000000129c0
[ 1777.641295]  ffff88007cec8040 ffff8800798de820 ffff88007a0f7fd8 ffff88007a0f7fd8
[ 1777.641295] Call Trace:
[ 1777.641295]  [<ffffffff8105d765>] refrigerator+0x95/0xf0
[ 1777.641295]  [<ffffffff81051a16>] worker_thread+0xc6/0x1e0
[ 1777.641295]  [<ffffffff81055e90>] ? autoremove_wake_function+0x0/0x40
[ 1777.641295]  [<ffffffff81051950>] ? worker_thread+0x0/0x1e0
[ 1777.641295]  [<ffffffff810559be>] kthread+0x8e/0xa0
[ 1777.641295]  [<ffffffff81003a94>] kernel_thread_helper+0x4/0x10
[ 1777.641295]  [<ffffffff81055930>] ? kthread+0x0/0xa0
[ 1777.641295]  [<ffffffff81003a90>] ? kernel_thread_helper+0x0/0x10
[ 1777.641295] async/0       R  running task        0  2211      2 0x00000008
[ 1777.641295]  ffff88007a08be70 ffffffff8130a504 0000000000000246 ffff88007a3398c0
[ 1777.641295]  ffff88007a08bee0 ffffffff8105c772 0000000000000000 ffff88007cdf9820
[ 1777.641295]  ffffffff81037620 ffff88007ce13ea8 ffff88007993fe98 0000000000000001
[ 1777.641295] Call Trace:
[ 1777.641295]  [<ffffffff8130a504>] ? async_suspend+0x24/0x60
[ 1777.641295]  [<ffffffff8105c772>] async_thread+0x112/0x280
[ 1777.641295]  [<ffffffff81037620>] ? default_wake_function+0x0/0x10
[ 1777.641295]  [<ffffffff8105c660>] ? async_thread+0x0/0x280
[ 1777.641295]  [<ffffffff810559be>] kthread+0x8e/0xa0
[ 1777.641295]  [<ffffffff81003a94>] kernel_thread_helper+0x4/0x10
[ 1777.641295]  [<ffffffff81055930>] ? kthread+0x0/0xa0
[ 1777.641295]  [<ffffffff81003a90>] ? kernel_thread_helper+0x0/0x10
[ 1777.641295] async/1       D 0000000000000000     0  2212      2 0x00000000
[ 1777.641295]  ffff88007993fc80 0000000000000046 ffff88007993ffd8 ffff88007cdd8820
[ 1777.641295]  ffff88007993ffd8 ffff88007993ffd8 00000000000129c0 00000000000129c0
[ 1777.641295]  ffff88007cdd8820 ffff88007cdba820 0000000000000010 0000000000000246
[ 1777.641295] Call Trace:
[ 1777.641295]  [<ffffffff8146838d>] schedule_timeout+0x19d/0x230
[ 1777.641295]  [<ffffffff81467961>] wait_for_common+0xe1/0x170
[ 1777.641295]  [<ffffffff81037620>] ? default_wake_function+0x0/0x10
[ 1777.641295]  [<ffffffff813092f0>] ? dpm_wait_fn+0x0/0x40
[ 1777.641295]  [<ffffffff81467a88>] wait_for_completion+0x18/0x20
[ 1777.641295]  [<ffffffff8130931f>] dpm_wait_fn+0x2f/0x40
[ 1777.641295]  [<ffffffff81302188>] device_for_each_child+0x48/0x70
[ 1777.641295]  [<ffffffff81309e68>] __device_suspend+0x38/0x1e0
[ 1777.641295]  [<ffffffff8130a504>] async_suspend+0x24/0x60
[ 1777.641295]  [<ffffffff8105c772>] async_thread+0x112/0x280
[ 1777.641295]  [<ffffffff81037620>] ? default_wake_function+0x0/0x10
[ 1777.641295]  [<ffffffff8105c660>] ? async_thread+0x0/0x280
[ 1777.641295]  [<ffffffff810559be>] kthread+0x8e/0xa0
[ 1777.641295]  [<ffffffff81003a94>] kernel_thread_helper+0x4/0x10
[ 1777.641295]  [<ffffffff81055930>] ? kthread+0x0/0xa0
[ 1777.641295]  [<ffffffff81003a90>] ? kernel_thread_helper+0x0/0x10
[ 1777.641295] async/2       D 0000000000000000     0  2213      2 0x00000000
[ 1777.641295]  ffff88007b737c80 0000000000000046 ffff88007b737fd8 ffff88007cec3040
[ 1777.641295]  ffff88007b737fd8 ffff88007b737fd8 00000000000129c0 00000000000129c0
[ 1777.641295]  ffff88007cec3040 ffff88007cf32040 000000000000000f 000000000000002a
[ 1777.641295] Call Trace:
[ 1777.641295]  [<ffffffff8146838d>] schedule_timeout+0x19d/0x230
[ 1777.641295]  [<ffffffff81467961>] wait_for_common+0xe1/0x170
[ 1777.641295]  [<ffffffff81037620>] ? default_wake_function+0x0/0x10
[ 1777.641295]  [<ffffffff813092f0>] ? dpm_wait_fn+0x0/0x40
[ 1777.641295]  [<ffffffff81467a88>] wait_for_completion+0x18/0x20
[ 1777.641295]  [<ffffffff8130931f>] dpm_wait_fn+0x2f/0x40
[ 1777.641295]  [<ffffffff81302188>] device_for_each_child+0x48/0x70
[ 1777.641295]  [<ffffffff81309e68>] __device_suspend+0x38/0x1e0
[ 1777.641295]  [<ffffffff8130a504>] async_suspend+0x24/0x60
[ 1777.641295]  [<ffffffff8105c772>] async_thread+0x112/0x280
[ 1777.641295]  [<ffffffff81037620>] ? default_wake_function+0x0/0x10
[ 1777.641295]  [<ffffffff8105c660>] ? async_thread+0x0/0x280
[ 1777.641295]  [<ffffffff810559be>] kthread+0x8e/0xa0
[ 1777.641295]  [<ffffffff81003a94>] kernel_thread_helper+0x4/0x10
[ 1777.641295]  [<ffffffff81055930>] ? kthread+0x0/0xa0
[ 1777.641295]  [<ffffffff81003a90>] ? kernel_thread_helper+0x0/0x10
[ 1777.641295] async/12      D 0000000000000000     0  2223      2 0x00000000
[ 1777.641295]  ffff88007a37db60 0000000000000046 ffff88007a37dfd8 ffff88007c531820
[ 1777.641295]  ffff88007a37dfd8 ffff88007a37dfd8 00000000000129c0 00000000000129c0
[ 1777.641295]  ffff88007c531820 ffff88007c53a040 0000000000000035 ffffffff812fd610
[ 1777.641295] Call Trace:
[ 1777.641295]  [<ffffffff812fd610>] ? serial8250_console_putchar+0x0/0x40
[ 1777.641295]  [<ffffffff8146838d>] schedule_timeout+0x19d/0x230
[ 1777.641295]  [<ffffffff8138d658>] ? pci_conf1_read+0xd8/0x110
[ 1777.641295]  [<ffffffff81467961>] wait_for_common+0xe1/0x170
[ 1777.641295]  [<ffffffff81037620>] ? default_wake_function+0x0/0x10
[ 1777.641295]  [<ffffffff81467a88>] wait_for_completion+0x18/0x20
[ 1777.641295]  [<ffffffff81051d43>] flush_cpu_workqueue+0x53/0x80
[ 1777.641295]  [<ffffffff81051e40>] ? wq_barrier_func+0x0/0x10
[ 1777.641295]  [<ffffffff81051f94>] flush_workqueue+0x44/0x70
[ 1777.641295]  [<ffffffff81051fd0>] flush_scheduled_work+0x10/0x20
[ 1777.641295]  [<ffffffffa0014229>] tg3_suspend+0x59/0x270 [tg3]
[ 1777.641295]  [<ffffffff811d036f>] pci_pm_suspend+0x6f/0x1a0
[ 1777.641295]  [<ffffffff81309a96>] pm_op+0x76/0xd0
[ 1777.641295]  [<ffffffff81309f77>] __device_suspend+0x147/0x1e0
[ 1777.641295]  [<ffffffff8130a504>] async_suspend+0x24/0x60
[ 1777.641295]  [<ffffffff8105c772>] async_thread+0x112/0x280
[ 1777.641295]  [<ffffffff81037620>] ? default_wake_function+0x0/0x10
[ 1777.641295]  [<ffffffff8105c660>] ? async_thread+0x0/0x280
[ 1777.641295]  [<ffffffff810559be>] kthread+0x8e/0xa0
[ 1777.641295]  [<ffffffff81003a94>] kernel_thread_helper+0x4/0x10
[ 1777.641295]  [<ffffffff81055930>] ? kthread+0x0/0xa0
[ 1777.641295]  [<ffffffff81003a90>] ? kernel_thread_helper+0x0/0x10
[ 1777.641295] async/14      D 0000000000000000     0  2225      2 0x00000000
[ 1777.641295]  ffff8800784f7c80 0000000000000046 ffff8800784f7fd8 ffff88007cf49820
[ 1777.641295]  ffff8800784f7fd8 ffff8800784f7fd8 00000000000129c0 00000000000129c0
[ 1777.641295]  ffff88007cf49820 ffff88007c53a040 0000000000000010 0000000000000246
[ 1777.641295] Call Trace:
[ 1777.641295]  [<ffffffff8146838d>] schedule_timeout+0x19d/0x230
[ 1777.641295]  [<ffffffff81467961>] wait_for_common+0xe1/0x170
[ 1777.641295]  [<ffffffff811d5b10>] ? suspend_iter+0x0/0x40
[ 1777.641295]  [<ffffffff81037620>] ? default_wake_function+0x0/0x10
[ 1777.641295]  [<ffffffff813092f0>] ? dpm_wait_fn+0x0/0x40
[ 1777.641295]  [<ffffffff81467a88>] wait_for_completion+0x18/0x20
[ 1777.641295]  [<ffffffff8130931f>] dpm_wait_fn+0x2f/0x40
[ 1777.641295]  [<ffffffff81302188>] device_for_each_child+0x48/0x70
[ 1777.641295]  [<ffffffff81309e68>] __device_suspend+0x38/0x1e0
[ 1777.641295]  [<ffffffff8130a504>] async_suspend+0x24/0x60
[ 1777.641295]  [<ffffffff8105c772>] async_thread+0x112/0x280
[ 1777.641295]  [<ffffffff81037620>] ? default_wake_function+0x0/0x10
[ 1777.641295]  [<ffffffff8105c660>] ? async_thread+0x0/0x280
[ 1777.641295]  [<ffffffff810559be>] kthread+0x8e/0xa0
[ 1777.641295]  [<ffffffff81003a94>] kernel_thread_helper+0x4/0x10
[ 1777.641295]  [<ffffffff81055930>] ? kthread+0x0/0xa0
[ 1777.641295]  [<ffffffff81003a90>] ? kernel_thread_helper+0x0/0x10
[ 1777.641295] async/15      D 0000000000000000     0  2226      2 0x00000000
[ 1777.641295]  ffff88007912dc80 0000000000000046 ffff88007912dfd8 ffff88007cf3c820
[ 1777.641295]  ffff88007912dfd8 ffff88007912dfd8 00000000000129c0 00000000000129c0
[ 1777.641295]  ffff88007cf3c820 ffff88007c53a040 0000000000000002 0000000000000113
[ 1777.641295] Call Trace:
[ 1777.641295]  [<ffffffff8146838d>] schedule_timeout+0x19d/0x230
[ 1777.641295]  [<ffffffff811f661c>] ? acpi_pci_irq_lookup+0x42/0x1b1
[ 1777.641295]  [<ffffffff811f67ff>] ? acpi_pci_irq_disable+0x74/0x7d
[ 1777.641295]  [<ffffffff81467961>] wait_for_common+0xe1/0x170
[ 1777.641295]  [<ffffffff81037620>] ? default_wake_function+0x0/0x10
[ 1777.641295]  [<ffffffff813092f0>] ? dpm_wait_fn+0x0/0x40
[ 1777.641295]  [<ffffffff81467a88>] wait_for_completion+0x18/0x20
[ 1777.641295]  [<ffffffff8130931f>] dpm_wait_fn+0x2f/0x40
[ 1777.641295]  [<ffffffff81302188>] device_for_each_child+0x48/0x70
[ 1777.641295]  [<ffffffff81309e68>] __device_suspend+0x38/0x1e0
[ 1777.641295]  [<ffffffff8130a504>] async_suspend+0x24/0x60
[ 1777.641295]  [<ffffffff8105c772>] async_thread+0x112/0x280
[ 1777.641295]  [<ffffffff81037620>] ? default_wake_function+0x0/0x10
[ 1777.641295]  [<ffffffff8105c660>] ? async_thread+0x0/0x280
[ 1777.641295]  [<ffffffff810559be>] kthread+0x8e/0xa0
[ 1777.641295]  [<ffffffff81003a94>] kernel_thread_helper+0x4/0x10
[ 1777.641295]  [<ffffffff81055930>] ? kthread+0x0/0xa0
[ 1777.641295]  [<ffffffff81003a90>] ? kernel_thread_helper+0x0/0x10
[ 1777.641295] async/16      D 0000000000000000     0  2227      2 0x00000000
[ 1777.641295]  ffff880079b89c80 0000000000000046 ffff880079b89fd8 ffff88007a8d3820
[ 1777.641295]  ffff880079b89fd8 ffff880079b89fd8 00000000000129c0 00000000000129c0
[ 1777.641295]  ffff88007a8d3820 ffff88007c53a040 000000000000000f 000000000000002f
[ 1777.641295] Call Trace:
[ 1777.641295]  [<ffffffff8146838d>] schedule_timeout+0x19d/0x230
[ 1777.641295]  [<ffffffff81467961>] wait_for_common+0xe1/0x170
[ 1777.641295]  [<ffffffff81037620>] ? default_wake_function+0x0/0x10
[ 1777.641295]  [<ffffffff813092f0>] ? dpm_wait_fn+0x0/0x40
[ 1777.641295]  [<ffffffff81467a88>] wait_for_completion+0x18/0x20
[ 1777.641295]  [<ffffffff8130931f>] dpm_wait_fn+0x2f/0x40
[ 1777.641295]  [<ffffffff81302188>] device_for_each_child+0x48/0x70
[ 1777.641295]  [<ffffffff81309e68>] __device_suspend+0x38/0x1e0
[ 1777.641295]  [<ffffffff8130a504>] async_suspend+0x24/0x60
[ 1777.641295]  [<ffffffff8105c772>] async_thread+0x112/0x280
[ 1777.641295]  [<ffffffff81037620>] ? default_wake_function+0x0/0x10
[ 1777.641295]  [<ffffffff8105c660>] ? async_thread+0x0/0x280
[ 1777.641295]  [<ffffffff810559be>] kthread+0x8e/0xa0
[ 1777.641295]  [<ffffffff81003a94>] kernel_thread_helper+0x4/0x10
[ 1777.641295]  [<ffffffff81055930>] ? kthread+0x0/0xa0
[ 1777.641295]  [<ffffffff81003a90>] ? kernel_thread_helper+0x0/0x10
