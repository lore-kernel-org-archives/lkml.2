Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab0LFQHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:07:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46199 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab0LFQHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:07:44 -0500
Date: Mon, 6 Dec 2010 11:07:28 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Tejun Heo <tj@kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 2.6.37
Message-ID: <20101206160728.GP25668@bombadil.infradead.org>
References: <20101130210938.GF25668@bombadil.infradead.org>
 <4CF62EE0.7040607@kernel.org>
 <20101201124445.GG25668@bombadil.infradead.org>
 <4CF6595A.6010104@kernel.org>
 <20101201155026.GH25668@bombadil.infradead.org>
 <20101201200907.GI25668@bombadil.infradead.org>
 <4CF77225.3040904@kernel.org>
 <20101202212346.GK25668@bombadil.infradead.org>
 <4CF8C204.8010904@kernel.org>
 <20101203115902.GL25668@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline
In-Reply-To: <20101203115902.GL25668@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 03, 2010 at 06:59:02AM -0500, Kyle McMartin wrote:
> On Fri, Dec 03, 2010 at 11:10:12AM +0100, Tejun Heo wrote:
> > > This gets triggered a bunch on boot-up:
> > 
> > Yeah, that's expected.  Can you please do the usual testing routine
> > and trigger the EH giving up message and then attach the full kernel
> > log?
> > 
> 

OK, attached is a couple days worth of suspend/resume, hopefully that
turns up what you're looking for.

regards, Kyle



--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.dreadnought-2010-12-06.txt"

nted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45717.620218] Call Trace:
[45717.620221]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45717.620223]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45717.620225]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[45717.620228]  [<ffffffff81313dc9>] ata_host_request_pm+0xcb/0x122
[45717.620230]  [<ffffffff81313ec9>] ata_host_suspend+0x2e/0x42
[45717.620233]  [<ffffffff81313f0a>] ata_pci_device_suspend+0x2d/0x4b
[45717.620235]  [<ffffffff813283d8>] ahci_pci_device_suspend+0x74/0x7b
[45717.620238]  [<ffffffff81244918>] pci_legacy_suspend+0x3a/0xbd
[45717.620240]  [<ffffffff81245725>] pci_pm_suspend+0x4c/0xf5
[45717.620242]  [<ffffffff8103e919>] ? need_resched+0x23/0x2d
[45717.620244]  [<ffffffff812ec7a4>] pm_op+0x8b/0x149
[45717.620247]  [<ffffffff812eca40>] __device_suspend+0x12e/0x19e
[45717.620249]  [<ffffffff812ecf06>] async_suspend+0x21/0x62
[45717.620251]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[45717.620253]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[45717.620256]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[45717.620258]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[45717.620260]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[45717.620262]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[45717.620264]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[45717.620267]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[45717.620269]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[45717.620311] ata6: XXX SET EH PENDING, fastdrain=1
[45717.620317] Pid: 14697, comm: kworker/u:5 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45717.620320] Call Trace:
[45717.620326]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45717.620331]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45717.620337]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[45717.620342]  [<ffffffff81313dc9>] ata_host_request_pm+0xcb/0x122
[45717.620348]  [<ffffffff81313ec9>] ata_host_suspend+0x2e/0x42
[45717.620354]  [<ffffffff81313f0a>] ata_pci_device_suspend+0x2d/0x4b
[45717.620359]  [<ffffffff813283d8>] ahci_pci_device_suspend+0x74/0x7b
[45717.620365]  [<ffffffff81244918>] pci_legacy_suspend+0x3a/0xbd
[45717.620371]  [<ffffffff81245725>] pci_pm_suspend+0x4c/0xf5
[45717.620376]  [<ffffffff8103e919>] ? need_resched+0x23/0x2d
[45717.620381]  [<ffffffff812ec7a4>] pm_op+0x8b/0x149
[45717.620386]  [<ffffffff812eca40>] __device_suspend+0x12e/0x19e
[45717.620391]  [<ffffffff812ecf06>] async_suspend+0x21/0x62
[45717.620396]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[45717.620401]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[45717.620407]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[45717.620412]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[45717.620417]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[45717.620422]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[45717.620427]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[45717.620433]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[45717.620438]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[45717.631130] PM: suspend of devices complete after 606.817 msecs
[45717.649957] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[45717.668943] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[45717.669054] PM: late suspend of devices complete after 37.940 msecs
[45717.669257] ACPI: Preparing to enter system sleep state S3
[45717.850865] PM: Saving platform NVS memory
[45717.988665] Disabling non-boot CPUs ...
[45717.991228] CPU 1 is now offline
[45718.009183] CPU 2 is now offline
[45718.015853] Broke affinity for irq 12
[45718.016896] CPU 3 is now offline
[45718.016898] SMP alternatives: switching to UP code
[45718.019763] Extended CMOS year: 2000
[45718.020126] Back to C!
[45718.020130] PM: Restoring platform NVS memory
[45718.167211] microcode: CPU0 updated to revision 0xc, date = 2010-06-10
[45718.167534] Extended CMOS year: 2000
[45718.167591] Enabling non-boot CPUs ...
[45718.167686] SMP alternatives: switching to SMP code
[45718.170250] Booting Node 0 Processor 1 APIC 0x1
[45718.260684] NMI watchdog enabled, takes one hw-pmu counter.
[45718.261112] microcode: CPU1 updated to revision 0xc, date = 2010-06-10
[45718.277487] CPU1 is up
[45718.277607] Booting Node 0 Processor 2 APIC 0x4
[45718.368562] NMI watchdog enabled, takes one hw-pmu counter.
[45718.369005] microcode: CPU2 updated to revision 0xc, date = 2010-06-10
[45718.384397] CPU2 is up
[45718.384564] Booting Node 0 Processor 3 APIC 0x5
[45718.475652] NMI watchdog enabled, takes one hw-pmu counter.
[45718.476460] microcode: CPU3 updated to revision 0xc, date = 2010-06-10
[45718.492526] CPU3 is up
[45718.494488] ACPI: Waking up from system sleep state S3
[45718.820466] thinkpad_acpi: EC reports that Thermal Table has changed
[45718.869272] i915 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900407)
[45718.869391] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x400, writing 0x40b)
[45718.869414] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4 (was 0x0, writing 0xf2728000)
[45718.869423] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
[45718.917124] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[45718.949089] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[45718.949283] pci 0000:00:1c.4: restoring config space at offset 0xf (was 0x100, writing 0x4010b)
[45718.949297] pci 0000:00:1c.4: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[45718.949303] pci 0000:00:1c.4: restoring config space at offset 0x8 (was 0x0, writing 0xf240f240)
[45718.949309] pci 0000:00:1c.4: restoring config space at offset 0x7 (was 0x0, writing 0xf0)
[45718.949319] pci 0000:00:1c.4: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[45718.949326] pci 0000:00:1c.4: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
[45718.949361] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf (was 0x400, writing 0x40b)
[45718.949381] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4 (was 0x0, writing 0xf2728400)
[45718.949390] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
[45718.973076] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[45718.997062] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[45718.997187] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[45718.997260] pci 0000:00:1f.6: restoring config space at offset 0xf (was 0x400, writing 0x40b)
[45718.997284] pci 0000:00:1f.6: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
[45718.997371] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[45718.997526] PM: early resume of devices complete after 128.437 msecs
[45718.997791] i915 0000:00:02.0: power state changed by ACPI to D0
[45718.997811] i915 0000:00:02.0: power state changed by ACPI to D0
[45718.997823] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[45718.997827] i915 0000:00:02.0: setting latency timer to 64
[45718.997831] e1000e 0000:00:19.0: PME# disabled
[45718.997900] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[45718.997910] HDA Intel 0000:00:1b.0: setting latency timer to 64
[45718.997991] HDA Intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[45718.998008] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[45718.998056] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[45718.998062] pci 0000:00:1c.0: setting latency timer to 64
[45718.998073] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[45718.998080] pci 0000:00:1c.3: setting latency timer to 64
[45718.998090] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[45718.998096] pci 0000:00:1c.4: setting latency timer to 64
[45718.998148] pci 0000:00:1e.0: setting latency timer to 64
[45718.998169] ahci 0000:00:1f.2: setting latency timer to 64
[45718.998212] ata1: XXX SET EH PENDING, fastdrain=1
[45718.998215] Pid: 14725, comm: kworker/u:15 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45718.998218] Call Trace:
[45718.998228]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45718.998233]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45718.998240]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[45718.998245]  [<ffffffff81313dc9>] ata_host_request_pm+0xcb/0x122
[45718.998249]  [<ffffffff81313e45>] ata_host_resume+0x25/0x37
[45718.998254]  [<ffffffff81328356>] ahci_pci_device_resume+0x58/0x66
[45718.998262]  [<ffffffff81244bc5>] pci_legacy_resume+0x38/0x47
[45718.998266]  [<ffffffff81245575>] pci_pm_resume+0x57/0x8b
[45718.998272]  [<ffffffff812ec7c2>] pm_op+0xa9/0x149
[45718.998276]  [<ffffffff812ecfe4>] device_resume+0x9d/0x1b6
[45718.998279]  [<ffffffff81476faf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[45718.998283]  [<ffffffff812ed4aa>] async_resume+0x21/0x62
[45718.998290]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[45718.998294]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[45718.998300]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[45718.998305]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[45718.998308]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[45718.998312]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[45718.998318]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[45718.998322]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[45718.998326]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[45718.998334] ata2: XXX SET EH PENDING, fastdrain=1
[45718.998337] Pid: 14725, comm: kworker/u:15 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45718.998339] Call Trace:
[45718.998343]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45718.998347]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45718.998351]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[45718.998355]  [<ffffffff81313dc9>] ata_host_request_pm+0xcb/0x122
[45718.998359]  [<ffffffff81313e45>] ata_host_resume+0x25/0x37
[45718.998363]  [<ffffffff81328356>] ahci_pci_device_resume+0x58/0x66
[45718.998367]  [<ffffffff81244bc5>] pci_legacy_resume+0x38/0x47
[45718.998371]  [<ffffffff81245575>] pci_pm_resume+0x57/0x8b
[45718.998375]  [<ffffffff812ec7c2>] pm_op+0xa9/0x149
[45718.998379]  [<ffffffff812ecfe4>] device_resume+0x9d/0x1b6
[45718.998382]  [<ffffffff81476faf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[45718.998386]  [<ffffffff812ed4aa>] async_resume+0x21/0x62
[45718.998390]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[45718.998394]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[45718.998398]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[45718.998402]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[45718.998406]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[45718.998409]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[45718.998413]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[45718.998417]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[45718.998421]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[45718.998427] ata3: XXX SET EH PENDING, fastdrain=1
[45718.998430] Pid: 14725, comm: kworker/u:15 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45718.998432] Call Trace:
[45718.998435]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45718.998439]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45718.998443]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[45718.998448]  [<ffffffff81313dc9>] ata_host_request_pm+0xcb/0x122
[45718.998452]  [<ffffffff81313e45>] ata_host_resume+0x25/0x37
[45718.998455]  [<ffffffff81328356>] ahci_pci_device_resume+0x58/0x66
[45718.998460]  [<ffffffff81244bc5>] pci_legacy_resume+0x38/0x47
[45718.998464]  [<ffffffff81245575>] pci_pm_resume+0x57/0x8b
[45718.998467]  [<ffffffff812ec7c2>] pm_op+0xa9/0x149
[45718.998471]  [<ffffffff812ecfe4>] device_resume+0x9d/0x1b6
[45718.998475]  [<ffffffff81476faf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[45718.998479]  [<ffffffff812ed4aa>] async_resume+0x21/0x62
[45718.998483]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[45718.998486]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[45718.998491]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[45718.998494]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[45718.998498]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[45718.998501]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[45718.998505]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[45718.998509]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[45718.998513]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[45718.998549] ata4: XXX SET EH PENDING, fastdrain=1
[45718.998552] Pid: 14725, comm: kworker/u:15 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45718.998554] Call Trace:
[45718.998557]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45718.998561]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45718.998565]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[45718.998570]  [<ffffffff81313dc9>] ata_host_request_pm+0xcb/0x122
[45718.998574]  [<ffffffff81313e45>] ata_host_resume+0x25/0x37
[45718.998578]  [<ffffffff81328356>] ahci_pci_device_resume+0x58/0x66
[45718.998582]  [<ffffffff81244bc5>] pci_legacy_resume+0x38/0x47
[45718.998586]  [<ffffffff81245575>] pci_pm_resume+0x57/0x8b
[45718.998590]  [<ffffffff812ec7c2>] pm_op+0xa9/0x149
[45718.998593]  [<ffffffff812ecfe4>] device_resume+0x9d/0x1b6
[45718.998597]  [<ffffffff81476faf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[45718.998601]  [<ffffffff812ed4aa>] async_resume+0x21/0x62
[45718.998605]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[45718.998609]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[45718.998613]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[45718.998617]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[45718.998620]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[45718.998624]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[45718.998628]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[45718.998632]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[45718.998636]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[45718.998642] ata5: XXX SET EH PENDING, fastdrain=1
[45718.998645] Pid: 14725, comm: kworker/u:15 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45718.998648] Call Trace:
[45718.998651]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45718.998655]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45718.998659]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[45718.998663]  [<ffffffff81313dc9>] ata_host_request_pm+0xcb/0x122
[45718.998668]  [<ffffffff81313e45>] ata_host_resume+0x25/0x37
[45718.998671]  [<ffffffff81328356>] ahci_pci_device_resume+0x58/0x66
[45718.998676]  [<ffffffff81244bc5>] pci_legacy_resume+0x38/0x47
[45718.998680]  [<ffffffff81245575>] pci_pm_resume+0x57/0x8b
[45718.998683]  [<ffffffff812ec7c2>] pm_op+0xa9/0x149
[45718.998687]  [<ffffffff812ecfe4>] device_resume+0x9d/0x1b6
[45718.998691]  [<ffffffff81476faf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[45718.998695]  [<ffffffff812ed4aa>] async_resume+0x21/0x62
[45718.998699]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[45718.998702]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[45718.998707]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[45718.998710]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[45718.998714]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[45718.998717]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[45718.998721]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[45718.998725]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[45718.998729]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[45718.998736] ata6: XXX SET EH PENDING, fastdrain=1
[45718.998739] Pid: 14725, comm: kworker/u:15 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45718.998741] Call Trace:
[45718.998745]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45718.998749]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45718.998752]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[45718.998757]  [<ffffffff81313dc9>] ata_host_request_pm+0xcb/0x122
[45718.998761]  [<ffffffff81313e45>] ata_host_resume+0x25/0x37
[45718.998765]  [<ffffffff81328356>] ahci_pci_device_resume+0x58/0x66
[45718.998769]  [<ffffffff81244bc5>] pci_legacy_resume+0x38/0x47
[45718.998773]  [<ffffffff81245575>] pci_pm_resume+0x57/0x8b
[45718.998776]  [<ffffffff812ec7c2>] pm_op+0xa9/0x149
[45718.998780]  [<ffffffff812ecfe4>] device_resume+0x9d/0x1b6
[45718.998784]  [<ffffffff81476faf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[45718.998788]  [<ffffffff812ed4aa>] async_resume+0x21/0x62
[45718.998792]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[45718.998796]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[45718.998800]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[45718.998803]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[45718.998807]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[45718.998810]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[45718.998815]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[45718.998819]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[45718.998822]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[45718.999106] sd 0:0:0:0: [sda] Starting disk
[45719.000928] ata1: XXX SET EH PENDING, fastdrain=0
[45719.000932] Pid: 14696, comm: kworker/u:4 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45719.000935] Call Trace:
[45719.000937]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45719.000947]  [<ffffffff8131db36>] ata_do_link_abort+0x44/0x94
[45719.000951]  [<ffffffff8131dbac>] ata_port_abort+0x10/0x12
[45719.000955]  [<ffffffff8131dbee>] ata_port_freeze+0x40/0x45
[45719.000960]  [<ffffffff8132b162>] ahci_interrupt+0x51e/0x5a1
[45719.000968]  [<ffffffff8105c784>] ? run_timer_softirq+0x28f/0x29e
[45719.000973]  [<ffffffff8106fb68>] ? sched_clock_cpu+0x42/0xc6
[45719.000981]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[45719.000988]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[45719.000994]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[45719.000999]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[45719.001004]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[45719.001009]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[45719.001012]  <EOI>  [<ffffffff812d4482>] ? i965_write_entry+0x0/0x2c
[45719.001023]  [<ffffffff812d531e>] ? intel_fake_agp_configure+0xdb/0x105
[45719.001028]  [<ffffffff812d375c>] agp_intel_resume+0x1c/0x23
[45719.001032]  [<ffffffff81244bc5>] pci_legacy_resume+0x38/0x47
[45719.001037]  [<ffffffff81245575>] pci_pm_resume+0x57/0x8b
[45719.001041]  [<ffffffff812ec7c2>] pm_op+0xa9/0x149
[45719.001045]  [<ffffffff812ecfe4>] device_resume+0x9d/0x1b6
[45719.001049]  [<ffffffff81476faf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[45719.001054]  [<ffffffff812ed4aa>] async_resume+0x21/0x62
[45719.001058]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[45719.001063]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[45719.001068]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[45719.001072]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[45719.001076]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[45719.001080]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[45719.001085]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[45719.001089]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[45719.001093]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[45719.018960] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[45719.018964] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[45719.023336] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[45719.023511] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[45719.023528] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[45719.024977] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[45719.024991] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[45719.024998] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[45719.255976] usb 1-1.3: reset full speed USB device using ehci_hcd and address 3
[45719.303816] ata5: SATA link down (SStatus 0 SControl 300)
[45719.307848] ata6: SATA link down (SStatus 0 SControl 300)
[45719.309811] ata2: SATA link down (SStatus 0 SControl 300)
[45720.588158] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[45720.594379] ata1: XXX SET EH PENDING, fastdrain=1
[45720.594385] Pid: 0, comm: swapper Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45720.594389] Call Trace:
[45720.594391]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45720.594409]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45720.594417]  [<ffffffff813150d7>] ata_qc_complete+0xd2/0x152
[45720.594423]  [<ffffffff8131521d>] ata_qc_complete_multiple+0xc6/0xcb
[45720.594431]  [<ffffffff8132b141>] ahci_interrupt+0x4fd/0x5a1
[45720.594439]  [<ffffffff8107738f>] ? tick_dev_program_event+0x36/0xf4
[45720.594448]  [<ffffffff81476faf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[45720.594454]  [<ffffffff8106dae4>] ? unlock_hrtimer_base.clone.16+0x11/0x13
[45720.594463]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[45720.594473]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[45720.594480]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[45720.594488]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[45720.594494]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[45720.594500]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[45720.594506]  <EOI>  [<ffffffff81274eab>] ? intel_idle+0x115/0x13d
[45720.594515]  [<ffffffff81274e8a>] ? intel_idle+0xf4/0x13d
[45720.594521]  [<ffffffff8139f894>] cpuidle_idle_call+0x9e/0x104
[45720.594524]  [<ffffffff8100932e>] cpu_idle+0xae/0x105
[45720.594530]  [<ffffffff8145f2ce>] rest_init+0x72/0x74
[45720.594534]  [<ffffffff81b53c31>] start_kernel+0x3e0/0x3eb
[45720.594539]  [<ffffffff81b532cb>] x86_64_start_reservations+0xb6/0xba
[45720.594543]  [<ffffffff81b533d5>] x86_64_start_kernel+0x106/0x115
[45720.594576] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[45720.594580] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[45720.594882] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[45720.594889] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[45720.597752] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[45720.597760] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[45720.598063] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[45720.598069] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[45720.599385] ata1.00: configured for UDMA/100
[45720.613150] ata1.00: configured for UDMA/100
[45720.613156] ata1: EH complete
[45720.641205] PM: resume of devices complete after 1644.504 msecs
[45720.642987] PM: Finishing wakeup.
[45720.642990] Restarting tasks ... 
[45720.643653] usb 1-1.4: USB disconnect, address 9
[45720.644069] done.
[45720.644077] video LNXVIDEO:00: Restoring backlight state
[45720.837513] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[45720.888013] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[45720.890421] ADDRCONF(NETDEV_UP): eth0: link is not ready
[45720.917389] ata1: XXX SET EH PENDING, fastdrain=0
[45720.917398] Pid: 0, comm: swapper Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45720.917402] Call Trace:
[45720.917405]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45720.917424]  [<ffffffff8131db36>] ata_do_link_abort+0x44/0x94
[45720.917430]  [<ffffffff8131dbac>] ata_port_abort+0x10/0x12
[45720.917437]  [<ffffffff8132b0ab>] ahci_interrupt+0x467/0x5a1
[45720.917446]  [<ffffffff812f8f93>] ? scsi_finish_command+0xe5/0xee
[45720.917456]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[45720.917466]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[45720.917473]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[45720.917482]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[45720.917489]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[45720.917497]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[45720.917500]  <EOI>  [<ffffffff81274eab>] ? intel_idle+0x115/0x13d
[45720.917513]  [<ffffffff81274e8a>] ? intel_idle+0xf4/0x13d
[45720.917523]  [<ffffffff8139f894>] cpuidle_idle_call+0x9e/0x104
[45720.917529]  [<ffffffff8100932e>] cpu_idle+0xae/0x105
[45720.917536]  [<ffffffff8145f2ce>] rest_init+0x72/0x74
[45720.917543]  [<ffffffff81b53c31>] start_kernel+0x3e0/0x3eb
[45720.917552]  [<ffffffff81b532cb>] x86_64_start_reservations+0xb6/0xba
[45720.917558]  [<ffffffff81b533d5>] x86_64_start_kernel+0x106/0x115
[45720.918625] ata1: XXX SET EH PENDING, fastdrain=1
[45720.918631] Pid: 33, comm: kseriod Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45720.918635] Call Trace:
[45720.918637]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45720.918650]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45720.918658]  [<ffffffff813150d7>] ata_qc_complete+0xd2/0x152
[45720.918665]  [<ffffffff8131521d>] ata_qc_complete_multiple+0xc6/0xcb
[45720.918672]  [<ffffffff8132b141>] ahci_interrupt+0x4fd/0x5a1
[45720.918680]  [<ffffffff81364e80>] ? i8042_interrupt+0x288/0x29a
[45720.918688]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[45720.918695]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[45720.918702]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[45720.918708]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[45720.918714]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[45720.918720]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[45720.918723]  <EOI>  [<ffffffff8105c899>] ? del_timer_sync+0x21/0x26
[45720.918738]  [<ffffffff81475d26>] ? schedule_timeout+0xb3/0xe3
[45720.918745]  [<ffffffff8105c793>] ? process_timeout+0x0/0x10
[45720.918752]  [<ffffffff81365c86>] ps2_sendbyte+0xbd/0xfd
[45720.918760]  [<ffffffff8106a80f>] ? autoremove_wake_function+0x0/0x39
[45720.918767]  [<ffffffff81365dfb>] __ps2_command+0x10c/0x33f
[45720.918772]  [<ffffffff8147610f>] ? mutex_lock+0x29/0x50
[45720.918778]  [<ffffffff8147610f>] ? mutex_lock+0x29/0x50
[45720.918784]  [<ffffffff813660b8>] ps2_command+0x2c/0x41
[45720.918792]  [<ffffffff81370b8b>] psmouse_sliced_command+0x5f/0x7f
[45720.918799]  [<ffffffff81371b71>] synaptics_pt_write+0x39/0x61
[45720.918805]  [<ffffffff81365c19>] ps2_sendbyte+0x50/0xfd
[45720.918814]  [<ffffffff8106a80f>] ? autoremove_wake_function+0x0/0x39
[45720.918824]  [<ffffffff8106a96f>] ? finish_wait+0x66/0x6e
[45720.918833]  [<ffffffff81365dd3>] __ps2_command+0xe4/0x33f
[45720.918842]  [<ffffffff8103e919>] ? need_resched+0x23/0x2d
[45720.918851]  [<ffffffff814759cb>] ? _cond_resched+0xe/0x22
[45720.918859]  [<ffffffff8147610f>] ? mutex_lock+0x29/0x50
[45720.918866]  [<ffffffff813660b8>] ps2_command+0x2c/0x41
[45720.918872]  [<ffffffff81376c54>] trackpoint_read+0x42/0x51
[45720.918877]  [<ffffffff81376cb4>] trackpoint_sync+0x51/0x1f8
[45720.918883]  [<ffffffff81376e84>] trackpoint_reconnect+0x29/0x34
[45720.918889]  [<ffffffff813715c0>] psmouse_reconnect+0xa5/0x135
[45720.918895]  [<ffffffff8136379e>] serio_reconnect_port+0x42/0x6e
[45720.918901]  [<ffffffff81363cca>] serio_thread+0x10f/0x2dc
[45720.918908]  [<ffffffff8106a80f>] ? autoremove_wake_function+0x0/0x39
[45720.918914]  [<ffffffff81476faf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[45720.918920]  [<ffffffff81363bbb>] ? serio_thread+0x0/0x2dc
[45720.918926]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[45720.918933]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[45720.918939]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[45720.918945]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[45720.921568] ata1.00: configured for UDMA/100
[45720.921575] ata1: EH complete
[45720.921997] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[45721.014959] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[45721.148470] EXT4-fs (dm-0): re-mounted. Opts: commit=600
[45721.157299] EXT4-fs (sda1): re-mounted. Opts: commit=600
[45721.161023] EXT4-fs (dm-2): re-mounted. Opts: commit=600
[45721.204459] ata1: XXX SET EH PENDING, fastdrain=1
[45721.204469] Pid: 15426, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45721.204475] Call Trace:
[45721.204491]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45721.204500]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45721.204512]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[45721.204520]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[45721.204528]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[45721.204540]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[45721.204548]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[45721.204554]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[45721.204562]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[45721.204962] ata2: XXX SET EH PENDING, fastdrain=1
[45721.204970] Pid: 15426, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45721.204975] Call Trace:
[45721.204984]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45721.204993]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45721.205002]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[45721.205011]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[45721.205019]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[45721.205028]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[45721.205038]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[45721.205046]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[45721.205054]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[45721.205296] ata3: XXX SET EH PENDING, fastdrain=1
[45721.205302] Pid: 15426, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45721.205305] Call Trace:
[45721.205313]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45721.205319]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45721.205326]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[45721.205331]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[45721.205337]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[45721.205343]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[45721.205350]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[45721.205356]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[45721.205362]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[45721.205562] ata4: XXX SET EH PENDING, fastdrain=1
[45721.205568] Pid: 15426, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45721.205572] Call Trace:
[45721.205579]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45721.205585]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45721.205591]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[45721.205597]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[45721.205602]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[45721.205609]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[45721.205615]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[45721.205621]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[45721.205627]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[45721.205953] ata5: XXX SET EH PENDING, fastdrain=1
[45721.205961] Pid: 15426, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45721.205966] Call Trace:
[45721.205976]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45721.205985]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45721.205994]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[45721.206002]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[45721.206010]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[45721.206019]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[45721.206029]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[45721.206037]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[45721.206045]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[45721.206374] ata6: XXX SET EH PENDING, fastdrain=1
[45721.206383] Pid: 15426, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45721.206389] Call Trace:
[45721.206399]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45721.206409]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45721.206418]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[45721.206427]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[45721.206437]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[45721.206446]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[45721.206457]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[45721.206466]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[45721.206475]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[45721.248855] usb 1-1.4: new full speed USB device using ehci_hcd and address 10
[45721.338217] usb 1-1.4: New USB device found, idVendor=0a5c, idProduct=217f
[45721.338225] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[45721.338231] usb 1-1.4: Product: Broadcom Bluetooth Device
[45721.338235] usb 1-1.4: Manufacturer: Broadcom Corp
[45721.338238] usb 1-1.4: SerialNumber: C417FEF2CB38
[45721.367639] ata1: XXX SET EH PENDING, fastdrain=0
[45721.367648] Pid: 0, comm: swapper Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45721.367652] Call Trace:
[45721.367655]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45721.367673]  [<ffffffff8131db36>] ata_do_link_abort+0x44/0x94
[45721.367680]  [<ffffffff8131dbac>] ata_port_abort+0x10/0x12
[45721.367687]  [<ffffffff8132b0ab>] ahci_interrupt+0x467/0x5a1
[45721.367697]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[45721.367707]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[45721.367715]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[45721.367723]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[45721.367730]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[45721.367738]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[45721.367741]  <EOI>  [<ffffffff81274eab>] ? intel_idle+0x115/0x13d
[45721.367755]  [<ffffffff81274e8a>] ? intel_idle+0xf4/0x13d
[45721.367764]  [<ffffffff8139f894>] cpuidle_idle_call+0x9e/0x104
[45721.367770]  [<ffffffff8100932e>] cpu_idle+0xae/0x105
[45721.367778]  [<ffffffff8145f2ce>] rest_init+0x72/0x74
[45721.367784]  [<ffffffff81b53c31>] start_kernel+0x3e0/0x3eb
[45721.367793]  [<ffffffff81b532cb>] x86_64_start_reservations+0xb6/0xba
[45721.367799]  [<ffffffff81b533d5>] x86_64_start_kernel+0x106/0x115
[45721.386484] ata1: XXX SET EH PENDING, fastdrain=1
[45721.386489] Pid: 0, comm: swapper Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45721.386492] Call Trace:
[45721.386495]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45721.386506]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45721.386514]  [<ffffffff813150d7>] ata_qc_complete+0xd2/0x152
[45721.386519]  [<ffffffff8131521d>] ata_qc_complete_multiple+0xc6/0xcb
[45721.386525]  [<ffffffff8132b141>] ahci_interrupt+0x4fd/0x5a1
[45721.386532]  [<ffffffff812f8f93>] ? scsi_finish_command+0xe5/0xee
[45721.386539]  [<ffffffff810114c6>] ? sched_clock+0x9/0xd
[45721.386545]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[45721.386551]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[45721.386556]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[45721.386562]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[45721.386566]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[45721.386572]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[45721.386574]  <EOI>  [<ffffffff81274eab>] ? intel_idle+0x115/0x13d
[45721.386584]  [<ffffffff81274e8a>] ? intel_idle+0xf4/0x13d
[45721.386590]  [<ffffffff8139f894>] cpuidle_idle_call+0x9e/0x104
[45721.386594]  [<ffffffff8100932e>] cpu_idle+0xae/0x105
[45721.386600]  [<ffffffff8145f2ce>] rest_init+0x72/0x74
[45721.386604]  [<ffffffff81b53c31>] start_kernel+0x3e0/0x3eb
[45721.386611]  [<ffffffff81b532cb>] x86_64_start_reservations+0xb6/0xba
[45721.386616]  [<ffffffff81b533d5>] x86_64_start_kernel+0x106/0x115
[45721.386668] ata1: hard resetting link
[45721.846324] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[45721.847618] ata1: XXX SET EH PENDING, fastdrain=1
[45721.847625] Pid: 0, comm: swapper Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45721.847629] Call Trace:
[45721.847632]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45721.847648]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45721.847656]  [<ffffffff813150d7>] ata_qc_complete+0xd2/0x152
[45721.847663]  [<ffffffff8131521d>] ata_qc_complete_multiple+0xc6/0xcb
[45721.847673]  [<ffffffff81065bb0>] ? queue_work+0x1f/0x21
[45721.847680]  [<ffffffff8132b141>] ahci_interrupt+0x4fd/0x5a1
[45721.847690]  [<ffffffff8105c784>] ? run_timer_softirq+0x28f/0x29e
[45721.847696]  [<ffffffff810114bb>] ? native_sched_clock+0x35/0x37
[45721.847704]  [<ffffffff8106fb68>] ? sched_clock_cpu+0x42/0xc6
[45721.847712]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[45721.847720]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[45721.847726]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[45721.847734]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[45721.847743]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[45721.847748]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[45721.847750]  <EOI>  [<ffffffff81274eab>] ? intel_idle+0x115/0x13d
[45721.847758]  [<ffffffff81274e8a>] ? intel_idle+0xf4/0x13d
[45721.847764]  [<ffffffff8139f894>] cpuidle_idle_call+0x9e/0x104
[45721.847768]  [<ffffffff8100932e>] cpu_idle+0xae/0x105
[45721.847772]  [<ffffffff8145f2ce>] rest_init+0x72/0x74
[45721.847776]  [<ffffffff81b53c31>] start_kernel+0x3e0/0x3eb
[45721.847780]  [<ffffffff81b532cb>] x86_64_start_reservations+0xb6/0xba
[45721.847784]  [<ffffffff81b533d5>] x86_64_start_kernel+0x106/0x115
[45721.847816] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[45721.847820] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[45721.848092] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[45721.848097] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[45721.851048] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[45721.851055] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[45721.851362] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[45721.851368] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[45721.852664] ata1.00: configured for UDMA/100
[45721.852966] ata1: hard resetting link
[45722.312083] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[45722.313501] ata1: XXX SET EH PENDING, fastdrain=1
[45722.313508] Pid: 0, comm: swapper Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45722.313511] Call Trace:
[45722.313514]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45722.313528]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45722.313536]  [<ffffffff813150d7>] ata_qc_complete+0xd2/0x152
[45722.313543]  [<ffffffff8131521d>] ata_qc_complete_multiple+0xc6/0xcb
[45722.313550]  [<ffffffff8132b141>] ahci_interrupt+0x4fd/0x5a1
[45722.313557]  [<ffffffff8105c784>] ? run_timer_softirq+0x28f/0x29e
[45722.313564]  [<ffffffff810114bb>] ? native_sched_clock+0x35/0x37
[45722.313570]  [<ffffffff8106fb68>] ? sched_clock_cpu+0x42/0xc6
[45722.313577]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[45722.313584]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[45722.313591]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[45722.313598]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[45722.313604]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[45722.313611]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[45722.313614]  <EOI>  [<ffffffff81274eab>] ? intel_idle+0x115/0x13d
[45722.313625]  [<ffffffff81274e8a>] ? intel_idle+0xf4/0x13d
[45722.313632]  [<ffffffff8139f894>] cpuidle_idle_call+0x9e/0x104
[45722.313638]  [<ffffffff8100932e>] cpu_idle+0xae/0x105
[45722.313644]  [<ffffffff8145f2ce>] rest_init+0x72/0x74
[45722.313650]  [<ffffffff81b53c31>] start_kernel+0x3e0/0x3eb
[45722.313657]  [<ffffffff81b532cb>] x86_64_start_reservations+0xb6/0xba
[45722.313664]  [<ffffffff81b533d5>] x86_64_start_kernel+0x106/0x115
[45722.313705] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[45722.313712] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[45722.313985] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[45722.313992] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[45722.316989] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[45722.316996] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[45722.317290] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[45722.317297] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[45722.318613] ata1.00: configured for UDMA/100
[45722.318924] ata1: hard resetting link
[45722.777866] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[45722.779288] ata1: XXX SET EH PENDING, fastdrain=1
[45722.779295] Pid: 0, comm: swapper Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45722.779299] Call Trace:
[45722.779301]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45722.779316]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45722.779324]  [<ffffffff813150d7>] ata_qc_complete+0xd2/0x152
[45722.779331]  [<ffffffff8131521d>] ata_qc_complete_multiple+0xc6/0xcb
[45722.779338]  [<ffffffff81065bb0>] ? queue_work+0x1f/0x21
[45722.779345]  [<ffffffff8132b141>] ahci_interrupt+0x4fd/0x5a1
[45722.779352]  [<ffffffff8105c784>] ? run_timer_softirq+0x28f/0x29e
[45722.779362]  [<ffffffff810114bb>] ? native_sched_clock+0x35/0x37
[45722.779367]  [<ffffffff8106fb68>] ? sched_clock_cpu+0x42/0xc6
[45722.779374]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[45722.779380]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[45722.779385]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[45722.779392]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[45722.779396]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[45722.779402]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[45722.779404]  <EOI>  [<ffffffff81274eab>] ? intel_idle+0x115/0x13d
[45722.779414]  [<ffffffff81274e8a>] ? intel_idle+0xf4/0x13d
[45722.779420]  [<ffffffff8139f894>] cpuidle_idle_call+0x9e/0x104
[45722.779425]  [<ffffffff8100932e>] cpu_idle+0xae/0x105
[45722.779430]  [<ffffffff8145f2ce>] rest_init+0x72/0x74
[45722.779435]  [<ffffffff81b53c31>] start_kernel+0x3e0/0x3eb
[45722.779441]  [<ffffffff81b532cb>] x86_64_start_reservations+0xb6/0xba
[45722.779446]  [<ffffffff81b533d5>] x86_64_start_kernel+0x106/0x115
[45722.779484] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[45722.779489] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[45722.779763] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[45722.779785] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[45722.782544] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[45722.782551] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[45722.782812] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[45722.782822] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[45722.784099] ata1.00: configured for UDMA/100
[45722.784399] ata1: hard resetting link
[45723.243580] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[45723.244908] ata1: XXX SET EH PENDING, fastdrain=1
[45723.244914] Pid: 0, comm: swapper Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45723.244918] Call Trace:
[45723.244921]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45723.244937]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45723.244945]  [<ffffffff813150d7>] ata_qc_complete+0xd2/0x152
[45723.244952]  [<ffffffff8131521d>] ata_qc_complete_multiple+0xc6/0xcb
[45723.244961]  [<ffffffff81065bb0>] ? queue_work+0x1f/0x21
[45723.244968]  [<ffffffff8132b141>] ahci_interrupt+0x4fd/0x5a1
[45723.244976]  [<ffffffff8105c784>] ? run_timer_softirq+0x28f/0x29e
[45723.244983]  [<ffffffff810114bb>] ? native_sched_clock+0x35/0x37
[45723.244990]  [<ffffffff8106fb68>] ? sched_clock_cpu+0x42/0xc6
[45723.244999]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[45723.245010]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[45723.245015]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[45723.245020]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[45723.245025]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[45723.245029]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[45723.245031]  <EOI>  [<ffffffff81274eab>] ? intel_idle+0x115/0x13d
[45723.245039]  [<ffffffff81274e8a>] ? intel_idle+0xf4/0x13d
[45723.245046]  [<ffffffff8139f894>] cpuidle_idle_call+0x9e/0x104
[45723.245049]  [<ffffffff8100932e>] cpu_idle+0xae/0x105
[45723.245054]  [<ffffffff8145f2ce>] rest_init+0x72/0x74
[45723.245058]  [<ffffffff81b53c31>] start_kernel+0x3e0/0x3eb
[45723.245063]  [<ffffffff81b532cb>] x86_64_start_reservations+0xb6/0xba
[45723.245067]  [<ffffffff81b533d5>] x86_64_start_kernel+0x106/0x115
[45723.245083] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[45723.245087] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[45723.245378] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[45723.245384] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[45723.248132] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[45723.248139] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[45723.248418] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[45723.248425] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[45723.249750] ata1.00: configured for UDMA/100
[45723.250042] ata1: hard resetting link
[45723.709349] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[45723.710790] ata1: XXX SET EH PENDING, fastdrain=1
[45723.710797] Pid: 0, comm: swapper Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45723.710801] Call Trace:
[45723.710803]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45723.710818]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45723.710826]  [<ffffffff813150d7>] ata_qc_complete+0xd2/0x152
[45723.710833]  [<ffffffff8131521d>] ata_qc_complete_multiple+0xc6/0xcb
[45723.710840]  [<ffffffff8132b141>] ahci_interrupt+0x4fd/0x5a1
[45723.710849]  [<ffffffff81364e80>] ? i8042_interrupt+0x288/0x29a
[45723.710856]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[45723.710864]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[45723.710871]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[45723.710878]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[45723.710884]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[45723.710894]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[45723.710897]  <EOI>  [<ffffffff81274eab>] ? intel_idle+0x115/0x13d
[45723.710906]  [<ffffffff81274e8a>] ? intel_idle+0xf4/0x13d
[45723.710912]  [<ffffffff8139f894>] cpuidle_idle_call+0x9e/0x104
[45723.710917]  [<ffffffff8100932e>] cpu_idle+0xae/0x105
[45723.710922]  [<ffffffff8145f2ce>] rest_init+0x72/0x74
[45723.710927]  [<ffffffff81b53c31>] start_kernel+0x3e0/0x3eb
[45723.710933]  [<ffffffff81b532cb>] x86_64_start_reservations+0xb6/0xba
[45723.710938]  [<ffffffff81b533d5>] x86_64_start_kernel+0x106/0x115
[45723.710976] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[45723.710982] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[45723.711224] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[45723.711230] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[45723.714025] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[45723.714036] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[45723.714338] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[45723.714343] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[45723.715607] ata1.00: configured for UDMA/100
[45723.715902] ata1: EH pending after 5 tries, giving up
[45723.715906] ata1: EH complete
[45723.716402] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[45723.905438] EXT4-fs (dm-0): re-mounted. Opts: commit=600
[45723.910863] EXT4-fs (sda1): re-mounted. Opts: commit=600
[45723.913176] EXT4-fs (dm-2): re-mounted. Opts: commit=600
[45723.936006] ata1: XXX SET EH PENDING, fastdrain=1
[45723.936012] Pid: 15486, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45723.936015] Call Trace:
[45723.936025]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45723.936029]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45723.936035]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[45723.936039]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[45723.936044]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[45723.936050]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[45723.936056]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[45723.936060]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[45723.936065]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[45723.936287] ata2: XXX SET EH PENDING, fastdrain=1
[45723.936292] Pid: 15486, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45723.936296] Call Trace:
[45723.936302]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45723.936307]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45723.936313]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[45723.936318]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[45723.936323]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[45723.936328]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[45723.936334]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[45723.936339]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[45723.936344]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[45723.936556] ata3: XXX SET EH PENDING, fastdrain=1
[45723.936559] Pid: 15486, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45723.936561] Call Trace:
[45723.936566]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45723.936570]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45723.936574]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[45723.936577]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[45723.936581]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[45723.936585]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[45723.936589]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[45723.936593]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[45723.936596]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[45723.936727] ata4: XXX SET EH PENDING, fastdrain=1
[45723.936730] Pid: 15486, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45723.936733] Call Trace:
[45723.936737]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45723.936741]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45723.936745]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[45723.936748]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[45723.936751]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[45723.936755]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[45723.936759]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[45723.936763]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[45723.936766]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[45723.936893] ata5: XXX SET EH PENDING, fastdrain=1
[45723.936897] Pid: 15486, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45723.936899] Call Trace:
[45723.936903]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45723.936907]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45723.936911]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[45723.936914]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[45723.936917]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[45723.936921]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[45723.936926]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[45723.936929]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[45723.936933]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[45723.937058] ata6: XXX SET EH PENDING, fastdrain=1
[45723.937062] Pid: 15486, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[45723.937064] Call Trace:
[45723.937069]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[45723.937072]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[45723.937076]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[45723.937079]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[45723.937083]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[45723.937087]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[45723.937091]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[45723.937094]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[45723.937098]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[45726.234940] ehci_hcd 0000:00:1d.0: PCI INT D disabled
[45726.234996] ehci_hcd 0000:00:1d.0: PME# enabled
[45726.248003] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[45726.590823] wlan0: deauthenticating from 00:0f:66:43:d7:0a by local choice (reason=3)
[45726.678595] wlan0: authenticate with 00:0f:66:43:d7:0a (try 1)
[45726.681608] wlan0: authenticated
[45726.789489] wlan0: associate with 00:0f:66:43:d7:0a (try 1)
[45726.792982] wlan0: RX AssocResp from 00:0f:66:43:d7:0a (capab=0x411 status=0 aid=2)
[45726.792988] wlan0: associated
[45726.811369] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[45730.232803] ehci_hcd 0000:00:1a.0: PCI INT D disabled
[45730.232870] ehci_hcd 0000:00:1a.0: PME# enabled
[45730.245732] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[45737.819489] wlan0: no IPv6 routers present
[45928.128568] tun0: Disabled Privacy Extensions
[46559.589280] ata1: XXX SET EH PENDING, fastdrain=0
[46559.589289] Pid: 0, comm: kworker/0:0 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46559.589293] Call Trace:
[46559.589296]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46559.589315]  [<ffffffff8131db36>] ata_do_link_abort+0x44/0x94
[46559.589321]  [<ffffffff8131dbac>] ata_port_abort+0x10/0x12
[46559.589329]  [<ffffffff8132b0ab>] ahci_interrupt+0x467/0x5a1
[46559.589339]  [<ffffffff8107ccc2>] ? arch_local_irq_save+0x18/0x1e
[46559.589347]  [<ffffffff8106fb68>] ? sched_clock_cpu+0x42/0xc6
[46559.589356]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[46559.589366]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[46559.589373]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[46559.589382]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[46559.589389]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[46559.589396]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[46559.589400]  <EOI>  [<ffffffff81274eab>] ? intel_idle+0x115/0x13d
[46559.589413]  [<ffffffff81274e8a>] ? intel_idle+0xf4/0x13d
[46559.589423]  [<ffffffff8139f894>] cpuidle_idle_call+0x9e/0x104
[46559.589428]  [<ffffffff8100932e>] cpu_idle+0xae/0x105
[46559.589436]  [<ffffffff8146f559>] start_secondary+0x22d/0x22f
[46559.589921] ata1: XXX SET EH PENDING, fastdrain=1
[46559.589927] Pid: 946, comm: rsyslogd Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46559.589931] Call Trace:
[46559.589933]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46559.589947]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46559.589955]  [<ffffffff813150d7>] ata_qc_complete+0xd2/0x152
[46559.589961]  [<ffffffff8131521d>] ata_qc_complete_multiple+0xc6/0xcb
[46559.589968]  [<ffffffff8132b141>] ahci_interrupt+0x4fd/0x5a1
[46559.589975]  [<ffffffff810afbc1>] ? check_for_new_grace_period.clone.21+0x8b/0x97
[46559.589983]  [<ffffffff810114bb>] ? native_sched_clock+0x35/0x37
[46559.589989]  [<ffffffff8106fb68>] ? sched_clock_cpu+0x42/0xc6
[46559.589996]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[46559.590003]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[46559.590009]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[46559.590016]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[46559.590021]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[46559.590027]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[46559.590031]  <EOI>  [<ffffffff8103b61b>] ? arch_local_irq_enable+0xb/0xd
[46559.590046]  [<ffffffff81042aa1>] finish_task_switch+0x48/0xa5
[46559.590052]  [<ffffffff814758b5>] schedule+0x610/0x673
[46559.590060]  [<ffffffff81078e65>] futex_wait_queue_me+0xc1/0xe0
[46559.590066]  [<ffffffff81078fc7>] futex_wait+0x143/0x2eb
[46559.590073]  [<ffffffff81476faf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[46559.590080]  [<ffffffff81048f00>] ? try_to_wake_up+0x214/0x226
[46559.590087]  [<ffffffff8107ac10>] do_futex+0xa3/0x83b
[46559.590092]  [<ffffffff8103e919>] ? need_resched+0x23/0x2d
[46559.590100]  [<ffffffff8107b4dc>] sys_futex+0x134/0x144
[46559.590108]  [<ffffffff8111f2fe>] ? fput_light+0x12/0x14
[46559.590114]  [<ffffffff8111fd99>] ? sys_read+0x61/0x6e
[46559.590121]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[46559.590159] ata1: hard resetting link
[46560.049365] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[46560.050644] ata1: XXX SET EH PENDING, fastdrain=1
[46560.050651] Pid: 0, comm: kworker/0:0 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46560.050655] Call Trace:
[46560.050658]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46560.050674]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46560.050682]  [<ffffffff813150d7>] ata_qc_complete+0xd2/0x152
[46560.050689]  [<ffffffff8131521d>] ata_qc_complete_multiple+0xc6/0xcb
[46560.050696]  [<ffffffff8132b141>] ahci_interrupt+0x4fd/0x5a1
[46560.050705]  [<ffffffff8107ccc2>] ? arch_local_irq_save+0x18/0x1e
[46560.050712]  [<ffffffff810114bb>] ? native_sched_clock+0x35/0x37
[46560.050719]  [<ffffffff8106fb68>] ? sched_clock_cpu+0x42/0xc6
[46560.050727]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[46560.050736]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[46560.050743]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[46560.050751]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[46560.050757]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[46560.050764]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[46560.050768]  <EOI>  [<ffffffff81274eab>] ? intel_idle+0x115/0x13d
[46560.050779]  [<ffffffff81274e8a>] ? intel_idle+0xf4/0x13d
[46560.050789]  [<ffffffff8139f894>] cpuidle_idle_call+0x9e/0x104
[46560.050795]  [<ffffffff8100932e>] cpu_idle+0xae/0x105
[46560.050801]  [<ffffffff8146f559>] start_secondary+0x22d/0x22f
[46560.050826] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[46560.050833] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[46560.051118] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[46560.051125] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[46560.053766] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[46560.053774] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[46560.054056] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[46560.054063] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[46560.055246] ata1.00: configured for UDMA/100
[46560.055530] ata1: hard resetting link
[46560.515063] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[46560.516288] ata1: XXX SET EH PENDING, fastdrain=1
[46560.516295] Pid: 0, comm: kworker/0:0 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46560.516298] Call Trace:
[46560.516301]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46560.516317]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46560.516325]  [<ffffffff813150d7>] ata_qc_complete+0xd2/0x152
[46560.516332]  [<ffffffff8131521d>] ata_qc_complete_multiple+0xc6/0xcb
[46560.516339]  [<ffffffff8132b141>] ahci_interrupt+0x4fd/0x5a1
[46560.516347]  [<ffffffff8107ccc2>] ? arch_local_irq_save+0x18/0x1e
[46560.516354]  [<ffffffff810114bb>] ? native_sched_clock+0x35/0x37
[46560.516361]  [<ffffffff8106fb68>] ? sched_clock_cpu+0x42/0xc6
[46560.516369]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[46560.516377]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[46560.516384]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[46560.516391]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[46560.516398]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[46560.516404]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[46560.516408]  <EOI>  [<ffffffff81274eab>] ? intel_idle+0x115/0x13d
[46560.516420]  [<ffffffff81274e8a>] ? intel_idle+0xf4/0x13d
[46560.516429]  [<ffffffff8139f894>] cpuidle_idle_call+0x9e/0x104
[46560.516434]  [<ffffffff8100932e>] cpu_idle+0xae/0x105
[46560.516441]  [<ffffffff8146f559>] start_secondary+0x22d/0x22f
[46560.516461] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[46560.516468] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[46560.516753] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[46560.516760] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[46560.519355] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[46560.519363] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[46560.519645] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[46560.519652] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[46560.521646] ata1.00: configured for UDMA/100
[46560.521967] ata1: hard resetting link
[46560.981822] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[46560.983025] ata1: XXX SET EH PENDING, fastdrain=1
[46560.983032] Pid: 0, comm: kworker/0:0 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46560.983036] Call Trace:
[46560.983039]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46560.983054]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46560.983062]  [<ffffffff813150d7>] ata_qc_complete+0xd2/0x152
[46560.983069]  [<ffffffff8131521d>] ata_qc_complete_multiple+0xc6/0xcb
[46560.983076]  [<ffffffff8132b141>] ahci_interrupt+0x4fd/0x5a1
[46560.983084]  [<ffffffff8107ccc2>] ? arch_local_irq_save+0x18/0x1e
[46560.983090]  [<ffffffff810114bb>] ? native_sched_clock+0x35/0x37
[46560.983097]  [<ffffffff8106fb68>] ? sched_clock_cpu+0x42/0xc6
[46560.983104]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[46560.983112]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[46560.983119]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[46560.983127]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[46560.983132]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[46560.983139]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[46560.983143]  <EOI>  [<ffffffff81274eab>] ? intel_idle+0x115/0x13d
[46560.983154]  [<ffffffff81274e8a>] ? intel_idle+0xf4/0x13d
[46560.983162]  [<ffffffff8139f894>] cpuidle_idle_call+0x9e/0x104
[46560.983168]  [<ffffffff8100932e>] cpu_idle+0xae/0x105
[46560.983174]  [<ffffffff8146f559>] start_secondary+0x22d/0x22f
[46560.983200] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[46560.983207] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[46560.983471] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[46560.983478] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[46560.986148] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[46560.986156] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[46560.986443] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[46560.986450] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[46560.987631] ata1.00: configured for UDMA/100
[46560.987891] ata1: hard resetting link
[46561.447514] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[46561.448682] ata1: XXX SET EH PENDING, fastdrain=1
[46561.448688] Pid: 0, comm: kworker/0:0 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46561.448692] Call Trace:
[46561.448695]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46561.448709]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46561.448717]  [<ffffffff813150d7>] ata_qc_complete+0xd2/0x152
[46561.448724]  [<ffffffff8131521d>] ata_qc_complete_multiple+0xc6/0xcb
[46561.448731]  [<ffffffff8132b141>] ahci_interrupt+0x4fd/0x5a1
[46561.448738]  [<ffffffff8107ccc2>] ? arch_local_irq_save+0x18/0x1e
[46561.448745]  [<ffffffff810114bb>] ? native_sched_clock+0x35/0x37
[46561.448751]  [<ffffffff8106fb68>] ? sched_clock_cpu+0x42/0xc6
[46561.448759]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[46561.448766]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[46561.448773]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[46561.448780]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[46561.448786]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[46561.448793]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[46561.448796]  <EOI>  [<ffffffff81274eab>] ? intel_idle+0x115/0x13d
[46561.448807]  [<ffffffff81274e8a>] ? intel_idle+0xf4/0x13d
[46561.448815]  [<ffffffff8139f894>] cpuidle_idle_call+0x9e/0x104
[46561.448821]  [<ffffffff8100932e>] cpu_idle+0xae/0x105
[46561.448827]  [<ffffffff8146f559>] start_secondary+0x22d/0x22f
[46561.448848] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[46561.448855] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[46561.449119] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[46561.449126] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[46561.451839] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[46561.451847] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[46561.452135] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[46561.452142] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[46561.453327] ata1.00: configured for UDMA/100
[46561.453594] ata1: hard resetting link
[46561.913330] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[46561.914592] ata1: XXX SET EH PENDING, fastdrain=1
[46561.914597] Pid: 0, comm: kworker/0:0 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46561.914600] Call Trace:
[46561.914603]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46561.914614]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46561.914620]  [<ffffffff813150d7>] ata_qc_complete+0xd2/0x152
[46561.914626]  [<ffffffff8131521d>] ata_qc_complete_multiple+0xc6/0xcb
[46561.914634]  [<ffffffff81065bb0>] ? queue_work+0x1f/0x21
[46561.914640]  [<ffffffff8132b141>] ahci_interrupt+0x4fd/0x5a1
[46561.914646]  [<ffffffff8107ccc2>] ? arch_local_irq_save+0x18/0x1e
[46561.914651]  [<ffffffff810114bb>] ? native_sched_clock+0x35/0x37
[46561.914656]  [<ffffffff8106fb68>] ? sched_clock_cpu+0x42/0xc6
[46561.914662]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[46561.914668]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[46561.914674]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[46561.914679]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[46561.914684]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[46561.914689]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[46561.914692]  <EOI>  [<ffffffff81274eab>] ? intel_idle+0x115/0x13d
[46561.914701]  [<ffffffff81274e8a>] ? intel_idle+0xf4/0x13d
[46561.914707]  [<ffffffff8139f894>] cpuidle_idle_call+0x9e/0x104
[46561.914712]  [<ffffffff8100932e>] cpu_idle+0xae/0x105
[46561.914717]  [<ffffffff8146f559>] start_secondary+0x22d/0x22f
[46561.914740] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[46561.914745] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[46561.915036] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[46561.915043] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[46561.918245] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[46561.918253] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[46561.918539] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[46561.918545] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[46561.919779] ata1.00: configured for UDMA/100
[46561.920068] ata1: EH pending after 5 tries, giving up
[46561.920073] ata1: EH complete
[46562.162643] EXT4-fs (dm-0): re-mounted. Opts: commit=0
[46562.169276] EXT4-fs (sda1): re-mounted. Opts: commit=0
[46562.513086] EXT4-fs (dm-2): re-mounted. Opts: commit=0
[46562.569495] ata1: XXX SET EH PENDING, fastdrain=1
[46562.569504] Pid: 15943, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46562.569508] Call Trace:
[46562.569521]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46562.569529]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46562.569538]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46562.569544]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[46562.569550]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[46562.569559]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[46562.569568]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[46562.569574]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[46562.569581]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[46562.570075] ata2: XXX SET EH PENDING, fastdrain=1
[46562.570081] Pid: 15943, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46562.570085] Call Trace:
[46562.570094]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46562.570102]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46562.570110]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46562.570117]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[46562.570124]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[46562.570132]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[46562.570140]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[46562.570147]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[46562.570155]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[46562.570500] ata3: XXX SET EH PENDING, fastdrain=1
[46562.570507] Pid: 15943, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46562.570510] Call Trace:
[46562.570518]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46562.570524]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46562.570531]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46562.570536]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[46562.570542]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[46562.570548]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[46562.570555]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[46562.570561]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[46562.570566]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[46562.570940] ata4: XXX SET EH PENDING, fastdrain=1
[46562.570946] Pid: 15943, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46562.570951] Call Trace:
[46562.570960]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46562.570967]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46562.570975]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46562.570982]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[46562.570989]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[46562.570997]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[46562.571005]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[46562.571012]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[46562.571019]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[46562.571391] ata5: XXX SET EH PENDING, fastdrain=1
[46562.571397] Pid: 15943, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46562.571400] Call Trace:
[46562.571408]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46562.571414]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46562.571420]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46562.571426]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[46562.571431]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[46562.571438]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[46562.571445]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[46562.571450]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[46562.571456]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[46562.571797] ata6: XXX SET EH PENDING, fastdrain=1
[46562.571803] Pid: 15943, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46562.571808] Call Trace:
[46562.571818]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46562.571826]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46562.571832]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46562.571838]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[46562.571844]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[46562.571850]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[46562.571857]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[46562.571863]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[46562.571869]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[46562.648829] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[46562.650951] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[46562.659810] ehci_hcd 0000:00:1d.0: BAR 0: set to [mem 0xf2728400-0xf27287ff] (PCI address [0xf2728400-0xf27287ff])
[46562.661854] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[46562.661881] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf (was 0x400, writing 0x40b)
[46562.661914] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
[46562.661954] ehci_hcd 0000:00:1d.0: PME# disabled
[46562.662008] ehci_hcd 0000:00:1a.0: BAR 0: set to [mem 0xf2728000-0xf27283ff] (PCI address [0xf2728000-0xf27283ff])
[46562.663859] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[46562.666020] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[46562.666042] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[46562.666057] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[46562.667847] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[46562.667876] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x400, writing 0x40b)
[46562.667908] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
[46562.667951] ehci_hcd 0000:00:1a.0: PME# disabled
[46562.669814] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[46562.671852] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[46562.671871] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[46562.671886] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[46562.846552] PM: Syncing filesystems ... done.
[46562.851072] PM: Preparing system for mem sleep
[46562.964708] wlan0: deauthenticating from 00:0f:66:43:d7:0a by local choice (reason=3)
[46562.986479] cfg80211: Calling CRDA to update world regulatory domain
[46562.986514] cfg80211: Calling CRDA for country: US
[46562.992380] cfg80211: Regulatory domain changed to country: US
[46562.992385]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[46562.992389]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[46562.992393]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[46562.992397]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[46562.992401]     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[46562.992404]     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[46562.992408]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[46563.094879] Freezing user space processes ... (elapsed 0.01 seconds) done.
[46563.106627] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[46563.117621] PM: Entering mem sleep
[46563.117809] Suspending console(s) (use no_console_suspend to debug)
[46563.290227] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[46563.290425] sd 0:0:0:0: [sda] Stopping disk
[46563.347608] ACPI handle has no context!
[46563.534195] ehci_hcd 0000:00:1d.0: PCI INT D disabled
[46563.534205] ehci_hcd 0000:00:1a.0: PCI INT D disabled
[46563.549368] i915 0000:00:02.0: power state changed by ACPI to D3
[46563.600382] [drm:intel_dp_aux_ch] *ERROR* dp_aux_ch not started status 0xffffffff
[46563.605226] [drm:intel_dp_aux_ch] *ERROR* dp_aux_ch not started status 0xffffffff
[46563.635760] HDA Intel 0000:00:1b.0: PCI INT B disabled
[46563.641090] e1000e 0000:00:19.0: PME# enabled
[46563.641100] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[46563.691724] ata1: XXX SET EH PENDING, fastdrain=1
[46563.691730] Pid: 16063, comm: kworker/u:2 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46563.691735] Call Trace:
[46563.691748]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46563.691755]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46563.691765]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46563.691776]  [<ffffffff81313dc9>] ata_host_request_pm+0xcb/0x122
[46563.691781]  [<ffffffff81313ec9>] ata_host_suspend+0x2e/0x42
[46563.691785]  [<ffffffff81313f0a>] ata_pci_device_suspend+0x2d/0x4b
[46563.691791]  [<ffffffff813283d8>] ahci_pci_device_suspend+0x74/0x7b
[46563.691799]  [<ffffffff81244918>] pci_legacy_suspend+0x3a/0xbd
[46563.691804]  [<ffffffff81245725>] pci_pm_suspend+0x4c/0xf5
[46563.691809]  [<ffffffff8103e919>] ? need_resched+0x23/0x2d
[46563.691815]  [<ffffffff812ec7a4>] pm_op+0x8b/0x149
[46563.691819]  [<ffffffff812eca40>] __device_suspend+0x12e/0x19e
[46563.691824]  [<ffffffff812ecf06>] async_suspend+0x21/0x62
[46563.691831]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[46563.691835]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[46563.691842]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[46563.691846]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[46563.691853]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[46563.691856]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[46563.691862]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[46563.691865]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[46563.691868]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[46563.692039] ata2: XXX SET EH PENDING, fastdrain=1
[46563.692044] Pid: 16063, comm: kworker/u:2 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46563.692047] Call Trace:
[46563.692054]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46563.692058]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46563.692063]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46563.692069]  [<ffffffff81313dc9>] ata_host_request_pm+0xcb/0x122
[46563.692074]  [<ffffffff81313ec9>] ata_host_suspend+0x2e/0x42
[46563.692078]  [<ffffffff81313f0a>] ata_pci_device_suspend+0x2d/0x4b
[46563.692083]  [<ffffffff813283d8>] ahci_pci_device_suspend+0x74/0x7b
[46563.692088]  [<ffffffff81244918>] pci_legacy_suspend+0x3a/0xbd
[46563.692093]  [<ffffffff81245725>] pci_pm_suspend+0x4c/0xf5
[46563.692097]  [<ffffffff8103e919>] ? need_resched+0x23/0x2d
[46563.692101]  [<ffffffff812ec7a4>] pm_op+0x8b/0x149
[46563.692105]  [<ffffffff812eca40>] __device_suspend+0x12e/0x19e
[46563.692110]  [<ffffffff812ecf06>] async_suspend+0x21/0x62
[46563.692115]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[46563.692119]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[46563.692124]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[46563.692128]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[46563.692132]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[46563.692137]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[46563.692141]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[46563.692146]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[46563.692150]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[46563.692361] ata3: XXX SET EH PENDING, fastdrain=1
[46563.692366] Pid: 16063, comm: kworker/u:2 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46563.692368] Call Trace:
[46563.692375]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46563.692380]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46563.692385]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46563.692390]  [<ffffffff81313dc9>] ata_host_request_pm+0xcb/0x122
[46563.692395]  [<ffffffff81313ec9>] ata_host_suspend+0x2e/0x42
[46563.692400]  [<ffffffff81313f0a>] ata_pci_device_suspend+0x2d/0x4b
[46563.692404]  [<ffffffff813283d8>] ahci_pci_device_suspend+0x74/0x7b
[46563.692410]  [<ffffffff81244918>] pci_legacy_suspend+0x3a/0xbd
[46563.692415]  [<ffffffff81245725>] pci_pm_suspend+0x4c/0xf5
[46563.692418]  [<ffffffff8103e919>] ? need_resched+0x23/0x2d
[46563.692423]  [<ffffffff812ec7a4>] pm_op+0x8b/0x149
[46563.692427]  [<ffffffff812eca40>] __device_suspend+0x12e/0x19e
[46563.692431]  [<ffffffff812ecf06>] async_suspend+0x21/0x62
[46563.692436]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[46563.692441]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[46563.692446]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[46563.692450]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[46563.692454]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[46563.692458]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[46563.692463]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[46563.692468]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[46563.692472]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[46563.692518] ata4: XXX SET EH PENDING, fastdrain=1
[46563.692523] Pid: 16063, comm: kworker/u:2 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46563.692526] Call Trace:
[46563.692532]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46563.692536]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46563.692541]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46563.692546]  [<ffffffff81313dc9>] ata_host_request_pm+0xcb/0x122
[46563.692551]  [<ffffffff81313ec9>] ata_host_suspend+0x2e/0x42
[46563.692555]  [<ffffffff81313f0a>] ata_pci_device_suspend+0x2d/0x4b
[46563.692560]  [<ffffffff813283d8>] ahci_pci_device_suspend+0x74/0x7b
[46563.692565]  [<ffffffff81244918>] pci_legacy_suspend+0x3a/0xbd
[46563.692570]  [<ffffffff81245725>] pci_pm_suspend+0x4c/0xf5
[46563.692574]  [<ffffffff8103e919>] ? need_resched+0x23/0x2d
[46563.692578]  [<ffffffff812ec7a4>] pm_op+0x8b/0x149
[46563.692582]  [<ffffffff812eca40>] __device_suspend+0x12e/0x19e
[46563.692586]  [<ffffffff812ecf06>] async_suspend+0x21/0x62
[46563.692591]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[46563.692596]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[46563.692601]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[46563.692605]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[46563.692609]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[46563.692613]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[46563.692617]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[46563.692622]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[46563.692626]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[46563.692780] ata5: XXX SET EH PENDING, fastdrain=1
[46563.692784] Pid: 16063, comm: kworker/u:2 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46563.692787] Call Trace:
[46563.692794]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46563.692799]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46563.692804]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46563.692809]  [<ffffffff81313dc9>] ata_host_request_pm+0xcb/0x122
[46563.692814]  [<ffffffff81313ec9>] ata_host_suspend+0x2e/0x42
[46563.692819]  [<ffffffff81313f0a>] ata_pci_device_suspend+0x2d/0x4b
[46563.692823]  [<ffffffff813283d8>] ahci_pci_device_suspend+0x74/0x7b
[46563.692829]  [<ffffffff81244918>] pci_legacy_suspend+0x3a/0xbd
[46563.692833]  [<ffffffff81245725>] pci_pm_suspend+0x4c/0xf5
[46563.692837]  [<ffffffff8103e919>] ? need_resched+0x23/0x2d
[46563.692842]  [<ffffffff812ec7a4>] pm_op+0x8b/0x149
[46563.692846]  [<ffffffff812eca40>] __device_suspend+0x12e/0x19e
[46563.692850]  [<ffffffff812ecf06>] async_suspend+0x21/0x62
[46563.692855]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[46563.692859]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[46563.692865]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[46563.692869]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[46563.692873]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[46563.692877]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[46563.692885]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[46563.692888]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[46563.692891]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[46563.692943] ata6: XXX SET EH PENDING, fastdrain=1
[46563.692948] Pid: 16063, comm: kworker/u:2 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46563.692951] Call Trace:
[46563.692957]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46563.692961]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46563.692966]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46563.692971]  [<ffffffff81313dc9>] ata_host_request_pm+0xcb/0x122
[46563.692976]  [<ffffffff81313ec9>] ata_host_suspend+0x2e/0x42
[46563.692980]  [<ffffffff81313f0a>] ata_pci_device_suspend+0x2d/0x4b
[46563.692985]  [<ffffffff813283d8>] ahci_pci_device_suspend+0x74/0x7b
[46563.692990]  [<ffffffff81244918>] pci_legacy_suspend+0x3a/0xbd
[46563.692995]  [<ffffffff81245725>] pci_pm_suspend+0x4c/0xf5
[46563.692999]  [<ffffffff8103e919>] ? need_resched+0x23/0x2d
[46563.693003]  [<ffffffff812ec7a4>] pm_op+0x8b/0x149
[46563.693007]  [<ffffffff812eca40>] __device_suspend+0x12e/0x19e
[46563.693011]  [<ffffffff812ecf06>] async_suspend+0x21/0x62
[46563.693016]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[46563.693021]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[46563.693026]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[46563.693030]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[46563.693034]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[46563.693038]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[46563.693042]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[46563.693050]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[46563.693052]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[46563.703340] PM: suspend of devices complete after 585.603 msecs
[46563.722335] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[46563.741348] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[46563.741460] PM: late suspend of devices complete after 38.136 msecs
[46563.741670] ACPI: Preparing to enter system sleep state S3
[46563.797236] [drm:ironlake_crtc_disable] *ERROR* failed to disable transcoder
[46563.923189] PM: Saving platform NVS memory
[46564.063151] Disabling non-boot CPUs ...
[46564.065666] CPU 1 is now offline
[46564.080504] CPU 2 is now offline
[46564.091275] Broke affinity for irq 23
[46564.092313] CPU 3 is now offline
[46564.092315] SMP alternatives: switching to UP code
[46564.096068] Extended CMOS year: 2000
[46564.096432] Back to C!
[46564.096435] PM: Restoring platform NVS memory
[46564.243536] microcode: CPU0 updated to revision 0xc, date = 2010-06-10
[46564.243860] Extended CMOS year: 2000
[46564.243901] Enabling non-boot CPUs ...
[46564.243997] SMP alternatives: switching to SMP code
[46564.246572] Booting Node 0 Processor 1 APIC 0x1
[46564.337034] NMI watchdog enabled, takes one hw-pmu counter.
[46564.337458] microcode: CPU1 updated to revision 0xc, date = 2010-06-10
[46564.352917] CPU1 is up
[46564.353046] Booting Node 0 Processor 2 APIC 0x4
[46564.444025] NMI watchdog enabled, takes one hw-pmu counter.
[46564.444465] microcode: CPU2 updated to revision 0xc, date = 2010-06-10
[46564.460863] CPU2 is up
[46564.461032] Booting Node 0 Processor 3 APIC 0x5
[46564.552131] NMI watchdog enabled, takes one hw-pmu counter.
[46564.552937] microcode: CPU3 updated to revision 0xc, date = 2010-06-10
[46564.568992] CPU3 is up
[46564.571053] ACPI: Waking up from system sleep state S3
[46564.863712] i915 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900407)
[46564.863831] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x400, writing 0x40b)
[46564.863851] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4 (was 0x0, writing 0xf2728000)
[46564.863860] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
[46564.887577] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[46564.911564] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[46564.911757] pci 0000:00:1c.4: restoring config space at offset 0xf (was 0x100, writing 0x4010b)
[46564.911771] pci 0000:00:1c.4: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[46564.911777] pci 0000:00:1c.4: restoring config space at offset 0x8 (was 0x0, writing 0xf240f240)
[46564.911783] pci 0000:00:1c.4: restoring config space at offset 0x7 (was 0x0, writing 0xf0)
[46564.911793] pci 0000:00:1c.4: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[46564.911800] pci 0000:00:1c.4: restoring config space at offset 0x1 (was 0x100000, writing 0x100107)
[46564.911836] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf (was 0x400, writing 0x40b)
[46564.911855] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4 (was 0x0, writing 0xf2728400)
[46564.911864] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
[46564.935551] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[46564.959537] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[46564.959662] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[46564.959737] pci 0000:00:1f.6: restoring config space at offset 0xf (was 0x400, writing 0x40b)
[46564.959761] pci 0000:00:1f.6: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
[46564.959847] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[46564.960002] PM: early resume of devices complete after 96.457 msecs
[46564.960263] i915 0000:00:02.0: power state changed by ACPI to D0
[46564.960268] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[46564.960278] e1000e 0000:00:19.0: PME# disabled
[46564.960282] i915 0000:00:02.0: power state changed by ACPI to D0
[46564.960294] i915 0000:00:02.0: setting latency timer to 64
[46564.960412] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[46564.960449] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[46564.960458] HDA Intel 0000:00:1b.0: setting latency timer to 64
[46564.960516] HDA Intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[46564.960573] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[46564.960581] pci 0000:00:1c.0: setting latency timer to 64
[46564.960592] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[46564.960599] pci 0000:00:1c.3: setting latency timer to 64
[46564.960610] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[46564.960616] pci 0000:00:1c.4: setting latency timer to 64
[46564.960662] pci 0000:00:1e.0: setting latency timer to 64
[46564.960687] ahci 0000:00:1f.2: setting latency timer to 64
[46564.960733] ata1: XXX SET EH PENDING, fastdrain=1
[46564.960737] Pid: 14700, comm: kworker/u:8 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46564.960740] Call Trace:
[46564.960751]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46564.960756]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46564.960764]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46564.960770]  [<ffffffff81313dc9>] ata_host_request_pm+0xcb/0x122
[46564.960775]  [<ffffffff81313e45>] ata_host_resume+0x25/0x37
[46564.960780]  [<ffffffff81328356>] ahci_pci_device_resume+0x58/0x66
[46564.960788]  [<ffffffff81244bc5>] pci_legacy_resume+0x38/0x47
[46564.960793]  [<ffffffff81245575>] pci_pm_resume+0x57/0x8b
[46564.960799]  [<ffffffff812ec7c2>] pm_op+0xa9/0x149
[46564.960804]  [<ffffffff812ecfe4>] device_resume+0x9d/0x1b6
[46564.960808]  [<ffffffff81476faf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[46564.960813]  [<ffffffff812ed4aa>] async_resume+0x21/0x62
[46564.960821]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[46564.960825]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[46564.960832]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[46564.960836]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[46564.960841]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[46564.960845]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[46564.960852]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[46564.960857]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[46564.960861]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[46564.960870] ata2: XXX SET EH PENDING, fastdrain=1
[46564.960873] Pid: 14700, comm: kworker/u:8 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46564.960876] Call Trace:
[46564.960881]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46564.960885]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46564.960888]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46564.960893]  [<ffffffff81313dc9>] ata_host_request_pm+0xcb/0x122
[46564.960898]  [<ffffffff81313e45>] ata_host_resume+0x25/0x37
[46564.960902]  [<ffffffff81328356>] ahci_pci_device_resume+0x58/0x66
[46564.960907]  [<ffffffff81244bc5>] pci_legacy_resume+0x38/0x47
[46564.960912]  [<ffffffff81245575>] pci_pm_resume+0x57/0x8b
[46564.960916]  [<ffffffff812ec7c2>] pm_op+0xa9/0x149
[46564.960921]  [<ffffffff812ecfe4>] device_resume+0x9d/0x1b6
[46564.960925]  [<ffffffff81476faf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[46564.960930]  [<ffffffff812ed4aa>] async_resume+0x21/0x62
[46564.960934]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[46564.960939]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[46564.960943]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[46564.960946]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[46564.960951]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[46564.960955]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[46564.960960]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[46564.960965]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[46564.960969]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[46564.960976] ata3: XXX SET EH PENDING, fastdrain=1
[46564.960979] Pid: 14700, comm: kworker/u:8 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46564.960982] Call Trace:
[46564.960986]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46564.960991]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46564.960995]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46564.960999]  [<ffffffff81313dc9>] ata_host_request_pm+0xcb/0x122
[46564.961004]  [<ffffffff81313e45>] ata_host_resume+0x25/0x37
[46564.961008]  [<ffffffff81328356>] ahci_pci_device_resume+0x58/0x66
[46564.961013]  [<ffffffff81244bc5>] pci_legacy_resume+0x38/0x47
[46564.961018]  [<ffffffff81245575>] pci_pm_resume+0x57/0x8b
[46564.961022]  [<ffffffff812ec7c2>] pm_op+0xa9/0x149
[46564.961026]  [<ffffffff812ecfe4>] device_resume+0x9d/0x1b6
[46564.961031]  [<ffffffff81476faf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[46564.961036]  [<ffffffff812ed4aa>] async_resume+0x21/0x62
[46564.961040]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[46564.961045]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[46564.961050]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[46564.961053]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[46564.961056]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[46564.961060]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[46564.961065]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[46564.961070]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[46564.961074]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[46564.961083] ata4: XXX SET EH PENDING, fastdrain=1
[46564.961086] Pid: 14700, comm: kworker/u:8 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46564.961089] Call Trace:
[46564.961093]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46564.961098]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46564.961102]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46564.961107]  [<ffffffff81313dc9>] ata_host_request_pm+0xcb/0x122
[46564.961111]  [<ffffffff81313e45>] ata_host_resume+0x25/0x37
[46564.961115]  [<ffffffff81328356>] ahci_pci_device_resume+0x58/0x66
[46564.961120]  [<ffffffff81244bc5>] pci_legacy_resume+0x38/0x47
[46564.961125]  [<ffffffff81245575>] pci_pm_resume+0x57/0x8b
[46564.961129]  [<ffffffff812ec7c2>] pm_op+0xa9/0x149
[46564.961133]  [<ffffffff812ecfe4>] device_resume+0x9d/0x1b6
[46564.961138]  [<ffffffff81476faf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[46564.961143]  [<ffffffff812ed4aa>] async_resume+0x21/0x62
[46564.961147]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[46564.961152]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[46564.961157]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[46564.961161]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[46564.961164]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[46564.961167]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[46564.961172]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[46564.961177]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[46564.961181]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[46564.961210] ata5: XXX SET EH PENDING, fastdrain=1
[46564.961213] Pid: 14700, comm: kworker/u:8 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46564.961215] Call Trace:
[46564.961219]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46564.961224]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46564.961228]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46564.961232]  [<ffffffff81313dc9>] ata_host_request_pm+0xcb/0x122
[46564.961237]  [<ffffffff81313e45>] ata_host_resume+0x25/0x37
[46564.961242]  [<ffffffff81328356>] ahci_pci_device_resume+0x58/0x66
[46564.961247]  [<ffffffff81244bc5>] pci_legacy_resume+0x38/0x47
[46564.961251]  [<ffffffff81245575>] pci_pm_resume+0x57/0x8b
[46564.961256]  [<ffffffff812ec7c2>] pm_op+0xa9/0x149
[46564.961260]  [<ffffffff812ecfe4>] device_resume+0x9d/0x1b6
[46564.961264]  [<ffffffff81476faf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[46564.961269]  [<ffffffff812ed4aa>] async_resume+0x21/0x62
[46564.961274]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[46564.961279]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[46564.961283]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[46564.961286]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[46564.961290]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[46564.961295]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[46564.961300]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[46564.961304]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[46564.961309]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[46564.961341] ata6: XXX SET EH PENDING, fastdrain=1
[46564.961344] Pid: 14700, comm: kworker/u:8 Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46564.961347] Call Trace:
[46564.961352]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46564.961356]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46564.961361]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46564.961366]  [<ffffffff81313dc9>] ata_host_request_pm+0xcb/0x122
[46564.961372]  [<ffffffff81313e45>] ata_host_resume+0x25/0x37
[46564.961376]  [<ffffffff81328356>] ahci_pci_device_resume+0x58/0x66
[46564.961381]  [<ffffffff81244bc5>] pci_legacy_resume+0x38/0x47
[46564.961385]  [<ffffffff81245575>] pci_pm_resume+0x57/0x8b
[46564.961390]  [<ffffffff812ec7c2>] pm_op+0xa9/0x149
[46564.961394]  [<ffffffff812ecfe4>] device_resume+0x9d/0x1b6
[46564.961398]  [<ffffffff81476faf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[46564.961403]  [<ffffffff812ed4aa>] async_resume+0x21/0x62
[46564.961408]  [<ffffffff810708f9>] async_run_entry_fn+0x9e/0x12b
[46564.961413]  [<ffffffff8107085b>] ? async_run_entry_fn+0x0/0x12b
[46564.961418]  [<ffffffff81065f4b>] process_one_work+0x18c/0x285
[46564.961422]  [<ffffffff81066d52>] worker_thread+0x104/0x1a4
[46564.961426]  [<ffffffff81066c4e>] ? worker_thread+0x0/0x1a4
[46564.961431]  [<ffffffff8106a35e>] kthread+0x82/0x8a
[46564.961434]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[46564.961438]  [<ffffffff8106a2dc>] ? kthread+0x0/0x8a
[46564.961443]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
[46564.961532] sd 0:0:0:0: [sda] Starting disk
[46564.981439] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[46564.981470] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[46564.985525] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[46564.985572] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[46564.985581] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[46564.987441] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[46564.987453] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[46564.987465] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[46565.217533] usb 1-1.3: reset full speed USB device using ehci_hcd and address 3
[46565.268269] ata6: SATA link down (SStatus 0 SControl 300)
[46565.270254] ata5: SATA link down (SStatus 0 SControl 300)
[46565.272311] ata2: SATA link down (SStatus 0 SControl 300)
[46566.695491] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[46566.700872] ata1: XXX SET EH PENDING, fastdrain=1
[46566.700878] Pid: 0, comm: swapper Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46566.700882] Call Trace:
[46566.700885]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46566.700902]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46566.700910]  [<ffffffff813150d7>] ata_qc_complete+0xd2/0x152
[46566.700917]  [<ffffffff8131521d>] ata_qc_complete_multiple+0xc6/0xcb
[46566.700924]  [<ffffffff8132b141>] ahci_interrupt+0x4fd/0x5a1
[46566.700932]  [<ffffffff810afbc1>] ? check_for_new_grace_period.clone.21+0x8b/0x97
[46566.700942]  [<ffffffff8106fb68>] ? sched_clock_cpu+0x42/0xc6
[46566.700950]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[46566.700960]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[46566.700966]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[46566.700974]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[46566.700981]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[46566.700988]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[46566.700991]  <EOI>  [<ffffffff81274eab>] ? intel_idle+0x115/0x13d
[46566.701005]  [<ffffffff81274e8a>] ? intel_idle+0xf4/0x13d
[46566.701012]  [<ffffffff8139f894>] cpuidle_idle_call+0x9e/0x104
[46566.701015]  [<ffffffff8100932e>] cpu_idle+0xae/0x105
[46566.701020]  [<ffffffff8145f2ce>] rest_init+0x72/0x74
[46566.701025]  [<ffffffff81b53c31>] start_kernel+0x3e0/0x3eb
[46566.701030]  [<ffffffff81b532cb>] x86_64_start_reservations+0xb6/0xba
[46566.701034]  [<ffffffff81b533d5>] x86_64_start_kernel+0x106/0x115
[46566.701066] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[46566.701070] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[46566.701288] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[46566.701293] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[46566.704251] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[46566.704259] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[46566.704508] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
[46566.704514] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[46566.705801] ata1.00: configured for UDMA/100
[46566.719484] ata1.00: configured for UDMA/100
[46566.719490] ata1: EH complete
[46566.747646] PM: resume of devices complete after 1788.550 msecs
[46566.749362] PM: Finishing wakeup.
[46566.749365] Restarting tasks ... 
[46566.750478] usb 1-1.4: USB disconnect, address 10
[46566.751931] done.
[46566.751943] video LNXVIDEO:00: Restoring backlight state
[46566.959070] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[46567.009427] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[46567.011202] ADDRCONF(NETDEV_UP): eth0: link is not ready
[46567.040393] ata1: XXX SET EH PENDING, fastdrain=0
[46567.040402] Pid: 0, comm: swapper Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46567.040406] Call Trace:
[46567.040409]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46567.040427]  [<ffffffff8131db36>] ata_do_link_abort+0x44/0x94
[46567.040433]  [<ffffffff8131dbac>] ata_port_abort+0x10/0x12
[46567.040441]  [<ffffffff8132b0ab>] ahci_interrupt+0x467/0x5a1
[46567.040452]  [<ffffffff8107ccc2>] ? arch_local_irq_save+0x18/0x1e
[46567.040460]  [<ffffffff8106fb68>] ? sched_clock_cpu+0x42/0xc6
[46567.040468]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[46567.040478]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[46567.040485]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[46567.040493]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[46567.040501]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[46567.040508]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[46567.040512]  <EOI>  [<ffffffff81274eab>] ? intel_idle+0x115/0x13d
[46567.040525]  [<ffffffff81274e8a>] ? intel_idle+0xf4/0x13d
[46567.040535]  [<ffffffff8139f894>] cpuidle_idle_call+0x9e/0x104
[46567.040540]  [<ffffffff8100932e>] cpu_idle+0xae/0x105
[46567.040548]  [<ffffffff8145f2ce>] rest_init+0x72/0x74
[46567.040554]  [<ffffffff81b53c31>] start_kernel+0x3e0/0x3eb
[46567.040562]  [<ffffffff81b532cb>] x86_64_start_reservations+0xb6/0xba
[46567.040569]  [<ffffffff81b533d5>] x86_64_start_kernel+0x106/0x115
[46567.041688] ata1: XXX SET EH PENDING, fastdrain=1
[46567.041695] Pid: 946, comm: rsyslogd Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46567.041700] Call Trace:
[46567.041704]  <IRQ>  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46567.041718]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46567.041726]  [<ffffffff813150d7>] ata_qc_complete+0xd2/0x152
[46567.041733]  [<ffffffff8131521d>] ata_qc_complete_multiple+0xc6/0xcb
[46567.041740]  [<ffffffff81476faf>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[46567.041747]  [<ffffffff8132b141>] ahci_interrupt+0x4fd/0x5a1
[46567.041755]  [<ffffffff812f8f93>] ? scsi_finish_command+0xe5/0xee
[46567.041762]  [<ffffffff81011131>] ? paravirt_read_tsc+0x9/0xd
[46567.041767]  [<ffffffff810114c6>] ? sched_clock+0x9/0xd
[46567.041774]  [<ffffffff810abbfe>] handle_IRQ_event+0x58/0x122
[46567.041781]  [<ffffffff81024d64>] ? apic_write+0x16/0x18
[46567.041788]  [<ffffffff810adf27>] handle_edge_irq+0xfa/0x145
[46567.041794]  [<ffffffff8100d2dd>] handle_irq+0x88/0x90
[46567.041799]  [<ffffffff8147d508>] do_IRQ+0x58/0xb0
[46567.041805]  [<ffffffff81477513>] ret_from_intr+0x0/0x11
[46567.041809]  <EOI> 
[46567.044452] ata1.00: configured for UDMA/100
[46567.044461] ata1: EH complete
[46567.044774] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[46567.152360] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[46567.210664] usb 1-1.4: new full speed USB device using ehci_hcd and address 11
[46567.236266] EXT4-fs (dm-0): re-mounted. Opts: commit=600
[46567.248157] EXT4-fs (sda1): re-mounted. Opts: commit=600
[46567.256348] EXT4-fs (dm-2): re-mounted. Opts: commit=600
[46567.289227] usb 1-1.4: New USB device found, idVendor=0a5c, idProduct=217f
[46567.289236] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[46567.289244] usb 1-1.4: Product: Broadcom Bluetooth Device
[46567.289250] usb 1-1.4: Manufacturer: Broadcom Corp
[46567.289256] usb 1-1.4: SerialNumber: C417FEF2CB38
[46567.303386] ata1: XXX SET EH PENDING, fastdrain=1
[46567.303392] Pid: 16306, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46567.303395] Call Trace:
[46567.303405]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46567.303409]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46567.303417]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46567.303421]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[46567.303425]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[46567.303432]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[46567.303438]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[46567.303441]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[46567.303447]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[46567.303692] ata2: XXX SET EH PENDING, fastdrain=1
[46567.303696] Pid: 16306, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46567.303698] Call Trace:
[46567.303703]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46567.303707]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46567.303711]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46567.303714]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[46567.303718]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[46567.303722]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[46567.303726]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[46567.303729]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[46567.303733]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[46567.304009] ata3: XXX SET EH PENDING, fastdrain=1
[46567.304014] Pid: 16306, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46567.304018] Call Trace:
[46567.304024]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46567.304030]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46567.304035]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46567.304040]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[46567.304044]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[46567.304050]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[46567.304055]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[46567.304060]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[46567.304065]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[46567.304363] ata4: XXX SET EH PENDING, fastdrain=1
[46567.304367] Pid: 16306, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46567.304369] Call Trace:
[46567.304374]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46567.304378]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46567.304382]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46567.304385]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[46567.304389]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[46567.304393]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[46567.304397]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[46567.304400]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[46567.304404]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[46567.304650] ata5: XXX SET EH PENDING, fastdrain=1
[46567.304654] Pid: 16306, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46567.304656] Call Trace:
[46567.304661]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46567.304665]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46567.304668]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46567.304672]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[46567.304675]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[46567.304679]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[46567.304683]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[46567.304687]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[46567.304690]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[46567.304920] ata6: XXX SET EH PENDING, fastdrain=1
[46567.304924] Pid: 16306, comm: sata_alpm Not tainted 2.6.37-0.rc4.git1.2.fc15.x86_64 #1
[46567.304927] Call Trace:
[46567.304933]  [<ffffffff8131d3df>] ata_eh_set_pending+0x3e/0x85
[46567.304937]  [<ffffffff8131dae5>] ata_port_schedule_eh+0x43/0x50
[46567.304942]  [<ffffffff81476f5a>] ? _raw_spin_lock_irqsave+0x12/0x2f
[46567.304946]  [<ffffffff8131993b>] ata_scsi_lpm_store+0x89/0xa5
[46567.304951]  [<ffffffff812e3912>] dev_attr_store+0x20/0x22
[46567.304956]  [<ffffffff811798df>] sysfs_write_file+0x114/0x150
[46567.304962]  [<ffffffff8111fbe9>] vfs_write+0xac/0xff
[46567.304967]  [<ffffffff8111fdf0>] sys_write+0x4a/0x6e
[46567.304972]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[46571.911625] ehci_hcd 0000:00:1d.0: PCI INT D disabled
[46571.911686] ehci_hcd 0000:00:1d.0: PME# enabled
[46571.924619] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[46575.909397] ehci_hcd 0000:00:1a.0: PCI INT D disabled
[46575.909456] ehci_hcd 0000:00:1a.0: PME# enabled
[46575.922366] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[46576.086269] wlan0: direct probe to 68:ef:bd:80:6c:f1 (try 1)
[46576.093588] wlan0: direct probe responded
[46576.093665] wlan0: authenticate with 68:ef:bd:80:6c:f1 (try 1)
[46576.293193] wlan0: authenticate with 68:ef:bd:80:6c:f1 (try 2)
[46576.493095] wlan0: authenticate with 68:ef:bd:80:6c:f1 (try 3)
[46576.499408] wlan0: authenticated
[46576.607903] wlan0: associate with 68:ef:bd:80:6c:f1 (try 1)
[46576.807895] wlan0: associate with 68:ef:bd:80:6c:f1 (try 2)
[46576.976005] wlan0: RX AssocResp from 68:ef:bd:80:6c:f1 (capab=0x431 status=0 aid=165)
[46576.976010] wlan0: associated
[46577.000821] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[46577.001019] cfg80211: Calling CRDA for country: CA
[46577.005095] cfg80211: Regulatory domain changed to country: CA
[46577.005101]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[46577.005107]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[46577.005112]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[46577.005118]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[46577.005123]     (5490000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[46577.005127]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[46587.102109] wlan0: no IPv6 routers present
[46601.185790] wlan0: deauthenticating from 68:ef:bd:80:6c:f1 by local choice (reason=3)
[46601.195861] cfg80211: Calling CRDA to update world regulatory domain
[46601.195958] cfg80211: Calling CRDA for country: US
[46601.203454] cfg80211: Regulatory domain changed to country: US
[46601.203460]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[46601.203466]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[46601.203472]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[46601.203477]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[46601.203482]     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[46601.203486]     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[46601.203491]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[46610.322495] wlan0: deauthenticating from 00:16:b6:50:30:19 by local choice (reason=3)
[46610.415005] wlan0: authenticate with 00:16:b6:50:30:19 (try 1)
[46610.417919] wlan0: authenticated
[46610.539380] wlan0: associate with 00:16:b6:50:30:19 (try 1)
[46610.551276] wlan0: RX AssocResp from 00:16:b6:50:30:19 (capab=0x401 status=0 aid=6)
[46610.551281] wlan0: associated
[46689.832895] wlan0: deauthenticating from 00:16:b6:50:30:19 by local choice (reason=3)
[46689.849571] cfg80211: Calling CRDA to update world regulatory domain
[46689.849648] cfg80211: Calling CRDA for country: US
[46689.857704] cfg80211: Regulatory domain changed to country: US
[46689.857710]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[46689.857716]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[46689.857721]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[46689.857726]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[46689.857731]     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[46689.857736]     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[46689.857741]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[46699.774919] wlan0: deauthenticating from 00:14:bf:f5:3b:ff by local choice (reason=3)
[46699.862382] wlan0: authenticate with 00:14:bf:f5:3b:ff (try 1)
[46699.869047] wlan0: authenticated
[46699.985470] wlan0: waiting for beacon from 00:14:bf:f5:3b:ff
[46700.050060] wlan0: beacon received
[46700.058148] wlan0: associate with 00:14:bf:f5:3b:ff (try 1)
[46700.060674] wlan0: RX AssocResp from 00:14:bf:f5:3b:ff (capab=0x431 status=0 aid=10)
[46700.060679] wlan0: associated
[46745.314473] wlan0: deauthenticating from 00:14:bf:f5:3b:ff by local choice (reason=3)
[46745.326563] cfg80211: Calling CRDA to update world regulatory domain
[46745.326652] cfg80211: Calling CRDA for country: US
[46745.335039] cfg80211: Regulatory domain changed to country: US
[46745.335046]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[46745.335052]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[46745.335057]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[46745.335062]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[46745.335067]     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[46745.335072]     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[46745.335077]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[46759.321593] wlan0: deauthenticating from 00:14:bf:f5:3b:ff by local choice (reason=3)
[46759.358416] wlan0: authenticate with 00:14:bf:f5:3b:ff (try 1)
[46759.361973] wlan0: authenticated
[46759.376671] wlan0: associate with 00:14:bf:f5:3b:ff (try 1)
[46759.380871] wlan0: RX AssocResp from 00:14:bf:f5:3b:ff (capab=0x431 status=0 aid=10)
[46759.380876] wlan0: associated
[46805.274127] wlan0: deauthenticating from 00:14:bf:f5:3b:ff by local choice (reason=3)
[46805.292013] cfg80211: Calling CRDA to update world regulatory domain
[46805.292102] cfg80211: Calling CRDA for country: US
[46805.301276] cfg80211: Regulatory domain changed to country: US
[46805.301283]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[46805.301289]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[46805.301294]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[46805.301299]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[46805.301304]     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[46805.301309]     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[46805.301314]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[46822.931999] wlan0: deauthenticating from 00:14:bf:f5:3b:ff by local choice (reason=3)
[46822.978782] wlan0: authenticate with 00:14:bf:f5:3b:ff (try 1)
[46822.981532] wlan0: authenticated
[46822.998784] wlan0: associate with 00:14:bf:f5:3b:ff (try 1)
[46823.003066] wlan0: RX AssocResp from 00:14:bf:f5:3b:ff (capab=0x431 status=0 aid=10)
[46823.003071] wlan0: associated
[46868.241585] wlan0: deauthenticating from 00:14:bf:f5:3b:ff by local choice (reason=3)
[46868.256255] cfg80211: Calling CRDA to update world regulatory domain
[46868.256326] cfg80211: Calling CRDA for country: US
[46868.264640] cfg80211: Regulatory domain changed to country: US
[46868.264646]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[46868.264652]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[46868.264658]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[46868.264663]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[46868.264667]     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[46868.264672]     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[46868.264677]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[46868.506331] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[46868.508306] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[46868.517347] ehci_hcd 0000:00:1d.0: BAR 0: set to [mem 0xf2728400-0xf27287ff] (PCI address [0xf2728400-0xf27287ff])
[46868.519273] ehci_hcd 0000:00:1a.0: BAR 0: set to [mem 0xf2728000-0xf27283ff] (PCI address [0xf2728000-0xf27283ff])
[46868.519360] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[46868.519387] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf (was 0x400, writing 0x40b)
[46868.519418] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
[46868.519458] ehci_hcd 0000:00:1d.0: PME# disabled
[46868.521301] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[46868.523302] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[46868.523318] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[46868.523330] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[46868.525299] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[46868.525326] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x400, writing 0x40b)
[46868.525357] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
[46868.525397] ehci_hcd 0000:00:1a.0: PME# disabled
[46868.527296] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[46868.529294] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[46868.529307] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[46868.529319] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[46870.920209] usb 1-1.2: new high speed USB device using ehci_hcd and address 12
[46871.010896] usb 1-1.2: New USB device found, idVendor=19d2, idProduct=0031
[46871.010903] usb 1-1.2: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[46871.010908] usb 1-1.2: Product: ZTE CDMA Technologies MSM
[46871.010912] usb 1-1.2: Manufacturer: ZTE, Incorporated
[46871.010916] usb 1-1.2: SerialNumber: 1234567890ABCDEF
[46875.606055] usb 1-1.2: selecting invalid altsetting 1
[46875.606184] scsi7 : usb-storage 1-1.2:1.2
[46876.607193] scsi 7:0:0:0: Direct-Access     ZTE      MMC Storage      322  PQ: 0 ANSI: 2
[46876.608314] sd 7:0:0:0: Attached scsi generic sg1 type 0
[46876.609748] sd 7:0:0:0: [sdb] Attached SCSI removable disk
[46877.538999] usbcore: registered new interface driver usbserial
[46877.539020] USB Serial support registered for generic
[46877.613884] usbcore: registered new interface driver usbserial_generic
[46877.613890] usbserial: USB Serial Driver core
[46877.692370] USB Serial support registered for GSM modem (1-port)
[46877.692498] option 1-1.2:1.0: GSM modem (1-port) converter detected
[46877.692777] usb 1-1.2: GSM modem (1-port) converter now attached to ttyUSB0
[46877.692802] option 1-1.2:1.1: GSM modem (1-port) converter detected
[46877.692915] usb 1-1.2: GSM modem (1-port) converter now attached to ttyUSB1
[46877.692957] option 1-1.2:1.3: GSM modem (1-port) converter detected
[46877.693082] usb 1-1.2: GSM modem (1-port) converter now attached to ttyUSB2
[46877.693220] usbcore: registered new interface driver option
[46877.693223] option: v0.7.2:USB Driver for GSM modems
[46919.702739] usb 1-1.2: USB disconnect, address 12
[46919.702990] option1 ttyUSB0: GSM modem (1-port) converter now disconnected from ttyUSB0
[46919.703014] option 1-1.2:1.0: device disconnected
[46919.703272] option1 ttyUSB1: GSM modem (1-port) converter now disconnected from ttyUSB1
[46919.703297] option 1-1.2:1.1: device disconnected
[46919.707617] option: option_instat_callback: error -108
[46919.707800] option1 ttyUSB2: GSM modem (1-port) converter now disconnected from ttyUSB2
[46919.707829] option 1-1.2:1.3: device disconnected
[46919.716374] modem-manager[1048]: segfault at 44 ip 000000000042b35a sp 00007fffc139e100 error 4 in modem-manager[400000+47000]
[46925.722470] ehci_hcd 0000:00:1a.0: PCI INT D disabled
[46925.722531] ehci_hcd 0000:00:1a.0: PME# enabled
[46925.735441] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[46939.452793] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[46939.463827] ehci_hcd 0000:00:1a.0: BAR 0: set to [mem 0xf2728000-0xf27283ff] (PCI address [0xf2728000-0xf27283ff])
[46939.465780] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[46939.465808] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x400, writing 0x40b)
[46939.465840] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
[46939.465882] ehci_hcd 0000:00:1a.0: PME# disabled
[46939.467777] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[46939.469777] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[46939.469793] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[46939.469805] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[46941.888687] usb 1-1.2: new high speed USB device using ehci_hcd and address 13
[46941.976017] usb 1-1.2: New USB device found, idVendor=19d2, idProduct=0031
[46941.976023] usb 1-1.2: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[46941.976027] usb 1-1.2: Product: ZTE CDMA Technologies MSM
[46941.976031] usb 1-1.2: Manufacturer: ZTE, Incorporated
[46941.976034] usb 1-1.2: SerialNumber: 1234567890ABCDEF
[46946.624909] option 1-1.2:1.0: GSM modem (1-port) converter detected
[46946.625102] usb 1-1.2: GSM modem (1-port) converter now attached to ttyUSB0
[46946.625233] option 1-1.2:1.1: GSM modem (1-port) converter detected
[46946.625373] usb 1-1.2: GSM modem (1-port) converter now attached to ttyUSB1
[46946.625478] usb 1-1.2: selecting invalid altsetting 1
[46946.625612] scsi8 : usb-storage 1-1.2:1.2
[46946.626022] option 1-1.2:1.3: GSM modem (1-port) converter detected
[46946.626184] usb 1-1.2: GSM modem (1-port) converter now attached to ttyUSB2
[46947.626959] scsi 8:0:0:0: Direct-Access     ZTE      MMC Storage      322  PQ: 0 ANSI: 2
[46947.628401] sd 8:0:0:0: Attached scsi generic sg1 type 0
[46947.630593] sd 8:0:0:0: [sdb] Attached SCSI removable disk
[47013.951055] PPP generic driver version 2.4.2
[47014.027652] PPP Deflate Compression module registered
[47046.781056] tun0: Disabled Privacy Extensions

--s2ZSL+KKDSLx8OML--
