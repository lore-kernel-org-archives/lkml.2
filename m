Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab2GMKEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 06:04:52 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49876 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab2GMKEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 06:04:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120712213305.GA11128@sli.dy.fi>
References: <20120712213305.GA11128@sli.dy.fi>
Date: Fri, 13 Jul 2012 12:04:46 +0200
Message-ID: <CAOMGZ=F2SkQN1sw9vaDqukFUi0QSaQ=tJOhXjvnJhNz+VYEcKg@mail.gmail.com>
Subject: Re: kmemcheck: Fatal error; system fails to boot when kmemcheck enabled
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Sami Liedes <sami.liedes@iki.fi>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 13 Jul 2012 00:33:07 +0300, Sami Liedes <sami.liedes@iki.fi> wrote:
> Hi,
>
> Kernel 3.4.4 with kmemcheck enabled does not correctly boot on my
> system, which is a x86-64, Core i7 Sandy Bridge computer with Asus
> P8P67-EVO motherboard. The errors seem to be related to ACPI, but
> there may be other things wrong. Userspace programs, particularly init
> and in other cases some other binaries run from initramfs die with
> SIGTRAP.
>
> I have been able to boot far enough to get usable backtraces with at
> least the following four sets of options (after some research, I think
> the "noacpi" and "noioapic" parameters are no-ops; mentioning them for
> completeness). The "Modules linked in:" lines say only <omitted>,
> because the lines become too long and cause netconsole to eat most of
> the messages. Here is the list from the running system without
> kmemcheck (first words of /proc/kmemcheck):

[...]

> === noacpi (should be equivalent to no parameters) ===
>
> Got this. Note that the pci_find_upstream_pcie_bridge warning also
> happens on a healthy system without KMEMCHECK:

[...]

> WARNING: at kernel/smp.c:459 smp_call_function_many+0xbd/0x270()

This one _doesn't_ show up without kmemcheck, so that's interesting.

> Hardware name: System Product Name
> Modules linked in: <omitted>
> Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsdebug3+kmc+ #6
> Call Trace:
>  [<ffffffff8103a7fa>] warn_slowpath_common+0x7a/0xb0
>  [<ffffffff8103a845>] warn_slowpath_null+0x15/0x20
>  [<ffffffff810885bd>] smp_call_function_many+0xbd/0x270
>  [<ffffffff8108889d>] smp_call_function+0x1d/0x30
>  [<ffffffff810888d3>] on_each_cpu+0x23/0x60
>  [<ffffffff81031977>] flush_tlb_all+0x17/0x20
>  [<ffffffff8110bac5>] __purge_vmap_area_lazy+0x165/0x1c0
>  [<ffffffff8110bd85>] vm_unmap_aliases+0x165/0x180
>  [<ffffffff8102e2e8>] change_page_attr_set_clr+0xb8/0x470
>  [<ffffffff8102eeda>] _set_memory_wb+0x2a/0x30
>  [<ffffffff8102d262>] ioremap_change_attr+0x12/0x40
>  [<ffffffff8102fcbd>] kernel_map_sync_memtype+0x7d/0xe0
>  [<ffffffff8102cfe8>] __ioremap_caller+0x258/0x360
>  [<ffffffff8102d11f>] ioremap_cache+0xf/0x20
>  [<ffffffff814104a9>] acpi_os_map_memory+0xfc/0x15c
>  [<ffffffff8124c739>] acpi_ex_system_memory_space_handler+0xe5/0x1e4
>  [<ffffffff81246334>] acpi_ev_address_space_dispatch+0x1a5/0x1fb
>  [<ffffffff812499b6>] acpi_ex_access_region+0x270/0x28d
>  [<ffffffff81249d14>] acpi_ex_field_datum_io+0x10a/0x187
>  [<ffffffff8124a061>] acpi_ex_write_with_update_rule+0xbd/0xc8
>  [<ffffffff81249b24>] acpi_ex_insert_into_field+0x151/0x237
>  [<ffffffff812496d5>] acpi_ex_write_data_to_field+0x1b9/0x1e8
>  [<ffffffff8124d4f9>] acpi_ex_store_object_to_node+0x95/0xd8
>  [<ffffffff8124d5f4>] acpi_ex_store+0xb8/0x238
>  [<ffffffff8124ac87>] acpi_ex_opcode_1A_1T_1R+0x363/0x4b5
>  [<ffffffff8124342d>] acpi_ds_exec_end_op+0xcf/0x3ee
>  [<ffffffff81254883>] acpi_ps_parse_loop+0x7c9/0x96e
>  [<ffffffff81254df2>] acpi_ps_parse_aml+0x91/0x273
>  [<ffffffff8125560c>] acpi_ps_execute_method+0x1c6/0x276
>  [<ffffffff81250042>] acpi_ns_evaluate+0xbe/0x1a8
>  [<ffffffff81250341>] acpi_ns_init_one_device+0x81/0xab
>  [<ffffffff812526ba>] acpi_ns_walk_namespace+0xb9/0x173
>  [<ffffffff81250612>] acpi_ns_initialize_devices+0xf8/0x146
>  [<ffffffff8125c013>] acpi_initialize_objects+0x4a/0x53
>  [<ffffffff818b894b>] acpi_init+0x113/0x28f
>  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
>  [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
>  [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
> ---[ end trace 4eaa2a86a8e2da24 ]---
> ERROR: kmemcheck: Fatal error
>
> Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsdebug3+kmc+
> #6 System manufacturer System Product Name/P8P67 EVO
> RIP: 0010:[<ffffffff81252660>]  [<ffffffff81252660>]
> acpi_ns_walk_namespace+0x5f/0x173
> RSP: 0018:ffff8802158efd10  EFLAGS: 00010146
> RAX: 0000000000000000 RBX: 0000000000000007 RCX: 000000000000001e
> RDX: 0000000000000000 RSI: 0000000000000282 RDI: 0000000000000282
> RBP: ffff8802158efd70 R08: ffffffff81246140 R09: 0000000000000001
> R10: 5f42535f158efd48 R11: 43534f5f158efc18 R12: ffff88021589aeb0
> R13: 0000000000000001 R14: 0000000000000000 R15: ffff88021589af00
> FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: ffff880215820154 CR3: 000000000180c000 CR4: 00000000000407f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
>  [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
>  [<ffffffff81032c4b>] kmemcheck_show+0x8b/0xa0
>  [<ffffffff81033067>] kmemcheck_fault+0x77/0xd0
>  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
>  [<ffffffff8142ffb5>] page_fault+0x25/0x30
>  [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
>  [<ffffffff812469e7>] acpi_ev_initialize_op_regions+0x7c/0x8d
>  [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
>  [<ffffffff818b894b>] acpi_init+0x113/0x28f
>  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
>  [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
>  [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
>  [<ffffffffffffffff>] 0xffffffffffffffff

[...]

> === "acpi=off noioapic" (should be equivalent to acpi=off) ===
>
> Got these two backtraces:
>
> ------------------------------------------------------------
> ERROR: kmemcheck: Fatal error

[...]

> ERROR: kmemcheck: Fatal error

[...]

Now this is interesting:

> === noacpi pci=noacpi (eqv to "pci=noacpi") ===
>
> ------------------------------------------------------------
> WARNING: kmemcheck: Caught 32-bit read from uninitialized memory
> (ffff880215822408)
> 00000000000000000c001000000000040000000002000000e109000000000000
>  i i i i i i i i u u u u u u u u u u u u u u u u u u u u u u u u
>                  ^
>
> Pid: 1, comm: swapper/0 Not tainted 3.4.4+btrfsdebug3+kmc+ #6 System
> manufacturer System Product Name/P8P67 EVO
> RIP: 0010:[<ffffffff81353001>]  [<ffffffff81353001>]
> qi_submit_sync+0x2d1/0x3f0
> RSP: 0018:ffff8802158efcf0  EFLAGS: 00010002
> RAX: ffff880215822408 RBX: 0000000000000086 RCX: 0000000200000025
> RDX: ffff880215822400 RSI: ffffc9000000c000 RDI: ffff8802158fe050
> RBP: ffff8802158efd60 R08: ffffea000856c000 R09: 0000000000115c01
> R10: ffff8802158fe000 R11: ffff8802158fe010 R12: 0000000000000000
> R13: ffff88021581a7c0 R14: 0000000000000004 R15: ffff8802158ec180
> FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: ffff88021581608c CR3: 000000000180c000 CR4: 00000000000406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
>  [<ffffffff81353144>] qi_global_iec+0x24/0x30
>  [<ffffffff81357d63>] iommu_set_intr_remapping+0xd3/0x170
>  [<ffffffff818c3bbd>] enable_intr_remapping+0x20d/0x269
>  [<ffffffff8189e85d>] enable_IR+8189eb4d>] enable_IR_x2apic+0x92/0x298
>  [<ffffffff818a0ab3>] default_setup_apic_routing+0x12/0x78
>  [<ffffffff8189c99c>] native_smp_prepare_cpus+0x2ba/0x2ee
>  [<ffffffff81891bab>] kernel_init+0x89/0x1be
> kmemcheck: Limiting number of CPUs to 1.
> NMI watchdog: enabled, takes one hw-pmu counter.
> PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
> Hardware name: System Product Name
>  [<ffffffff812836c2>] ? vt_console_print+0xa2/0x3a0
>  [<ffffffff81427a6f>] printk+0x3c/0x3e
>  [<ffffffff8142ffb5>] page_fault+0x25/0x30
>  [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
>  [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
> ---[ end trace 4eaa2a86a8e2da22 ]---
>  [<ffffffff810330a9>] kmemcheck_fault+0xb9/0xd0
>  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x120
>  [<ffffffff8142ff90>] ? general_protection+0x30/0x30
>  [<ffffffff8142ff90>] ? general_protection+0x30/0x30
>  [<ffffffff8142ff90>] ? general_protection+0x30/0x30
>  <<EOE>>  [<ffffffff81252660>] ? acpi_ns_walk_namespace+0x5f/0x173
>  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x120
>  [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
>  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x120
>  [<ffffffff812469ac>] ? acpi_ev_initialize_op_regions+0x41/0x8d
>  [<ffffffff812469e7>] acpi_ev_initialize_op_regions+0x7c/0x8d
>  [<ffffffff818b8838>] ? acpi_sleep_init+0xee/0xee
>  [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
>  [<ffffffff818b894b>] acpi_init+0x113/0x28f
>  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
>  [<ffffffff81891b22>] ? start_kernel+0x341/0x341
> RSP: 0018:ffff8802158efbc8  EFLAGS: 00010286
>  [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
>  [<ffffffff81250341>] acpi_ns_init_one_device+0x81/0xab
>  [<ffffffff8125c013>] acpi_initialize_objects+0x4a/0x53
> ACPI: SSDT 00000000df0ee018 0083B (v01  PmRef  Cpu0Cst 00003001 INTL
> 20051117)
> ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL
> 20051117)
> R10: 5f315353158ef888 R11: 5f315353158ef888 R12: 0000000000000000
>  [<ffffffff81032c4b>] kmemcheck_show+0x8b/0xa0
>  [<ffffffff81254df2>] acpi_ps_parse_aml+0x91/0x273
>  [<ffffffffffffffff>] 0xffffffffffffffff
> RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000246
> FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
> ACPI: Power Resource [FN00] (off)
> usbcore: registered new device driver usb
> pci 0000:00:1c.0: PCI bridge to [bus 02-02]
> pci 0000:00:1c.7: PCI bridge to [bus 08-08]
> system 00:05: [io  0x0200-0x020f] has been reserved
> system 00:05: [io  0xffff] has been reserved
> ERROR: kmemcheck: Fatal error
> R10: 0000000000000000 R11: 42334f49158efa48 R12: 0000000000000000
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  [<ffffffff810324d9>] kmemcheck_read_strict+0x29/0xa0
>  [<ffffffff8124f8cf>] acpi_ns_lookup+0x203/0x339
>  [<ffffffff81256d16>] acpi_walk_resources+0x62/0xce
>  [<ffffffff81252aa4>] acpi_ns_get_device_callback+0x144/0x15e
> Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsdebug3+kmc+
> #6 System manufacturer System Product Name/P8P67 EVO
> RBP: ffff88021ec07d68 R08: 0000000000000000 R09: ffff880000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
> R13: ffff88021ec07dc0 R14: ffff880215822800 R15: 0000000000000021
> FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: ffff880215820154 CR3: 000000000180c000 CR4: 00000000000407f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
>  [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
>  [<ffffffff81032850>] kmemcheck_access+0x1d0/0x440
>  [<ffffffff8103308d>] kmemcheck_fault+0x9d/0xd0
>  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
>  [<ffffffff8142ffb5>] page_fault+0x25/0x30
>  [<ffffffff810179f1>] intel_pmu_save_and_restart+0x11/0x20
>  [<ffffffff81017b5d>] intel_pmu_handle_irq+0x15d/0x320
>  [<ffffffff814313ed>] perf_event_nmi_handler+0x1d/0x20
>  [<ffffffff81430c49>] nmi_handle.isra.0+0x49/0x80
>  [<ffffffff81430d60>] do_nmi+0xe0/0x310
>  [<ffffff0000000000004 R15: ffff8802158ec180
> FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: ffff88021581608c CR3: 000000000180c000 CR4: 00000000000406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
>  [<ffffffff81353144>] qi_global_iec+0x24/0x30
>  [<ffffffff81357d63>] iommu_set_intr_remapping+0xd3/0x170
>  [<ffffffff818c3bbd>] enable_intr_remapping+0x20d/0x269
>  [<ffffffff8189e85d>] enable_IR+0x5a/0x62
>  [<ffffffff8189eb4d>] enable_IR_x2apic+0x92/0x298
>  [<ffffffff818a0ab3>] default_setup_apic_routing+0x12/0x78
>  [<ffffffff8189c99c>] native_smp_prepare_cpus+0x2ba/0x2ee
>  [<ffffffff81891bab>] kernel_init+0x89/0x1be
> kmemcheck: Limiting number of CPUs to 1.
> NMI watchdog: enabled, takes one hw-pmu counter.
> PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
> Hardware name: System Product Name
>  [<ffffffff812836c2>] ? vt_console_print+0xa2/0x3a0
>  [<ffffffff81427a6f>] printk+0x3c/0x3e
>  [<ffffffff8142ffb5>] page_fault+0x25/0x30
>  [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
>  [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
> ---[ end trace 4eaa2a86a8e2da22 ]---
>  [<ffffffff810330a9>] kmemcheck_fault+0xb9/0xd0
>  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x120
>  [<ffffffff8142ff90>] ? general_protection+0x30/0x30
>  [<ffffffff8142ff90>] ? general_protection+0x30/0x30
>  [<ffffffff8142ff90>] ? general_protection+0x30/0x30
>  <<EOE>>  [<ffffffff81252660>] ? acpi_ns_walk_namespace+0x5f/0x173
>  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x120
>  [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
>  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x120
>  [<ffffffff812469ac>] ? acpi_ev_initialize_op_regions+0x41/0x8d
>  [<ffffffff812469e7>] acpi_ev_initialize_op_regions+0x7c/0x8d
>  [<ffffffff818b8838>] ? acpi_sleep_init+0xee/0xee
>  [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
>  [<ffffffff818b894b>] acpi_init+0x113/0x28f
>  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
>  [<ffffffff81891b22>] ? start_kernel+0x341/0x341
> RSP: 0018:ffff8802158efbc8  EFLAGS: 00010286
>  [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
>  [<ffffffff81250341>] acpi_ns_init_one_device+0x81/0xab
>  [<ffffffff8125c013>] acpi_initialize_objects+0x4a/0x53
> ACPI: SSDT 00000000df0ee018 0083B (v01  PmRef  Cpu0Cst 00003001 INTL
> 20051117)
> ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL
> 20051117)
> R10: 5f315353158ef888 R11: 5f315353158ef888 R12: 0000000000000000
>  [<ffffffff81032c4b>] kmemcheck_show+0x8b/0xa0
>  [<ffffffff81254df2>] acpi_ps_parse_aml+0x91/0x273
>  [<ffffffffffffffff>] 0xffffffffffffffff
> RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000246
> FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
> ACPI: Power Resource [FN00] (off)
> usbcore: registered new device driver usb
> pci 0000:00:1c.0: PCI bridge to [bus 02-02]
> pci 0000:00:1c.7: PCI bridge to [bus 08-08]
> system 00:05: [io  0x0200-0x020f] has been reserved
> system 00:05: [io  0xffff] has been reserved

[...]

It seems that we're getting messages from two CPUs at the same time.
Could you try booting with the nosmp option as well to see if anything
changes here? Given that there's also a warning from
smp_call_function_many() above, maybe something changed w.r.t.
SMP/kmemcheck initialisation order lately.

> IOMMU: Setting identity map for device 0000:00:1a.0 [0xdf0d6000 - 0xdf0e4fff]
> Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsdebug3+kmc+ #6
>  [<ffffffff8134da5b>] bus_set_iommu+0x3b/0x50
> audit: initializing netlink socket (disabled)
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> RAX: 0000000000000124 RBX: 0000000000000009 RCX: 0000000000000124
> CR2: ffff880215820154 CR3: 000000000180c000 CR4: 00000000000407f0
>  [<ffffffff811c8aa0>] add_disk+0x190/0x460

[...]

> === noapic pci=noacpi noacpi (eqv to "noapic pci=noacpi") ===

[...]

So could you please try booting with nosmp to see if it makes a
difference? That would narrow it down a bit.

Another thing you can try is try to figure out when things went wrong.
If you test an old kernel like 3.0 or so -- and find that kmemcheck
works, that's great, it means we have a way to narrow it down further.
I may also try your config here to see if I can reproduce it.

I guess there may really be two issues here, as you suspected, that
something goes wrong with both the ACPI memory mapping and also the
SMP thing.

Thanks for the report,


Vegard
