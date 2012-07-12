Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964842Ab2GLVy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 17:54:59 -0400
Received: from smtp-2.hut.fi ([130.233.228.92]:39253 "EHLO smtp-2.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932998Ab2GLVyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 17:54:51 -0400
X-Greylist: delayed 1268 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jul 2012 17:54:49 EDT
Date: Fri, 13 Jul 2012 00:33:07 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: Vegard Nossum <vegardno@ifi.uio.no>, Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: kmemcheck: Fatal error; system fails to boot when kmemcheck enabled
Message-ID: <20120712213305.GA11128@sli.dy.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5gxpn/Q6ypwruk0T"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TKK-Virus-Scanned: by amavisd-new-2.1.2-hutcc at katosiko.hut.fi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5gxpn/Q6ypwruk0T
Content-Type: multipart/mixed; boundary="69pVuxX8awAiJ7fD"
Content-Disposition: inline


--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Kernel 3.4.4 with kmemcheck enabled does not correctly boot on my
system, which is a x86-64, Core i7 Sandy Bridge computer with Asus
P8P67-EVO motherboard. The errors seem to be related to ACPI, but
there may be other things wrong. Userspace programs, particularly init
and in other cases some other binaries run from initramfs die with
SIGTRAP.

I have been able to boot far enough to get usable backtraces with at
least the following four sets of options (after some research, I think
the "noacpi" and "noioapic" parameters are no-ops; mentioning them for
completeness). The "Modules linked in:" lines say only <omitted>,
because the lines become too long and cause netconsole to eat most of
the messages. Here is the list from the running system without
kmemcheck (first words of /proc/kmemcheck):

   ip6_tables ebtable_nat ebtables tun cn parport_pc ppdev lp parport
   rfcomm bnep cpufreq_userspace cpufreq_stats cpufreq_powersave
   cpufreq_conservative binfmt_misc nfsd nfs nfs_acl auth_rpcgss
   fscache lockd sunrpc iptable_filter ipt_MASQUERADE ipt_REDIRECT
   iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack
   ip_tables x_tables xfs ext4 jbd2 mbcache radeon drm_kms_helper ttm
   drm i2c_algo_bit loop fuse kvm_intel kvm snd_hda_codec_hdmi
   snd_hda_codec_realtek snd_usb_audio snd_hda_intel snd_usbmidi_lib
   snd_hda_codec snd_hwdep joydev snd_pcm_oss snd_mixer_oss snd_pcm
   snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq
   acpi_cpufreq mperf ath3k coretemp eeepc_wmi button processor video
   asus_wmi sparse_keymap pci_hotplug snd_seq_device snd_timer mxm_wmi
   bluetooth wmi iTCO_wdt snd evdev rfkill psmouse serio_raw crc16
   intel_agp intel_gtt soundcore pcspkr i2c_i801 microcode i2c_core
   sha256_generic dm_crypt dm_mod raid456 async_raid6_recov
   async_memcpy async_pq async_xor xor async_tx raid6_pq md_mod nbd
   btrfs libcrc32c zlib_deflate sd_mod crc_t10dif firewire_ohci
   firewire_core r8169 crc_itu_t mii ahci libahci crc32c_intel
   ghash_clmulni_intel aesni_intel libata aes_x86_64 aes_generic
   cryptd scsi_mod e1000e thermal fan thermal_sys

=== noacpi (should be equivalent to no parameters) ===

Got this. Note that the pci_find_upstream_pcie_bridge warning also
happens on a healthy system without KMEMCHECK:

------------------------------------------------------------
WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (ffff880215822408)
00000000000000000c001000000000040000000002000000e109000000000000
 i i i i i i i i u u u u u u u u u u u u u u u u u u u u u u u u
                 ^

Pid: 1, comm: swapper/0 Not tainted 3.4.4+btrfsdebug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
 [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x120
 [<ffffffff81252660>] ? acpi_ns_walk_namespace+0x5f/0x173
 [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x120
 [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
 [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x120
 [<ffffffff812469ac>] ? acpi_ev_initialize_op_regions+0x41/0x8d
 [<ffffffff812469e7>] acpi_ev_initialize_op_regions+0x7c/0x8d
 [<ffffffff818b8838>] ? acpi_sleep_init+0xee/0xee
 [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
 [<ffffffff818b894b>] acpi_init+0x113/0x28f
 [<ffffffff810002b2>] do_one_initcall+0x122/0x170
 [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
Hardware name: System Product Name
Modules linked in: <omitted>
Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsdebug3+kmc+ #6
Call Trace:
 <NMI>  [<ffffffff8103a7fa>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8103a845>] warn_slowpath_null+0x15/0x20
 [<ffffffff810330a9>] kmemcheck_fault+0xb9/0xd0
 [<ffffffff81033067>] kmemcheck_fault+0x77/0xd0
 [<ffffffff81032592>] ? kmemcheck_read+0x42/0x70
 [<ffffffff8142ffb5>] ? page_fault+0x25/0x30
 [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x120
 [<ffffffff8142ffb5>] page_fault+0x25/0x30
 [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x120
 [<ffffffff81252660>] ? acpi_ns_walk_namespace+0x5f/0x173
 [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x120
 [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
 [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x120
 [<ffffffff812469ac>] ? acpi_ev_initialize_op_regions+0x41/0x8d
 [<ffffffff812469e7>] acpi_ev_initialize_op_regions+0x7c/0x8d
 [<ffffffff818b8838>] ? acpi_sleep_init+0xee/0xee
 [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
 [<ffffffff818b894b>] acpi_init+0x113/0x28f
 [<ffffffff810002b2>] do_one_initcall+0x122/0x170
 [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
 [<ffffffff81891582>] ? do_early_param+0x8c/0x8c
 [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81891b22>] ? start_kernel+0x341/0x341
 [<ffffffff814389a0>] ? gs_change+0x13/0x13
---[ end trace 4eaa2a86a8e2da23 ]---
ACPI: Executed 1 blocks of module-level executable AML code
------------[ cut here ]------------
WARNING: at kernel/smp.c:459 smp_call_function_many+0xbd/0x270()
Hardware name: System Product Name
Modules linked in: <omitted>
Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsdebug3+kmc+ #6
Call Trace:
 [<ffffffff8103a7fa>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8103336a>] ? kmemcheck_shadow_lookup+0x2a/0x70
 [<ffffffff8103a845>] warn_slowpath_null+0x15/0x20
 [<ffffffff810885bd>] smp_call_function_many+0xbd/0x270
 [<ffffffff8142ffb5>] ? page_fault+0x25/0x30
 [<ffffffff81031560>] ? leave_mm+0x40/0x40
 [<ffffffff81031560>] ? leave_mm+0x40/0x40
 [<ffffffff8108889d>] smp_call_function+0x1d/0x30
 [<ffffffff810888d3>] on_each_cpu+0x23/0x60
 [<ffffffff81031977>] flush_tlb_all+0x17/0x20
 [<ffffffff8110bac5>] __purge_vmap_area_lazy+0x165/0x1c0
 [<ffffffff81033067>] ? kmemcheck_fault+0x77/0xd0
 [<ffffffff8110bd85>] vm_unmap_aliases+0x165/0x180
 [<ffffffff8102e2e8>] change_page_attr_set_clr+0xb8/0x470
 [<ffffffff8142ffb5>] ? page_fault+0x25/0x30
 [<ffffffff8102eeda>] _set_memory_wb+0x2a/0x30
 [<ffffffff8102d262>] ioremap_change_attr+0x12/0x40
 [<ffffffff8102fcbd>] kernel_map_sync_memtype+0x7d/0xe0
 [<ffffffff8102cfe8>] __ioremap_caller+0x258/0x360
 [<ffffffff8102d11f>] ioremap_cache+0xf/0x20
 [<ffffffff814104a9>] acpi_os_map_memory+0xfc/0x15c
 [<ffffffff8124c739>] acpi_ex_system_memory_space_handler+0xe5/0x1e4
 [<ffffffff8124c654>] ? acpi_ex_do_logical_op+0x15f/0x15f
 [<ffffffff81246334>] acpi_ev_address_space_dispatch+0x1a5/0x1fb
 [<ffffffff812499b6>] acpi_ex_access_region+0x270/0x28d
 [<ffffffff81249d14>] acpi_ex_field_datum_io+0x10a/0x187
 [<ffffffff8124a061>] acpi_ex_write_with_update_rule+0xbd/0xc8
 [<ffffffff81249b24>] acpi_ex_insert_into_field+0x151/0x237
 [<ffffffff812496d5>] acpi_ex_write_data_to_field+0x1b9/0x1e8
 [<ffffffff8124d4f9>] acpi_ex_store_object_to_node+0x95/0xd8
 [<ffffffff8124d5f4>] acpi_ex_store+0xb8/0x238
 [<ffffffff8124ac87>] acpi_ex_opcode_1A_1T_1R+0x363/0x4b5
 [<ffffffff8124342d>] acpi_ds_exec_end_op+0xcf/0x3ee
 [<ffffffff8124335e>] ? acpi_ds_exec_begin_op+0x11e/0x11e
 [<ffffffff81254883>] acpi_ps_parse_loop+0x7c9/0x96e
 [<ffffffff81254df2>] acpi_ps_parse_aml+0x91/0x273
 [<ffffffff8125560c>] acpi_ps_execute_method+0x1c6/0x276
 [<ffffffff81250042>] acpi_ns_evaluate+0xbe/0x1a8
 [<ffffffff81250341>] acpi_ns_init_one_device+0x81/0xab
 [<ffffffff812526ba>] acpi_ns_walk_namespace+0xb9/0x173
 [<ffffffff812502c0>] ? acpi_ns_exec_module_code_list+0x194/0x194
 [<ffffffff818b8838>] ? acpi_sleep_init+0xee/0xee
 [<ffffffff81250612>] acpi_ns_initialize_devices+0xf8/0x146
 [<ffffffff8125c013>] acpi_initialize_objects+0x4a/0x53
 [<ffffffff818b894b>] acpi_init+0x113/0x28f
 [<ffffffff810002b2>] do_one_initcall+0x122/0x170
 [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
 [<ffffffff81891582>] ? do_early_param+0x8c/0x8c
 [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81891b22>] ? start_kernel+0x341/0x341
 [<ffffffff814389a0>] ? gs_change+0x13/0x13
---[ end trace 4eaa2a86a8e2da24 ]---
ERROR: kmemcheck: Fatal error

Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsdebug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
RIP: 0010:[<ffffffff81252660>]  [<ffffffff81252660>] acpi_ns_walk_namespace+0x5f/0x173
RSP: 0018:ffff8802158efd10  EFLAGS: 00010146
RAX: 0000000000000000 RBX: 0000000000000007 RCX: 000000000000001e
RDX: 0000000000000000 RSI: 0000000000000282 RDI: 0000000000000282
RBP: ffff8802158efd70 R08: ffffffff81246140 R09: 0000000000000001
R10: 5f42535f158efd48 R11: 43534f5f158efc18 R12: ffff88021589aeb0
R13: 0000000000000001 R14: 0000000000000000 R15: ffff88021589af00
FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff880215820154 CR3: 000000000180c000 CR4: 00000000000407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
 [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
 [<ffffffff81032c4b>] kmemcheck_show+0x8b/0xa0
 [<ffffffff81033067>] kmemcheck_fault+0x77/0xd0
 [<ffffffff81433465>] do_page_fault+0x445/0x4d0
 [<ffffffff8142ffb5>] page_fault+0x25/0x30
 [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
 [<ffffffff812469e7>] acpi_ev_initialize_op_regions+0x7c/0x8d
 [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
 [<ffffffff818b894b>] acpi_init+0x113/0x28f
 [<ffffffff810002b2>] do_one_initcall+0x122/0x170
 [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
 [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
 [<ffffffffffffffff>] 0xffffffffffffffff

[...]

------------[ cut here ]------------
WARNING: at drivers/pci/search.c:44 pci_find_upstream_pcie_bridge+0x50/0x70()
Hardware name: System Product Name
Modules linked in: <omitted>
Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsdebug3+kmc+ #6
Call Trace:
 [<ffffffff8103a7fa>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8103a845>] warn_slowpath_null+0x15/0x20
 [<ffffffff81208770>] pci_find_upstream_pcie_bridge+0x50/0x70
 [<ffffffff8135754d>] intel_iommu_device_group+0x7d/0x100
 [<ffffffff8134da70>] ? bus_set_iommu+0x50/0x50
 [<ffffffff8134da9b>] add_iommu_group+0x2b/0x60
 [<ffffffff8129f17d>] bus_for_each_dev+0x4d/0x90
 [<ffffffff8134da5b>] bus_set_iommu+0x3b/0x50
 [<ffffffff818c34b4>] intel_iommu_init+0xae9/0xc1a
 [<ffffffff818939ee>] ? clean_rootfs+0x1c1/0x1c1
 [<ffffffff81896aa3>] ? memblock_find_dma_reserve+0x13d/0x13d
 [<ffffffff81896ab6>] pci_iommu_init+0x13/0x3e
 [<ffffffff810002b2>] do_one_initcall+0x122/0x170
 [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
 [<ffffffff81891582>] ? do_early_param+0x8c/0x8c
 [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81891b22>] ? start_kernel+0x341/0x341
 [<ffffffff814389a0>] ? gs_change+0x13/0x13
---[ end trace 4eaa2a86a8e2da25 ]---

[...]

Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000005

Pid: 1, comm: init Tainted: G        W    3.4.4+btrfsdebug3+kmc+ #6
Call Trace:
 [<ffffffff81427927>] panic+0xb5/0x1c1
 [<ffffffff8103ec6c>] do_exit+0x7bc/0x8a0
 [<ffffffff8103efea>] do_group_exit+0x3a/0xa0
 [<ffffffff8104d655>] get_signal_to_deliver+0x1a5/0x5c0
 [<ffffffff8104c0b0>] ? send_signal+0x40/0x80
 [<ffffffff81002260>] do_signal+0x60/0x950
 [<ffffffff8104c88c>] ? force_sig_info+0xdc/0x100
 [<ffffffff81002bd5>] do_notify_resume+0x65/0x80
 [<ffffffff814377fa>] int_signal+0x12/0x17
 [<ffffffff81426069>] ? run_init_process+0x1e/0x20
 [<ffffffff814260ad>] ? init_post+0x42/0xbb
 [<ffffffff81891ce0>] ? kernel_init+0x1be/0x1be
 [<ffffffff81891582>] ? do_early_param+0x8c/0x8c
 [<ffffffff814389a4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81891b22>] ? start_kernel+0x341/0x341
 [<ffffffff814389a0>] ? gs_change+0x13/0x13
------------------------------------------------------------


=== "acpi=off noioapic" (should be equivalent to acpi=off) ===

Got these two backtraces:

------------------------------------------------------------
ERROR: kmemcheck: Fatal error

Pid: 597, comm: udevadm Tainted: G        W    3.4.4+btrfsdebug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
RIP: 0010:[<ffffffff81140d0f>]  [<ffffffff81140d0f>] address_space_init_once+0x6f/0x130
RSP: 0018:ffff8802123ef9a8  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff880211d63e80 RCX: 0000000000000000
RDX: ffffffff81a18090 RSI: ffff880211d63d40 RDI: ffff880211d63ec0
RBP: ffff8802123ef9b8 R08: 0000000000000000 R09: 0000000000000010
R10: 000000000000000c R11: 000000000000000e R12: ffff880211d63d40
R13: ffff880211d63d40 R14: ffff880211d60000 R15: ffffea0008475800
FS:  00007f5983b707a0(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88021214eb00 CR3: 00000002123fa000 CR4: 00000000000407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
 [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
 [<ffffffff81032c4b>] kmemcheck_show+0x8b/0xa0
 [<ffffffff81033067>] kmemcheck_fault+0x77/0xd0
 [<ffffffff81433465>] do_page_fault+0x445/0x4d0
 [<ffffffff8142ffb5>] page_fault+0x25/0x30
 [<ffffffff81140e8e>] inode_init_once+0xbe/0x120
 [<ffffffff81140ef9>] init_once+0x9/0x10
 [<ffffffff8111cb3a>] setup_object.isra.55+0x5a/0x70
 [<ffffffff8111d907>] new_slab+0x1c7/0x2c0
 [<ffffffff81429967>] __slab_alloc.constprop.63+0x155/0x4ba
 [<ffffffff8111eed4>] kmem_cache_alloc+0xf4/0x160
 [<ffffffff81141129>] alloc_inode+0x59/0x90
 [<ffffffff811426b0>] iget_locked+0xb0/0x190
 [<ffffffff811913f2>] sysfs_get_inode+0x12/0x150
 [<ffffffff81193436>] sysfs_lookup+0x76/0x120
 [<ffffffff8113377c>] __lookup_hash+0x5c/0x120
 [<ffffffff81135b30>] do_lookup+0x2a0/0x350
 [<ffffffff81136b04>] path_lookupat+0x114/0x700
 [<ffffffff8113711c>] do_path_lookup+0x2c/0xc0
 [<ffffffff811385f8>] user_path_at_empty+0x58/0xa0
 [<ffffffff8113864c>] user_path_at+0xc/0x10
 [<ffffffff8112dda0>] vfs_fstatat+0x30/0x70
 [<ffffffff8112de16>] vfs_stat+0x16/0x20
 [<ffffffff8112dfe5>] sys_newstat+0x15/0x30
 [<ffffffff8143753d>] system_call_fastpath+0x1a/0x1f
 [<ffffffffffffffff>] 0xffffffffffffffff

[...]

ERROR: kmemcheck: Fatal error

Pid: 631, comm: modprobe Tainted: G        W    3.4.4+btrfsdebug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
RIP: 0010:[<ffffffff81430c46>]  [<ffffffff81430c46>] nmi_handle.isra.0+0x46/0x80
RSP: 0018:ffff88021ec07e78  EFLAGS: 00010046
RAX: ffff88021580e580 RBX: ffff88021580e580 RCX: 0000000000000001
RDX: ffffffff81432d0b RSI: ffff88021ec07ef8 RDI: 0000000000000000
RBP: ffff88021ec07eb8 R08: 00003ffffffff000 R09: ffff880000000000
R10: 00000000116e0e01 R11: 00000000fffffff4 R12: 0000000000000000
R13: ffffffff81816828 R14: 0000000000000000 R15: ffff88021ec07ef8
FS:  00007fe3eecd9700(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88021214eb00 CR3: 00000002119ad000 CR4: 00000000000407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
 [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
 [<ffffffff81032850>] kmemcheck_access+0x1d0/0x440
 [<ffffffff8103308d>] kmemcheck_fault+0x9d/0xd0
 [<ffffffff81433465>] do_page_fault+0x445/0x4d0
 [<ffffffff8142ffb5>] page_fault+0x25/0x30
 [<ffffffff81430d60>] do_nmi+0xe0/0x310
 [<ffffffff814302dc>] end_repeat_nmi+0x1a/0x1e
 [<ffffffff8103305f>] kmemcheck_fault+0x6f/0xd0
 [<ffffffff81433465>] do_page_fault+0x445/0x4d0
 [<ffffffff8142ffb5>] page_fault+0x25/0x30
 [<ffffffff811e1517>] kobject_uevent_env+0x437/0x640
 [<ffffffff811e172b>] kobject_uevent+0xb/0x10
 [<ffffffff8129e63e>] device_add+0x5ae/0x6a0
 [<ffffffffa00e8269>] scsi_add_host_with_dma+0x99/0x290 [scsi_mod]
 [<ffffffffa0174274>] ata_scsi_add_hosts+0xa4/0x130 [libata]
 [<ffffffffa016f5c3>] ata_host_register+0xf3/0x290 [libata]
 [<ffffffffa016f82e>] ata_host_activate+0xce/0x110 [libata]
 [<ffffffffa02329a7>] ahci_init_one+0x627/0xa2c [ahci]
 [<ffffffff8120803f>] pci_device_probe+0xaf/0x130
 [<ffffffff812a106d>] driver_probe_device+0x8d/0x3a0
 [<ffffffff812a141b>] __driver_attach+0x9b/0xa0
 [<ffffffff8129f17d>] bus_for_each_dev+0x4d/0x90
 [<ffffffff812a09d9>] driver_attach+0x19/0x20
 [<ffffffff812a0658>] bus_add_driver+0x1a8/0x2a0
 [<ffffffff812a1882>] driver_register+0x72/0x150
 [<ffffffff81207a09>] __pci_register_driver+0x59/0xd0
 [<ffffffffa023901e>] ahci_init+0x1e/0x20 [ahci]
 [<ffffffff810002b2>] do_one_initcall+0x122/0x170
 [<ffffffff8108d91e>] sys_init_module+0x109e/0x2070
 [<ffffffff8143753d>] system_call_fastpath+0x1a/0x1f
 [<ffffffffffffffff>] 0xffffffffffffffff
------------------------------------------------------------


=== noacpi pci=noacpi (eqv to "pci=noacpi") ===

------------------------------------------------------------
WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (ffff880215822408)
00000000000000000c001000000000040000000002000000e109000000000000
 i i i i i i i i u u u u u u u u u u u u u u u u u u u u u u u u
                 ^

Pid: 1, comm: swapper/0 Not tainted 3.4.4+btrfsdebug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
RIP: 0010:[<ffffffff81353001>]  [<ffffffff81353001>] qi_submit_sync+0x2d1/0x3f0
RSP: 0018:ffff8802158efcf0  EFLAGS: 00010002
RAX: ffff880215822408 RBX: 0000000000000086 RCX: 0000000200000025
RDX: ffff880215822400 RSI: ffffc9000000c000 RDI: ffff8802158fe050
RBP: ffff8802158efd60 R08: ffffea000856c000 R09: 0000000000115c01
R10: ffff8802158fe000 R11: ffff8802158fe010 R12: 0000000000000000
R13: ffff88021581a7c0 R14: 0000000000000004 R15: ffff8802158ec180
FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff88021581608c CR3: 000000000180c000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
 [<ffffffff81353144>] qi_global_iec+0x24/0x30
 [<ffffffff81357d63>] iommu_set_intr_remapping+0xd3/0x170
 [<ffffffff818c3bbd>] enable_intr_remapping+0x20d/0x269
 [<ffffffff8189e85d>] enable_IR+8189eb4d>] enable_IR_x2apic+0x92/0x298
 [<ffffffff818a0ab3>] default_setup_apic_routing+0x12/0x78
 [<ffffffff8189c99c>] native_smp_prepare_cpus+0x2ba/0x2ee
 [<ffffffff81891bab>] kernel_init+0x89/0x1be
kmemcheck: Limiting number of CPUs to 1.
NMI watchdog: enabled, takes one hw-pmu counter.
PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
Hardware name: System Product Name
 [<ffffffff812836c2>] ? vt_console_print+0xa2/0x3a0
 [<ffffffff81427a6f>] printk+0x3c/0x3e
 [<ffffffff8142ffb5>] page_fault+0x25/0x30
 [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
 [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
---[ end trace 4eaa2a86a8e2da22 ]---
 [<ffffffff810330a9>] kmemcheck_fault+0xb9/0xd0
 [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x120
 [<ffffffff8142ff90>] ? general_protection+0x30/0x30
 [<ffffffff8142ff90>] ? general_protection+0x30/0x30
 [<ffffffff8142ff90>] ? general_protection+0x30/0x30
 <<EOE>>  [<ffffffff81252660>] ? acpi_ns_walk_namespace+0x5f/0x173
 [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x120
 [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
 [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x120
 [<ffffffff812469ac>] ? acpi_ev_initialize_op_regions+0x41/0x8d
 [<ffffffff812469e7>] acpi_ev_initialize_op_regions+0x7c/0x8d
 [<ffffffff818b8838>] ? acpi_sleep_init+0xee/0xee
 [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
 [<ffffffff818b894b>] acpi_init+0x113/0x28f
 [<ffffffff810002b2>] do_one_initcall+0x122/0x170
 [<ffffffff81891b22>] ? start_kernel+0x341/0x341
RSP: 0018:ffff8802158efbc8  EFLAGS: 00010286
 [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
 [<ffffffff81250341>] acpi_ns_init_one_device+0x81/0xab
 [<ffffffff8125c013>] acpi_initialize_objects+0x4a/0x53
ACPI: SSDT 00000000df0ee018 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
R10: 5f315353158ef888 R11: 5f315353158ef888 R12: 0000000000000000
 [<ffffffff81032c4b>] kmemcheck_show+0x8b/0xa0
 [<ffffffff81254df2>] acpi_ps_parse_aml+0x91/0x273
 [<ffffffffffffffff>] 0xffffffffffffffff
RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000246
FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
ACPI: Power Resource [FN00] (off)
usbcore: registered new device driver usb
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.7: PCI bridge to [bus 08-08]
system 00:05: [io  0x0200-0x020f] has been reserved
system 00:05: [io  0xffff] has been reserved
ERROR: kmemcheck: Fatal error
R10: 0000000000000000 R11: 42334f49158efa48 R12: 0000000000000000
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [<ffffffff810324d9>] kmemcheck_read_strict+0x29/0xa0
 [<ffffffff8124f8cf>] acpi_ns_lookup+0x203/0x339
 [<ffffffff81256d16>] acpi_walk_resources+0x62/0xce
 [<ffffffff81252aa4>] acpi_ns_get_device_callback+0x144/0x15e
Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsdebug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
RBP: ffff88021ec07d68 R08: 0000000000000000 R09: ffff880000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffff88021ec07dc0 R14: ffff880215822800 R15: 0000000000000021
FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff880215820154 CR3: 000000000180c000 CR4: 00000000000407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
 [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
 [<ffffffff81032850>] kmemcheck_access+0x1d0/0x440
 [<ffffffff8103308d>] kmemcheck_fault+0x9d/0xd0
 [<ffffffff81433465>] do_page_fault+0x445/0x4d0
 [<ffffffff8142ffb5>] page_fault+0x25/0x30
 [<ffffffff810179f1>] intel_pmu_save_and_restart+0x11/0x20
 [<ffffffff81017b5d>] intel_pmu_handle_irq+0x15d/0x320
 [<ffffffff814313ed>] perf_event_nmi_handler+0x1d/0x20
 [<ffffffff81430c49>] nmi_handle.isra.0+0x49/0x80
 [<ffffffff81430d60>] do_nmi+0xe0/0x310
 [<ffffff0000000000004 R15: ffff8802158ec180
FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff88021581608c CR3: 000000000180c000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
 [<ffffffff81353144>] qi_global_iec+0x24/0x30
 [<ffffffff81357d63>] iommu_set_intr_remapping+0xd3/0x170
 [<ffffffff818c3bbd>] enable_intr_remapping+0x20d/0x269
 [<ffffffff8189e85d>] enable_IR+0x5a/0x62
 [<ffffffff8189eb4d>] enable_IR_x2apic+0x92/0x298
 [<ffffffff818a0ab3>] default_setup_apic_routing+0x12/0x78
 [<ffffffff8189c99c>] native_smp_prepare_cpus+0x2ba/0x2ee
 [<ffffffff81891bab>] kernel_init+0x89/0x1be
kmemcheck: Limiting number of CPUs to 1.
NMI watchdog: enabled, takes one hw-pmu counter.
PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
Hardware name: System Product Name
 [<ffffffff812836c2>] ? vt_console_print+0xa2/0x3a0
 [<ffffffff81427a6f>] printk+0x3c/0x3e
 [<ffffffff8142ffb5>] page_fault+0x25/0x30
 [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
 [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
---[ end trace 4eaa2a86a8e2da22 ]---
 [<ffffffff810330a9>] kmemcheck_fault+0xb9/0xd0
 [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x120
 [<ffffffff8142ff90>] ? general_protection+0x30/0x30
 [<ffffffff8142ff90>] ? general_protection+0x30/0x30
 [<ffffffff8142ff90>] ? general_protection+0x30/0x30
 <<EOE>>  [<ffffffff81252660>] ? acpi_ns_walk_namespace+0x5f/0x173
 [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x120
 [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
 [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x120
 [<ffffffff812469ac>] ? acpi_ev_initialize_op_regions+0x41/0x8d
 [<ffffffff812469e7>] acpi_ev_initialize_op_regions+0x7c/0x8d
 [<ffffffff818b8838>] ? acpi_sleep_init+0xee/0xee
 [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
 [<ffffffff818b894b>] acpi_init+0x113/0x28f
 [<ffffffff810002b2>] do_one_initcall+0x122/0x170
 [<ffffffff81891b22>] ? start_kernel+0x341/0x341
RSP: 0018:ffff8802158efbc8  EFLAGS: 00010286
 [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
 [<ffffffff81250341>] acpi_ns_init_one_device+0x81/0xab
 [<ffffffff8125c013>] acpi_initialize_objects+0x4a/0x53
ACPI: SSDT 00000000df0ee018 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
R10: 5f315353158ef888 R11: 5f315353158ef888 R12: 0000000000000000
 [<ffffffff81032c4b>] kmemcheck_show+0x8b/0xa0
 [<ffffffff81254df2>] acpi_ps_parse_aml+0x91/0x273
 [<ffffffffffffffff>] 0xffffffffffffffff
RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000246
FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
ACPI: Power Resource [FN00] (off)
usbcore: registered new device driver usb
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.7: PCI bridge to [bus 08-08]
system 00:05: [io  0x0200-0x020f] has been reserved
system 00:05: [io  0xffff] has been reserved
ERROR: kmemcheck: Fatal error
R10: 0000000000000000 R11: 42334f49158efa48 R12: 0000000000000000
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [<ffffffff810324d9>] kmemcheck_read_strict+0x29/0xa0
 [<ffffffff8124f8cf>] acpi_ns_lookup+0x203/0x339
 [<ffffffff81256d16>] acpi_walk_resources+0x62/0xce
 [<ffffffff81252aa4>] acpi_ns_get_device_callback+0x144/0x15e
Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsdebug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
RBP: ffff88021ec07d68 R08: 0000000000000000 R09: ffff880000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffff88021ec07dc0 R14: ffff880215822800 R15: 0000000000000021
FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff880215820154 CR3: 000000000180c000 CR4: 00000000000407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 00fffff8124f8cf>] acpi_ns_lookup+0x203/0x339
 [<ffffffff81253870>] acpi_ps_get_next_namepath+0x74/0x1cf
 [<ffffffff81254570>] acpi_ps_parse_loop+0x4b6/0x96e
 [<ffffffff81254df2>] acpi_ps_parse_aml+0x91/0x273
 [<ffffffff8125560c>] acpi_ps_execute_method+0x1c6/0x276
 [<ffffffff81250042>] acpi_ns_evaluate+0xbe/0x1a8
 [<ffffffff81259cfa>] acpi_ut_evaluate_object+0x7e/0x1a7
 [<ffffffff81256a74>] acpi_rs_get_method_data+0x1a/0x40
 [<ffffffff81256d16>] acpi_walk_resources+0x62/0xce
 [<ffffffff81264e2f>] pnpacpi_parse_allocated_resource+0x3f/0x70
 [<ffffffff818ba200>] pnpacpi_add_device_handler+0x193/0x211
 [<ffffffff81252aa4>] acpi_ns_get_device_callback+0x144/0x15e
 [<ffffffff812526ba>] acpi_ns_walk_namespace+0xb9/0x173
 [<ffffffff81252949>] acpi_get_devices+0x61/0x78

[...]

IOMMU: Setting identity map for device 0000:00:1a.0 [0xdf0d6000 - 0xdf0e4fff]
Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsdebug3+kmc+ #6
 [<ffffffff8134da5b>] bus_set_iommu+0x3b/0x50
audit: initializing netlink socket (disabled)
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
RAX: 0000000000000124 RBX: 0000000000000009 RCX: 0000000000000124
CR2: ffff880215820154 CR3: 000000000180c000 CR4: 00000000000407f0
 [<ffffffff811c8aa0>] add_disk+0x190/0x460

[...]

ERROR: kmemcheck: Fatal error
RBP: ffff88021ec03dd8 R08: ffff88021ec12140 R09: 0000000000000000
 [<ffffffff81891b15>] start_kernel+0x334/0x341
generic-usb 0003:046D:C501.0004: input,hidraw3: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1d.0-1.3/input0
console [netcon0] enabled
netconsole: network logging started
rtc_cmos 00:06: setting system clock to 2012-07-12 19:00:02 UTC (1342119602)
Freeing unused kernel memory: 512k freed
Write protecting the kernel read-only data: 8192k
Freeing unused kernel memory: 1792k freed
Freeing unused kernel memory: 52k freed
Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000005

Pid: 1, comm: init Tainted: G        W    3.4.4+btrfsdebug3+kmc+ #6
Call Trace:
 [<ffffffff81427927>] panic+0xb5/0x1c1
 [<ffffffff8103ec6c>] do_exit+0x7bc/0x8a0
 [<ffffffff8103efea>] do_group_exit+0x3a/0xa0
 [<ffffffff8104d655>] get_signal_to_deliver+0x1a5/0x5c0
 [<ffffffff8104c0b0>] ? send_signal+0x40/0x80
 [<ffffffff81002260>] do_signal+0x60/0x950
 [<ffffffff8104c88c>] ? force_sig_info+0xdc/0x100
 [<ffffffff81002bd5>] do_notify_resume+0x65/0x80
 [<ffffffff814377fa>] int_signal+0x12/0x17
 [<ffffffff81426069>] ? run_init_process+0x1e/0x20
 [<ffffffff814260ad>] ? init_post+0x42/0xbb
 [<ffffffff81891ce0>] ? kernel_init+0x1be/0x1be
 [<ffffffff81891582>] ? do_early_param+0x8c/0x8c
 [<ffffffff814389a4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81891b22>] ? start_kernel+0x341/0x341
 [<ffffffff814389a0>] ? gs_change+0x13/0x13
------------------------------------------------------------

=== noapic pci=noacpi noacpi (eqv to "noapic pci=noacpi") ===

------------------------------------------------------------
------------[ cut here ]------------
------------[ cut here ]------------
WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 kmemcheck_fault+0xb9/0xd0()
Hardware name: System Product Name
Modules linked in: <omitted>
Pid: 1, comm: swapper/0 Not tainted 3.4.4+btrfsdebug3+kmc+ #6
Call Trace:
 <NMI>  [<ffffffff8103a7fa>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8103a845>] warn_slowpath_null+0x15/0x20
 [<ffffffff810330a9>] kmemcheck_fault+0xb9/0xd0
 [<ffffffff81433465>] do_page_fault+0x445/0x4d0
 [<ffffffff8142ffb5>] page_fault+0x25/0x30
 [<ffffffff812836c2>] ? vt_console_print+0xa2/0x3a0
 [<ffffffff81283687>] ? vt_console_print+0x67/0x3a0
 [<ffffffff8103a7b9>] warn_slowpath_common+0x39/0xb0
 [<ffffffff81430c46>] ? nmi_handle.isra.0+0x46/0x80
 [<ffffffff8142fb8a>] ? _raw_spin_lock_irqsave+0x1a/0x40
 [<ffffffff818b894b>] acpi_init+0x113/0x28f
 [<ffffffff814389a0>] ? gs_change+0x13/0x13
Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsdebug3+kmc+ #6
 [<ffffffff81430d60>] do_nmi+0xe0/0x310
 [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x120
 [<ffffffff818b894b>] acpi_init+0x113/0x28f
 [<ffffffff81891b22>] ? start_kernel+0x341/0x341
------------[ cut here ]------------
 [<ffffffff8103336a>] ? kmemcheck_shadow_lookup+0x2a/0x70
 [<ffffffff8103a845>] warn_slowpath_null+0x15/0x20
 [<ffffffff810885bd>] smp_call_function_many+0xbd/0x270
 [<ffffffff8142ffb5>] ? page_fault+0x25/0x30
 [<ffffffff81031560>] ? leave_mm+0x40/0x40
 [<ffffffff81031560>] ? leave_mm+0x40/0x40
 [<ffffffff8108889d>] smp_call_function+0x1d/0x30
 [<ffffffff810888d3>] on_each_cpu+0x23/0x60
 [<ffffffff81031977>] flush_tlb_all+0x17/0x20
 [<ffffffff8110bac5>] __purge_vmap_area_lazy+0x165/0x1c0
 [<ffffffff81033067>] ? kmemcheck_fault+0x77/0xd0
 [<ffffffff8110bd85>] vm_unmap_aliases+0x165/0x180
 [<ffffffff8102e2e8>] change_page_attr_set_clr+0xb8/0x470
 [<ffffffff8142ffb5>] ? page_fault+0x25/0x30
 [<ffffffff8102eeda>] _set_memory_wb+0x2a/0x30
 [<ffffffff812499b6>] acpi_ex_access_region+0x270/0x28d
 [<ffffffff8124342d>] acpi_ds_exec_end_op+0xcf/0x3ee
RSP: 0018:ffff8802158ef070  EFLAGS: 00010082
RBP: ffff8802158ef0c0 R08: 0000000000000000 R09: 0000000000000000
 [<ffffffff81032c4b>] kmemcheck_show+0x8b/0xa0
 [<ffffffff81005877>] show_trace_log_lvl+0x57/0x70
 [<ffffffff81031977>] flush_tlb_all+0x17/0x20
 [<ffffffff814104a9>] acpi_os_map_memory+0xfc/0x15c
ACPI: SSDT 00000000df0f0c18 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
RAX: 0000000000000002 RBX: ffff880215a8f798 RCX: 0000000000000001
FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
 [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
 [<ffffffff8124358f>] acpi_ds_exec_end_op+0x231/0x3ee
 [<ffffffff81252ca6>] acpi_evaluate_object+0x122/0x22e
 [<ffffffffffffffff>] 0xffffffffffffffff
R10: ffffffffffffffff R11: 54534f49158ef8c8 R12: ffff8802158ef8c8
 [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
 [<ffffffff8124f8cf>] acpi_ns_lookup+0x203/0x339
 [<ffffffff81252ca6>] acpi_evaluate_object+0x122/0x22e
 [<ffffffff8123b385>] acpi_bus_scan+0x56/0x77
 [<ffffffffffffffff>] 0xffffffffffffffff
CR2: ffff880215820154 CR3: 000000000180c000 CR4: 00000000000407f0
 [<ffffffff814302dc>] end_repeat_nmi+0x1a/0x1e
 [<ffffffff81252560>] acpi_ns_get_node+0x3f/0x9f
 [<ffffffff81252b51>] acpi_walk_namespace+0x93/0xc6
 [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
 [<ffffffffffffffff>] 0xffffffffffffffff
ERROR: kmemcheck: Fatal error

Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsdebug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
RIP: 0010:[<ffffffff81011f3a>]  [<ffffffff81011f3a>] x86_perf_event_update+0x2a/0xc0
RSP: 0018:ffff88021ec07d20  EFLAGS: 00010002
RAX: 00000000ffffffff RBX: 0000000000000010 RCX: 0000000000000390
RDX: 0000000000000021 RSI: 0000000000000040 RDI: ffff880215822400
RBP: ffff88021ec07d68 R08: 0000000000000000 R09: ffff880000000000
R10: ffffffffffffffff R11: 0000000000000000 R12: 0000000000000001
R13: ffff88021ec07dc0 R14: ffff880215822400 R15: 0000000000000021
FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff880215820154 CR3: 000000000180c000 CR4: 00000000000407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
 [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
 [<ffffffff81032850>] kmemcheck_access+0x1d0/0x440
 [<ffffffff8103308d>] kmemcheck_fault+0x9d/0xd0
 [<ffffffff81433465>] do_page_fault+0x445/0x4d0
 [<ffffffff8142ffb5>] page_fault+0x25/0x30
 [<ffffffff810179f1>] intel_pmu_save_and_restart+0x11/0x20
 [<ffffffff81017b5d>] intel_pmu_handle_irq+0x15d/0x320
 [<ffffffff814313ed>] perf_event_nmi_handler+0x1d/0x20
 [<ffffffff81430c49>] nmi_handle.isra.0+0x49/0x80
 [<ffffffff81430d60>] do_nmi+0xe0/0x310
 [<ffffffff814302dc>] end_repeat_nmi+0x1a/0x1e
 [<ffffffff81033351>] kmemcheck_shadow_lookup+0x11/0x70
 [<ffffffff810325df>] kmemcheck_write_strict.isra.1+0x1f/0x50
 [<ffffffff810328d4>] kmemcheck_access+0x254/0x440
 [<ffffffff8103305f>] kmemcheck_fault+0x6f/0xd0
 [<ffffffff81433465>] do_page_fault+0x445/0x4d0
 [<ffffffff8142ffb5>] page_fault+0x25/0x30
 [<ffffffff812522b6>] acpi_ns_internalize_name+0x52/0x77
 [<ffffffff81252560>] acpi_ns_get_node+0x3f/0x9f
 [<ffffffff8124ffc2>] acpi_ns_evaluate+0x3e/0x1a8
 [<ffffffff81259cfa>] acpi_ut_evaluate_object+0x7e/0x1a7
 [<ffffffff81259ef6>] acpi_ut_execute_power_methods+0x3f/0x79
 [<ffffffff812533fb>] acpi_get_object_info+0x1b5/0x326
 [<ffffffff8123a8c8>] acpi_add_single_object+0x264/0xb64

[...]

IOMMU 0 0xfed90000: using Queued invalidation
Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsdebug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
R13: ffff88021278d500 R14: 0000000000000004 R15: ffff8802158ec180
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
 [<ffffffff81353196>] qi_flush_context+0x46/0x50
 [<ffffffff818c3343>] intel_iommu_init+0x978/0xc1a
 [<ffffffff81896ab6>] pci_iommu_init+0x13/0x3e
 [<ffffffff810002b2>] do_one_initcall+0x122/0x170
 [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
 [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
 [<ffffffffffffffff>] 0xffffffffffffffff
Hardware name: System Product Name
Modules linked in: <omitted>
Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsdebug3+kmc+ #6
Call Trace:
 [<ffffffff8103a7fa>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8103a845>] warn_slowpath_null+0x15/0x20
 [<ffffffff81208770>] pci_find_upstream_pcie_bridge+0x50/0x70
 [<ffffffff8135754d>] intel_iommu_device_group+0x7d/0x100
 [<ffffffff8134da70>] ? bus_set_iommu+0x50/0x50
 [<ffffffff8134da9b>] add_iommu_group+0x2b/0x60
 [<ffffffff8129f17d>] bus_for_each_dev+0x4d/0x90
 [<ffffffff8134da5b>] bus_set_iommu+0x3b/0x50
 [<ffffffff818c34b4>] intel_iommu_init+0xae9/0xc1a
 [<ffffffff818939ee>] ? clean_rootfs+0x1c1/0x1c1
 [<ffffffff81896aa3>] ? memblock_find_dma_reserve+0x13d/0x13d
 [<ffffffff81896ab6>] pci_iommu_init+0x13/0x3e
 [<ffffffff810002b2>] do_one_initcall+0x122/0x170
 [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
 [<ffffffff81891582>] ? do_early_param+0x8c/0x8c
 [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81891b22>] ? start_kernel+0x341/0x341
 [<ffffffff814389a0>] ? gs_change+0x13/0x13
---[ end trace 4eaa2a86a8e2da25 ]---

[...]

Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000005

Pid: 1, comm: init Tainted: G        W    3.4.4+btrfsdebug3+kmc+ #6
Call Trace:
 [<ffffffff81427927>] panic+0xb5/0x1c1
 [<ffffffff8103ec6c>] do_exit+0x7bc/0x8a0
 [<ffffffff8103efea>] do_group_exit+0x3a/0xa0
 [<ffffffff8104d655>] get_signal_to_deliver+0x1a5/0x5c0
 [<ffffffff8104c0b0>] ? send_signal+0x40/0x80
 [<ffffffff81002260>] do_signal+0x60/0x950
 [<ffffffff8104c88c>] ? force_sig_info+0xdc/0x100
 [<ffffffff81002bd5>] do_notify_resume+0x65/0x80
 [<ffffffff814377fa>] int_signal+0x12/0x17
 [<ffffffff81426069>] ? run_init_process+0x1e/0x20
 [<ffffffff814260ad>] ? init_post+0x42/0xbb
 [<ffffffff81891ce0>] ? kernel_init+0x1be/0x1be
 [<ffffffff81891582>] ? do_early_param+0x8c/0x8c
 [<ffffffff814389a4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81891b22>] ? start_kernel+0x341/0x341
 [<ffffffff814389a0>] ? gs_change+0x13/0x13
------------------------------------------------------------


Full dmesg outputs attached, as well as dmesg from a healthy boot
without KMEMCHECK.

	Sami

--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="healthy.log"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.4-modded-oops+ (sliedes@lh) (gcc version 4=
=2E7.1 (Debian 4.7.1-2) ) #2 SMP Wed Jul 4 15:49:35 EEST 2012
[    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-3.4.4-modded-oops+ root=
=3D/dev/mapper/rootvg-root_crypt ro rootfstype=3Dbtrfs zcache
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
[    0.000000]  BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000deb91000 (usable)
[    0.000000]  BIOS-e820: 00000000deb91000 - 00000000df141000 (reserved)
[    0.000000]  BIOS-e820: 00000000df141000 - 00000000df386000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df386000 - 00000000df394000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df394000 - 00000000df3c1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df3c1000 - 00000000df3c6000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df3c6000 - 00000000df409000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df409000 - 00000000df800000 (usable)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed04000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000021f000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: System manufacturer System Product Name/P8P67 EVO, BIOS=
 3207 04/13/2012
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usab=
le)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x21f000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FF0000000 write-back
[    0.000000]   2 base 210000000 mask FF8000000 write-back
[    0.000000]   3 base 218000000 mask FFC000000 write-back
[    0.000000]   4 base 21C000000 mask FFE000000 write-back
[    0.000000]   5 base 21E000000 mask FFF000000 write-back
[    0.000000]   6 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] e820 update range: 00000000e0000000 - 0000000100000000 (usab=
le) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0xdf800 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fce00] fce00
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009b000] 9b000 size 8192
[    0.000000] init_memory_mapping: 0000000000000000-00000000df800000
[    0.000000]  0000000000 - 00df800000 page 2M
[    0.000000] kernel direct mapping tables up to df800000 @ 1fffb000-20000=
000
[    0.000000] init_memory_mapping: 0000000100000000-000000021f000000
[    0.000000]  0100000000 - 021f000000 page 2M
[    0.000000] kernel direct mapping tables up to 21f000000 @ df7f6000-df80=
0000
[    0.000000] RAMDISK: 263e0000 - 2f1e8000
[    0.000000] ACPI: RSDP 00000000000f0450 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000df386070 00064 (v01 ALASKA    A M I 01072=
009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000df391cd8 000F4 (v04 ALASKA    A M I 01072=
009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000df386168 0BB6D (v02 ALASKA    A M I 00000=
015 INTL 20051117)
[    0.000000] ACPI: FACS 00000000df3bff80 00040
[    0.000000] ACPI: APIC 00000000df391dd0 00092 (v03 ALASKA    A M I 01072=
009 AMI  00010013)
[    0.000000] ACPI: MCFG 00000000df391e68 0003C (v01 ALASKA    A M I 01072=
009 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000df391ea8 00038 (v01 ALASKA    A M I 01072=
009 AMI. 00000005)
[    0.000000] ACPI: SSDT 00000000df391ee0 0036D (v01 SataRe SataTabl 00001=
000 INTL 20091112)
[    0.000000] ACPI: SSDT 00000000df392250 009AA (v01  PmRef  Cpu0Ist 00003=
000 INTL 20051117)
[    0.000000] ACPI: SSDT 00000000df392c00 00A92 (v01  PmRef    CpuPm 00003=
000 INTL 20051117)
[    0.000000] ACPI: DMAR 00000000df393698 00078 (v01 INTEL      SNB  00000=
001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00087fffff] PMD -> [ffff88021660000=
0-ffff88021e5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0021f000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000deb91
[    0.000000]     0: 0x000df409 -> 0x000df800
[    0.000000]     0: 0x00100000 -> 0x0021f000
[    0.000000] On node 0 totalpages: 2088725
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 2 pages reserved
[    0.000000]   DMA zone: 3915 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 892872 pages, LIFO batch:31
[    0.000000]   Normal zone: 18368 pages used for memmap
[    0.000000]   Normal zone: 1157184 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] Allocating PCI resources starting at df800000 (gap: df800000=
:18800000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:8 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88021ec00000 s77120 r8192=
 d21184 u262144
[    0.000000] pcpu-alloc: s77120 r8192 d21184 u262144 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 2053971
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-3.4.4-modded-oops=
+ root=3D/dev/mapper/rootvg-root_crypt ro rootfstype=3Dbtrfs zcache
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608=
 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 b=
ytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 7988644k/8896512k available (4206k kernel code, 5416=
12k absent, 366256k reserved, 4472k data, 508k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D8, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 3411.163 MHz processor.
[    0.000002] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6822.32 BogoMIPS (lpj=3D13644652)
[    0.000113] pid_max: default: 32768 minimum: 301
[    0.000185] Security Framework initialized
[    0.000251] Mount-cache hash table entries: 256
[    0.000407] Initializing cgroup subsys cpuacct
[    0.000464] Initializing cgroup subsys devices
[    0.000521] Initializing cgroup subsys freezer
[    0.000577] Initializing cgroup subsys net_cls
[    0.000633] Initializing cgroup subsys blkio
[    0.000691] Initializing cgroup subsys perf_event
[    0.000763] CPU: Physical Processor ID: 0
[    0.000818] CPU: Processor Core ID: 0
[    0.000875] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.000876] ENERGY_PERF_BIAS: View and update with x86_energy_perf_polic=
y(8)
[    0.000991] mce: CPU supports 9 MCE banks
[    0.001054] CPU0: Thermal monitoring enabled (TM1)
[    0.001115] using mwait in idle threads.
[    0.001968] ACPI: Core revision 20120320
[    0.101769] DMAR: Host address width 36
[    0.101824] DMAR: DRHD base: 0x000000fed90000 flags: 0x1
[    0.101885] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020660262 e=
cap f0105a
[    0.101947] DMAR: RMRR base: 0x000000df0d6000 end: 0x000000df0e4fff
[    0.102073] IOAPIC id 2 under DRHD base  0xfed90000 IOMMU 0
[    0.102131] HPET id 0 under DRHD base 0xfed90000
[    0.102254] Enabled IRQ remapping in x2apic mode
[    0.102310] Enabling x2apic
[    0.102363] Enabled x2apic
[    0.102422] Switched APIC routing to cluster x2apic.
[    0.102892] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.142605] CPU0: Intel(R) Core(TM) i7-2600 CPU @ 3.40GHz stepping 07
[    0.248959] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge eve=
nts, Intel PMU driver.
[    0.249214] PEBS disabled due to CPU errata.
[    0.249270] ... version:                3
[    0.249325] ... bit width:              48
[    0.249380] ... generic registers:      4
[    0.249437] ... value mask:             0000ffffffffffff
[    0.249494] ... max period:             000000007fffffff
[    0.249552] ... fixed-purpose events:   3
[    0.249607] ... event mask:             000000070000000f
[    0.249755] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.249854] Booting Node   0, Processors  #1
[    0.262987] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.263147]  #2
[    0.276229] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.276391]  #3
[    0.289474] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.289632]  #4
[    0.302718] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.302886]  #5
[    0.315965] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.316127]  #6
[    0.329209] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.329367]  #7 Ok.
[    0.342454] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.342530] Brought up 8 CPUs
[    0.342584] Total of 8 processors activated (54578.60 BogoMIPS).
[    0.349144] dummy:=20
[    0.349236] NET: Registered protocol family 16
[    0.349465] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.349527] ACPI: bus type pci registered
[    0.349645] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000=
-0xfbffffff] (base 0xf8000000)
[    0.349711] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.358066] PCI: Using configuration type 1 for base access
[    0.359346] bio: create slab <bio-0> at 0
[    0.359465] ACPI: Added _OSI(Module Device)
[    0.359520] ACPI: Added _OSI(Processor Device)
[    0.359577] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.359634] ACPI: Added _OSI(Processor Aggregator Device)
[    0.360697] ACPI: EC: Look up EC in DSDT
[    0.361663] ACPI: Executed 1 blocks of module-level executable AML code
[    0.377176] ACPI: SSDT 00000000df0ee018 0083B (v01  PmRef  Cpu0Cst 00003=
001 INTL 20051117)
[    0.377591] ACPI: Dynamic OEM Table Load:
[    0.377747] ACPI: SSDT           (null) 0083B (v01  PmRef  Cpu0Cst 00003=
001 INTL 20051117)
[    0.393061] ACPI: SSDT 00000000df0efa98 00303 (v01  PmRef    ApIst 00003=
000 INTL 20051117)
[    0.393491] ACPI: Dynamic OEM Table Load:
[    0.393645] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003=
000 INTL 20051117)
[    0.408969] ACPI: SSDT 00000000df0f0c18 00119 (v01  PmRef    ApCst 00003=
000 INTL 20051117)
[    0.409378] ACPI: Dynamic OEM Table Load:
[    0.409531] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003=
000 INTL 20051117)
[    0.421616] ACPI: Interpreter enabled
[    0.421672] ACPI: (supports S0 S5)
[    0.421831] ACPI: Using IOAPIC for interrupt routing
[    0.426621] ACPI: Power Resource [FN00] (off)
[    0.426742] ACPI: Power Resource [FN01] (off)
[    0.426856] ACPI: Power Resource [FN02] (off)
[    0.426969] ACPI: Power Resource [FN03] (off)
[    0.427084] ACPI: Power Resource [FN04] (off)
[    0.427363] ACPI: EC: GPE =3D 0x18, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.427561] ACPI: No dock devices found.
[    0.427617] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.427851] \_SB_.PCI0:_OSC invalid UUID
[    0.427852] _OSC request data:1 8 1f=20
[    0.427854] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.428164] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.428222] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.428282] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x00=
0bffff]
[    0.428344] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x00=
0d3fff]
[    0.428407] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x00=
0d7fff]
[    0.428470] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x00=
0dbfff]
[    0.428530] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x00=
0dffff]
[    0.428591] pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x00=
0e3fff]
[    0.428652] pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x00=
0e7fff]
[    0.428714] pci_root PNP0A08:00: host bridge window [mem 0xe0000000-0xfe=
afffff]
[    0.428800] PCI host bridge to bus 0000:00
[    0.428859] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.428916] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.428972] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.429029] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3ff=
f]
[    0.429084] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7ff=
f]
[    0.429140] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbff=
f]
[    0.429198] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dfff=
f]
[    0.429257] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3ff=
f]
[    0.429316] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7ff=
f]
[    0.429375] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfeaffff=
f]
[    0.429437] pci 0000:00:00.0: [8086:0100] type 00 class 0x060000
[    0.429463] pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
[    0.429485] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.429522] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.429544] pci 0000:00:16.0: reg 10: [mem 0xf7f2c000-0xf7f2c00f 64bit]
[    0.429614] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.429641] pci 0000:00:19.0: [8086:1503] type 00 class 0x020000
[    0.429657] pci 0000:00:19.0: reg 10: [mem 0xf7f00000-0xf7f1ffff]
[    0.429665] pci 0000:00:19.0: reg 14: [mem 0xf7f29000-0xf7f29fff]
[    0.429673] pci 0000:00:19.0: reg 18: [io  0xf040-0xf05f]
[    0.429730] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.429753] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.429772] pci 0000:00:1a.0: reg 10: [mem 0xf7f28000-0xf7f283ff]
[    0.429855] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.429879] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.429893] pci 0000:00:1b.0: reg 10: [mem 0xf7f20000-0xf7f23fff 64bit]
[    0.429954] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.429975] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.430049] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.430072] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    0.430145] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.430170] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
[    0.430243] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.430267] pci 0000:00:1c.4: [8086:1c18] type 01 class 0x060400
[    0.430339] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.430364] pci 0000:00:1c.6: [8086:244e] type 01 class 0x060401
[    0.430437] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.430460] pci 0000:00:1c.7: [8086:1c1e] type 01 class 0x060400
[    0.430533] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.430561] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.430580] pci 0000:00:1d.0: reg 10: [mem 0xf7f27000-0xf7f273ff]
[    0.430664] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.430687] pci 0000:00:1f.0: [8086:1c46] type 00 class 0x060100
[    0.430802] pci 0000:00:1f.2: [8086:1c02] type 00 class 0x010601
[    0.430818] pci 0000:00:1f.2: reg 10: [io  0xf090-0xf097]
[    0.430825] pci 0000:00:1f.2: reg 14: [io  0xf080-0xf083]
[    0.430832] pci 0000:00:1f.2: reg 18: [io  0xf070-0xf077]
[    0.430839] pci 0000:00:1f.2: reg 1c: [io  0xf060-0xf063]
[    0.430846] pci 0000:00:1f.2: reg 20: [io  0xf020-0xf03f]
[    0.430853] pci 0000:00:1f.2: reg 24: [mem 0xf7f26000-0xf7f267ff]
[    0.430892] pci 0000:00:1f.2: PME# supported from D3hot
[    0.430909] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.430922] pci 0000:00:1f.3: reg 10: [mem 0xf7f25000-0xf7f250ff 64bit]
[    0.430941] pci 0000:00:1f.3: reg 20: [io  0xf000-0xf01f]
[    0.430986] pci 0000:01:00.0: [1002:9589] type 00 class 0x030000
[    0.430996] pci 0000:01:00.0: reg 10: [mem 0xe0000000-0xefffffff 64bit p=
ref]
[    0.431005] pci 0000:01:00.0: reg 18: [mem 0xf7e20000-0xf7e2ffff 64bit]
[    0.431010] pci 0000:01:00.0: reg 20: [io  0xe000-0xe0ff]
[    0.431020] pci 0000:01:00.0: reg 30: [mem 0xf7e00000-0xf7e1ffff pref]
[    0.431046] pci 0000:01:00.0: supports D1 D2
[    0.431061] pci 0000:01:00.1: [1002:aa08] type 00 class 0x040300
[    0.431071] pci 0000:01:00.1: reg 10: [mem 0xf7e30000-0xf7e33fff 64bit]
[    0.431118] pci 0000:01:00.1: supports D1 D2
[    0.436844] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.436913] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.436917] pci 0000:00:01.0:   bridge window [mem 0xf7e00000-0xf7efffff]
[    0.436922] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff=
 64bit pref]
[    0.436974] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.437099] pci 0000:03:00.0: [1033:0194] type 00 class 0x0c0330
[    0.437124] pci 0000:03:00.0: reg 10: [mem 0xf7d00000-0xf7d01fff 64bit]
[    0.437252] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.444846] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.444921] pci 0000:00:1c.1:   bridge window [mem 0xf7d00000-0xf7dfffff]
[    0.444996] pci 0000:04:00.0: [197b:2362] type 00 class 0x010185
[    0.445030] pci 0000:04:00.0: reg 10: [io  0xd040-0xd047]
[    0.445046] pci 0000:04:00.0: reg 14: [io  0xd030-0xd033]
[    0.445061] pci 0000:04:00.0: reg 18: [io  0xd020-0xd027]
[    0.445077] pci 0000:04:00.0: reg 1c: [io  0xd010-0xd013]
[    0.445092] pci 0000:04:00.0: reg 20: [io  0xd000-0xd00f]
[    0.445108] pci 0000:04:00.0: reg 24: [mem 0xf7c10000-0xf7c101ff]
[    0.445124] pci 0000:04:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.445184] pci 0000:04:00.0: PME# supported from D3hot
[    0.452840] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    0.452912] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.452917] pci 0000:00:1c.3:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.452994] pci 0000:05:00.0: [1033:0194] type 00 class 0x0c0330
[    0.453019] pci 0000:05:00.0: reg 10: [mem 0xf7b00000-0xf7b01fff 64bit]
[    0.453147] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.460836] pci 0000:00:1c.4: PCI bridge to [bus 05-05]
[    0.460909] pci 0000:00:1c.4:   bridge window [mem 0xf7b00000-0xf7bfffff]
[    0.460977] pci 0000:06:00.0: [1b21:1080] type 01 class 0x060401
[    0.461094] pci 0000:00:1c.6: PCI bridge to [bus 06-07] (subtractive dec=
ode)
[    0.461154] pci 0000:00:1c.6:   bridge window [io  0xc000-0xcfff]
[    0.461157] pci 0000:00:1c.6:   bridge window [mem 0xf7a00000-0xf7afffff]
[    0.461163] pci 0000:00:1c.6:   bridge window [io  0x0000-0x0cf7] (subtr=
active decode)
[    0.461164] pci 0000:00:1c.6:   bridge window [io  0x0d00-0xffff] (subtr=
active decode)
[    0.461165] pci 0000:00:1c.6:   bridge window [mem 0x000a0000-0x000bffff=
] (subtractive decode)
[    0.461167] pci 0000:00:1c.6:   bridge window [mem 0x000d0000-0x000d3fff=
] (subtractive decode)
[    0.461168] pci 0000:00:1c.6:   bridge window [mem 0x000d4000-0x000d7fff=
] (subtractive decode)
[    0.461170] pci 0000:00:1c.6:   bridge window [mem 0x000d8000-0x000dbfff=
] (subtractive decode)
[    0.461172] pci 0000:00:1c.6:   bridge window [mem 0x000dc000-0x000dffff=
] (subtractive decode)
[    0.461173] pci 0000:00:1c.6:   bridge window [mem 0x000e0000-0x000e3fff=
] (subtractive decode)
[    0.461175] pci 0000:00:1c.6:   bridge window [mem 0x000e4000-0x000e7fff=
] (subtractive decode)
[    0.461176] pci 0000:00:1c.6:   bridge window [mem 0xe0000000-0xfeafffff=
] (subtractive decode)
[    0.461241] pci 0000:07:02.0: [10ec:8167] type 00 class 0x020000
[    0.461275] pci 0000:07:02.0: reg 10: [io  0xc000-0xc0ff]
[    0.461292] pci 0000:07:02.0: reg 14: [mem 0xf7a21000-0xf7a210ff]
[    0.461368] pci 0000:07:02.0: reg 30: [mem 0xf7a00000-0xf7a1ffff pref]
[    0.461436] pci 0000:07:02.0: supports D1 D2
[    0.461437] pci 0000:07:02.0: PME# supported from D1 D2 D3hot D3cold
[    0.461472] pci 0000:07:03.0: [1106:3044] type 00 class 0x0c0010
[    0.461502] pci 0000:07:03.0: reg 10: [mem 0xf7a20000-0xf7a207ff]
[    0.461519] pci 0000:07:03.0: reg 14: [io  0xc100-0xc17f]
[    0.461648] pci 0000:07:03.0: supports D2
[    0.461649] pci 0000:07:03.0: PME# supported from D2 D3hot D3cold
[    0.461725] pci 0000:06:00.0: PCI bridge to [bus 07-07] (subtractive dec=
ode)
[    0.461791] pci 0000:06:00.0:   bridge window [io  0xc000-0xcfff]
[    0.461796] pci 0000:06:00.0:   bridge window [mem 0xf7a00000-0xf7afffff]
[    0.461806] pci 0000:06:00.0:   bridge window [io  0xc000-0xcfff] (subtr=
active decode)
[    0.461807] pci 0000:06:00.0:   bridge window [mem 0xf7a00000-0xf7afffff=
] (subtractive decode)
[    0.461809] pci 0000:06:00.0:   bridge window [??? 0x00000000 flags 0x0]=
 (subtractive decode)
[    0.461810] pci 0000:06:00.0:   bridge window [??? 0x00000000 flags 0x0]=
 (subtractive decode)
[    0.461811] pci 0000:06:00.0:   bridge window [io  0x0000-0x0cf7] (subtr=
active decode)
[    0.461813] pci 0000:06:00.0:   bridge window [io  0x0d00-0xffff] (subtr=
active decode)
[    0.461814] pci 0000:06:00.0:   bridge window [mem 0x000a0000-0x000bffff=
] (subtractive decode)
[    0.461815] pci 0000:06:00.0:   bridge window [mem 0x000d0000-0x000d3fff=
] (subtractive decode)
[    0.461817] pci 0000:06:00.0:   bridge window [mem 0x000d4000-0x000d7fff=
] (subtractive decode)
[    0.461818] pci 0000:06:00.0:   bridge window [mem 0x000d8000-0x000dbfff=
] (subtractive decode)
[    0.461819] pci 0000:06:00.0:   bridge window [mem 0x000dc000-0x000dffff=
] (subtractive decode)
[    0.461821] pci 0000:06:00.0:   bridge window [mem 0x000e0000-0x000e3fff=
] (subtractive decode)
[    0.461822] pci 0000:06:00.0:   bridge window [mem 0x000e4000-0x000e7fff=
] (subtractive decode)
[    0.461824] pci 0000:06:00.0:   bridge window [mem 0xe0000000-0xfeafffff=
] (subtractive decode)
[    0.461892] pci 0000:08:00.0: [1b4b:9172] type 00 class 0x010601
[    0.461909] pci 0000:08:00.0: reg 10: [io  0xb040-0xb047]
[    0.461921] pci 0000:08:00.0: reg 14: [io  0xb030-0xb033]
[    0.461933] pci 0000:08:00.0: reg 18: [io  0xb020-0xb027]
[    0.461945] pci 0000:08:00.0: reg 1c: [io  0xb010-0xb013]
[    0.461957] pci 0000:08:00.0: reg 20: [io  0xb000-0xb00f]
[    0.461970] pci 0000:08:00.0: reg 24: [mem 0xf7910000-0xf79101ff]
[    0.461982] pci 0000:08:00.0: reg 30: [mem 0xf7900000-0xf790ffff pref]
[    0.462038] pci 0000:08:00.0: PME# supported from D3hot
[    0.468827] pci 0000:00:1c.7: PCI bridge to [bus 08-08]
[    0.468898] pci 0000:00:1c.7:   bridge window [io  0xb000-0xbfff]
[    0.468903] pci 0000:00:1c.7:   bridge window [mem 0xf7900000-0xf79fffff]
[    0.468944] pci_bus 0000:00: on NUMA node 0
[    0.468946] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.469021] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.469040] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.469060] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.469082] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.469102] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP08._PRT]
[    0.469120] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
[    0.469143] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP07._PRT]
[    0.469160] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP07.PXSX._PRT]
[    0.469228] \_SB_.PCI0:_OSC invalid UUID
[    0.469229] _OSC request data:1 1f 1f=20
[    0.469232]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.469316] \_SB_.PCI0:_OSC invalid UUID
[    0.469317] _OSC request data:1 0 1d=20
[    0.469319]  pci0000:00: ACPI _OSC request failed (AE_ERROR), returned c=
ontrol mask: 0x1d
[    0.469380] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.472578] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    0.473203] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 1=
5)
[    0.473827] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 10 11 12 14 1=
5)
[    0.474440] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 1=
5)
[    0.475055] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    0.475669] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15=
) *0, disabled.
[    0.476386] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *10 11 12 14 1=
5)
[    0.477002] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 10 11 12 14 1=
5)
[    0.477668] vgaarb: device added: PCI:0000:01:00.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.477731] vgaarb: loaded
[    0.477789] vgaarb: bridge control possible 0000:01:00.0
[    0.477940] usbcore: registered new interface driver usbfs
[    0.478022] usbcore: registered new interface driver hub
[    0.478098] usbcore: registered new device driver usb
[    0.478231] PCI: Using ACPI for IRQ routing
[    0.479605] PCI: pci_cache_line_size set to 64 bytes
[    0.479688] reserve RAM buffer: 000000000009d400 - 000000000009ffff=20
[    0.479689] reserve RAM buffer: 00000000deb91000 - 00000000dfffffff=20
[    0.479691] reserve RAM buffer: 00000000df800000 - 00000000dfffffff=20
[    0.479692] reserve RAM buffer: 000000021f000000 - 000000021fffffff=20
[    0.479834] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.480326] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.482395] Switching to clocksource hpet
[    0.483147] pnp: PnP ACPI init
[    0.483215] ACPI: bus type pnp registered
[    0.483425] pnp 00:00: [bus 00-3e]
[    0.483427] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.483428] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.483429] pnp 00:00: [io  0x0d00-0xffff window]
[    0.483430] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.483431] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.483433] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.483434] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.483435] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.483436] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.483437] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.483438] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.483439] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.483440] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.483442] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.483443] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.483444] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.483445] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.483446] pnp 00:00: [mem 0xe0000000-0xfeafffff window]
[    0.483447] pnp 00:00: [mem 0x00010000-0x0001ffff window]
[    0.483498] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (a=
ctive)
[    0.483512] pnp 00:01: [mem 0xfed40000-0xfed44fff]
[    0.483549] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.483607] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.483614] pnp 00:02: [io  0x0000-0x001f]
[    0.483615] pnp 00:02: [io  0x0081-0x0091]
[    0.483616] pnp 00:02: [io  0x0093-0x009f]
[    0.483617] pnp 00:02: [io  0x00c0-0x00df]
[    0.483618] pnp 00:02: [dma 4]
[    0.483644] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.483649] pnp 00:03: [mem 0xff000000-0xffffffff]
[    0.483675] pnp 00:03: Plug and Play ACPI device, IDs INT0800 (active)
[    0.483723] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.483750] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.483758] pnp 00:05: [io  0x002e-0x002f]
[    0.483759] pnp 00:05: [io  0x004e-0x004f]
[    0.483760] pnp 00:05: [io  0x0061]
[    0.483761] pnp 00:05: [io  0x0063]
[    0.483762] pnp 00:05: [io  0x0065]
[    0.483763] pnp 00:05: [io  0x0067]
[    0.483764] pnp 00:05: [io  0x0070]
[    0.483765] pnp 00:05: [io  0x0080]
[    0.483765] pnp 00:05: [io  0x0092]
[    0.483766] pnp 00:05: [io  0x00b2-0x00b3]
[    0.483767] pnp 00:05: [io  0x0680-0x069f]
[    0.483768] pnp 00:05: [io  0x0200-0x020f]
[    0.483769] pnp 00:05: [io  0xffff]
[    0.483770] pnp 00:05: [io  0xffff]
[    0.483772] pnp 00:05: [io  0x0400-0x0453]
[    0.483773] pnp 00:05: [io  0x0458-0x047f]
[    0.483774] pnp 00:05: [io  0x0500-0x057f]
[    0.483775] pnp 00:05: [io  0x164e-0x164f]
[    0.483816] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.483875] system 00:05: [io  0x0200-0x020f] has been reserved
[    0.483934] system 00:05: [io  0xffff] has been reserved
[    0.483989] system 00:05: [io  0xffff] has been reserved
[    0.484045] system 00:05: [io  0x0400-0x0453] has been reserved
[    0.484104] system 00:05: [io  0x0458-0x047f] has been reserved
[    0.484162] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.484218] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.484275] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.484280] pnp 00:06: [io  0x0070-0x0077]
[    0.484288] pnp 00:06: [irq 8]
[    0.484316] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.484331] pnp 00:07: [io  0x0454-0x0457]
[    0.484366] system 00:07: [io  0x0454-0x0457] has been reserved
[    0.484425] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02=
 (active)
[    0.484462] pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
[    0.484463] pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
[    0.484464] pnp 00:08: [io  0x0290-0x029f]
[    0.484465] pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
[    0.484502] system 00:08: [io  0x0290-0x029f] has been reserved
[    0.484560] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.484575] pnp 00:09: [io  0x0010-0x001f]
[    0.484576] pnp 00:09: [io  0x0022-0x003f]
[    0.484577] pnp 00:09: [io  0x0044-0x005f]
[    0.484578] pnp 00:09: [io  0x0062-0x0063]
[    0.484578] pnp 00:09: [io  0x0065-0x006f]
[    0.484579] pnp 00:09: [io  0x0072-0x007f]
[    0.484580] pnp 00:09: [io  0x0080]
[    0.484581] pnp 00:09: [io  0x0084-0x0086]
[    0.484582] pnp 00:09: [io  0x0088]
[    0.484583] pnp 00:09: [io  0x008c-0x008e]
[    0.484584] pnp 00:09: [io  0x0090-0x009f]
[    0.484585] pnp 00:09: [io  0x00a2-0x00bf]
[    0.484586] pnp 00:09: [io  0x00e0-0x00ef]
[    0.484587] pnp 00:09: [io  0x04d0-0x04d1]
[    0.484626] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.484684] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.484689] pnp 00:0a: [io  0x00f0-0x00ff]
[    0.484694] pnp 00:0a: [irq 13]
[    0.484721] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.484871] pnp 00:0b: [io  0x03f8-0x03ff]
[    0.484876] pnp 00:0b: [irq 4]
[    0.484877] pnp 00:0b: [dma 0 disabled]
[    0.484923] pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.485062] pnp 00:0c: [mem 0xfed1c000-0xfed1ffff]
[    0.485063] pnp 00:0c: [mem 0xfed10000-0xfed17fff]
[    0.485064] pnp 00:0c: [mem 0xfed18000-0xfed18fff]
[    0.485065] pnp 00:0c: [mem 0xfed19000-0xfed19fff]
[    0.485066] pnp 00:0c: [mem 0xf8000000-0xfbffffff]
[    0.485067] pnp 00:0c: [mem 0xfed20000-0xfed3ffff]
[    0.485068] pnp 00:0c: [mem 0xfed90000-0xfed93fff]
[    0.485069] pnp 00:0c: [mem 0xfed45000-0xfed8ffff]
[    0.485070] pnp 00:0c: [mem 0xff000000-0xffffffff]
[    0.485071] pnp 00:0c: [mem 0xfee00000-0xfeefffff]
[    0.485072] pnp 00:0c: [mem 0xf0000000-0xf0000fff]
[    0.485132] system 00:0c: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.485190] system 00:0c: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.485249] system 00:0c: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.485307] system 00:0c: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.485370] system 00:0c: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.485427] system 00:0c: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.485484] system 00:0c: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.485542] system 00:0c: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.485598] system 00:0c: [mem 0xff000000-0xffffffff] has been reserved
[    0.485655] system 00:0c: [mem 0xfee00000-0xfeefffff] could not be reser=
ved
[    0.485711] system 00:0c: [mem 0xf0000000-0xf0000fff] has been reserved
[    0.485769] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.485848] pnp: PnP ACPI: found 13 devices
[    0.485907] ACPI: ACPI bus type pnp unregistered
[    0.492344] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus =
02-02] add_size 1000
[    0.492347] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 6=
4bit pref] to [bus 02-02] add_size 200000
[    0.492349] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] =
to [bus 02-02] add_size 200000
[    0.492399] pci 0000:00:1c.0: res[14]=3D[mem 0x00100000-0x000fffff] get_=
res_add_size add_size 200000
[    0.492401] pci 0000:00:1c.0: res[15]=3D[mem 0x00100000-0x000fffff 64bit=
 pref] get_res_add_size add_size 200000
[    0.492402] pci 0000:00:1c.0: res[13]=3D[io  0x1000-0x0fff] get_res_add_=
size add_size 1000
[    0.492405] pci 0000:00:1c.0: BAR 14: assigned [mem 0xf0100000-0xf02ffff=
f]
[    0.492465] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf0300000-0xf04ffff=
f 64bit pref]
[    0.492529] pci 0000:00:1c.3: BAR 15: assigned [mem 0xf0500000-0xf05ffff=
f pref]
[    0.492590] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.492648] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.492705] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.492765] pci 0000:00:01.0:   bridge window [mem 0xf7e00000-0xf7efffff]
[    0.492824] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff=
 64bit pref]
[    0.492888] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.492944] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.493003] pci 0000:00:1c.0:   bridge window [mem 0xf0100000-0xf02fffff]
[    0.493064] pci 0000:00:1c.0:   bridge window [mem 0xf0300000-0xf04fffff=
 64bit pref]
[    0.493129] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.493189] pci 0000:00:1c.1:   bridge window [mem 0xf7d00000-0xf7dfffff]
[    0.493252] pci 0000:04:00.0: BAR 6: assigned [mem 0xf0500000-0xf050ffff=
 pref]
[    0.493315] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    0.493373] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.493434] pci 0000:00:1c.3:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.493493] pci 0000:00:1c.3:   bridge window [mem 0xf0500000-0xf05fffff=
 pref]
[    0.493560] pci 0000:00:1c.4: PCI bridge to [bus 05-05]
[    0.493619] pci 0000:00:1c.4:   bridge window [mem 0xf7b00000-0xf7bfffff]
[    0.493682] pci 0000:06:00.0: PCI bridge to [bus 07-07]
[    0.493741] pci 0000:06:00.0:   bridge window [io  0xc000-0xcfff]
[    0.493806] pci 0000:06:00.0:   bridge window [mem 0xf7a00000-0xf7afffff]
[    0.493875] pci 0000:00:1c.6: PCI bridge to [bus 06-07]
[    0.493933] pci 0000:00:1c.6:   bridge window [io  0xc000-0xcfff]
[    0.493992] pci 0000:00:1c.6:   bridge window [mem 0xf7a00000-0xf7afffff]
[    0.494056] pci 0000:00:1c.7: PCI bridge to [bus 08-08]
[    0.494112] pci 0000:00:1c.7:   bridge window [io  0xb000-0xbfff]
[    0.494171] pci 0000:00:1c.7:   bridge window [mem 0xf7900000-0xf79fffff]
[    0.494274] pci 0000:06:00.0: setting latency timer to 64
[    0.494282] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.494284] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.494285] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.494286] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.494287] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.494289] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.494290] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.494291] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.494292] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.494294] pci_bus 0000:00: resource 13 [mem 0xe0000000-0xfeafffff]
[    0.494295] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.494296] pci_bus 0000:01: resource 1 [mem 0xf7e00000-0xf7efffff]
[    0.494297] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xefffffff 64bit=
 pref]
[    0.494299] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.494300] pci_bus 0000:02: resource 1 [mem 0xf0100000-0xf02fffff]
[    0.494301] pci_bus 0000:02: resource 2 [mem 0xf0300000-0xf04fffff 64bit=
 pref]
[    0.494302] pci_bus 0000:03: resource 1 [mem 0xf7d00000-0xf7dfffff]
[    0.494304] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.494305] pci_bus 0000:04: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    0.494306] pci_bus 0000:04: resource 2 [mem 0xf0500000-0xf05fffff pref]
[    0.494307] pci_bus 0000:05: resource 1 [mem 0xf7b00000-0xf7bfffff]
[    0.494309] pci_bus 0000:06: resource 0 [io  0xc000-0xcfff]
[    0.494310] pci_bus 0000:06: resource 1 [mem 0xf7a00000-0xf7afffff]
[    0.494311] pci_bus 0000:06: resource 4 [io  0x0000-0x0cf7]
[    0.494312] pci_bus 0000:06: resource 5 [io  0x0d00-0xffff]
[    0.494313] pci_bus 0000:06: resource 6 [mem 0x000a0000-0x000bffff]
[    0.494315] pci_bus 0000:06: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.494316] pci_bus 0000:06: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.494317] pci_bus 0000:06: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.494318] pci_bus 0000:06: resource 10 [mem 0x000dc000-0x000dffff]
[    0.494319] pci_bus 0000:06: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.494321] pci_bus 0000:06: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.494322] pci_bus 0000:06: resource 13 [mem 0xe0000000-0xfeafffff]
[    0.494323] pci_bus 0000:07: resource 0 [io  0xc000-0xcfff]
[    0.494324] pci_bus 0000:07: resource 1 [mem 0xf7a00000-0xf7afffff]
[    0.494325] pci_bus 0000:07: resource 4 [io  0xc000-0xcfff]
[    0.494327] pci_bus 0000:07: resource 5 [mem 0xf7a00000-0xf7afffff]
[    0.494328] pci_bus 0000:07: resource 8 [io  0x0000-0x0cf7]
[    0.494329] pci_bus 0000:07: resource 9 [io  0x0d00-0xffff]
[    0.494330] pci_bus 0000:07: resource 10 [mem 0x000a0000-0x000bffff]
[    0.494331] pci_bus 0000:07: resource 11 [mem 0x000d0000-0x000d3fff]
[    0.494332] pci_bus 0000:07: resource 12 [mem 0x000d4000-0x000d7fff]
[    0.494334] pci_bus 0000:07: resource 13 [mem 0x000d8000-0x000dbfff]
[    0.494335] pci_bus 0000:07: resource 14 [mem 0x000dc000-0x000dffff]
[    0.494336] pci_bus 0000:07: resource 15 [mem 0x000e0000-0x000e3fff]
[    0.494337] pci_bus 0000:07: resource 16 [mem 0x000e4000-0x000e7fff]
[    0.494339] pci_bus 0000:07: resource 17 [mem 0xe0000000-0xfeafffff]
[    0.494340] pci_bus 0000:08: resource 0 [io  0xb000-0xbfff]
[    0.494341] pci_bus 0000:08: resource 1 [mem 0xf7900000-0xf79fffff]
[    0.494363] NET: Registered protocol family 2
[    0.494456] IP route cache hash table entries: 262144 (order: 9, 2097152=
 bytes)
[    0.494671] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    0.495146] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.495310] TCP: Hash tables configured (established 262144 bind 65536)
[    0.495368] TCP: reno registered
[    0.495425] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.495497] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.495604] NET: Registered protocol family 1
[    0.495672] pci 0000:00:1a.0: broken D3 during system sleep on ASUS
[    0.622405] pci 0000:00:1d.0: broken D3 during system sleep on ASUS
[    0.750305] pci 0000:01:00.0: Boot video device
[    0.750421] PCI: CLS 64 bytes, default 64
[    0.750453] Trying to unpack rootfs image as initramfs...
[    2.507767] Freeing initrd memory: 145440k freed
[    2.519964] DMAR: No ATSR found
[    2.520048] IOMMU 0 0xfed90000: using Queued invalidation
[    2.520105] IOMMU: Setting RMRR:
[    2.520169] IOMMU: Setting identity map for device 0000:00:1d.0 [0xdf0d6=
000 - 0xdf0e4fff]
[    2.520250] IOMMU: Setting identity map for device 0000:00:1a.0 [0xdf0d6=
000 - 0xdf0e4fff]
[    2.520319] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    2.520381] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0=
xffffff]
[    2.520518] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    2.520591] ------------[ cut here ]------------
[    2.520654] WARNING: at drivers/pci/search.c:44 pci_find_upstream_pcie_b=
ridge+0x50/0x70()
[    2.520717] Hardware name: System Product Name
[    2.520773] Modules linked in: <omitted>=20
[    2.520880] Pid: 1, comm: swapper/0 Not tainted 3.4.4-modded-oops+ #2
[    2.520936] Call Trace:
[    2.520996]  [<ffffffff8103905a>] warn_slowpath_common+0x7a/0xb0
[    2.521053]  [<ffffffff810390a5>] warn_slowpath_null+0x15/0x20
[    2.521110]  [<ffffffff812067d0>] pci_find_upstream_pcie_bridge+0x50/0x70
[    2.521183]  [<ffffffff81339bcd>] intel_iommu_device_group+0x7d/0x100
[    2.521242]  [<ffffffff813301d0>] ? bus_set_iommu+0x50/0x50
[    2.521300]  [<ffffffff813301fb>] add_iommu_group+0x2b/0x60
[    2.521359]  [<ffffffff8129cabd>] bus_for_each_dev+0x4d/0x90
[    2.521416]  [<ffffffff813301bb>] bus_set_iommu+0x3b/0x50
[    2.521473]  [<ffffffff818bfe24>] intel_iommu_init+0xae9/0xc1a
[    2.522059]  [<ffffffff81890a2b>] ? clean_rootfs+0x1c1/0x1c1
[    2.522116]  [<ffffffff81893a82>] ? memblock_find_dma_reserve+0x13d/0x13d
[    2.522174]  [<ffffffff81893a95>] pci_iommu_init+0x13/0x3e
[    2.522232]  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
[    2.522288]  [<ffffffff8188ecc2>] kernel_init+0x13a/0x1be
[    2.522345]  [<ffffffff8188e5e8>] ? do_early_param+0x8c/0x8c
[    2.522404]  [<ffffffff81419064>] kernel_thread_helper+0x4/0x10
[    2.522461]  [<ffffffff8188eb88>] ? start_kernel+0x341/0x341
[    2.522519]  [<ffffffff81419060>] ? gs_change+0x13/0x13
[    2.522578] ---[ end trace e93713a9d40cd06c ]---
[    2.524405] audit: initializing netlink socket (disabled)
[    2.524469] type=3D2000 audit(1342120235.328:1): initialized
[    2.536218] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.538469] VFS: Disk quotas dquot_6.5.2
[    2.538567] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.538696] msgmni has been set to 16015
[    2.539014] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    2.539093] io scheduler noop registered
[    2.539210] io scheduler cfq registered (default)
[    2.539429] pcieport 0000:00:01.0: irq 41 for MSI/MSI-X
[    2.539886] intel_idle: MWAIT substates: 0x1120
[    2.539887] intel_idle: v0.4 model 0x2A
[    2.539888] intel_idle: lapic_timer_reliable_states 0xffffffff
[    2.539930] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.560378] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    2.581029] 00:0b: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    2.581389] Linux agpgart interface v0.103
[    2.582602] brd: module loaded
[    2.582733] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.582818] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.582821] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    2.582914] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 1
[    2.583001] ehci_hcd 0000:00:1a.0: debug port 2
[    2.586931] ehci_hcd 0000:00:1a.0: Enabling legacy PCI PM
[    2.586991] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    2.587003] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf7f28000
[    2.597091] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.597187] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    2.597246] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    2.597308] usb usb1: Product: EHCI Host Controller
[    2.597365] usb usb1: Manufacturer: Linux 3.4.4-modded-oops+ ehci_hcd
[    2.597422] usb usb1: SerialNumber: 0000:00:1a.0
[    2.597545] hub 1-0:1.0: USB hub found
[    2.597602] hub 1-0:1.0: 2 ports detected
[    2.597715] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.597718] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    2.597802] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 2
[    2.597884] ehci_hcd 0000:00:1d.0: debug port 2
[    2.601814] ehci_hcd 0000:00:1d.0: Enabling legacy PCI PM
[    2.601874] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    2.601883] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf7f27000
[    2.613082] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.613164] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    2.613230] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    2.613293] usb usb2: Product: EHCI Host Controller
[    2.613349] usb usb2: Manufacturer: Linux 3.4.4-modded-oops+ ehci_hcd
[    2.613408] usb usb2: SerialNumber: 0000:00:1d.0
[    2.613530] hub 2-0:1.0: USB hub found
[    2.613586] hub 2-0:1.0: 2 ports detected
[    2.613709] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.613789] uhci_hcd: USB Universal Host Controller Interface driver
[    2.613890] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    2.613976] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus =
number 3
[    2.614208] xhci_hcd 0000:03:00.0: irq 17, io mem 0xf7d00000
[    2.614319] xhci_hcd 0000:03:00.0: irq 42 for MSI/MSI-X
[    2.614323] xhci_hcd 0000:03:00.0: irq 43 for MSI/MSI-X
[    2.614327] xhci_hcd 0000:03:00.0: irq 44 for MSI/MSI-X
[    2.614331] xhci_hcd 0000:03:00.0: irq 45 for MSI/MSI-X
[    2.614335] xhci_hcd 0000:03:00.0: irq 46 for MSI/MSI-X
[    2.614338] xhci_hcd 0000:03:00.0: irq 47 for MSI/MSI-X
[    2.614342] xhci_hcd 0000:03:00.0: irq 48 for MSI/MSI-X
[    2.614346] xhci_hcd 0000:03:00.0: irq 49 for MSI/MSI-X
[    2.614451] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    2.614508] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    2.614571] usb usb3: Product: xHCI Host Controller
[    2.614626] usb usb3: Manufacturer: Linux 3.4.4-modded-oops+ xhci_hcd
[    2.614684] usb usb3: SerialNumber: 0000:03:00.0
[    2.614775] xHCI xhci_add_endpoint called for root hub
[    2.614777] xHCI xhci_check_bandwidth called for root hub
[    2.614806] hub 3-0:1.0: USB hub found
[    2.614866] hub 3-0:1.0: 2 ports detected
[    2.614970] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    2.615057] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus =
number 4
[    2.617611] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003
[    2.617673] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    2.617733] usb usb4: Product: xHCI Host Controller
[    2.617791] usb usb4: Manufacturer: Linux 3.4.4-modded-oops+ xhci_hcd
[    2.617849] usb usb4: SerialNumber: 0000:03:00.0
[    2.617940] xHCI xhci_add_endpoint called for root hub
[    2.617941] xHCI xhci_check_bandwidth called for root hub
[    2.617969] hub 4-0:1.0: USB hub found
[    2.618029] hub 4-0:1.0: 2 ports detected
[    2.618151] xhci_hcd 0000:05:00.0: xHCI Host Controller
[    2.618238] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus =
number 5
[    2.618460] xhci_hcd 0000:05:00.0: irq 16, io mem 0xf7b00000
[    2.618567] xhci_hcd 0000:05:00.0: irq 50 for MSI/MSI-X
[    2.618571] xhci_hcd 0000:05:00.0: irq 51 for MSI/MSI-X
[    2.618575] xhci_hcd 0000:05:00.0: irq 52 for MSI/MSI-X
[    2.618578] xhci_hcd 0000:05:00.0: irq 53 for MSI/MSI-X
[    2.618582] xhci_hcd 0000:05:00.0: irq 54 for MSI/MSI-X
[    2.618586] xhci_hcd 0000:05:00.0: irq 55 for MSI/MSI-X
[    2.618590] xhci_hcd 0000:05:00.0: irq 56 for MSI/MSI-X
[    2.618593] xhci_hcd 0000:05:00.0: irq 57 for MSI/MSI-X
[    2.618697] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    2.618755] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    2.618818] usb usb5: Product: xHCI Host Controller
[    2.618875] usb usb5: Manufacturer: Linux 3.4.4-modded-oops+ xhci_hcd
[    2.618932] usb usb5: SerialNumber: 0000:05:00.0
[    2.619024] xHCI xhci_add_endpoint called for root hub
[    2.619025] xHCI xhci_check_bandwidth called for root hub
[    2.619053] hub 5-0:1.0: USB hub found
[    2.619112] hub 5-0:1.0: 2 ports detected
[    2.619216] xhci_hcd 0000:05:00.0: xHCI Host Controller
[    2.619302] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus =
number 6
[    2.621871] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003
[    2.621933] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    2.621994] usb usb6: Product: xHCI Host Controller
[    2.622051] usb usb6: Manufacturer: Linux 3.4.4-modded-oops+ xhci_hcd
[    2.622110] usb usb6: SerialNumber: 0000:05:00.0
[    2.622200] xHCI xhci_add_endpoint called for root hub
[    2.622201] xHCI xhci_check_bandwidth called for root hub
[    2.622230] hub 6-0:1.0: USB hub found
[    2.622290] hub 6-0:1.0: 2 ports detected
[    2.622509] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    2.625016] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.625091] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.625222] mousedev: PS/2 mouse device common for all mice
[    2.625314] rtc_cmos 00:06: RTC can wake from S4
[    2.625476] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    2.625556] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    2.625716] cpuidle: using governor ladder
[    2.625860] cpuidle: using governor menu
[    2.626706] usbcore: registered new interface driver usbhid
[    2.626762] usbhid: USB HID core driver
[    2.626825] zcache: using lzo compressor
[    2.626952] zcache: cleancache enabled using kernel transcendent memory =
and compression buddies
[    2.627065] TCP: cubic registered
[    2.627121] NET: Registered protocol family 17
[    2.627181] Registering the dns_resolver key type
[    2.627347] registered taskstats version 1
[    2.627868] rtc_cmos 00:06: setting system clock to 2012-07-12 19:10:36 =
UTC (1342120236)
[    2.628621] Freeing unused kernel memory: 508k freed
[    2.628716] Write protecting the kernel read-only data: 8192k
[    2.632242] Freeing unused kernel memory: 1920k freed
[    2.632751] Freeing unused kernel memory: 96k freed
[    2.699369] ACPI: Fan [FAN0] (off)
[    2.704589] e1000e: Intel(R) PRO/1000 Network Driver - 1.9.5-k
[    2.704653] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    2.705092] e1000e 0000:00:19.0: setting latency timer to 64
[    2.705172] e1000e 0000:00:19.0: (unregistered net_device): Interrupt Th=
rottling Rate (ints/sec) set to dynamic conservative mode
[    2.705275] e1000e 0000:00:19.0: irq 58 for MSI/MSI-X
[    2.709692] SCSI subsystem initialized
[    2.713664] libata version 3.00 loaded.
[    2.715931] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    2.716070] r8169 0000:07:02.0: (unregistered net_device): not PCI Expre=
ss
[    2.716263] r8169 0000:07:02.0: eth0: RTL8169sc/8110sc at 0xffffc9000007=
e000, f4:6d:04:b0:81:c0, XID 18000000 IRQ 16
[    2.716340] r8169 0000:07:02.0: eth0: jumbo features [frames: 7152 bytes=
, tx checksumming: ok]
[    2.737308] thermal LNXTHERM:00: registered as thermal_zone0
[    2.737373] ACPI: Thermal Zone [TZ00] (28 C)
[    2.737555] thermal LNXTHERM:01: registered as thermal_zone1
[    2.737617] ACPI: Thermal Zone [TZ01] (30 C)
[    2.737750] ACPI: Fan [FAN1] (off)
[    2.737836] ACPI: Fan [FAN2] (off)
[    2.737919] ACPI: Fan [FAN3] (off)
[    2.737999] ACPI: Fan [FAN4] (off)
[    2.777087] firewire_ohci 0000:07:03.0: added OHCI v1.10 device as card =
0, 4 IR + 8 IT contexts, quirks 0x11
[    2.777121] firewire_ohci 0000:07:03.0: DMA context ARReq has stopped, e=
rror code: evt_unknown
[    2.777164] DRHD: handling fault status reg 3
[    2.777172] DMAR:[DMA Read] Request device [07:00.0] fault addr fffff000=
=20
[    2.777172] DMAR:[fault reason 02] Present bit in context entry is clear
[    2.777189] firewire_ohci 0000:07:03.0: DMA context ARReq has stopped, e=
rror code: evt_unknown
[    2.777193] firewire_ohci 0000:07:03.0: DMA context ARRsp has stopped, e=
rror code: evt_unknown
[    2.777690] DRHD: handling fault status reg 3
[    2.777751] DMAR:[DMA Write] Request device [07:00.0] fault addr fffff00=
0=20
[    2.777752] DMAR:[fault reason 02] Present bit in context entry is clear
[    2.777886] firewire_ohci 0000:07:03.0: inconsistent self IDs
[    2.908935] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    3.021702] e1000e 0000:00:19.0: eth1: (PCI Express:2.5GT/s:Width x1) f4=
:6d:04:b0:8f:c5
[    3.021768] e1000e 0000:00:19.0: eth1: Intel(R) PRO/1000 Network Connect=
ion
[    3.021854] e1000e 0000:00:19.0: eth1: MAC: 10, PHY: 11, PBA No: FFFFFF-=
0FF
[    3.021966] ahci 0000:00:1f.2: version 3.0
[    3.022047] ahci 0000:00:1f.2: irq 59 for MSI/MSI-X
[    3.036866] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x=
b impl SATA mode
[    3.036942] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part=
 ems apst=20
[    3.037005] ahci 0000:00:1f.2: setting latency timer to 64
[    3.041218] usb 1-1: New USB device found, idVendor=3D8087, idProduct=3D=
0024
[    3.041296] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    3.041474] hub 1-1:1.0: USB hub found
[    3.041705] hub 1-1:1.0: 6 ports detected
[    3.057201] scsi0 : ahci
[    3.057954] scsi1 : ahci
[    3.058105] scsi2 : ahci
[    3.058227] scsi3 : ahci
[    3.058332] scsi4 : ahci
[    3.058478] scsi5 : ahci
[    3.058698] ata1: SATA max UDMA/133 abar m2048@0xf7f26000 port 0xf7f2610=
0 irq 59
[    3.058765] ata2: SATA max UDMA/133 abar m2048@0xf7f26000 port 0xf7f2618=
0 irq 59
[    3.058830] ata3: DUMMY
[    3.058890] ata4: SATA max UDMA/133 abar m2048@0xf7f26000 port 0xf7f2628=
0 irq 59
[    3.058952] ata5: DUMMY
[    3.059007] ata6: DUMMY
[    3.059169] ahci 0000:04:00.0: AHCI 0001.0100 32 slots 2 ports 3 Gbps 0x=
3 impl SATA mode
[    3.059239] ahci 0000:04:00.0: flags: 64bit ncq pm led clo pmp pio slum =
part=20
[    3.059475] scsi6 : ahci
[    3.059604] scsi7 : ahci
[    3.059742] ata7: SATA max UDMA/133 abar m512@0xf7c10000 port 0xf7c10100=
 irq 19
[    3.059818] ata8: SATA max UDMA/133 abar m512@0xf7c10000 port 0xf7c10180=
 irq 19
[    3.059972] ahci 0000:08:00.0: irq 60 for MSI/MSI-X
[    3.060029] ahci 0000:08:00.0: AHCI 0001.0000 32 slots 2 ports 6 Gbps 0x=
3 impl SATA mode
[    3.060093] ahci 0000:08:00.0: flags: 64bit ncq sntf led only pmp fbs pi=
o slum part sxs=20
[    3.060327] scsi8 : ahci
[    3.060420] scsi9 : ahci
[    3.060497] ata9: SATA max UDMA/133 abar m512@0xf7910000 port 0xf7910100=
 irq 60
[    3.060560] ata10: SATA max UDMA/133 abar m512@0xf7910000 port 0xf791018=
0 irq 60
[    3.152785] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    3.285056] usb 2-1: New USB device found, idVendor=3D8087, idProduct=3D=
0024
[    3.285132] usb 2-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    3.285318] hub 2-1:1.0: USB hub found
[    3.285557] hub 2-1:1.0: 8 ports detected
[    3.376676] ata7: SATA link down (SStatus 0 SControl 300)
[    3.376683] ata9: SATA link down (SStatus 0 SControl 300)
[    3.376698] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.376754] ata10: SATA link down (SStatus 0 SControl 300)
[    3.376756] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.376795] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    3.377120] ata8: SATA link down (SStatus 0 SControl 300)
[    3.377184] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (2=
0120320/psargs-359)
[    3.377406] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.S=
PT1._GTF] (Node ffff880215869708), AE_NOT_FOUND (20120320/psparse-536)
[    3.378078] ata2.00: ATA-8: ST2000DM001-9YN164, CC4C, max UDMA/133
[    3.378158] ata2.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[    3.378241] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (2=
0120320/psargs-359)
[    3.378457] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.S=
PT0._GTF] (Node ffff880215869690), AE_NOT_FOUND (20120320/psparse-536)
[    3.379054] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (2=
0120320/psargs-359)
[    3.379276] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.S=
PT1._GTF] (Node ffff880215869708), AE_NOT_FOUND (20120320/psparse-536)
[    3.379806] ata2.00: configured for UDMA/133
[    3.380797] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (2=
0120320/psargs-359)
[    3.381019] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.S=
PT3._GTF] (Node ffff8802158697f8), AE_NOT_FOUND (20120320/psparse-536)
[    3.381508] ata4.00: ATA-8: WDC WD20EARX-00PASB0, 51.0AB51, max UDMA/133
[    3.381588] ata4.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[    3.385833] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (2=
0120320/psargs-359)
[    3.386059] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.S=
PT3._GTF] (Node ffff8802158697f8), AE_NOT_FOUND (20120320/psparse-536)
[    3.386540] ata4.00: configured for UDMA/133
[    3.406148] ata1.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
[    3.406226] ata1.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2)
[    3.420868] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (2=
0120320/psargs-359)
[    3.421091] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.S=
PT0._GTF] (Node ffff880215869690), AE_NOT_FOUND (20120320/psparse-536)
[    3.448769] ata1.00: configured for UDMA/133
[    3.449007] scsi 0:0:0:0: Direct-Access     ATA      ST31500341AS     CC=
1H PQ: 0 ANSI: 5
[    3.449271] scsi 1:0:0:0: Direct-Access     ATA      ST2000DM001-9YN1 CC=
4C PQ: 0 ANSI: 5
[    3.449544] scsi 3:0:0:0: Direct-Access     ATA      WDC WD20EARX-00P 51=
=2E0 PQ: 0 ANSI: 5
[    3.450677] sd 3:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 =
TB/1.81 TiB)
[    3.450693] sd 0:0:0:0: [sda] 2930277168 512-byte logical blocks: (1.50 =
TB/1.36 TiB)
[    3.450714] sd 1:0:0:0: [sdb] 3907029168 512-byte logical blocks: (2.00 =
TB/1.81 TiB)
[    3.450716] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    3.450761] sd 1:0:0:0: [sdb] Write Protect is off
[    3.450763] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.450765] sd 0:0:0:0: [sda] Write Protect is off
[    3.450769] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.450779] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.450793] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.451223] sd 3:0:0:0: [sdc] 4096-byte physical blocks
[    3.451398] sd 3:0:0:0: [sdc] Write Protect is off
[    3.451455] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    3.451478] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.460229]  sdc: sdc1 sdc2 sdc3 sdc4
[    3.460589] sd 3:0:0:0: [sdc] Attached SCSI disk
[    3.469997]  sdb: sdb1 sdb2
[    3.470498] sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.470527]  sda: sda1 sda2
[    3.470805] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.520523] Refined TSC clocksource calibration: 3411.127 MHz.
[    3.520599] Switching to clocksource tsc
[    3.560599] usb 2-1.1: new low-speed USB device number 3 using ehci_hcd
[    3.660025] usb 2-1.1: New USB device found, idVendor=3D0518, idProduct=
=3D0001
[    3.660106] usb 2-1.1: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    3.660169] usb 2-1.1: Product: USB-compliant keyboard
[    3.660227] usb 2-1.1: Manufacturer: Plus More Enterprise LTD.
[    3.663275] input: Plus More Enterprise LTD. USB-compliant keyboard as /=
devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.0/input/input0
[    3.663362] generic-usb 0003:0518:0001.0001: input,hidraw0: USB HID v1.1=
0 Keyboard [Plus More Enterprise LTD. USB-compliant keyboard] on usb-0000:0=
0:1d.0-1.1/input0
[    3.666775] input: Plus More Enterprise LTD. USB-compliant keyboard as /=
devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.1/input/input1
[    3.666867] generic-usb 0003:0518:0001.0002: input,hidraw1: USB HID v1.1=
0 Mouse [Plus More Enterprise LTD. USB-compliant keyboard] on usb-0000:00:1=
d.0-1.1/input1
[    3.736621] usb 2-1.2: new full-speed USB device number 4 using ehci_hcd
[    3.831600] usb 2-1.2: New USB device found, idVendor=3D0d8c, idProduct=
=3D0005
[    3.831678] usb 2-1.2: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[    3.831740] usb 2-1.2: Product: Blue Snowball
[    3.831795] usb 2-1.2: Manufacturer: BLUE MICROPHONE
[    3.831850] usb 2-1.2: SerialNumber: 201111
[    3.833527] input: BLUE MICROPHONE Blue Snowball as /devices/pci0000:00/=
0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.2/input/input2
[    3.833618] generic-usb 0003:0D8C:0005.0003: input,hidraw2: USB HID v1.0=
0 Device [BLUE MICROPHONE Blue Snowball] on usb-0000:00:1d.0-1.2/input2
[    3.904517] usb 2-1.3: new low-speed USB device number 5 using ehci_hcd
[    4.003353] usb 2-1.3: New USB device found, idVendor=3D046d, idProduct=
=3Dc501
[    4.003432] usb 2-1.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    4.003493] usb 2-1.3: Product: USB Receiver
[    4.003550] usb 2-1.3: Manufacturer: Logitech
[    4.008082] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:=
1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input3
[    4.008177] generic-usb 0003:046D:C501.0004: input,hidraw3: USB HID v1.1=
0 Mouse [Logitech USB Receiver] on usb-0000:00:1d.0-1.3/input0
[    4.080361] usb 2-1.7: new full-speed USB device number 6 using ehci_hcd
[    4.153453] Btrfs loaded
[    4.154970] nbd: registered device at major 43
[    4.176833] usb 2-1.7: New USB device found, idVendor=3D0cf3, idProduct=
=3D3000
[    4.176898] usb 2-1.7: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[    4.228036] raid6: int64x1   3312 MB/s
[    4.295993] raid6: int64x2   3961 MB/s
[    4.363954] raid6: int64x4   3417 MB/s
[    4.431912] raid6: int64x8   2975 MB/s
[    4.499861] raid6: sse2x1    9188 MB/s
[    4.567818] raid6: sse2x2   11309 MB/s
[    4.635770] raid6: sse2x4   13060 MB/s
[    4.635827] raid6: using algorithm sse2x4 (13060 MB/s)
[    4.636116] async_tx: api initialized (async)
[    4.636273] xor: automatically using best checksumming function: generic=
_sse
[    4.655757]    generic_sse: 15246.000 MB/sec
[    4.655813] xor: using function: generic_sse (15246.000 MB/sec)
[    4.657178] md: raid6 personality registered for level 6
[    4.657235] md: raid5 personality registered for level 5
[    4.657292] md: raid4 personality registered for level 4
[    4.659129] mdadm: sending ioctl 800c0910 to a partition!
[    4.659192] mdadm: sending ioctl 800c0910 to a partition!
[    4.659252] mdadm: sending ioctl 1261 to a partition!
[    4.659842] mdadm: sending ioctl 1261 to a partition!
[    4.660074] mdadm: sending ioctl 1261 to a partition!
[    4.660145] mdadm: sending ioctl 1261 to a partition!
[    4.660353] mdadm: sending ioctl 1261 to a partition!
[    4.660426] mdadm: sending ioctl 1261 to a partition!
[    4.660587] mdadm: sending ioctl 1261 to a partition!
[    4.660663] mdadm: sending ioctl 1261 to a partition!
[    4.684325] device-mapper: uevent: version 1.0.3
[    4.684427] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised:=
 dm-devel@redhat.com
[   17.402029] device fsid f26f08b1-89e6-4f2d-b7f9-857010dd2517 devid 1 tra=
nsid 171977 /dev/dm-5
[   17.418364] device fsid f26f08b1-89e6-4f2d-b7f9-857010dd2517 devid 2 tra=
nsid 171977 /dev/dm-6
[   17.420772] device fsid f26f08b1-89e6-4f2d-b7f9-857010dd2517 devid 1 tra=
nsid 171977 /dev/mapper/rootvg-root_crypt
[   17.423276] btrfs: disk space caching is enabled
[   22.846578] zcache: created ephemeral tmem pool, id=3D0, client=3D65535
[   26.385845] udevd[1272]: starting version 175
[   27.410193] microcode: CPU0 sig=3D0x206a7, pf=3D0x2, revision=3D0x25
[   27.451486] ACPI Warning: 0x000000000000f000-0x000000000000f01f SystemIO=
 conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120320/utaddress-251)
[   27.451656] ACPI: If an ACPI driver is available for this device, you sh=
ould use it instead of the native driver
[   27.488987] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   27.879281] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[   27.879431] iTCO_wdt: Found a Cougar Point TCO device (Version=3D2, TCOB=
ASE=3D0x0460)
[   27.879520] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
[   27.963372] wmi: Mapper loaded
[   27.981897] Bluetooth: Core ver 2.16
[   27.981964] NET: Registered protocol family 31
[   27.982019] Bluetooth: HCI device and connection manager initialized
[   27.982078] Bluetooth: HCI socket layer initialized
[   27.982133] Bluetooth: L2CAP socket layer initialized
[   27.982190] Bluetooth: SCO socket layer initialized
[   28.066026] microcode: CPU1 sig=3D0x206a7, pf=3D0x2, revision=3D0x25
[   28.067045] microcode: CPU2 sig=3D0x206a7, pf=3D0x2, revision=3D0x25
[   28.068046] microcode: CPU3 sig=3D0x206a7, pf=3D0x2, revision=3D0x25
[   28.069005] microcode: CPU4 sig=3D0x206a7, pf=3D0x2, revision=3D0x25
[   28.070094] microcode: CPU5 sig=3D0x206a7, pf=3D0x2, revision=3D0x25
[   28.071046] microcode: CPU6 sig=3D0x206a7, pf=3D0x2, revision=3D0x25
[   28.071999] microcode: CPU7 sig=3D0x206a7, pf=3D0x2, revision=3D0x25
[   28.072994] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[   28.109912] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   28.122790] asus_wmi: ASUS WMI generic driver loaded
[   28.238903] ACPI: Requesting acpi_cpufreq
[   28.241532] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
C:00/input/input5
[   28.241609] ACPI: Power Button [PWRB]
[   28.241689] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input6
[   28.241764] ACPI: Power Button [PWRF]
[   28.248308] asus_wmi: Initialization: 0x0
[   28.248374] asus_wmi: BIOS WMI version: 0.9
[   28.248503] asus_wmi: SFUN value: 0x0
[   28.248738] input: Eee PC WMI hotkeys as /devices/platform/eeepc-wmi/inp=
ut/input7
[   28.284558] udevd[1331]: renamed network interface eth0 to rename2
[   28.316521] udevd[1343]: renamed network interface eth1 to eth0
[   28.356465] udevd[1331]: renamed network interface rename2 to eth1
[   28.357144] Bluetooth: Firmware file "ath3k-1.fw" not found
[   28.357202] ath3k: probe of 2-1.7:1.0 failed with error -2
[   28.357266] usbcore: registered new interface driver ath3k
[   29.651070] snd_hda_intel 0000:00:1b.0: irq 61 for MSI/MSI-X
[   29.679049] usbcore: registered new interface driver snd-usb-audio
[   32.697654] hda-intel: azx_get_response timeout, switching to polling mo=
de: last cmd=3D0x300f0000
[   33.705016] hda-intel: No response from codec, disabling MSI: last cmd=
=3D0x300f0000
[   34.712356] hda-intel: Codec #3 probe error; disabling it...
[   34.792684] snd_hda_intel 0000:01:00.1: irq 61 for MSI/MSI-X
[   36.094016] btrfs: disk space caching is enabled
[   36.294406] fuse init (API version 7.18)
[   36.329151] loop: module loaded
[   36.607872] [drm] Initialized drm 1.1.0 20060810
[   36.665860] scsi_verify_blk_ioctl: 102 callbacks suppressed
[   36.665939] mdadm: sending ioctl 800c0910 to a partition!
[   36.665999] mdadm: sending ioctl 800c0910 to a partition!
[   36.666056] mdadm: sending ioctl 800c0910 to a partition!
[   36.666116] mdadm: sending ioctl 1261 to a partition!
[   36.666173] mdadm: sending ioctl 1261 to a partition!
[   36.666229] mdadm: sending ioctl 1261 to a partition!
[   36.666396] mdadm: sending ioctl 1261 to a partition!
[   36.666467] mdadm: sending ioctl 1261 to a partition!
[   36.666535] mdadm: sending ioctl 1261 to a partition!
[   36.666712] mdadm: sending ioctl 1261 to a partition!
[   36.978831] [drm] radeon kernel modesetting enabled.
[   36.979080] [drm] initializing kernel modesetting (RV630 0x1002:0x9589 0=
x174B:0xE410).
[   36.979264] [drm] register mmio base: 0xF7E20000
[   36.979334] [drm] register mmio size: 65536
[   36.979571] ATOM BIOS: 11X
[   36.979651] radeon 0000:01:00.0: VRAM: 256M 0x0000000000000000 - 0x00000=
0000FFFFFFF (256M used)
[   36.979732] radeon 0000:01:00.0: GTT: 512M 0x0000000010000000 - 0x000000=
002FFFFFFF
[   36.979814] mtrr: type mismatch for e0000000,10000000 old: write-back ne=
w: write-combining
[   36.979893] [drm] Detected VRAM RAM=3D256M, BAR=3D256M
[   36.979960] [drm] RAM width 128bits DDR
[   36.980137] [TTM] Zone  kernel: Available graphics memory: 4101280 kiB
[   36.980207] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[   36.980275] [TTM] Initializing pool allocator
[   36.980345] [TTM] Initializing DMA pool allocator
[   36.980427] [drm] radeon: 256M of VRAM memory ready
[   36.980494] [drm] radeon: 512M of GTT memory ready.
[   36.980568] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   36.980638] [drm] Driver supports precise vblank timestamp query.
[   36.980751] radeon 0000:01:00.0: irq 62 for MSI/MSI-X
[   36.980761] radeon 0000:01:00.0: radeon: using MSI.
[   36.980851] [drm] radeon: irq initialized.
[   36.980950] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   36.981469] [drm] radeon: ib pool ready.
[   36.981603] [drm] Loading RV630 Microcode
[   37.235587] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000=
).
[   37.235721] radeon 0000:01:00.0: WB enabled
[   37.235789] [drm] fence driver on ring 0 use gpu addr 0x10000c00 and cpu=
 addr 0xffff880213de9c00
[   37.267424] [drm] ring test on 0 succeeded in 1 usecs
[   37.267718] [drm] ib test on ring 0 succeeded in 0 usecs
[   37.268037] [drm] Radeon Display Connectors
[   37.268114] [drm] Connector 0:
[   37.268179] [drm]   DVI-I
[   37.268245] [drm]   HPD1
[   37.268312] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5=
c 0x7e5c
[   37.268389] [drm]   Encoders:
[   37.268464] [drm]     DFP1: INTERNAL_KLDSCP_TMDS1
[   37.268537] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[   37.268605] [drm] Connector 1:
[   37.268670] [drm]   DIN
[   37.268733] [drm]   Encoders:
[   37.268798] [drm]     TV1: INTERNAL_KLDSCP_DAC2
[   37.268865] [drm] Connector 2:
[   37.268929] [drm]   DVI-I
[   37.268995] [drm]   HPD2
[   37.269061] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4=
c 0x7e4c
[   37.269139] [drm]   Encoders:
[   37.269205] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[   37.269271] [drm]     DFP2: INTERNAL_LVTM1
[   37.269347] [drm] Internal thermal controller with fan control
[   37.269450] [drm] radeon: power management initialized
[   37.343089] [drm] fb mappable at 0xE0142000
[   37.343155] [drm] vram apper at 0xE0000000
[   37.343219] [drm] size 7680000
[   37.343282] [drm] fb depth is 24
[   37.343344] [drm]    pitch is 6400
[   37.343441] fbcon: radeondrmfb (fb0) is primary device
[   37.764475] Console: switching to colour frame buffer device 200x75
[   37.770430] fb0: radeondrmfb frame buffer device
[   37.770431] drm: registered panic notifier
[   37.770437] [drm] Initialized radeon 2.16.0 20080528 for 0000:01:00.0 on=
 minor 0
[   42.193866] Adding 2928636k swap on /dev/mapper/rootvg-swap_crypt.  Prio=
rity:-1 extents:1 across:2928636k=20
[   42.790451] zcache: created ephemeral tmem pool, id=3D1, client=3D65535
[   42.790568] EXT4-fs (sdc1): mounted filesystem with ordered data mode. O=
pts: (null)
[   42.992696] SGI XFS with ACLs, security attributes, realtime, large bloc=
k/inode numbers, no debug enabled
[   42.994753] XFS (dm-8): Mounting Filesystem
[   43.194801] XFS (dm-8): Ending clean mount
[   43.204922] device fsid ad75beab-b52b-4f63-9d14-956cc8e95fc7 devid 1 tra=
nsid 5060 /dev/mapper/rootvg-scratch_crypt
[   43.205534] btrfs: disk space caching is enabled
[   43.653771] zcache: created ephemeral tmem pool, id=3D2, client=3D65535
[   44.306801] ip_tables: (C) 2000-2006 Netfilter Core Team
[   44.406931] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   45.744232] RPC: Registered named UNIX socket transport module.
[   45.744267] RPC: Registered udp transport module.
[   45.744290] RPC: Registered tcp transport module.
[   45.744312] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   45.804816] FS-Cache: Loaded
[   45.952035] NFS: Registering the id_resolver key type
[   45.952085] FS-Cache: Netfs 'nfs' registered for caching
[   46.002294] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   50.105286] zfs-fuse (3953): /proc/4032/oom_adj is deprecated, please us=
e /proc/4032/oom_score_adj instead.
[   61.328349] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   61.329869] Bluetooth: BNEP filters: protocol multicast
[   61.783150] Bluetooth: RFCOMM TTY layer initialized
[   61.784139] Bluetooth: RFCOMM socket layer initialized
[   61.785111] Bluetooth: RFCOMM ver 1.11
[   62.274723] lp: driver loaded but no devices found
[   62.375031] ppdev: user-space parallel port driver
[   66.273481] e1000e 0000:00:19.0: irq 58 for MSI/MSI-X
[   66.375920] e1000e 0000:00:19.0: irq 58 for MSI/MSI-X
[   66.382081] r8169 0000:07:02.0: eth1: link down
[   66.382106] DRHD: handling fault status reg 3
[   66.382109] DMAR:[DMA Read] Request device [07:00.0] fault addr ffffe000=
=20
[   66.382110] DMAR:[fault reason 02] Present bit in context entry is clear
[   66.382125] r8169 0000:07:02.0: eth1: link down
[   66.382131] NOHZ: local_softirq_pending 08
[   67.917641] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Contr=
ol: Rx/Tx
[   67.918651] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   72.438999] tun: Universal TUN/TAP device driver, 1.6
[   72.440888] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   73.160520] Ebtables v2.0 registered
[   73.343833] ip6_tables: (C) 2000-2006 Netfilter Core Team

--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="nc.log.acpioff_noioapic"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.4+btrfsdebug3+kmc+ (sliedes@lh) (gcc versi=
on 4.7.1 (Debian 4.7.1-4) ) #6 SMP Thu Jul 12 21:38:46 EEST 2012
[    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-3.4.4+btrfsdebug3+kmc+ r=
oot=3D/dev/mapper/rootvg-root_crypt ro netconsole=3D4444@192.168.1.2/eth0,1=
194@192.168.1.12/00:1c:10:44:47:2c acpi=3Doff noioapic
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
[    0.000000]  BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000deb91000 (usable)
[    0.000000]  BIOS-e820: 00000000deb91000 - 00000000df141000 (reserved)
[    0.000000]  BIOS-e820: 00000000df141000 - 00000000df386000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df386000 - 00000000df394000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df394000 - 00000000df3c1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df3c1000 - 00000000df3c6000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df3c6000 - 00000000df409000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df409000 - 00000000df800000 (usable)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed04000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000021f000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x21f000 max_arch_pfn =3D 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] last_pfn =3D 0xdf800 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fce00] fce00
[    0.000000] init_memory_mapping: 0000000000000000-00000000df800000
[    0.000000] init_memory_mapping: 0000000100000000-000000021f000000
[    0.000000] RAMDISK: 364c2000 - 37259000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0021f000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000deb91
[    0.000000]     0: 0x000df409 -> 0x000df800
[    0.000000]     0: 0x00100000 -> 0x0021f000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000] MPTABLE: OEM ID: A M I
[    0.000000] MPTABLE: Product ID: ALASKA
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #2
[    0.000000] Processor #4
[    0.000000] Processor #6
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] Processors: 4
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at df800000 (gap: df800000=
:18800000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88021ec00000 s77184 r8192=
 d21120 u524288
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 2053971
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-3.4.4+btrfsdebug3=
+kmc+ root=3D/dev/mapper/rootvg-root_crypt ro netconsole=3D4444@192.168.1.2=
/eth0,1194@192.168.1.12/00:1c:10:44:47:2c acpi=3Doff noioapic
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608=
 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 b=
ytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 8104200k/8896512k available (4332k kernel code, 5416=
12k absent, 250700k reserved, 4356k data, 512k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D4, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000001] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6822.04 BogoMIPS (lpj=3D13644088)
[    0.000817] pid_max: default: 32768 minimum: 301
[    0.004000] Fast TSC calibration using PIT
[    0.005729] Security Framework initialized
[    0.008000] Detected 3411.022 MHz processor.
[    0.009566] Mount-cache hash table entries: 256
[    0.042839] Initializing cgroup subsys cpuacct
[    0.043174] Initializing cgroup subsys devices
[    0.043545] Initializing cgroup subsys freezer
[    0.043902] Initializing cgroup subsys net_cls
[    0.044289] Initializing cgroup subsys blkio
[    0.045481] Initializing cgroup subsys perf_event
[    0.047812] CPU: Physical Processor ID: 0
[    0.048124] CPU: Processor Core ID: 0
[    0.048451] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.048452] ENERGY_PERF_BIAS: View and update with x86_energy_perf_polic=
y(8)
[    0.049343] mce: CPU supports 9 MCE banks
[    0.049822] CPU0: Thermal monitoring enabled (TM1)
[    0.050178] using mwait in idle threads.
[    0.054916] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.094994] CPU0: Intel(R) Core(TM) i7-2600 CPU @ 3.40GHz stepping 07
[    0.308130] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge eve=
nts, Intel PMU driver.
[    0.308991] PEBS disabled due to CPU errata.
[    0.309337] ... version:                3
[    0.309636] ... bit width:              48
[    0.309938] ... generic registers:      4
[    0.310238] ... value mask:             0000ffffffffffff
[    0.310605] ... max period:             000000007fffffff
[    0.310969] ... fixed-purpose events:   3
[    0.311269] ... event mask:             000000070000000f
[    0.311907] kmemcheck: Limiting number of CPUs to 1.
[    0.312258] kmemcheck: Initialized
[    0.317539] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.318168] Brought up 1 CPUs
[    0.318414] Total of 1 processors activated (6822.04 BogoMIPS).
[    0.374413] dummy:=20
[    0.384393] NET: Registered protocol family 16
[    0.424483] PCI: Using configuration type 1 for base access
[    0.656756] bio: create slab <bio-0> at 0
[    0.666777] ACPI: Interpreter disabled.
[    0.677620] vgaarb: loaded
[    0.697021] usbcore: registered new interface driver usbfs
[    0.701969] usbcore: registered new interface driver hub
[    0.704838] usbcore: registered new device driver usb
[    0.719486] PCI: Probing PCI hardware
[    0.724878] PCI host bridge to bus 0000:00
[    0.725230] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.725690] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
ff]
[    0.762565] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.763707] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.766973] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.770487] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    0.773793] pci 0000:00:1c.4: PCI bridge to [bus 05-05]
[    0.776564] pci 0000:00:1c.6: PCI bridge to [bus 06-07] (subtractive dec=
ode)
[    0.782098] pci 0000:06:00.0: PCI bridge to [bus 07-07] (subtractive dec=
ode)
[    0.786111] pci 0000:00:1c.7: PCI bridge to [bus 08-08]
[    0.865366] vgaarb: device added: PCI:0000:01:00.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.938617] pci 0000:00:1f.0: PIIX/ICH IRQ router [8086:1c46]
[    0.947136] ------------[ cut here ]------------
[    1.626642]  [<ffffffff818bb52c>] vty_init+0x15b/0x17b
[    1.627078]  [<ffffffff818bac3a>] tty_init+0x136/0x13a
[    1.627514]  [<ffffffff818bc0cf>] chr_dev_init+0xbc/0xc1
[    1.627957]  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
[    1.628428]  [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
[    1.628878]  [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
[    5.450684] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 1
[    5.455036] ehci_hcd 0000:00:1a.0: debug port 2
[    5.459304] ehci_hcd 0000:00:1a.0: Enabling legacy PCI PM
[    5.460043] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf7f28000
[    5.469171] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    5.471687] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    5.472147] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.472701] usb usb1: Product: EHCI Host Controller
[    5.473142] usb usb1: Manufacturer: Linux 3.4.4+btrfsdebug3+kmc+ ehci_hcd
[    5.473625] usb usb1: SerialNumber: 0000:00:1a.0
[    5.485897] hub 1-0:1.0: USB hub found
[    5.486490] hub 1-0:1.0: 2 ports detected
[    7.878322] console [netcon0] enabled
[    7.878796] netconsole: network logging started
[    7.879511] rtc_cmos rtc_cmos: setting system clock to 2012-07-12 19:05:=
00 UTC (1342119900)
[    7.892939] Freeing unused kernel memory: 512k freed
[    7.893536] Write protecting the kernel read-only data: 8192k
[    7.897439] Freeing unused kernel memory: 1792k freed
[    7.898367] Freeing unused kernel memory: 52k freed
[    8.227384] Clocksource tsc unstable (delta =3D 144020669 ns)
[    8.231423] Switching to clocksource jiffies
[    8.860496] ERROR: kmemcheck: Fatal error
[    8.860993]=20
[    8.861376] Pid: 597, comm: udevadm Tainted: G        W    3.4.4+btrfsde=
bug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
[    8.863112] RIP: 0010:[<ffffffff81140d0f>]  [<ffffffff81140d0f>] address=
_space_init_once+0x6f/0x130
[    8.864179] RSP: 0018:ffff8802123ef9a8  EFLAGS: 00010046
[    8.864747] RAX: 0000000000000000 RBX: ffff880211d63e80 RCX: 00000000000=
00000
[    8.865420] RDX: ffffffff81a18090 RSI: ffff880211d63d40 RDI: ffff880211d=
63ec0
[    8.866091] RBP: ffff8802123ef9b8 R08: 0000000000000000 R09: 00000000000=
00010
[    8.866763] R10: 000000000000000c R11: 000000000000000e R12: ffff880211d=
63d40
[    8.867436] R13: ffff880211d63d40 R14: ffff880211d60000 R15: ffffea00084=
75800
[    8.868108] FS:  00007f5983b707a0(0000) GS:ffff88021ec00000(0000) knlGS:=
0000000000000000
[    8.868868] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    8.869460] CR2: ffff88021214eb00 CR3: 00000002123fa000 CR4: 00000000000=
407f0
[    8.870131] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    8.870803] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 00000000000=
00400
[    8.871476]  [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
[    8.872354]  [<ffffffff81032c4b>] kmemcheck_show+0x8b/0xa0
[    8.873182]  [<ffffffff81033067>] kmemcheck_fault+0x77/0xd0
[    8.874019]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[    8.874855]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    8.875666]  [<ffffffff81140e8e>] inode_init_once+0xbe/0x120
[    8.876503]  [<ffffffff81140ef9>] init_once+0x9/0x10
[    8.877300]  [<ffffffff8111cb3a>] setup_object.isra.55+0x5a/0x70
[    8.878159]  [<ffffffff8111d907>] new_slab+0x1c7/0x2c0
[    8.878967]  [<ffffffff81429967>] __slab_alloc.constprop.63+0x155/0x4ba
[    8.879862]  [<ffffffff8111eed4>] kmem_cache_alloc+0xf4/0x160
[    8.880708]  [<ffffffff81141129>] alloc_inode+0x59/0x90
[    8.881523]  [<ffffffff811426b0>] iget_locked+0xb0/0x190
[    8.882341]  [<ffffffff811913f2>] sysfs_get_inode+0x12/0x150
[    8.883184]  [<ffffffff81193436>] sysfs_lookup+0x76/0x120
[    8.884010]  [<ffffffff8113377c>] __lookup_hash+0x5c/0x120
[    8.884838]  [<ffffffff81135b30>] do_lookup+0x2a0/0x350
[    8.885653]  [<ffffffff81136b04>] path_lookupat+0x114/0x700
[    8.886488]  [<ffffffff8113711c>] do_path_lookup+0x2c/0xc0
[    8.887319]  [<ffffffff811385f8>] user_path_at_empty+0x58/0xa0
[    8.888894]  [<ffffffff8113864c>] user_path_at+0xc/0x10
[    8.889709]  [<ffffffff8112dda0>] vfs_fstatat+0x30/0x70
[    8.890526]  [<ffffffff8112de16>] vfs_stat+0x16/0x20
[    8.891327]  [<ffffffff8112dfe5>] sys_newstat+0x15/0x30
[    8.892141]  [<ffffffff8143753d>] system_call_fastpath+0x1a/0x1f
[    8.892994]  [<ffffffffffffffff>] 0xffffffffffffffff
[    9.925255] Btrfs loaded
[   10.208132] nbd: registered device at major 43
[   10.946293] SCSI subsystem initialized
[   11.109670] raid6: int64x1   3318 MB/s
[   11.177615] raid6: int64x2   3966 MB/s
[   11.245585] raid6: int64x4   3418 MB/s
[   11.313542] raid6: int64x8   2976 MB/s
[   11.381493] raid6: sse2x1    9188 MB/s
[   11.449456] raid6: sse2x2   11300 MB/s
[   11.517413] raid6: sse2x4   13058 MB/s
[   11.517892] raid6: using algorithm sse2x4 (13058 MB/s)
[   11.818423] async_tx: api initialized (async)
[   11.829037] xor: measuring software checksum speed
[   11.849213]    8regs     : 15001.000 MB/sec
[   11.869201]    8regs_prefetch: 13953.000 MB/sec
[   11.889189]    32regs    : 15002.000 MB/sec
[   11.909177]    32regs_prefetch: 13921.000 MB/sec
[   11.909707] xor: using function: 32regs (15002.000 MB/sec)
[   12.079936] md: raid6 personality registered for level 6
[   12.080508] md: raid5 personality registered for level 5
[   12.081210] md: raid4 personality registered for level 4
[   12.166941] ahci 0000:00:1f.2: PCI->APIC IRQ transform: INT B -> IRQ 19
[   12.318843] device-mapper: uevent: version 1.0.3
[   12.328683] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised:=
 dm-devel@redhat.com
[   12.573153] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x=
b impl SATA mode
[   12.573942] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part=
 ems apst=20
[   14.042785] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   14.044861] r8169 0000:07:02.0: PCI->APIC IRQ transform: INT A -> IRQ 16
[   14.047443] r8169 0000:07:02.0: (unregistered net_device): not PCI Expre=
ss
[   14.066264] r8169 0000:07:02.0: eth1: RTL8169sc/8110sc at 0xffffc900000b=
e000, f4:6d:04:b0:81:c0, XID 18000000 IRQ 16
[   14.067194] r8169 0000:07:02.0: eth1: jumbo features [frames: 7152 bytes=
, tx checksumming: ok]
[   14.342022] firewire_ohci 0000:07:03.0: PCI->APIC IRQ transform: INT A -=
> IRQ 17
[   14.352004] scsi0 : ahci
[   14.367929] scsi1 : ahci
[   14.388148] scsi2 : ahci
[   14.407975] scsi3 : ahci
[   14.411710] ERROR: kmemcheck: Fatal error
[   14.412206]=20
[   14.412588] Pid: 631, comm: modprobe Tainted: G        W    3.4.4+btrfsd=
ebug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
[   14.414323] RIP: 0010:[<ffffffff81430c46>]  [<ffffffff81430c46>] nmi_han=
dle.isra.0+0x46/0x80
[   14.415355] RSP: 0018:ffff88021ec07e78  EFLAGS: 00010046
[   14.415958] RAX: ffff88021580e580 RBX: ffff88021580e580 RCX: 00000000000=
00001
[   14.416634] RDX: ffffffff81432d0b RSI: ffff88021ec07ef8 RDI: 00000000000=
00000
[   14.417306] RBP: ffff88021ec07eb8 R08: 00003ffffffff000 R09: ffff8800000=
00000
[   14.418065] R10: 00000000116e0e01 R11: 00000000fffffff4 R12: 00000000000=
00000
[   14.418738] R13: ffffffff81816828 R14: 0000000000000000 R15: ffff88021ec=
07ef8
[   14.419410] FS:  00007fe3eecd9700(0000) GS:ffff88021ec00000(0000) knlGS:=
0000000000000000
[   14.420237] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   14.420832] CR2: ffff88021214eb00 CR3: 00000002119ad000 CR4: 00000000000=
407f0
[   14.421505] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   14.422177] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 00000000000=
00400
[   14.422850]  [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
[   14.423762]  [<ffffffff81032850>] kmemcheck_access+0x1d0/0x440
[   14.424695]  [<ffffffff8103308d>] kmemcheck_fault+0x9d/0xd0
[   14.425531]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[   14.426367]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[   14.427264]  [<ffffffff81430d60>] do_nmi+0xe0/0x310
[   14.428095]  [<ffffffff814302dc>] end_repeat_nmi+0x1a/0x1e
[   14.428924]  [<ffffffff8103305f>] kmemcheck_fault+0x6f/0xd0
[   14.429761]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[   14.430600]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[   14.431495]  [<ffffffff811e1517>] kobject_uevent_env+0x437/0x640
[   14.432425]  [<ffffffff811e172b>] kobject_uevent+0xb/0x10
[   14.433252]  [<ffffffff8129e63e>] device_add+0x5ae/0x6a0
[   14.434159]  [<ffffffffa00e8269>] scsi_add_host_with_dma+0x99/0x290 [scs=
i_mod]
[   14.435122]  [<ffffffffa0174274>] ata_scsi_add_hosts+0xa4/0x130 [libata]
[   14.436057]  [<ffffffffa016f5c3>] ata_host_register+0xf3/0x290 [libata]
[   14.436954]  [<ffffffffa016f82e>] ata_host_activate+0xce/0x110 [libata]
[   14.437847]  [<ffffffffa02329a7>] ahci_init_one+0x627/0xa2c [ahci]
[   14.438801]  [<ffffffff8120803f>] pci_device_probe+0xaf/0x130
[   14.439646]  [<ffffffff812a106d>] driver_probe_device+0x8d/0x3a0
[   14.440540]  [<ffffffff812a141b>] __driver_attach+0x9b/0xa0
[   14.441460]  [<ffffffff8129f17d>] bus_for_each_dev+0x4d/0x90
[   14.442298]  [<ffffffff812a09d9>] driver_attach+0x19/0x20
[   14.443122]  [<ffffffff812a0658>] bus_add_driver+0x1a8/0x2a0
[   14.444027]  [<ffffffff812a1882>] driver_register+0x72/0x150
[   14.444865]  [<ffffffff81207a09>] __pci_register_driver+0x59/0xd0
[   14.445814]  [<ffffffffa023901e>] ahci_init+0x1e/0x20 [ahci]
[   14.446653]  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
[   14.447500]  [<ffffffff8108d91e>] sys_init_module+0x109e/0x2070
[   14.448478]  [<ffffffff8143753d>] system_call_fastpath+0x1a/0x1f
[   14.449338]  [<ffffffffffffffff>] 0xffffffffffffffff
[   14.609320] firewire_ohci 0000:07:03.0: added OHCI v1.10 device as card =
0, 4 IR + 8 IT contexts, quirks 0x11
[   14.869597] scsi4 : ahci
[   14.887951] scsi5 : ahci
[   14.897107] ata1: SATA max UDMA/133 abar m2048@0xf7f26000 port 0xf7f2610=
0 irq 45
[   14.897835] ata2: SATA max UDMA/133 abar m2048@0xf7f26000 port 0xf7f2618=
0 irq 45
[   14.898684] ata3: DUMMY
[   14.899098] ata4: SATA max UDMA/133 abar m2048@0xf7f26000 port 0xf7f2628=
0 irq 45
[   14.899965] ata5: DUMMY
[   14.900376] ata6: DUMMY
[   14.902599] ahci 0000:04:00.0: PCI->APIC IRQ transform: INT A -> IRQ 19
[   14.904771] ahci 0000:04:00.0: AHCI 0001.0100 32 slots 2 ports 3 Gbps 0x=
3 impl SATA mode
[   14.905562] ahci 0000:04:00.0: flags: 64bit ncq pm led clo pmp pio slum =
part=20
[   14.945981] scsi6 : ahci
[   14.962614] scsi7 : ahci
[   14.972263] ata7: SATA max UDMA/133 abar m512@0xf7c10000 port 0xf7c10100=
 irq 19
[   14.972987] ata8: SATA max UDMA/133 abar m512@0xf7c10000 port 0xf7c10180=
 irq 19
[   14.975441] ahci 0000:08:00.0: PCI->APIC IRQ transform: INT A -> IRQ 19
[   14.978361] ahci 0000:08:00.0: AHCI 0001.0000 32 slots 2 ports 6 Gbps 0x=
3 impl SATA mode
[   14.979150] ahci 0000:08:00.0: flags: 64bit ncq sntf led only pmp fbs pi=
o slum part sxs=20
[   15.016149] scsi8 : ahci
[   15.077235] scsi9 : ahci
[   15.086442] ata9: SATA max UDMA/133 abar m512@0xf7910000 port 0xf7910100=
 irq 46
[   15.087165] ata10: SATA max UDMA/133 abar m512@0xf7910000 port 0xf791018=
0 irq 46
[   15.117524] firewire_core 0000:07:03.0: created device fw0: GUID 001e8c0=
0004bb103, S400
[   15.271412] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   15.272117] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   15.273950] ata2.00: ATA-8: ST2000DM001-9YN164, CC4C, max UDMA/133
[   15.274567] ata2.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[   15.276939] ata2.00: configured for UDMA/133
[   15.300829] ata1.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
[   15.301417] ata1.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2)
[   15.323357] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   15.328720] ata4.00: ATA-8: WDC WD20EARX-00PASB0, 51.0AB51, max UDMA/133
[   15.329370] ata4.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[   15.335287] ata4.00: configured for UDMA/133
[   15.343404] ata7: SATA link down (SStatus 0 SControl 300)
[   15.347655] ata1.00: configured for UDMA/133
[   15.361210] scsi 0:0:0:0: Direct-Access     ATA      ST31500341AS     CC=
1H PQ: 0 ANSI: 5
[   15.392924] scsi 1:0:0:0: Direct-Access     ATA      ST2000DM001-9YN1 CC=
4C PQ: 0 ANSI: 5
[   15.419211] ata9: SATA link down (SStatus 0 SControl 300)
[   15.433430] scsi 3:0:0:0: Direct-Access     ATA      WDC WD20EARX-00P 51=
=2E0 PQ: 0 ANSI: 5
[   15.455275] ata8: SATA link down (SStatus 0 SControl 300)
[   15.456192] ata10: SATA link down (SStatus 0 SControl 300)
[   16.343002] sd 3:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 =
TB/1.81 TiB)
[   16.343769] sd 3:0:0:0: [sdc] 4096-byte physical blocks
[   16.345392] sd 0:0:0:0: [sda] 2930277168 512-byte logical blocks: (1.50 =
TB/1.36 TiB)
[   16.347148] sd 1:0:0:0: [sdb] 3907029168 512-byte logical blocks: (2.00 =
TB/1.81 TiB)
[   16.347914] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[   16.361652] sd 0:0:0:0: [sda] Write Protect is off
[   16.364973] sd 3:0:0:0: [sdc] Write Protect is off
[   16.366550] sd 1:0:0:0: [sdb] Write Protect is off
[   16.371371] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[   16.382748] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[   16.391323] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[   16.465948]  sda: sda1 sda2
[   16.474401]  sdb: sdb1 sdb2
[   16.556798] sd 1:0:0:0: [sdb] Attached SCSI disk
[   16.558539] sd 0:0:0:0: [sda] Attached SCSI disk
[   16.860224]  sdc: sdc1 sdc2 sdc3 sdc4
[   16.911152] sd 3:0:0:0: [sdc] Attached SCSI disk
[  310.276443] sd 3:0:0:0: [sdc] Synchronizing SCSI cache
[  310.277957] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
[  310.279544] sd 0:0:0:0: [sda] Synchronizing SCSI cache

--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="nc.log.noacpi"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.4+btrfsdebug3+kmc+ (sliedes@lh) (gcc versi=
on 4.7.1 (Debian 4.7.1-4) ) #6 SMP Thu Jul 12 21:38:46 EEST 2012
[    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-3.4.4+btrfsdebug3+kmc+ r=
oot=3D/dev/mapper/rootvg-root_crypt ro netconsole=3D4444@192.168.1.2/eth0,1=
194@192.168.1.12/00:1c:10:44:47:2c noacpi
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
[    0.000000]  BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000deb91000 (usable)
[    0.000000]  BIOS-e820: 00000000deb91000 - 00000000df141000 (reserved)
[    0.000000]  BIOS-e820: 00000000df141000 - 00000000df386000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df386000 - 00000000df394000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df394000 - 00000000df3c1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df3c1000 - 00000000df3c6000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df3c6000 - 00000000df409000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df409000 - 00000000df800000 (usable)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed04000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000021f000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x21f000 max_arch_pfn =3D 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] last_pfn =3D 0xdf800 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fce00] fce00
[    0.000000] init_memory_mapping: 0000000000000000-00000000df800000
[    0.000000] init_memory_mapping: 0000000100000000-000000021f000000
[    0.000000] RAMDISK: 364c2000 - 37259000
[    0.000000] ACPI: RSDP 00000000000f0450 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000df386070 00064 (v01 ALASKA    A M I 01072=
009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000df391cd8 000F4 (v04 ALASKA    A M I 01072=
009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000df386168 0BB6D (v02 ALASKA    A M I 00000=
015 INTL 20051117)
[    0.000000] ACPI: FACS 00000000df3bff80 00040
[    0.000000] ACPI: APIC 00000000df391dd0 00092 (v03 ALASKA    A M I 01072=
009 AMI  00010013)
[    0.000000] ACPI: MCFG 00000000df391e68 0003C (v01 ALASKA    A M I 01072=
009 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000df391ea8 00038 (v01 ALASKA    A M I 01072=
009 AMI. 00000005)
[    0.000000] ACPI: SSDT 00000000df391ee0 0036D (v01 SataRe SataTabl 00001=
000 INTL 20091112)
[    0.000000] ACPI: SSDT 00000000df392250 009AA (v01  PmRef  Cpu0Ist 00003=
000 INTL 20051117)
[    0.000000] ACPI: SSDT 00000000df392c00 00A92 (v01  PmRef    CpuPm 00003=
000 INTL 20051117)
[    0.000000] ACPI: DMAR 00000000df393698 00078 (v01 INTEL      SNB  00000=
001 INTL 00000001)
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0021f000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000deb91
[    0.000000]     0: 0x000df409 -> 0x000df800
[    0.000000]     0: 0x00100000 -> 0x0021f000
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at df800000 (gap: df800000=
:18800000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:8 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88021ec00000 s77184 r8192=
 d21120 u262144
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 2053971
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-3.4.4+btrfsdebug3=
+kmc+ root=3D/dev/mapper/rootvg-root_crypt ro netconsole=3D4444@192.168.1.2=
/eth0,1194@192.168.1.12/00:1c:10:44:47:2c noacpi
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608=
 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 b=
ytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 8103784k/8896512k available (4332k kernel code, 5416=
12k absent, 251116k reserved, 4356k data, 512k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D8, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000001] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6821.90 BogoMIPS (lpj=3D13643808)
[    0.000817] pid_max: default: 32768 minimum: 301
[    0.004000] Detected 3410.952 MHz processor.
[    0.005768] Security Framework initialized
[    0.009613] Mount-cache hash table entries: 256
[    0.045802] Initializing cgroup subsys cpuacct
[    0.046137] Initializing cgroup subsys devices
[    0.046510] Initializing cgroup subsys freezer
[    0.046867] Initializing cgroup subsys net_cls
[    0.047223] Initializing cgroup subsys blkio
[    0.048449] Initializing cgroup subsys perf_event
[    0.050785] CPU: Physical Processor ID: 0
[    0.051095] CPU: Processor Core ID: 0
[    0.051390] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.051391] ENERGY_PERF_BIAS: View and update with x86_energy_perf_polic=
y(8)
[    0.052315] mce: CPU supports 9 MCE banks
[    0.052795] CPU0: Thermal monitoring enabled (TM1)
[    0.053152] using mwait in idle threads.
[    0.054124] ACPI: Core revision 20120320
[    2.156335] DMAR: Host address width 36
[    2.156629] DMAR: DRHD base: 0x000000fed90000 flags: 0x1
[    2.157291] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020660262 e=
cap f0105a
[    2.157819] DMAR: RMRR base: 0x000000df0d6000 end: 0x000000df0e4fff
[    2.158410] IOAPIC id 2 under DRHD base  0xfed90000 IOMMU 0
[    2.158796] HPET id 0 under DRHD base 0xfed90000
[    2.159321] Enabled IRQ remapping in x2apic mode
[    2.159655] Enabling x2apic
[    2.159896] Enabled x2apic
[    2.160165] WARNING: kmemcheck: Caught 32-bit read from uninitialized me=
mory (ffff880215822408)
[    2.160748] 00000000000000000c001000000000040000000002000000e10900000000=
0000
[    2.163611]  i i i i i i i i u u u u u u u u u u u u u u u u u u u u u u=
 u u
[    2.166453]                  ^
[    2.166705]=20
[    2.166879] Pid: 1, comm: swapper/0 Not tainted 3.4.4+btrfsdebug3+kmc+ #=
6 System manufacturer System Product Name/P8P67 EVO
[    2.965976]  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x1=
20
[    2.965978]  [<ffffffff81252660>] ? acpi_ns_walk_namespace+0x5f/0x173
[    2.965980]  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x1=
20
[    2.965981]  [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
[    2.965983]  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x1=
20
[    2.965984]  [<ffffffff812469ac>] ? acpi_ev_initialize_op_regions+0x41/0=
x8d
[    2.965985]  [<ffffffff812469e7>] acpi_ev_initialize_op_regions+0x7c/0x8d
[    2.965988]  [<ffffffff818b8838>] ? acpi_sleep_init+0xee/0xee
[    2.965990]  [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
[    2.965992]  [<ffffffff818b894b>] acpi_init+0x113/0x28f
[    2.965994]  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
[    2.965996]  [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
[    2.989175] Hardware name: System Product Name
[    2.989505] Modules linked in: <omitted>
[    2.989876] Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsde=
bug3+kmc+ #6
[    2.990414] Call Trace:
[    2.990637]  <NMI>  [<ffffffff8103a7fa>] warn_slowpath_common+0x7a/0xb0
[    2.991157]  [<ffffffff8103a845>] warn_slowpath_null+0x15/0x20
[    2.991558]  [<ffffffff810330a9>] kmemcheck_fault+0xb9/0xd0
[    2.995999]  [<ffffffff81033067>] kmemcheck_fault+0x77/0xd0
[    2.996774]  [<ffffffff81032592>] ? kmemcheck_read+0x42/0x70
[    2.997168]  [<ffffffff8142ffb5>] ? page_fault+0x25/0x30
[    2.997543]  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x1=
20
[    2.998000]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    2.998366]  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x1=
20
[    2.998823]  [<ffffffff81252660>] ? acpi_ns_walk_namespace+0x5f/0x173
[    2.999258]  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x1=
20
[    2.999713]  [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
[    3.000161]  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x1=
20
[    3.000618]  [<ffffffff812469ac>] ? acpi_ev_initialize_op_regions+0x41/0=
x8d
[    3.001080]  [<ffffffff812469e7>] acpi_ev_initialize_op_regions+0x7c/0x8d
[    3.001535]  [<ffffffff818b8838>] ? acpi_sleep_init+0xee/0xee
[    3.001933]  [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
[    3.002360]  [<ffffffff818b894b>] acpi_init+0x113/0x28f
[    3.002729]  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
[    3.003127]  [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
[    3.003507]  [<ffffffff81891582>] ? do_early_param+0x8c/0x8c
[    3.003901]  [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
[    3.004310]  [<ffffffff81891b22>] ? start_kernel+0x341/0x341
[    3.004702]  [<ffffffff814389a0>] ? gs_change+0x13/0x13
[    3.005072] ---[ end trace 4eaa2a86a8e2da23 ]---
[    3.078935] ACPI: Executed 1 blocks of module-level executable AML code
[    4.236119] ------------[ cut here ]------------
[    4.236455] WARNING: at kernel/smp.c:459 smp_call_function_many+0xbd/0x2=
70()
[    4.236912] Hardware name: System Product Name
[    4.237236] Modules linked in: <omitted>
[    4.237600] Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsde=
bug3+kmc+ #6
[    4.238129] Call Trace:
[    4.238350]  [<ffffffff8103a7fa>] warn_slowpath_common+0x7a/0xb0
[    4.238758]  [<ffffffff8103336a>] ? kmemcheck_shadow_lookup+0x2a/0x70
[    4.239183]  [<ffffffff8103a845>] warn_slowpath_null+0x15/0x20
[    4.239579]  [<ffffffff810885bd>] smp_call_function_many+0xbd/0x270
[    4.239998]  [<ffffffff8142ffb5>] ? page_fault+0x25/0x30
[    4.240366]  [<ffffffff81031560>] ? leave_mm+0x40/0x40
[    4.240727]  [<ffffffff81031560>] ? leave_mm+0x40/0x40
[    4.241086]  [<ffffffff8108889d>] smp_call_function+0x1d/0x30
[    4.241478]  [<ffffffff810888d3>] on_each_cpu+0x23/0x60
[    4.241844]  [<ffffffff81031977>] flush_tlb_all+0x17/0x20
[    4.242220]  [<ffffffff8110bac5>] __purge_vmap_area_lazy+0x165/0x1c0
[    4.242642]  [<ffffffff81033067>] ? kmemcheck_fault+0x77/0xd0
[    4.243032]  [<ffffffff8110bd85>] vm_unmap_aliases+0x165/0x180
[    4.243426]  [<ffffffff8102e2e8>] change_page_attr_set_clr+0xb8/0x470
[    4.243853]  [<ffffffff8142ffb5>] ? page_fault+0x25/0x30
[    4.244223]  [<ffffffff8102eeda>] _set_memory_wb+0x2a/0x30
[    4.244603]  [<ffffffff8102d262>] ioremap_change_attr+0x12/0x40
[    4.245003]  [<ffffffff8102fcbd>] kernel_map_sync_memtype+0x7d/0xe0
[    4.245423]  [<ffffffff8102cfe8>] __ioremap_caller+0x258/0x360
[    4.245818]  [<ffffffff8102d11f>] ioremap_cache+0xf/0x20
[    4.246188]  [<ffffffff814104a9>] acpi_os_map_memory+0xfc/0x15c
[    4.246589]  [<ffffffff8124c739>] acpi_ex_system_memory_space_handler+0x=
e5/0x1e4
[    4.247100]  [<ffffffff8124c654>] ? acpi_ex_do_logical_op+0x15f/0x15f
[    4.247525]  [<ffffffff81246334>] acpi_ev_address_space_dispatch+0x1a5/0=
x1fb
[    4.247983]  [<ffffffff812499b6>] acpi_ex_access_region+0x270/0x28d
[    4.248402]  [<ffffffff81249d14>] acpi_ex_field_datum_io+0x10a/0x187
[    4.248825]  [<ffffffff8124a061>] acpi_ex_write_with_update_rule+0xbd/0x=
c8
[    4.249276]  [<ffffffff81249b24>] acpi_ex_insert_into_field+0x151/0x237
[    4.249714]  [<ffffffff812496d5>] acpi_ex_write_data_to_field+0x1b9/0x1e8
[    4.250159]  [<ffffffff8124d4f9>] acpi_ex_store_object_to_node+0x95/0xd8
[    4.250598]  [<ffffffff8124d5f4>] acpi_ex_store+0xb8/0x238
[    4.250977]  [<ffffffff8124ac87>] acpi_ex_opcode_1A_1T_1R+0x363/0x4b5
[    4.251402]  [<ffffffff8124342d>] acpi_ds_exec_end_op+0xcf/0x3ee
[    4.251808]  [<ffffffff8124335e>] ? acpi_ds_exec_begin_op+0x11e/0x11e
[    4.252236]  [<ffffffff81254883>] acpi_ps_parse_loop+0x7c9/0x96e
[    4.252642]  [<ffffffff81254df2>] acpi_ps_parse_aml+0x91/0x273
[    4.253038]  [<ffffffff8125560c>] acpi_ps_execute_method+0x1c6/0x276
[    4.253460]  [<ffffffff81250042>] acpi_ns_evaluate+0xbe/0x1a8
[    4.253851]  [<ffffffff81250341>] acpi_ns_init_one_device+0x81/0xab
[    4.254270]  [<ffffffff812526ba>] acpi_ns_walk_namespace+0xb9/0x173
[    4.254688]  [<ffffffff812502c0>] ? acpi_ns_exec_module_code_list+0x194/=
0x194
[    4.255152]  [<ffffffff818b8838>] ? acpi_sleep_init+0xee/0xee
[    4.255543]  [<ffffffff81250612>] acpi_ns_initialize_devices+0xf8/0x146
[    4.255981]  [<ffffffff8125c013>] acpi_initialize_objects+0x4a/0x53
[    4.256399]  [<ffffffff818b894b>] acpi_init+0x113/0x28f
[    4.256764]  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
[    4.257156]  [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
[    4.257529]  [<ffffffff81891582>] ? do_early_param+0x8c/0x8c
[    4.257915]  [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
[    4.258314]  [<ffffffff81891b22>] ? start_kernel+0x341/0x341
[    4.258699]  [<ffffffff814389a0>] ? gs_change+0x13/0x13
[    4.259063] ---[ end trace 4eaa2a86a8e2da24 ]---
[    4.285989] ERROR: kmemcheck: Fatal error
[    4.286288]=20
[    4.286460] Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsde=
bug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
[    4.287429] RIP: 0010:[<ffffffff81252660>]  [<ffffffff81252660>] acpi_ns=
_walk_namespace+0x5f/0x173
[    4.288099] RSP: 0018:ffff8802158efd10  EFLAGS: 00010146
[    4.288467] RAX: 0000000000000000 RBX: 0000000000000007 RCX: 00000000000=
0001e
[    4.288929] RDX: 0000000000000000 RSI: 0000000000000282 RDI: 00000000000=
00282
[    4.289395] RBP: ffff8802158efd70 R08: ffffffff81246140 R09: 00000000000=
00001
[    4.289859] R10: 5f42535f158efd48 R11: 43534f5f158efc18 R12: ffff8802158=
9aeb0
[    4.291053] R13: 0000000000000001 R14: 0000000000000000 R15: ffff8802158=
9af00
[    4.291515] FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:=
0000000000000000
[    4.292063] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    4.292455] CR2: ffff880215820154 CR3: 000000000180c000 CR4: 00000000000=
407f0
[    4.292918] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    4.293379] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 00000000000=
00400
[    4.293841]  [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
[    4.294338]  [<ffffffff81032c4b>] kmemcheck_show+0x8b/0xa0
[    4.294790]  [<ffffffff81033067>] kmemcheck_fault+0x77/0xd0
[    4.295246]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[    4.295702]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    4.296135]  [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
[    4.296649]  [<ffffffff812469e7>] acpi_ev_initialize_op_regions+0x7c/0x8d
[    4.297169]  [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
[    4.297664]  [<ffffffff818b894b>] acpi_init+0x113/0x28f
[    4.298101]  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
[    4.298569]  [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
[    4.299016]  [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
[    4.299490]  [<ffffffffffffffff>] 0xffffffffffffffff
[    4.419616] ACPI: SSDT 00000000df0ee018 0083B (v01  PmRef  Cpu0Cst 00003=
001 INTL 20051117)
[    4.471545] ACPI: Dynamic OEM Table Load:
[    4.471996] ACPI: SSDT           (null) 0083B (v01  PmRef  Cpu0Cst 00003=
001 INTL 20051117)
[    4.564560] ACPI: SSDT 00000000df0efa98 00303 (v01  PmRef    ApIst 00003=
000 INTL 20051117)
[    4.625902] ACPI: Dynamic OEM Table Load:
[    4.626353] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003=
000 INTL 20051117)
[    4.666028] ACPI: SSDT 00000000df0f0c18 00119 (v01  PmRef    ApCst 00003=
000 INTL 20051117)
[    4.713480] ACPI: Dynamic OEM Table Load:
[    4.713931] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003=
000 INTL 20051117)
[    5.195975] ACPI: Interpreter enabled
[    5.196260] ACPI: (supports S0 S5)
[    5.200093] ACPI: Using IOAPIC for interrupt routing
[    6.970951] ACPI: Power Resource [FN00] (off)
[    6.988908] ACPI: Power Resource [FN01] (off)
[    7.006666] ACPI: Power Resource [FN02] (off)
[    7.024684] ACPI: Power Resource [FN03] (off)
[    7.042732] ACPI: Power Resource [FN04] (off)
[    7.090558] ACPI: EC: GPE =3D 0x18, I/O: command/status =3D 0x66, data =
=3D 0x62
[    7.134460] ACPI: No dock devices found.
[    7.134768] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    7.236526] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    7.399198] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    7.399689] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    7.400173] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x00=
0bffff]
[    7.400826] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x00=
0d3fff]
[    7.401381] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x00=
0d7fff]
[    7.401937] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x00=
0dbfff]
[    7.402493] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x00=
0dffff]
[    7.403048] pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x00=
0e3fff]
[    7.403605] pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x00=
0e7fff]
[    7.404234] pci_root PNP0A08:00: host bridge window [mem 0xe0000000-0xfe=
afffff]
[    7.410416] PCI host bridge to bus 0000:00
[    7.410771] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    7.411230] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    7.411694] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    7.412191] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3ff=
f]
[    7.412687] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7ff=
f]
[    7.413183] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbff=
f]
[    7.413679] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dfff=
f]
[    7.414176] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3ff=
f]
[    7.414674] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7ff=
f]
[    7.415170] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfeaffff=
f]
[    7.451273] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    7.452496] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    7.455921] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    7.459601] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    7.463064] pci 0000:00:1c.4: PCI bridge to [bus 05-05]
[    7.465764] pci 0000:00:1c.6: PCI bridge to [bus 06-07] (subtractive dec=
ode)
[    7.471953] pci 0000:06:00.0: PCI bridge to [bus 07-07] (subtractive dec=
ode)
[    7.476591] pci 0000:00:1c.7: PCI bridge to [bus 08-08]
[    7.654057]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    7.669920]  pci0000:00: ACPI _OSC request failed (AE_ERROR), returned c=
ontrol mask: 0x1d
[    7.670465] ACPI _OSC control for PCIe not granted, disabling ASPM
[    8.837184] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    8.848819] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 1=
5)
[    8.860916] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 10 11 12 14 1=
5)
[    8.872498] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 1=
5)
[    8.884109] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    8.895677] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15=
) *0, disabled.
[    8.907502] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *10 11 12 14 1=
5)
[    8.919330] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 10 11 12 14 1=
5)
[    8.936487] vgaarb: device added: PCI:0000:01:00.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    8.937562] vgaarb: loaded
[    8.937820] vgaarb: bridge control possible 0000:01:00.0
[    8.957146] usbcore: registered new interface driver usbfs
[    8.962594] usbcore: registered new interface driver hub
[    8.965188] usbcore: registered new device driver usb
[    8.980446] PCI: Using ACPI for IRQ routing
[    9.018843] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    9.019919] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    9.024161] Switching to clocksource hpet
[    9.377382] pnp: PnP ACPI init
[    9.378424] ACPI: bus type pnp registered
[    9.483925] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    9.543302] system 00:05: [io  0x0680-0x069f] has been reserved
[    9.543851] system 00:05: [io  0x0200-0x020f] has been reserved
[    9.544378] system 00:05: [io  0xffff] has been reserved
[    9.544884] system 00:05: [io  0xffff] has been reserved
[    9.545357] system 00:05: [io  0x0400-0x0453] has been reserved
[    9.545870] system 00:05: [io  0x0458-0x047f] has been reserved
[    9.546385] system 00:05: [io  0x0500-0x057f] has been reserved
[    9.546897] system 00:05: [io  0x164e-0x164f] has been reserved
[    9.565771] system 00:07: [io  0x0454-0x0457] has been reserved
[    9.597416] system 00:08: [io  0x0290-0x029f] has been reserved
[    9.617687] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    9.767047] system 00:0c: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    9.767614] system 00:0c: [mem 0xfed10000-0xfed17fff] has been reserved
[    9.768138] system 00:0c: [mem 0xfed18000-0xfed18fff] has been reserved
[    9.768669] system 00:0c: [mem 0xfed19000-0xfed19fff] has been reserved
[    9.769238] system 00:0c: [mem 0xf8000000-0xfbffffff] has been reserved
[    9.769775] system 00:0c: [mem 0xfed20000-0xfed3ffff] has been reserved
[    9.770317] system 00:0c: [mem 0xfed90000-0xfed93fff] has been reserved
[    9.770863] system 00:0c: [mem 0xfed45000-0xfed8ffff] has been reserved
[    9.771416] system 00:0c: [mem 0xff000000-0xffffffff] has been reserved
[    9.771984] system 00:0c: [mem 0xfee00000-0xfeefffff] could not be reser=
ved
[    9.772547] system 00:0c: [mem 0xf0000000-0xf0000fff] has been reserved
[    9.807359] pnp: PnP ACPI: found 13 devices
[    9.807675] ACPI: ACPI bus type pnp unregistered
[   10.116165] pci 0000:00:1c.0: BAR 14: assigned [mem 0xf0100000-0xf02ffff=
f]
[   10.116974] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf0300000-0xf04ffff=
f 64bit pref]
[   10.117876] pci 0000:00:1c.3: BAR 15: assigned [mem 0xf0500000-0xf05ffff=
f pref]
[   10.118609] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[   10.119233] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[   10.119661] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[   10.120178] pci 0000:00:01.0:   bridge window [mem 0xf7e00000-0xf7efffff]
[   10.120729] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xefffffff=
 64bit pref]
[   10.121324] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[   10.121748] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[   10.122268] pci 0000:00:1c.0:   bridge window [mem 0xf0100000-0xf02fffff]
[   10.122818] pci 0000:00:1c.0:   bridge window [mem 0xf0300000-0xf04fffff=
 64bit pref]
[   10.123435] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[   10.123946] pci 0000:00:1c.1:   bridge window [mem 0xf7d00000-0xf7dfffff]
[   10.124598] pci 0000:04:00.0: BAR 6: assigned [mem 0xf0500000-0xf050ffff=
 pref]
[   10.125205] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[   10.125628] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[   10.126148] pci 0000:00:1c.3:   bridge window [mem 0xf7c00000-0xf7cfffff]
[   10.126697] pci 0000:00:1c.3:   bridge window [mem 0xf0500000-0xf05fffff=
 pref]
[   10.127281] pci 0000:00:1c.4: PCI bridge to [bus 05-05]
[   10.127798] pci 0000:00:1c.4:   bridge window [mem 0xf7b00000-0xf7bfffff]
[   10.128419] pci 0000:06:00.0: PCI bridge to [bus 07-07]
[   10.128845] pci 0000:06:00.0:   bridge window [io  0xc000-0xcfff]
[   10.129368] pci 0000:06:00.0:   bridge window [mem 0xf7a00000-0xf7afffff]
[   10.129930] pci 0000:00:1c.6: PCI bridge to [bus 06-07]
[   10.130353] pci 0000:00:1c.6:   bridge window [io  0xc000-0xcfff]
[   10.130873] pci 0000:00:1c.6:   bridge window [mem 0xf7a00000-0xf7afffff]
[   10.131461] pci 0000:00:1c.7: PCI bridge to [bus 08-08]
[   10.131887] pci 0000:00:1c.7:   bridge window [io  0xb000-0xbfff]
[   10.132409] pci 0000:00:1c.7:   bridge window [mem 0xf7900000-0xf79fffff]
[   10.144803] NET: Registered protocol family 2
[   10.149710] IP route cache hash table entries: 262144 (order: 9, 2097152=
 bytes)
[   10.169444] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[   10.171317] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   10.171865] TCP: Hash tables configured (established 262144 bind 65536)
[   10.172304] TCP: reno registered
[   10.173312] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[   10.173739] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[   10.183757] NET: Registered protocol family 1
[   10.186604] pci 0000:00:1a.0: broken D3 during system sleep on ASUS
[   10.318489] pci 0000:00:1d.0: broken D3 during system sleep on ASUS
[   10.456549] Trying to unpack rootfs image as initramfs...
[   12.470772] Freeing initrd memory: 13916k freed
[   12.473272] DMAR: No ATSR found
[   12.478407] IOMMU 0 0xfed90000: using Queued invalidation
[   12.479096] IOMMU: Setting RMRR:
[   12.481201] IOMMU: Setting identity map for device 0000:00:1d.0 [0xdf0d6=
000 - 0xdf0e4fff]
[   12.483794] IOMMU: Setting identity map for device 0000:00:1a.0 [0xdf0d6=
000 - 0xdf0e4fff]
[   12.484759] IOMMU: Prepare 0-16MiB unity mapping for LPC
[   12.486977] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0=
xffffff]
[   12.487858] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[   12.491090] ------------[ cut here ]------------
[   12.491426] WARNING: at drivers/pci/search.c:44 pci_find_upstream_pcie_b=
ridge+0x50/0x70()
[   12.491979] Hardware name: System Product Name
[   12.492304] Modules linked in: <omitted>
[   12.492670] Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsde=
bug3+kmc+ #6
[   12.493201] Call Trace:
[   12.493427]  [<ffffffff8103a7fa>] warn_slowpath_common+0x7a/0xb0
[   12.493836]  [<ffffffff8103a845>] warn_slowpath_null+0x15/0x20
[   12.494232]  [<ffffffff81208770>] pci_find_upstream_pcie_bridge+0x50/0x70
[   12.494678]  [<ffffffff8135754d>] intel_iommu_device_group+0x7d/0x100
[   12.495106]  [<ffffffff8134da70>] ? bus_set_iommu+0x50/0x50
[   12.495490]  [<ffffffff8134da9b>] add_iommu_group+0x2b/0x60
[   12.495874]  [<ffffffff8129f17d>] bus_for_each_dev+0x4d/0x90
[   12.496260]  [<ffffffff8134da5b>] bus_set_iommu+0x3b/0x50
[   12.496635]  [<ffffffff818c34b4>] intel_iommu_init+0xae9/0xc1a
[   12.497035]  [<ffffffff818939ee>] ? clean_rootfs+0x1c1/0x1c1
[   12.497422]  [<ffffffff81896aa3>] ? memblock_find_dma_reserve+0x13d/0x13d
[   12.497873]  [<ffffffff81896ab6>] pci_iommu_init+0x13/0x3e
[   12.498251]  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
[   12.498643]  [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
[   12.499016]  [<ffffffff81891582>] ? do_early_param+0x8c/0x8c
[   12.499407]  [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
[   12.499807]  [<ffffffff81891b22>] ? start_kernel+0x341/0x341
[   12.500195]  [<ffffffff814389a0>] ? gs_change+0x13/0x13
[   12.500558] ---[ end trace 4eaa2a86a8e2da25 ]---
[   12.544164] audit: initializing netlink socket (disabled)
[   12.545138] type=3D2000 audit(1342119368.980:1): initialized
[   12.577891] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   12.989892] VFS: Disk quotas dquot_6.5.2
[   12.998431] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   13.016090] msgmni has been set to 15983
[   13.047003] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[   13.048052] io scheduler noop registered
[   13.060631] io scheduler cfq registered (default)
[   13.126095] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   13.153637] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   13.201812] 00:0b: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   13.244113] Linux agpgart interface v0.103
[   13.487828] brd: module loaded
[   13.491038] e1000e: Intel(R) PRO/1000 Network Driver - 1.9.5-k
[   13.491431] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[   13.497264] e1000e 0000:00:19.0: (unregistered net_device): Interrupt Th=
rottling Rate (ints/sec) set to dynamic conservative mode
[   13.513189] Refined TSC clocksource calibration: 3411.127 MHz.
[   13.513582] Switching to clocksource tsc
[   13.830372] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) f4=
:6d:04:b0:8f:c5
[   13.830938] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connect=
ion
[   13.831443] e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-=
0FF
[   13.842285] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   13.844273] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[   13.850971] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 1
[   13.855511] ehci_hcd 0000:00:1a.0: debug port 2
[   13.859767] ehci_hcd 0000:00:1a.0: Enabling legacy PCI PM
[   13.861451] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf7f28000
[   13.872997] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[   13.875447] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   13.875904] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   13.876451] usb usb1: Product: EHCI Host Controller
[   13.876870] usb usb1: Manufacturer: Linux 3.4.4+btrfsdebug3+kmc+ ehci_hcd
[   13.877361] usb usb1: SerialNumber: 0000:00:1a.0
[   13.889082] hub 1-0:1.0: USB hub found
[   13.889666] hub 1-0:1.0: 2 ports detected
[   13.900114] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[   13.905374] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 2
[   13.909805] ehci_hcd 0000:00:1d.0: debug port 2
[   13.914056] ehci_hcd 0000:00:1d.0: Enabling legacy PCI PM
[   13.915727] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf7f27000
[   13.924952] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   13.927408] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   13.927862] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   13.928408] usb usb2: Product: EHCI Host Controller
[   13.928828] usb usb2: Manufacturer: Linux 3.4.4+btrfsdebug3+kmc+ ehci_hcd
[   13.929305] usb usb2: SerialNumber: 0000:00:1d.0
[   13.941170] hub 2-0:1.0: USB hub found
[   13.941753] hub 2-0:1.0: 2 ports detected
[   13.953681] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   13.956684] uhci_hcd: USB Universal Host Controller Interface driver
[   13.962471] xhci_hcd 0000:03:00.0: xHCI Host Controller
[   13.967602] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus =
number 3
[   13.974654] xhci_hcd 0000:03:00.0: irq 17, io mem 0xf7d00000
[   13.983379] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   13.983834] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   13.984380] usb usb3: Product: xHCI Host Controller
[   13.984800] usb usb3: Manufacturer: Linux 3.4.4+btrfsdebug3+kmc+ xhci_hcd
[   13.985278] usb usb3: SerialNumber: 0000:03:00.0
[   13.998361] hub 3-0:1.0: USB hub found
[   13.998958] hub 3-0:1.0: 2 ports detected
[   14.008405] xhci_hcd 0000:03:00.0: xHCI Host Controller
[   14.013693] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus =
number 4
[   14.016460] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003
[   14.016963] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   14.017509] usb usb4: Product: xHCI Host Controller
[   14.017927] usb usb4: Manufacturer: Linux 3.4.4+btrfsdebug3+kmc+ xhci_hcd
[   14.018403] usb usb4: SerialNumber: 0000:03:00.0
[   14.030619] hub 4-0:1.0: USB hub found
[   14.031213] hub 4-0:1.0: 2 ports detected
[   14.042183] xhci_hcd 0000:05:00.0: xHCI Host Controller
[   14.051181] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus =
number 5
[   14.056718] xhci_hcd 0000:05:00.0: irq 16, io mem 0xf7b00000
[   14.064348] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   14.064805] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   14.065350] usb usb5: Product: xHCI Host Controller
[   14.065772] usb usb5: Manufacturer: Linux 3.4.4+btrfsdebug3+kmc+ xhci_hcd
[   14.066248] usb usb5: SerialNumber: 0000:05:00.0
[   14.078683] hub 5-0:1.0: USB hub found
[   14.079278] hub 5-0:1.0: 2 ports detected
[   14.088974] xhci_hcd 0000:05:00.0: xHCI Host Controller
[   14.095040] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus =
number 6
[   14.098008] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003
[   14.098465] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   14.099012] usb usb6: Product: xHCI Host Controller
[   14.099435] usb usb6: Manufacturer: Linux 3.4.4+btrfsdebug3+kmc+ xhci_hcd
[   14.099911] usb usb6: SerialNumber: 0000:05:00.0
[   14.113678] hub 6-0:1.0: USB hub found
[   14.114270] hub 6-0:1.0: 2 ports detected
[   14.136950] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   14.144926] serio: i8042 KBD port at 0x60,0x64 irq 1
[   14.145394] serio: i8042 AUX port at 0x60,0x64 irq 12
[   14.162680] mousedev: PS/2 mouse device common for all mice
[   14.166232] rtc_cmos 00:06: RTC can wake from S4
[   14.173681] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[   14.174506] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[   14.183364] cpuidle: using governor ladder
[   14.188367] cpuidle: using governor menu
[   14.205115] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[   14.273410] usbcore: registered new interface driver usbhid
[   14.273788] usbhid: USB HID core driver
[   14.293625] TCP: cubic registered
[   14.293889] NET: Registered protocol family 17
[   14.294432] Registering the dns_resolver key type
[   14.307274] registered taskstats version 1
[   14.332240] netpoll: netconsole: local port 4444
[   14.332719] netpoll: netconsole: local IP 192.168.1.2
[   14.333079] netpoll: netconsole: interface 'eth0'
[   14.333414] netpoll: netconsole: remote port 1194
[   14.333750] netpoll: netconsole: remote IP 192.168.1.12
[   14.334117] netpoll: netconsole: remote ethernet address 00:1c:10:44:47:=
2c
[   14.334581] netpoll: netconsole: device eth0 not up yet, forcing it
[   14.359375] usb 1-1: New USB device found, idVendor=3D8087, idProduct=3D=
0024
[   14.359832] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[   14.372758] hub 1-1:1.0: USB hub found
[   14.373875] hub 1-1:1.0: 6 ports detected
[   14.546021] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[   14.679411] usb 2-1: New USB device found, idVendor=3D8087, idProduct=3D=
0024
[   14.679866] usb 2-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[   14.692794] hub 2-1:1.0: USB hub found
[   14.694672] hub 2-1:1.0: 8 ports detected
[   14.981746] usb 2-1.1: new low-speed USB device number 3 using ehci_hcd
[   15.089584] usb 2-1.1: New USB device found, idVendor=3D0518, idProduct=
=3D0001
[   15.090052] usb 2-1.1: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[   15.090616] usb 2-1.1: Product: USB-compliant keyboard
[   15.091035] usb 2-1.1: Manufacturer: Plus More Enterprise LTD.
[   15.135165] input: Plus More Enterprise LTD. USB-compliant keyboard as /=
devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.0/input/input0
[   15.144369] generic-usb 0003:0518:0001.0001: input,hidraw0: USB HID v1.1=
0 Keyboard [Plus More Enterprise LTD. USB-compliant keyboard] on usb-0000:0=
0:1d.0-1.1/input0
[   15.178975] input: Plus More Enterprise LTD. USB-compliant keyboard as /=
devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.1/input/input1
[   15.191576] generic-usb 0003:0518:0001.0002: input,hidraw1: USB HID v1.1=
0 Mouse [Plus More Enterprise LTD. USB-compliant keyboard] on usb-0000:00:1=
d.0-1.1/input1
[   15.274367] usb 2-1.2: new full-speed USB device number 4 using ehci_hcd
[   15.377106] usb 2-1.2: New USB device found, idVendor=3D0d8c, idProduct=
=3D0005
[   15.377573] usb 2-1.2: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[   15.378121] usb 2-1.2: Product: Blue Snowball
[   15.378483] usb 2-1.2: Manufacturer: BLUE MICROPHONE
[   15.378862] usb 2-1.2: SerialNumber: 201111
[   15.425337] input: BLUE MICROPHONE Blue Snowball as /devices/pci0000:00/=
0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.2/input/input2
[   15.431302] generic-usb 0003:0D8C:0005.0003: input,hidraw2: USB HID v1.0=
0 Device [BLUE MICROPHONE Blue Snowball] on usb-0000:00:1d.0-1.2/input2
[   15.514189] usb 2-1.3: new low-speed USB device number 5 using ehci_hcd
[   15.620443] usb 2-1.3: New USB device found, idVendor=3D046d, idProduct=
=3Dc501
[   15.620911] usb 2-1.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[   15.621458] usb 2-1.3: Product: USB Receiver
[   15.621804] usb 2-1.3: Manufacturer: Logitech
[   15.658106] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:=
1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input3
[   15.667508] generic-usb 0003:046D:C501.0004: input,hidraw3: USB HID v1.1=
0 Mouse [Logitech USB Receiver] on usb-0000:00:1d.0-1.3/input0
[   15.749917] usb 2-1.7: new full-speed USB device number 6 using ehci_hcd
[   15.847446] usb 2-1.7: New USB device found, idVendor=3D0cf3, idProduct=
=3D3000
[   15.847921] usb 2-1.7: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[   16.126315] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Contr=
ol: Rx/Tx
[   16.126858] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   16.416278] console [netcon0] enabled
[   16.416804] netconsole: network logging started
[   16.419105] rtc_cmos 00:06: setting system clock to 2012-07-12 18:56:14 =
UTC (1342119374)
[   16.434310] Freeing unused kernel memory: 512k freed
[   16.434956] Write protecting the kernel read-only data: 8192k
[   16.440574] Freeing unused kernel memory: 1792k freed
[   16.441649] Freeing unused kernel memory: 52k freed
[   16.447768] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000005
[   16.447768]=20
[   16.450624] Pid: 1, comm: init Tainted: G        W    3.4.4+btrfsdebug3+=
kmc+ #6
[   16.451437] Call Trace:
[   16.452116]  [<ffffffff81427927>] panic+0xb5/0x1c1
[   16.452730]  [<ffffffff8103ec6c>] do_exit+0x7bc/0x8a0
[   16.453563]  [<ffffffff8103efea>] do_group_exit+0x3a/0xa0
[   16.454212]  [<ffffffff8104d655>] get_signal_to_deliver+0x1a5/0x5c0
[   16.455132]  [<ffffffff8104c0b0>] ? send_signal+0x40/0x80
[   16.455787]  [<ffffffff81002260>] do_signal+0x60/0x950
[   16.456637]  [<ffffffff8104c88c>] ? force_sig_info+0xdc/0x100
[   16.457310]  [<ffffffff81002bd5>] do_notify_resume+0x65/0x80
[   16.458200]  [<ffffffff814377fa>] int_signal+0x12/0x17
[   16.458840]  [<ffffffff81426069>] ? run_init_process+0x1e/0x20
[   16.460294]  [<ffffffff814260ad>] ? init_post+0x42/0xbb
[   16.460910]  [<ffffffff81891ce0>] ? kernel_init+0x1be/0x1be
[   16.463216]  [<ffffffff81891582>] ? do_early_param+0x8c/0x8c
[   16.463873]  [<ffffffff814389a4>] ? kernel_thread_helper+0x4/0x10
[   16.464758]  [<ffffffff81891b22>] ? start_kernel+0x341/0x341
[   16.465417]  [<ffffffff814389a0>] ? gs_change+0x13/0x13

--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="nc.log.noacpi_pci_noacpi"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.4+btrfsdebug3+kmc+ (sliedes@lh) (gcc versi=
on 4.7.1 (Debian 4.7.1-4) ) #6 SMP Thu Jul 12 21:38:46 EEST 2012
[    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-3.4.4+btrfsdebug3+kmc+ r=
oot=3D/dev/mapper/rootvg-root_crypt ro netconsole=3D4444@192.168.1.2/eth0,1=
194@192.168.1.12/00:1c:10:44:47:2c noacpi pci=3Dnoacpi
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
[    0.000000]  BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000deb91000 (usable)
[    0.000000]  BIOS-e820: 00000000deb91000 - 00000000df141000 (reserved)
[    0.000000]  BIOS-e820: 00000000df141000 - 00000000df386000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df386000 - 00000000df394000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df394000 - 00000000df3c1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df3c1000 - 00000000df3c6000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df3c6000 - 00000000df409000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df409000 - 00000000df800000 (usable)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed04000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000021f000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x21f000 max_arch_pfn =3D 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] last_pfn =3D 0xdf800 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fce00] fce00
[    0.000000] init_memory_mapping: 0000000000000000-00000000df800000
[    0.000000] init_memory_mapping: 0000000100000000-000000021f000000
[    0.000000] RAMDISK: 364c2000 - 37259000
[    0.000000] ACPI: RSDP 00000000000f0450 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000df386070 00064 (v01 ALASKA    A M I 01072=
009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000df391cd8 000F4 (v04 ALASKA    A M I 01072=
009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000df386168 0BB6D (v02 ALASKA    A M I 00000=
015 INTL 20051117)
[    0.000000] ACPI: FACS 00000000df3bff80 00040
[    0.000000] ACPI: APIC 00000000df391dd0 00092 (v03 ALASKA    A M I 01072=
009 AMI  00010013)
[    0.000000] ACPI: MCFG 00000000df391e68 0003C (v01 ALASKA    A M I 01072=
009 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000df391ea8 00038 (v01 ALASKA    A M I 01072=
009 AMI. 00000005)
[    0.000000] ACPI: SSDT 00000000df391ee0 0036D (v01 SataRe SataTabl 00001=
000 INTL 20091112)
[    0.000000] ACPI: SSDT 00000000df392250 009AA (v01  PmRef  Cpu0Ist 00003=
000 INTL 20051117)
[    0.000000] ACPI: SSDT 00000000df392c00 00A92 (v01  PmRef    CpuPm 00003=
000 INTL 20051117)
[    0.000000] ACPI: DMAR 00000000df393698 00078 (v01 INTEL      SNB  00000=
001 INTL 00000001)
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0021f000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000deb91
[    0.000000]     0: 0x000df409 -> 0x000df800
[    0.000000]     0: 0x00100000 -> 0x0021f000
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000] MPTABLE: OEM ID: A M I
[    0.000000] MPTABLE: Product ID: ALASKA
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] Processors: 8
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at df800000 (gap: df800000=
:18800000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:8 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88021ec00000 s77184 r8192=
 d21120 u262144
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 2053971
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-3.4.4+btrfsdebug3=
+kmc+ root=3D/dev/mapper/rootvg-root_crypt ro netconsole=3D4444@192.168.1.2=
/eth0,1194@192.168.1.12/00:1c:10:44:47:2c noacpi pci=3Dnoacpi
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608=
 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 b=
ytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 8103784k/8896512k available (4332k kernel code, 5416=
12k absent, 251116k reserved, 4356k data, 512k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D8, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000002] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6821.77 BogoMIPS (lpj=3D13643544)
[    0.000815] pid_max: default: 32768 minimum: 301
[    0.004000] Detected 3410.886 MHz processor.
[    0.005768] Security Framework initialized
[    0.009611] Mount-cache hash table entries: 256
[    0.045697] Initializing cgroup subsys cpuacct
[    0.046031] Initializing cgroup subsys devices
[    0.046404] Initializing cgroup subsys freezer
[    0.046759] Initializing cgroup subsys net_cls
[    0.047112] Initializing cgroup subsys blkio
[    0.048336] Initializing cgroup subsys perf_event
[    0.050668] CPU: Physical Processor ID: 0
[    0.050976] CPU: Processor Core ID: 0
[    0.051269] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.051270] ENERGY_PERF_BIAS: View and update with x86_energy_perf_polic=
y(8)
[    0.052159] mce: CPU supports 9 MCE banks
[    0.052673] CPU0: Thermal monitoring enabled (TM1)
[    0.053029] using mwait in idle threads.
[    0.054001] ACPI: Core revision 20120320
[    2.061180] ACPI: setting ELCR to 0e28 (from 0c28)
[    2.168289] DMAR: Host address width 36
[    2.168583] DMAR: DRHD base: 0x000000fed90000 flags: 0x1
[    2.169244] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020660262 e=
cap f0105a
[    2.169771] DMAR: RMRR base: 0x000000df0d6000 end: 0x000000df0e4fff
[    2.170360] IOAPIC id 2 under DRHD base  0xfed90000 IOMMU 0
[    2.170743] HPET id 0 under DRHD base 0xfed90000
[    2.171266] Enabled IRQ remapping in x2apic mode
[    2.171600] Enabling x2apic
[    2.171841] Enabled x2apic
[    2.172110] WARNING: kmemcheck: Caught 32-bit read from uninitialized me=
mory (ffff880215822408)
[    2.172692] 00000000000000000c001000000000040000000002000000e10900000000=
0000
[    2.175554]  i i i i i i i i u u u u u u u u u u u u u u u u u u u u u u=
 u u
[    2.178381]                  ^
[    2.178636]=20
[    2.178807] Pid: 1, comm: swapper/0 Not tainted 3.4.4+btrfsdebug3+kmc+ #=
6 System manufacturer System Product Name/P8P67 EVO
[    2.179762] RIP: 0010:[<ffffffff81353001>]  [<ffffffff81353001>] qi_subm=
it_sync+0x2d1/0x3f0
[    2.180402] RSP: 0018:ffff8802158efcf0  EFLAGS: 00010002
[    2.180773] RAX: ffff880215822408 RBX: 0000000000000086 RCX: 00000002000=
00025
[    2.181239] RDX: ffff880215822400 RSI: ffffc9000000c000 RDI: ffff8802158=
fe050
[    2.181706] RBP: ffff8802158efd60 R08: ffffea000856c000 R09: 00000000001=
15c01
[    2.182170] R10: ffff8802158fe000 R11: ffff8802158fe010 R12: 00000000000=
00000
[    2.182635] R13: ffff88021581a7c0 R14: 0000000000000004 R15: ffff8802158=
ec180
[    2.183134] FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:=
0000000000000000
[    2.183683] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.184075] CR2: ffff88021581608c CR3: 000000000180c000 CR4: 00000000000=
406f0
[    2.184540] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    2.185005] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 00000000000=
00400
[    2.185470]  [<ffffffff81353144>] qi_global_iec+0x24/0x30
[    2.185918]  [<ffffffff81357d63>] iommu_set_intr_remapping+0xd3/0x170
[    2.186421]  [<ffffffff818c3bbd>] enable_intr_remapping+0x20d/0x269
[    2.186950]  [<ffffffff8189e85d>] enable_IR+0x5a/0x62
[    2.187382]  [<ffffffff8189eb4d>] enable_IR_x2apic+0x92/0x298
[    2.187851]  [<ffffffff818a0ab3>] default_setup_apic_routing+0x12/0x78
[    2.188360]  [<ffffffff8189c99c>] native_smp_prepare_cpus+0x2ba/0x2ee
[    2.188862]  [<ffffffff81891bab>] kernel_init+0x89/0x1be
[    2.346615] kmemcheck: Limiting number of CPUs to 1.
[    2.352329] NMI watchdog: enabled, takes one hw-pmu counter.
[    2.464192] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    2.981933] Hardware name: System Product Name
[    2.981952]  [<ffffffff812836c2>] ? vt_console_print+0xa2/0x3a0
[    2.981964]  [<ffffffff81427a6f>] printk+0x3c/0x3e
[    2.981974]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    2.981993]  [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
[    2.982002]  [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
[    2.982019] ---[ end trace 4eaa2a86a8e2da22 ]---
[    3.004692]  [<ffffffff810330a9>] kmemcheck_fault+0xb9/0xd0
[    3.007408]  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x1=
20
[    3.007860]  [<ffffffff8142ff90>] ? general_protection+0x30/0x30
[    3.008267]  [<ffffffff8142ff90>] ? general_protection+0x30/0x30
[    3.008675]  [<ffffffff8142ff90>] ? general_protection+0x30/0x30
[    3.009083]  <<EOE>>  [<ffffffff81252660>] ? acpi_ns_walk_namespace+0x5f=
/0x173
[    3.009666]  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x1=
20
[    3.010119]  [<ffffffff81246881>] acpi_ev_execute_reg_methods+0x3d/0x127
[    3.010563]  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x1=
20
[    3.011015]  [<ffffffff812469ac>] ? acpi_ev_initialize_op_regions+0x41/0=
x8d
[    3.011475]  [<ffffffff812469e7>] acpi_ev_initialize_op_regions+0x7c/0x8d
[    3.011924]  [<ffffffff818b8838>] ? acpi_sleep_init+0xee/0xee
[    3.012318]  [<ffffffff8125bfe8>] acpi_initialize_objects+0x1f/0x53
[    3.012741]  [<ffffffff818b894b>] acpi_init+0x113/0x28f
[    3.013108]  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
[    3.014672]  [<ffffffff81891b22>] ? start_kernel+0x341/0x341
[    4.279612] RSP: 0018:ffff8802158efbc8  EFLAGS: 00010286
[    4.284620]  [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
[    4.288823]  [<ffffffff81250341>] acpi_ns_init_one_device+0x81/0xab
[    4.290314]  [<ffffffff8125c013>] acpi_initialize_objects+0x4a/0x53
[    4.418185] ACPI: SSDT 00000000df0ee018 0083B (v01  PmRef  Cpu0Cst 00003=
001 INTL 20051117)
[    4.713306] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003=
000 INTL 20051117)
[    5.536500] R10: 5f315353158ef888 R11: 5f315353158ef888 R12: 00000000000=
00000
[    5.540224]  [<ffffffff81032c4b>] kmemcheck_show+0x8b/0xa0
[    5.544714]  [<ffffffff81254df2>] acpi_ps_parse_aml+0x91/0x273
[    5.551875]  [<ffffffffffffffff>] 0xffffffffffffffff
[    6.167104] RDX: 0000000000000000 RSI: 0000000000000003 RDI: 00000000000=
00246
[    6.168943] FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:=
0000000000000000
[    7.006890] ACPI: Power Resource [FN00] (off)
[    7.208859] usbcore: registered new device driver usb
[    7.267259] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    7.289582] pci 0000:00:1c.7: PCI bridge to [bus 08-08]
[    8.009865] system 00:05: [io  0x0200-0x020f] has been reserved
[    8.011059] system 00:05: [io  0xffff] has been reserved
[    8.050522] ERROR: kmemcheck: Fatal error
[    8.054315] R10: 0000000000000000 R11: 42334f49158efa48 R12: 00000000000=
00000
[    8.056616] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    8.060684]  [<ffffffff810324d9>] kmemcheck_read_strict+0x29/0xa0
[    8.063900]  [<ffffffff8124f8cf>] acpi_ns_lookup+0x203/0x339
[    8.067716]  [<ffffffff81256d16>] acpi_walk_resources+0x62/0xce
[    8.069217]  [<ffffffff81252aa4>] acpi_ns_get_device_callback+0x144/0x15e
[    8.072947] Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsde=
bug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
[    8.075831] RBP: ffff88021ec07d68 R08: 0000000000000000 R09: ffff8800000=
00000
[    8.076288] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00001
[    8.076744] R13: ffff88021ec07dc0 R14: ffff880215822800 R15: 00000000000=
00021
[    8.077202] FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:=
0000000000000000
[    8.077740] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    8.078126] CR2: ffff880215820154 CR3: 000000000180c000 CR4: 00000000000=
407f0
[    8.078587] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    8.079045] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 00000000000=
00400
[    8.079501]  [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
[    8.079990]  [<ffffffff81032850>] kmemcheck_access+0x1d0/0x440
[    8.080453]  [<ffffffff8103308d>] kmemcheck_fault+0x9d/0xd0
[    8.080904]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[    8.081352]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    8.081780]  [<ffffffff810179f1>] intel_pmu_save_and_restart+0x11/0x20
[    8.082280]  [<ffffffff81017b5d>] intel_pmu_handle_irq+0x15d/0x320
[    8.082767]  [<ffffffff814313ed>] perf_event_nmi_handler+0x1d/0x20
[    8.083250]  [<ffffffff81430c49>] nmi_handle.isra.0+0x49/0x80
[    8.083708]  [<ffffffff81430d60>] do_nmi+0xe0/0x310
[    8.084125]  [<ffffffff814302dc>] end_repeat_nmi+0x1a/0x1e
[    8.084569]  [<ffffffff810324d9>] kmemcheck_read_strict+0x29/0xa0
[    8.085045]  [<ffffffff81032592>] kmemcheck_read+0x42/0x70
[    8.086219]  [<ffffffff81032704>] kmemcheck_access+0x84/0x440
[    8.086683]  [<ffffffff8103308d>] kmemcheck_fault+0x9d/0xd0
[    8.087136]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[    8.087585]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    8.088014]  [<ffffffff81251f9a>] acpi_ns_search_and_enter+0x122/0x174
[    8.088512]  [<ffffffff8124f8cf>] acpi_ns_lookup+0x203/0x339
[    8.088966]  [<ffffffff81253870>] acpi_ps_get_next_namepath+0x74/0x1cf
[    8.089464]  [<ffffffff81254570>] acpi_ps_parse_loop+0x4b6/0x96e
[    8.089937]  [<ffffffff81254df2>] acpi_ps_parse_aml+0x91/0x273
[    8.090399]  [<ffffffff8125560c>] acpi_ps_execute_method+0x1c6/0x276
[    8.090895]  [<ffffffff81250042>] acpi_ns_evaluate+0xbe/0x1a8
[    8.091353]  [<ffffffff81259cfa>] acpi_ut_evaluate_object+0x7e/0x1a7
[    8.091842]  [<ffffffff81256a74>] acpi_rs_get_method_data+0x1a/0x40
[    8.092329]  [<ffffffff81256d16>] acpi_walk_resources+0x62/0xce
[    8.092798]  [<ffffffff81264e2f>] pnpacpi_parse_allocated_resource+0x3f/=
0x70
[    8.093323]  [<ffffffff818ba200>] pnpacpi_add_device_handler+0x193/0x211
[    8.093832]  [<ffffffff81252aa4>] acpi_ns_get_device_callback+0x144/0x15e
[    8.094343]  [<ffffffff812526ba>] acpi_ns_walk_namespace+0xb9/0x173
[    8.094834]  [<ffffffff81252949>] acpi_get_devices+0x61/0x78
[    8.280117] system 00:0c: [mem 0xfed90000-0xfed93fff] has been reserved
[    8.625695] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf0300000-0xf04ffff=
f 64bit pref]
[    8.630077] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    8.636711] pci 0000:06:00.0:   bridge window [io  0xc000-0xcfff]
[    8.640705] pci 0000:00:01.0: PCI->APIC IRQ transform: INT A -> IRQ 16
[    8.652041] NET: Registered protocol family 2
[    8.690207] pci 0000:00:1a.0: broken D3 during system sleep on ASUS
[   10.987259] IOMMU: Setting identity map for device 0000:00:1a.0 [0xdf0d6=
000 - 0xdf0e4fff]
[   10.995799] Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsde=
bug3+kmc+ #6
[   10.999391]  [<ffffffff8134da5b>] bus_set_iommu+0x3b/0x50
[   11.045883] audit: initializing netlink socket (disabled)
[   11.621110] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   11.859679] RAX: 0000000000000124 RBX: 0000000000000009 RCX: 00000000000=
00124
[   11.862952] CR2: ffff880215820154 CR3: 000000000180c000 CR4: 00000000000=
407f0
[   11.869019]  [<ffffffff811c8aa0>] add_disk+0x190/0x460
[   12.004263] e1000e 0000:00:19.0: PCI->APIC IRQ transform: INT A -> IRQ 20
[   12.353504] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   12.386346] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   12.435817] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   12.468188] uhci_hcd: USB Universal Host Controller Interface driver
[   12.494502] usb usb3: Manufacturer: Linux 3.4.4+btrfsdebug3+kmc+ xhci_hcd
[   12.507594] hub 3-0:1.0: USB hub found
[   12.508299] hub 3-0:1.0: 2 ports detected
[   12.517940] xhci_hcd 0000:03:00.0: xHCI Host Controller
[   12.522774] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus =
number 4
[   12.525681] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003
[   12.526138] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   12.526685] usb usb4: Product: xHCI Host Controller
[   12.527106] usb usb4: Manufacturer: Linux 3.4.4+btrfsdebug3+kmc+ xhci_hcd
[   12.527581] usb usb4: SerialNumber: 0000:03:00.0
[   12.540361] hub 4-0:1.0: USB hub found
[   12.540954] hub 4-0:1.0: 2 ports detected
[   12.550795] xhci_hcd 0000:05:00.0: PCI->APIC IRQ transform: INT A -> IRQ=
 16
[   12.552193] xhci_hcd 0000:05:00.0: xHCI Host Controller
[   12.561311] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus =
number 5
[   12.566900] xhci_hcd 0000:05:00.0: irq 16, io mem 0xf7b00000
[   12.574500] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   12.574956] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   12.575502] usb usb5: Product: xHCI Host Controller
[   12.575927] usb usb5: Manufacturer: Linux 3.4.4+btrfsdebug3+kmc+ xhci_hcd
[   12.576403] usb usb5: SerialNumber: 0000:05:00.0
[   12.588948] hub 5-0:1.0: USB hub found
[   12.589542] hub 5-0:1.0: 2 ports detected
[   12.599161] xhci_hcd 0000:05:00.0: xHCI Host Controller
[   12.605185] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus =
number 6
[   12.608015] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003
[   12.608470] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   12.609017] usb usb6: Product: xHCI Host Controller
[   12.609438] usb usb6: Manufacturer: Linux 3.4.4+btrfsdebug3+kmc+ xhci_hcd
[   12.609914] usb usb6: SerialNumber: 0000:05:00.0
[   12.623000] hub 6-0:1.0: USB hub found
[   12.623703] hub 6-0:1.0: 2 ports detected
[   12.648792] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   12.839296] netpoll: netconsole: local IP 192.168.1.2
[   12.880293] hub 1-1:1.0: 6 ports detected
[   13.593058] usb 2-1.1: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[   13.693813] generic-usb 0003:0518:0001.0002: input,hidraw1: USB HID v1.1=
0 Mouse [Plus More Enterprise LTD. USB-compliant keyboard] on usb-0000:00:1=
d.0-1.1/input1
[   14.126819] ERROR: kmemcheck: Fatal error
[   14.130183] RBP: ffff88021ec03dd8 R08: ffff88021ec12140 R09: 00000000000=
00000
[   14.142345]  [<ffffffff81891b15>] start_kernel+0x334/0x341
[   14.192174] generic-usb 0003:046D:C501.0004: input,hidraw3: USB HID v1.1=
0 Mouse [Logitech USB Receiver] on usb-0000:00:1d.0-1.3/input0
[   14.984018] console [netcon0] enabled
[   14.984543] netconsole: network logging started
[   14.985399] rtc_cmos 00:06: setting system clock to 2012-07-12 19:00:02 =
UTC (1342119602)
[   15.005503] Freeing unused kernel memory: 512k freed
[   15.006386] Write protecting the kernel read-only data: 8192k
[   15.011879] Freeing unused kernel memory: 1792k freed
[   15.012953] Freeing unused kernel memory: 52k freed
[   15.019056] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000005
[   15.019057]=20
[   15.021913] Pid: 1, comm: init Tainted: G        W    3.4.4+btrfsdebug3+=
kmc+ #6
[   15.022752] Call Trace:
[   15.023430]  [<ffffffff81427927>] panic+0xb5/0x1c1
[   15.024041]  [<ffffffff8103ec6c>] do_exit+0x7bc/0x8a0
[   15.024875]  [<ffffffff8103efea>] do_group_exit+0x3a/0xa0
[   15.025525]  [<ffffffff8104d655>] get_signal_to_deliver+0x1a5/0x5c0
[   15.026445]  [<ffffffff8104c0b0>] ? send_signal+0x40/0x80
[   15.027095]  [<ffffffff81002260>] do_signal+0x60/0x950
[   15.027948]  [<ffffffff8104c88c>] ? force_sig_info+0xdc/0x100
[   15.028620]  [<ffffffff81002bd5>] do_notify_resume+0x65/0x80
[   15.029510]  [<ffffffff814377fa>] int_signal+0x12/0x17
[   15.030819]  [<ffffffff81426069>] ? run_init_process+0x1e/0x20
[   15.031465]  [<ffffffff814260ad>] ? init_post+0x42/0xbb
[   15.033774]  [<ffffffff81891ce0>] ? kernel_init+0x1be/0x1be
[   15.034415]  [<ffffffff81891582>] ? do_early_param+0x8c/0x8c
[   15.035283]  [<ffffffff814389a4>] ? kernel_thread_helper+0x4/0x10
[   15.035957]  [<ffffffff81891b22>] ? start_kernel+0x341/0x341
[   15.036829]  [<ffffffff814389a0>] ? gs_change+0x13/0x13

--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="nc.log.noapic_pci_noacpi_noacpi"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.4+btrfsdebug3+kmc+ (sliedes@lh) (gcc versi=
on 4.7.1 (Debian 4.7.1-4) ) #6 SMP Thu Jul 12 21:38:46 EEST 2012
[    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-3.4.4+btrfsdebug3+kmc+ r=
oot=3D/dev/mapper/rootvg-root_crypt ro netconsole=3D4444@192.168.1.2/eth0,1=
194@192.168.1.12/00:1c:10:44:47:2c noapic pci=3Dnoacpi noacpi
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
[    0.000000]  BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000deb91000 (usable)
[    0.000000]  BIOS-e820: 00000000deb91000 - 00000000df141000 (reserved)
[    0.000000]  BIOS-e820: 00000000df141000 - 00000000df386000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df386000 - 00000000df394000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df394000 - 00000000df3c1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df3c1000 - 00000000df3c6000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df3c6000 - 00000000df409000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df409000 - 00000000df800000 (usable)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed04000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000021f000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x21f000 max_arch_pfn =3D 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] last_pfn =3D 0xdf800 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fce00] fce00
[    0.000000] init_memory_mapping: 0000000000000000-00000000df800000
[    0.000000] init_memory_mapping: 0000000100000000-000000021f000000
[    0.000000] RAMDISK: 364c2000 - 37259000
[    0.000000] ACPI: RSDP 00000000000f0450 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000df386070 00064 (v01 ALASKA    A M I 01072=
009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000df391cd8 000F4 (v04 ALASKA    A M I 01072=
009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000df386168 0BB6D (v02 ALASKA    A M I 00000=
015 INTL 20051117)
[    0.000000] ACPI: FACS 00000000df3bff80 00040
[    0.000000] ACPI: APIC 00000000df391dd0 00092 (v03 ALASKA    A M I 01072=
009 AMI  00010013)
[    0.000000] ACPI: MCFG 00000000df391e68 0003C (v01 ALASKA    A M I 01072=
009 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000df391ea8 00038 (v01 ALASKA    A M I 01072=
009 AMI. 00000005)
[    0.000000] ACPI: SSDT 00000000df391ee0 0036D (v01 SataRe SataTabl 00001=
000 INTL 20091112)
[    0.000000] ACPI: SSDT 00000000df392250 009AA (v01  PmRef  Cpu0Ist 00003=
000 INTL 20051117)
[    0.000000] ACPI: SSDT 00000000df392c00 00A92 (v01  PmRef    CpuPm 00003=
000 INTL 20051117)
[    0.000000] ACPI: DMAR 00000000df393698 00078 (v01 INTEL      SNB  00000=
001 INTL 00000001)
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0021f000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000deb91
[    0.000000]     0: 0x000df409 -> 0x000df800
[    0.000000]     0: 0x00100000 -> 0x0021f000
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000] MPTABLE: OEM ID: A M I
[    0.000000] MPTABLE: Product ID: ALASKA
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] Processors: 8
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at df800000 (gap: df800000=
:18800000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:8 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88021ec00000 s77184 r8192=
 d21120 u262144
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 2053971
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-3.4.4+btrfsdebug3=
+kmc+ root=3D/dev/mapper/rootvg-root_crypt ro netconsole=3D4444@192.168.1.2=
/eth0,1194@192.168.1.12/00:1c:10:44:47:2c noapic pci=3Dnoacpi noacpi
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608=
 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 b=
ytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 8103784k/8896512k available (4332k kernel code, 5416=
12k absent, 251116k reserved, 4356k data, 512k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D8, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000002] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6822.22 BogoMIPS (lpj=3D13644448)
[    0.000817] pid_max: default: 32768 minimum: 301
[    0.004000] Detected 3411.112 MHz processor.
[    0.005762] Security Framework initialized
[    0.009595] Mount-cache hash table entries: 256
[    0.045709] Initializing cgroup subsys cpuacct
[    0.046041] Initializing cgroup subsys devices
[    0.046413] Initializing cgroup subsys freezer
[    0.046769] Initializing cgroup subsys net_cls
[    0.047122] Initializing cgroup subsys blkio
[    0.048346] Initializing cgroup subsys perf_event
[    0.050676] CPU: Physical Processor ID: 0
[    0.050986] CPU: Processor Core ID: 0
[    0.051281] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.051282] ENERGY_PERF_BIAS: View and update with x86_energy_perf_polic=
y(8)
[    0.052205] mce: CPU supports 9 MCE banks
[    0.052685] CPU0: Thermal monitoring enabled (TM1)
[    0.053041] using mwait in idle threads.
[    0.054014] ACPI: Core revision 20120320
[    2.061336] ACPI: setting ELCR to 0e28 (from 0c28)
[    2.167409] DMAR: Host address width 36
[    2.167704] DMAR: DRHD base: 0x000000fed90000 flags: 0x1
[    2.168367] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020660262 e=
cap f0105a
[    2.168896] DMAR: RMRR base: 0x000000df0d6000 end: 0x000000df0e4fff
[    2.169482] Skipped enabling intr-remap because of skipping io-apic setup
[    2.169988] CPU0: Intel(R) Core(TM) i7-2600 CPU @ 3.40GHz stepping 07
[    2.274631] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge eve=
nts, Intel PMU driver.
[    2.275501] PEBS disabled due to CPU errata.
[    2.275849] ... version:                3
[    2.276151] ... bit width:              48
[    2.276459] ... generic registers:      4
[    2.276762] ... value mask:             0000ffffffffffff
[    2.277131] ... max period:             000000007fffffff
[    2.277500] ... fixed-purpose events:   3
[    2.277803] ... event mask:             000000070000000f
[    2.278439] kmemcheck: Limiting number of CPUs to 1.
[    2.278793] kmemcheck: Initialized
[    2.284205] NMI watchdog: enabled, takes one hw-pmu counter.
[    2.284842] Brought up 1 CPUs
[    2.285092] Total of 1 processors activated (6822.22 BogoMIPS).
[    2.335671] dummy:=20
[    2.345541] NET: Registered protocol family 16
[    2.374877] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    2.375402] ACPI: bus type pci registered
[    2.386116] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000=
-0xfbffffff] (base 0xf8000000)
[    2.386933] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    2.395939] PCI: Using configuration type 1 for base access
[    2.647966] bio: create slab <bio-0> at 0
[    2.659156] ACPI: Added _OSI(Module Device)
[    2.659518] ACPI: Added _OSI(Processor Device)
[    2.659899] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.660310] ACPI: Added _OSI(Processor Aggregator Device)
[    2.913809] ------------[ cut here ]------------
[    2.913810] ------------[ cut here ]------------
[    2.913814] WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 kmemcheck_=
fault+0xb9/0xd0()
[    2.913815] Hardware name: System Product Name
[    2.913816] Modules linked in: <omitted>
[    2.913817] Pid: 1, comm: swapper/0 Not tainted 3.4.4+btrfsdebug3+kmc+ #6
[    2.913818] Call Trace:
[    2.913819]  <NMI>  [<ffffffff8103a7fa>] warn_slowpath_common+0x7a/0xb0
[    2.913824]  [<ffffffff8103a845>] warn_slowpath_null+0x15/0x20
[    2.913825]  [<ffffffff810330a9>] kmemcheck_fault+0xb9/0xd0
[    2.913828]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[    2.913831]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    2.913833]  [<ffffffff812836c2>] ? vt_console_print+0xa2/0x3a0
[    2.913835]  [<ffffffff81283687>] ? vt_console_print+0x67/0x3a0
[    2.913849]  [<ffffffff8103a7b9>] warn_slowpath_common+0x39/0xb0
[    2.913859]  [<ffffffff81430c46>] ? nmi_handle.isra.0+0x46/0x80
[    2.913869]  [<ffffffff8142fb8a>] ? _raw_spin_lock_irqsave+0x1a/0x40
[    2.913894]  [<ffffffff818b894b>] acpi_init+0x113/0x28f
[    2.913905]  [<ffffffff814389a0>] ? gs_change+0x13/0x13
[    2.937049] Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsde=
bug3+kmc+ #6
[    2.940737]  [<ffffffff81430d60>] do_nmi+0xe0/0x310
[    2.945887]  [<ffffffff81246140>] ? acpi_ev_execute_reg_method+0x120/0x1=
20
[    2.948083]  [<ffffffff818b894b>] acpi_init+0x113/0x28f
[    2.950034]  [<ffffffff81891b22>] ? start_kernel+0x341/0x341
[    4.187506] ------------[ cut here ]------------
[    4.190142]  [<ffffffff8103336a>] ? kmemcheck_shadow_lookup+0x2a/0x70
[    4.190569]  [<ffffffff8103a845>] warn_slowpath_null+0x15/0x20
[    4.190964]  [<ffffffff810885bd>] smp_call_function_many+0xbd/0x270
[    4.191383]  [<ffffffff8142ffb5>] ? page_fault+0x25/0x30
[    4.191752]  [<ffffffff81031560>] ? leave_mm+0x40/0x40
[    4.192112]  [<ffffffff81031560>] ? leave_mm+0x40/0x40
[    4.192472]  [<ffffffff8108889d>] smp_call_function+0x1d/0x30
[    4.192863]  [<ffffffff810888d3>] on_each_cpu+0x23/0x60
[    4.193227]  [<ffffffff81031977>] flush_tlb_all+0x17/0x20
[    4.193601]  [<ffffffff8110bac5>] __purge_vmap_area_lazy+0x165/0x1c0
[    4.194024]  [<ffffffff81033067>] ? kmemcheck_fault+0x77/0xd0
[    4.194416]  [<ffffffff8110bd85>] vm_unmap_aliases+0x165/0x180
[    4.194815]  [<ffffffff8102e2e8>] change_page_attr_set_clr+0xb8/0x470
[    4.195241]  [<ffffffff8142ffb5>] ? page_fault+0x25/0x30
[    4.195609]  [<ffffffff8102eeda>] _set_memory_wb+0x2a/0x30
[    4.199366]  [<ffffffff812499b6>] acpi_ex_access_region+0x270/0x28d
[    4.202784]  [<ffffffff8124342d>] acpi_ds_exec_end_op+0xcf/0x3ee
[    4.238398] RSP: 0018:ffff8802158ef070  EFLAGS: 00010082
[    4.239692] RBP: ffff8802158ef0c0 R08: 0000000000000000 R09: 00000000000=
00000
[    4.243900]  [<ffffffff81032c4b>] kmemcheck_show+0x8b/0xa0
[    4.249808]  [<ffffffff81005877>] show_trace_log_lvl+0x57/0x70
[    4.253487]  [<ffffffff81031977>] flush_tlb_all+0x17/0x20
[    4.257736]  [<ffffffff814104a9>] acpi_os_map_memory+0xfc/0x15c
[    4.625131] ACPI: SSDT 00000000df0f0c18 00119 (v01  PmRef    ApCst 00003=
000 INTL 20051117)
[    5.168300] RAX: 0000000000000002 RBX: ffff880215a8f798 RCX: 00000000000=
00001
[    5.170585] FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:=
0000000000000000
[    5.172882]  [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
[    5.176693]  [<ffffffff8124358f>] acpi_ds_exec_end_op+0x231/0x3ee
[    5.179056]  [<ffffffff81252ca6>] acpi_evaluate_object+0x122/0x22e
[    5.183738]  [<ffffffffffffffff>] 0xffffffffffffffff
[    5.472329] R10: ffffffffffffffff R11: 54534f49158ef8c8 R12: ffff8802158=
ef8c8
[    5.475578]  [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
[    5.478378]  [<ffffffff8124f8cf>] acpi_ns_lookup+0x203/0x339
[    5.482204]  [<ffffffff81252ca6>] acpi_evaluate_object+0x122/0x22e
[    5.485110]  [<ffffffff8123b385>] acpi_bus_scan+0x56/0x77
[    5.487831]  [<ffffffffffffffff>] 0xffffffffffffffff
[    6.733770] CR2: ffff880215820154 CR3: 000000000180c000 CR4: 00000000000=
407f0
[    6.737851]  [<ffffffff814302dc>] end_repeat_nmi+0x1a/0x1e
[    6.741576]  [<ffffffff81252560>] acpi_ns_get_node+0x3f/0x9f
[    6.745427]  [<ffffffff81252b51>] acpi_walk_namespace+0x93/0xc6
[    6.747674]  [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
[    6.748580]  [<ffffffffffffffff>] 0xffffffffffffffff
[    6.749000] ERROR: kmemcheck: Fatal error
[    6.749297]=20
[    6.749466] Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsde=
bug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
[    6.750425] RIP: 0010:[<ffffffff81011f3a>]  [<ffffffff81011f3a>] x86_per=
f_event_update+0x2a/0xc0
[    6.751074] RSP: 0018:ffff88021ec07d20  EFLAGS: 00010002
[    6.751439] RAX: 00000000ffffffff RBX: 0000000000000010 RCX: 00000000000=
00390
[    6.751897] RDX: 0000000000000021 RSI: 0000000000000040 RDI: ffff8802158=
22400
[    6.752355] RBP: ffff88021ec07d68 R08: 0000000000000000 R09: ffff8800000=
00000
[    6.752813] R10: ffffffffffffffff R11: 0000000000000000 R12: 00000000000=
00001
[    6.753270] R13: ffff88021ec07dc0 R14: ffff880215822400 R15: 00000000000=
00021
[    6.753728] FS:  0000000000000000(0000) GS:ffff88021ec00000(0000) knlGS:=
0000000000000000
[    6.754267] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    6.754652] CR2: ffff880215820154 CR3: 000000000180c000 CR4: 00000000000=
407f0
[    6.755108] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    6.755564] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 00000000000=
00400
[    6.756021]  [<ffffffff8103244a>] kmemcheck_error_save_bug+0x7a/0xb0
[    6.756511]  [<ffffffff81032850>] kmemcheck_access+0x1d0/0x440
[    6.756976]  [<ffffffff8103308d>] kmemcheck_fault+0x9d/0xd0
[    6.757426]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[    6.757878]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    6.758307]  [<ffffffff810179f1>] intel_pmu_save_and_restart+0x11/0x20
[    6.758805]  [<ffffffff81017b5d>] intel_pmu_handle_irq+0x15d/0x320
[    6.759288]  [<ffffffff814313ed>] perf_event_nmi_handler+0x1d/0x20
[    6.759770]  [<ffffffff81430c49>] nmi_handle.isra.0+0x49/0x80
[    6.760229]  [<ffffffff81430d60>] do_nmi+0xe0/0x310
[    6.760645]  [<ffffffff814302dc>] end_repeat_nmi+0x1a/0x1e
[    6.761091]  [<ffffffff81033351>] kmemcheck_shadow_lookup+0x11/0x70
[    6.762307]  [<ffffffff810325df>] kmemcheck_write_strict.isra.1+0x1f/0x50
[    6.762821]  [<ffffffff810328d4>] kmemcheck_access+0x254/0x440
[    6.763286]  [<ffffffff8103305f>] kmemcheck_fault+0x6f/0xd0
[    6.763739]  [<ffffffff81433465>] do_page_fault+0x445/0x4d0
[    6.764189]  [<ffffffff8142ffb5>] page_fault+0x25/0x30
[    6.764617]  [<ffffffff812522b6>] acpi_ns_internalize_name+0x52/0x77
[    6.765106]  [<ffffffff81252560>] acpi_ns_get_node+0x3f/0x9f
[    6.765560]  [<ffffffff8124ffc2>] acpi_ns_evaluate+0x3e/0x1a8
[    6.766020]  [<ffffffff81259cfa>] acpi_ut_evaluate_object+0x7e/0x1a7
[    6.766512]  [<ffffffff81259ef6>] acpi_ut_execute_power_methods+0x3f/0x79
[    6.767025]  [<ffffffff812533fb>] acpi_get_object_info+0x1b5/0x326
[    6.767506]  [<ffffffff8123a8c8>] acpi_add_single_object+0x264/0xb64
[    7.005628] ACPI: Power Resource [FN00] (off)
[    7.221192] PCI: Probing PCI hardware
[    7.276596] pci 0000:00:1c.6: PCI bridge to [bus 06-07] (subtractive dec=
ode)
[    8.006301] system 00:05: [io  0xffff] has been reserved
[    8.079361] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    8.231088] system 00:0c: [mem 0xfed45000-0xfed8ffff] has been reserved
[    8.577447] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    8.583667] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    8.588098] pci 0000:00:1c.6: PCI bridge to [bus 06-07]
[    8.592855] pci 0000:00:01.0: sharing IRQ 11 with 0000:00:1c.0
[    8.599013] pci 0000:00:1c.0: sharing IRQ 11 with 0000:00:1c.4
[    8.608439] pci 0000:00:1c.3: sharing IRQ 5 with 0000:04:00.0
[    8.613977] pci 0000:00:1c.4: sharing IRQ 11 with 0000:05:00.0
[    8.622850] pci 0000:00:1c.7: sharing IRQ 5 with 0000:00:1c.3
[    8.668259] NET: Registered protocol family 1
[    8.806126] pci 0000:00:1d.0: broken D3 during system sleep on ASUS
[    8.944397] pci 0000:05:00.0: sharing IRQ 11 with 0000:00:16.0
[   10.975276] IOMMU 0 0xfed90000: using Queued invalidation
[   10.996483] Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsde=
bug3+kmc+ #6 System manufacturer System Product Name/P8P67 EVO
[   11.000313] R13: ffff88021278d500 R14: 0000000000000004 R15: ffff8802158=
ec180
[   11.002183] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   11.002646] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 00000000000=
00400
[   11.003109]  [<ffffffff81353196>] qi_flush_context+0x46/0x50
[   11.003569]  [<ffffffff818c3343>] intel_iommu_init+0x978/0xc1a
[   11.004041]  [<ffffffff81896ab6>] pci_iommu_init+0x13/0x3e
[   11.004493]  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
[   11.004960]  [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
[   11.005408]  [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
[   11.005887]  [<ffffffffffffffff>] 0xffffffffffffffff
[   11.006311] Hardware name: System Product Name
[   11.006636] Modules linked in: <omitted>
[   11.007002] Pid: 1, comm: swapper/0 Tainted: G        W    3.4.4+btrfsde=
bug3+kmc+ #6
[   11.007534] Call Trace:
[   11.007756]  [<ffffffff8103a7fa>] warn_slowpath_common+0x7a/0xb0
[   11.008161]  [<ffffffff8103a845>] warn_slowpath_null+0x15/0x20
[   11.008555]  [<ffffffff81208770>] pci_find_upstream_pcie_bridge+0x50/0x70
[   11.009002]  [<ffffffff8135754d>] intel_iommu_device_group+0x7d/0x100
[   11.009434]  [<ffffffff8134da70>] ? bus_set_iommu+0x50/0x50
[   11.009822]  [<ffffffff8134da9b>] add_iommu_group+0x2b/0x60
[   11.010205]  [<ffffffff8129f17d>] bus_for_each_dev+0x4d/0x90
[   11.010590]  [<ffffffff8134da5b>] bus_set_iommu+0x3b/0x50
[   11.010965]  [<ffffffff818c34b4>] intel_iommu_init+0xae9/0xc1a
[   11.011361]  [<ffffffff818939ee>] ? clean_rootfs+0x1c1/0x1c1
[   11.011749]  [<ffffffff81896aa3>] ? memblock_find_dma_reserve+0x13d/0x13d
[   11.012193]  [<ffffffff81896ab6>] pci_iommu_init+0x13/0x3e
[   11.012570]  [<ffffffff810002b2>] do_one_initcall+0x122/0x170
[   11.012961]  [<ffffffff81891c5c>] kernel_init+0x13a/0x1be
[   11.013334]  [<ffffffff81891582>] ? do_early_param+0x8c/0x8c
[   11.013726]  [<ffffffff814389a4>] kernel_thread_helper+0x4/0x10
[   11.014126]  [<ffffffff81891b22>] ? start_kernel+0x341/0x341
[   11.014514]  [<ffffffff814389a0>] ? gs_change+0x13/0x13
[   11.014877] ---[ end trace 4eaa2a86a8e2da25 ]---
[   11.057007] audit: initializing netlink socket (disabled)
[   11.058130] type=3D2000 audit(1342119687.848:1): initialized
[   11.090907] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   11.503443] VFS: Disk quotas dquot_6.5.2
[   11.510010] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   11.525854] msgmni has been set to 15983
[   11.554501] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[   11.555544] io scheduler noop registered
[   11.568279] io scheduler cfq registered (default)
[   11.633350] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   12.343140] e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-=
0FF
[   12.359432] ehci_hcd 0000:00:1a.0: sharing IRQ 11 with 0000:07:02.0
[   12.391626] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   12.447137] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   12.481291] xhci_hcd 0000:03:00.0: found PCI INT A -> IRQ 10
[   12.504483] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   12.536793] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003
[   12.565850] xhci_hcd 0000:05:00.0: sharing IRQ 11 with 0000:07:02.0
[   12.604982] hub 5-0:1.0: USB hub found
[   12.626784] usb usb6: SerialNumber: 0000:05:00.0
[   12.701566] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[   12.856164] netpoll: netconsole: remote port 1194
[   13.069378] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[   13.614201] usb 2-1.1: Manufacturer: Plus More Enterprise LTD.
[   13.802110] usb 2-1.2: new full-speed USB device number 4 using ehci_hcd
[   14.185814] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:=
1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input3
[   15.035390] console [netcon0] enabled
[   15.035916] netconsole: network logging started
[   15.038217] rtc_cmos 00:06: setting system clock to 2012-07-12 19:01:33 =
UTC (1342119693)
[   15.053395] Freeing unused kernel memory: 512k freed
[   15.054038] Write protecting the kernel read-only data: 8192k
[   15.059613] Freeing unused kernel memory: 1792k freed
[   15.060689] Freeing unused kernel memory: 52k freed
[   15.066519] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000005
[   15.066520]=20
[   15.068164] Pid: 1, comm: init Tainted: G        W    3.4.4+btrfsdebug3+=
kmc+ #6
[   15.068930] Call Trace:
[   15.071066]  [<ffffffff81427927>] panic+0xb5/0x1c1
[   15.071675]  [<ffffffff8103ec6c>] do_exit+0x7bc/0x8a0
[   15.072504]  [<ffffffff8103efea>] do_group_exit+0x3a/0xa0
[   15.073139]  [<ffffffff8104d655>] get_signal_to_deliver+0x1a5/0x5c0
[   15.074043]  [<ffffffff8104c0b0>] ? send_signal+0x40/0x80
[   15.074682]  [<ffffffff81002260>] do_signal+0x60/0x950
[   15.075532]  [<ffffffff8104c88c>] ? force_sig_info+0xdc/0x100
[   15.076205]  [<ffffffff81002bd5>] do_notify_resume+0x65/0x80
[   15.077087]  [<ffffffff814377fa>] int_signal+0x12/0x17
[   15.077735]  [<ffffffff81426069>] ? run_init_process+0x1e/0x20
[   15.078626]  [<ffffffff814260ad>] ? init_post+0x42/0xbb
[   15.080093]  [<ffffffff81891ce0>] ? kernel_init+0x1be/0x1be
[   15.080726]  [<ffffffff81891582>] ? do_early_param+0x8c/0x8c
[   15.083058]  [<ffffffff814389a4>] ? kernel_thread_helper+0x4/0x10
[   15.083727]  [<ffffffff81891b22>] ? start_kernel+0x341/0x341
[   15.084598]  [<ffffffff814389a0>] ? gs_change+0x13/0x13

--69pVuxX8awAiJ7fD--

--5gxpn/Q6ypwruk0T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJP/0KRAAoJEKLT589SE0a0GuMP/2p7b7giovvZ+RRtQx+LY+KD
82lsD99Wa98O9W0/zaAEBQq2g4vHFRGqSZRHj8te3xqt5FP4qMWI5zlG59OMNjUr
5jlz5GjagAXo0ayn5gZBqIBQPgm5lXWC7IbSNz1WdSfwf4dQCR0D8jYGmot/uf7C
NKeG2J+aXEnnFfopD8x71W1Egk+0BzCZW2NAhNHKZybHv1xwNHPzVVgpSwRnhjFM
bEjoMWQOETaqpjPt2A6Sn/vKd2hdVjdcANFTvXNkmCkOMQXuBrS5T+BBwKnB1axq
r1i7ZJB0l0whLkwqXXd08+Wtm+hAy3INbiHAnM/p3QgeBIVoNmo6ByKHdfrQ4AaG
T2STYvQ4/RvlnUTQGFdJwLbYVL+OVPo9EOfRC/F+YuXJMHvFxokf2ViTJlAoxJUU
o8FCt/GLq5Zj5q00wXxsVVS1ZkJJCPISeh2uZSGqynPaCocROVC/DYeRJT5R1WMV
IExW9xEbAQ5KlxP0dOTyXpBuvNQF/yMCyHVUv2VQqKNf97ncemBmvIbsWXeUq74Q
gi2hc3aHoz8NR0t8RibWXyY69rlwFgKwo7T7r/YkxcW775jb9L2aXMy7dB7NKR0l
XEskh0jwDni0juei/asCU7SXBGQl7h36jS9DnDDp7KjkXoaIOOU52PNxGegw2Y9o
WXCfPFQZlou64eMo6+ok
=EAqK
-----END PGP SIGNATURE-----

--5gxpn/Q6ypwruk0T--
