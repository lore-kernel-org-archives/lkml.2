Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966249Ab2EPBa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:30:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23491 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab2EPBaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:30:25 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Y-zaDMMdLwAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=bJFL23k2Gy_HPBSVZZUA:9 a=QcM2ZoRJ_6_pSaXaSaQA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337131823.6724.11.camel@gandalf.stny.rr.com>
Subject: [WARNING] at kernel/irq/manage.c:421 __enable_irq
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 15 May 2012 21:30:23 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting this on my main box. I'm running 3.3.6 but I also tried out
the latest Linus kernel (as of yesterday) and it has it too:

[    1.572757] ------------[ cut here ]------------
[    1.573063] WARNING: at /home/rostedt/work/git/nobackup/linux-build.git/kerne
l/irq/manage.c:421 __enable_irq+0x38/0xc0()
[    1.573663] Hardware name: System Product Name
[    1.573936] Unbalanced enable for IRQ 16
[    1.574184] Modules linked in: usb_storage ata_generic(+) uas ohci_hcd ata_pi
ix via82cxxx(+) ehci_hcd libata scsi_mod ide_pci_generic ide_core xhci_hcd r8169
 mii usbcore usb_common
[    1.575829] Pid: 177, comm: modprobe Not tainted 3.3.6-custom+ #2
[    1.576185] Call Trace:
[    1.576364]  [<ffffffff8103789f>] warn_slowpath_common+0x7f/0xc0
[    1.576717]  [<ffffffff81037996>] warn_slowpath_fmt+0x46/0x50
[    1.577055]  [<ffffffff810b9d68>] __enable_irq+0x38/0xc0
[    1.577372]  [<ffffffff810b9e37>] enable_irq+0x47/0x90
[    1.577684]  [<ffffffffa00b5938>] ide_probe_port+0x398/0x6a0 [ide_core]
[    1.578067]  [<ffffffff8132b09b>] ? dmi_check_system+0x2b/0x60
[    1.578410]  [<ffffffffa00b5fc9>] ide_host_register+0x2d9/0x730 [ide_core]
[    1.578807]  [<ffffffffa00bbbba>] ide_pci_init_two+0x4ba/0x7c0 [ide_core]
[    1.579198]  [<ffffffff8106e501>] ? get_parent_ip+0x11/0x50
[    1.579530]  [<ffffffff81448edd>] ? sub_preempt_count+0x9d/0xd0
[    1.579878]  [<ffffffff81445746>] ? _raw_spin_unlock+0x16/0x40
[    1.580224]  [<ffffffffa00bbed6>] ide_pci_init_one+0x16/0x20 [ide_core]
[    1.580607]  [<ffffffffa009491e>] via_init_one+0x237/0x25c [via82cxxx]
[    1.580983]  [<ffffffff8106e501>] ? get_parent_ip+0x11/0x50
[    1.581315]  [<ffffffffa00940a0>] ? via82cxxx_cable_detect+0xa0/0xa0 [via82cxxx]
[    1.581747]  [<ffffffff81265dfc>] local_pci_probe+0x5c/0xd0
[    1.582545]  [<ffffffff81267721>] pci_device_probe+0x101/0x120
[    1.582890]  [<ffffffff812febae>] driver_probe_device+0x7e/0x1b0
[    1.583242]  [<ffffffff812fed8b>] __driver_attach+0xab/0xb0
[    1.583572]  [<ffffffff812fece0>] ? driver_probe_device+0x1b0/0x1b0
[    1.583937]  [<ffffffff812fd226>] bus_for_each_dev+0x56/0x90
[    1.584271]  [<ffffffff812fe83e>] driver_attach+0x1e/0x20
[    1.584593]  [<ffffffff812fe4a0>] bus_add_driver+0x1a0/0x260
[    1.584928]  [<ffffffffa003e000>] ? 0xffffffffa003dfff
[    1.585238]  [<ffffffff812ff2e6>] driver_register+0x76/0x140
[    1.585573]  [<ffffffff81448d5d>] ? notifier_call_chain.isra.0+0x4d/0x70
[    1.585958]  [<ffffffffa003e000>] ? 0xffffffffa003dfff
[    1.586268]  [<ffffffff812673e5>] __pci_register_driver+0x55/0xd0
[    1.586624]  [<ffffffff8102c763>] ? set_memory_nx+0x43/0x50
[    1.586955]  [<ffffffffa003e01e>] via_ide_init+0x1e/0x1000 [via82cxxx]
[    1.587333]  [<ffffffff810001cf>] do_one_initcall+0x3f/0x170
[    1.587668]  [<ffffffff8109aaee>] sys_init_module+0xbe/0x230
[    1.588004]  [<ffffffff8144e129>] ia32_do_call+0x13/0x13
[    1.588322] ---[ end trace 78e7b514db9ce361 ]---
[    1.588632] Probing IDE interface ide1...

The code in ide_probe_port() does the following:

        irqd = hwif->irq;
        if (irqd)
                disable_irq(hwif->irq);

        if (ide_port_wait_ready(hwif) == -EBUSY)
                printk(KERN_DEBUG "%s: Wait for ready failed before probe !\n", hwif->name);

        /*
         * Second drive should only exist if first drive was found,
         * but a lot of cdrom drives are configured as single slaves.
         */
        ide_port_for_each_dev(i, drive, hwif) {
                (void) probe_for_drive(drive);
                if (drive->dev_flags & IDE_DFLAG_PRESENT)
                        rc = 0;
        }

        /*
         * Use cached IRQ number. It might be (and is...) changed by probe
         * code above
         */
        if (irqd)
                enable_irq(irqd);

We disable the interrupt for the device (hwif->irq), do the probes, and
then enable the irq if it existed. The problem is that the probe resets
the depth count of the irq descriptor. I ran some traces, and added some
trace_printks, to confirm it.

Coming into this function, the desc->depth is 1. The disable_irq() sets
the depth to 2. Then the probe calls irq_startup() that resets the depth
to 0.

Then the enable_irq(irqd) is called with depth of 0, and produces the
above warning.

Here's the output of the trace:


           <...>-183   [000] ....     0.950828: disable_irq <-ide_probe_port
           <...>-183   [000] ....     0.950830: __disable_irq_nosync <-disable_irq
           <...>-183   [000] d..1     0.950831: __disable_irq <-__disable_irq_nosync
           <...>-183   [000] d..1     0.950832: __disable_irq: irq=16 depth=2
           <...>-193   [002] d..1     1.057579: irq_startup: irq=16 depth=0
           <...>-183   [001] ....     1.518815: enable_irq <-ide_probe_port
           <...>-183   [001] d..1     1.518817: __enable_irq <-enable_irq
           <...>-183   [001] d..1     1.518818: __enable_irq: irq=16 depth=0
           <...>-183   [001] d..1     1.518819: __enable_irq: warning irq=16

I had trace_printk's in __disable_irq, __enable_irq, and irq_startup,
and I traced '*disable_irq*,*enable_irq*' functions.

The depth was printed after the increment in __disable_irq() and before
the decrement in __enable_irq().

-- Steve


