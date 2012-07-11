Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab2GKScp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 14:32:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663Ab2GKScn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 14:32:43 -0400
Date: Wed, 11 Jul 2012 14:32:39 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 3.5-rc6 dentry related GPF
Message-ID: <20120711183239.GA7122@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just triggered this using my fuzzing tool. To give it some more interesting things
to chew on, I had first loaded every module I had built.  This is why the P and C flags
are tainted (patch sent to netdev for the 'P' in nci.ko).
(The W flag was a warning from networking about an > MAX_ORDER page alloc that failed).
So the taints should be unrelated to this GPF.


[ 1995.677766] general protection fault: 0000 [#1] SMP 
[ 1995.678070] CPU 1 
[ 1995.678076] Modules linked in:
[ 1995.680010]  unix_diag
[ 1995.680010]  ip_set_hash_ipportnet
[ 1995.680010]  xt_connmark
[ 1995.680010]  vlsi_ir
[ 1995.680010]  ath9k_hw
[ 1995.680010]  mkiss
[ 1995.680010]  dell_rbu
[ 1995.767843]  garmin_gps
[ 1995.767843]  rc_apac_viewcomp
[ 1995.767843]  rc_norwood
[ 1995.767843]  gspca_spca508
[ 1995.767843]  hid_petalynx
[ 1995.767843]  lm92
[ 1995.767843]  megaraid_sas
[ 1995.767843]  touchwin
[ 1995.767843]  pata_ns87410
[ 1995.767843]  snd_ymfpci
[ 1995.767843]  michael_mic
[ 1995.767843]  blocklayoutdriver
[ 1995.767843]  nfs_layout_nfsv41_files nfs fscache auth_rpcgss nfs_acl lockd ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables dm_mirror dm_region_hash dm_log btrfs zlib_deflate libcrc32c coretemp snd_hda_codec_idt snd_hda_intel kvm_intel snd_hda_codec kvm i5000_edac snd_hwdep snd_seq tg3 snd_seq_device snd_pcm edac_core dcdbas snd_timer snd iTCO_wdt iTCO_vendor_support lpc_ich mfd_core serio_raw ppdev raid0 pcspkr i5k_amb soundcore sunrpc i2c_i801 microcode parport_pc snd_page_alloc parport shpchp firewire_ohci firewire_core crc_itu_t floppy nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core mxm_wmi video wmi [last unloaded: scsi_wait_scan]
[ 1995.767843] 
[ 1995.767843] Pid: 25682, comm: trinity-main Tainted: P        WC   3.5.0-rc6+ #78 Dell Inc.                 Precision WorkStation 490    /0DT031
[ 1995.767843] RIP: 0010:[<ffffffff810df39e>]  [<ffffffff810df39e>] try_module_get+0x3e/0x1b0
[ 1995.767843] RSP: 0018:ffff88018aba9c48  EFLAGS: 00010202
[ 1995.767843] RAX: ffff88018aba9fd8 RBX: 54415541e5894855 RCX: 00000000000015eb
[ 1995.767843] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 54415541e5894855
[ 1995.767843] RBP: ffff88018aba9c78 R08: ffff880210f91800 R09: 0000000000000000
[ 1995.767843] R10: 0000000000000002 R11: 0000000000000000 R12: ffff88021ccb2fa0
[ 1995.767843] R13: ffff880156ccb9c0 R14: 0000000000000000 R15: ffff88019e22a010
[ 1995.767843] FS:  00007fede7afa700(0000) GS:ffff880226800000(0000) knlGS:0000000000000000
[ 1995.767843] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1995.767843] CR2: 00000000028bb209 CR3: 000000018de33000 CR4: 00000000000007e0
[ 1995.767843] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1995.767843] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1995.767843] Process trinity-main (pid: 25682, threadinfo ffff88018aba8000, task ffff880179c1a480)
[ 1995.767843] Stack:
[ 1995.767843]  ffff880222c79bd8 ffff88019e1cf090 ffff88021ccb2fa0 ffff880156ccb9c0
[ 1995.767843]  0000000000000000 ffff88019e22a010 ffff88018aba9cd8 ffffffff811c160c
[ 1995.767843]  0000000000000000 0000000000000000 ffff880210f91800 ffffffff816b81fb
[ 1995.767843] Call Trace:
[ 1995.767843]  [<ffffffff811c160c>] do_dentry_open+0xec/0x370
[ 1995.767843]  [<ffffffff816b81fb>] ? _raw_spin_unlock+0x2b/0x50
[ 1995.767843]  [<ffffffff811c2f9e>] nameidata_to_filp+0x7e/0xc0
[ 1995.767843]  [<ffffffff811d2bfc>] do_last+0x44c/0xa10
[ 1995.767843]  [<ffffffff811d50f9>] path_openat+0xd9/0x460
[ 1995.767843]  [<ffffffff811d55a2>] do_filp_open+0x42/0xa0
[ 1995.767843]  [<ffffffff816b81fb>] ? _raw_spin_unlock+0x2b/0x50
[ 1995.767843]  [<ffffffff811e42fe>] ? alloc_fd+0x16e/0x220
[ 1995.767843]  [<ffffffff811c30d8>] do_sys_open+0xf8/0x1d0
[ 1995.767843]  [<ffffffff811c31d1>] sys_open+0x21/0x30
[ 1995.767843]  [<ffffffff816c15e9>] system_call_fastpath+0x16/0x1b
[ 1995.767843] Code: e8 4c 89 75 f0 4c 89 7d f8 66 66 66 66 90 b8 01 00 00 00 48 85 ff 48 89 fb 74 42 65 48 8b 04 25 b0 c8 00 00 83 80 44 e0 ff ff 01 <83> 3f 02 0f 84 54 01 00 00 48 8b 87 50 02 00 00 65 48 ff 00 4c 
[ 1995.767843] RIP  [<ffffffff810df39e>] try_module_get+0x3e/0x1b0
[ 1995.767843]  RSP <ffff88018aba9c48>
[ 1995.972351] ---[ end trace 417f34768f3458c0 ]---

Somehow we blew up dereferencing RDI (54415541e5894855), which is obviously garbage.
It's almost an ascii string, but it looks meaningless to me. "TUAU??HU"
It doesn't look like x86 opcodes either afaict, so no idea where that came from.
There is a google single hit for that hex value in a userspace stack trace so
maybe it comes from some library ?

What's puzzling me though is how we got from do_dentry_open to try_module_get ?

Filesystem it was running from was btrfs.

It went on to spew more, but that looks just like fallout from the above.

	Dave


[ 1995.973175] BUG: sleeping function called from invalid context at kernel/rwsem.c:20
[ 1995.974091] in_atomic(): 1, irqs_disabled(): 0, pid: 25682, name: trinity-main
[ 1995.974998] INFO: lockdep is turned off.
[ 1995.975878] Pid: 25682, comm: trinity-main Tainted: P      D WC   3.5.0-rc6+ #78
[ 1995.976795] Call Trace:
[ 1995.977674]  [<ffffffff8109df95>] __might_sleep+0x185/0x240
[ 1995.978545]  [<ffffffff816b5aa6>] down_read+0x26/0x93
[ 1995.979393]  [<ffffffff8107ef44>] exit_signals+0x24/0x130
[ 1995.980257]  [<ffffffff8106b6af>] do_exit+0xbf/0xbb0
[ 1995.981041]  [<ffffffff810683e8>] ? kmsg_dump+0x1c8/0x250
[ 1995.981816]  [<ffffffff81068244>] ? kmsg_dump+0x24/0x250
[ 1995.982591]  [<ffffffff816b99dc>] oops_end+0xac/0xf0
[ 1995.983346]  [<ffffffff8101d978>] die+0x58/0x90
[ 1995.984076]  [<ffffffff816b94a2>] do_general_protection+0x162/0x170
[ 1995.984802]  [<ffffffff816b8ae0>] ? restore_args+0x30/0x30
[ 1995.985520]  [<ffffffff816b8d25>] general_protection+0x25/0x30
[ 1995.986233]  [<ffffffff810df39e>] ? try_module_get+0x3e/0x1b0
[ 1995.986945]  [<ffffffff81099f83>] ? lg_local_unlock+0x23/0x50
[ 1995.987643]  [<ffffffff811c160c>] do_dentry_open+0xec/0x370
[ 1995.988336]  [<ffffffff816b81fb>] ? _raw_spin_unlock+0x2b/0x50
[ 1995.989033]  [<ffffffff811c2f9e>] nameidata_to_filp+0x7e/0xc0
[ 1995.989714]  [<ffffffff811d2bfc>] do_last+0x44c/0xa10
[ 1995.990423]  [<ffffffff811d50f9>] path_openat+0xd9/0x460
[ 1995.991078]  [<ffffffff811d55a2>] do_filp_open+0x42/0xa0
[ 1995.991743]  [<ffffffff816b81fb>] ? _raw_spin_unlock+0x2b/0x50
[ 1995.992407]  [<ffffffff811e42fe>] ? alloc_fd+0x16e/0x220
[ 1995.993065]  [<ffffffff811c30d8>] do_sys_open+0xf8/0x1d0
[ 1995.993708]  [<ffffffff811c31d1>] sys_open+0x21/0x30
[ 1995.994343]  [<ffffffff816c15e9>] system_call_fastpath+0x16/0x1b
[ 1995.994982] note: trinity-main[25682] exited with preempt_count 1
[ 1995.995703] BUG: scheduling while atomic: trinity-main/25682/0x10000002
[ 1995.996261] INFO: lockdep is turned off.
[ 1996.003161]  rose
[ 1996.011946]  ip_set_bitmap_ipmac
[ 1996.021744]  nf_conntrack_h323
[ 1996.033260]  girbil_sir
[ 1996.046566]  ath9k_common
[ 1996.060362]  hdlcdrv
[ 1996.074182]  tun
[ 1996.088092]  spcp8x5
[ 1996.102013]  rc_streamzap
[ 1996.115693]  rc_medion_x10
[ 1996.129305]  gspca_mr97310a
[ 1996.142832]  hid_multitouch
[ 1996.156294]  fam15h_power
[ 1996.169897]  sym53c8xx
[ 1996.183711]  gunze
[ 1996.197565]  pata_ns87410
[ 1996.211407]  snd_ymfpci
[ 1996.225196]  michael_mic
[ 1996.238934]  blocklayoutdriver
[ 1996.241622]  nfs_layout_nfsv41_files nfs fscache auth_rpcgss nfs_acl lockd ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables dm_mirror dm_region_hash dm_log btrfs zlib_deflate libcrc32c coretemp snd_hda_codec_idt snd_hda_intel kvm_intel snd_hda_codec kvm i5000_edac snd_hwdep snd_seq tg3 snd_seq_device snd_pcm edac_core dcdbas snd_timer snd iTCO_wdt iTCO_vendor_support lpc_ich mfd_core serio_raw ppdev raid0 pcspkr i5k_amb soundcore sunrpc i2c_i801 microcode parport_pc snd_page_alloc parport shpchp firewire_ohci firewire_core crc_itu_t floppy nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core mxm_wmi video wmi [last unloaded: scsi_wait_scan]
[ 1996.249760] Pid: 25682, comm: trinity-main Tainted: P      D WC   3.5.0-rc6+ #78
[ 1996.251127] Call Trace:
[ 1996.252433]  [<ffffffff816ab1b3>] __schedule_bug+0x67/0x75
[ 1996.253737]  [<ffffffff816b69e5>] __schedule+0x9f5/0xa20
[ 1996.255026]  [<ffffffff810a190a>] __cond_resched+0x2a/0x40
[ 1996.256290]  [<ffffffff816b6a92>] _cond_resched+0x32/0x40
[ 1996.257537]  [<ffffffff81180c8e>] unmap_single_vma+0x4ae/0x7d0
[ 1996.258769]  [<ffffffff81181734>] unmap_vmas+0x54/0xa0
[ 1996.259975]  [<ffffffff81189302>] exit_mmap+0x92/0x150
[ 1996.261200]  [<ffffffff810619e7>] mmput+0x77/0x100
[ 1996.262347]  [<ffffffff8106b5c8>] exit_mm+0x108/0x130
[ 1996.263516]  [<ffffffff816b8130>] ? _raw_spin_unlock_irq+0x30/0x50
[ 1996.264667]  [<ffffffff8106b75b>] do_exit+0x16b/0xbb0
[ 1996.265805]  [<ffffffff810683e8>] ? kmsg_dump+0x1c8/0x250
[ 1996.266908]  [<ffffffff81068244>] ? kmsg_dump+0x24/0x250
[ 1996.267998]  [<ffffffff816b99dc>] oops_end+0xac/0xf0
[ 1996.269067]  [<ffffffff8101d978>] die+0x58/0x90
[ 1996.270158]  [<ffffffff816b94a2>] do_general_protection+0x162/0x170
[ 1996.271179]  [<ffffffff816b8ae0>] ? restore_args+0x30/0x30
[ 1996.272204]  [<ffffffff816b8d25>] general_protection+0x25/0x30
[ 1996.273205]  [<ffffffff810df39e>] ? try_module_get+0x3e/0x1b0
[ 1996.274211]  [<ffffffff81099f83>] ? lg_local_unlock+0x23/0x50
[ 1996.275201]  [<ffffffff811c160c>] do_dentry_open+0xec/0x370
[ 1996.276140]  [<ffffffff816b81fb>] ? _raw_spin_unlock+0x2b/0x50
[ 1996.277090]  [<ffffffff811c2f9e>] nameidata_to_filp+0x7e/0xc0
[ 1996.278019]  [<ffffffff811d2bfc>] do_last+0x44c/0xa10
[ 1996.278936]  [<ffffffff811d50f9>] path_openat+0xd9/0x460
[ 1996.279826]  [<ffffffff811d55a2>] do_filp_open+0x42/0xa0
[ 1996.280752]  [<ffffffff816b81fb>] ? _raw_spin_unlock+0x2b/0x50
[ 1996.281571]  [<ffffffff811e42fe>] ? alloc_fd+0x16e/0x220
[ 1996.282404]  [<ffffffff811c30d8>] do_sys_open+0xf8/0x1d0
[ 1996.283237]  [<ffffffff811c31d1>] sys_open+0x21/0x30
[ 1996.284050]  [<ffffffff816c15e9>] system_call_fastpath+0x16/0x1b
[ 1996.290055] BUG: scheduling while atomic: trinity-main/25682/0x10000002
[ 1996.290342] INFO: lockdep is turned off.
[ 1996.297178]  rose
[ 1996.305513]  ip_set_bitmap_ipmac
[ 1996.315315]  nf_conntrack_h323
[ 1996.326834]  girbil_sir
[ 1996.340152]  ath9k_common
[ 1996.353916]  hdlcdrv
[ 1996.367758]  tun
[ 1996.381691]  spcp8x5
[ 1996.395592]  rc_streamzap
[ 1996.409267]  rc_medion_x10
[ 1996.422902]  gspca_mr97310a
[ 1996.436424]  hid_multitouch
[ 1996.449890]  fam15h_power
[ 1996.463529]  sym53c8xx
[ 1996.477333]  gunze
[ 1996.491218]  pata_ns87410
[ 1996.505025]  snd_ymfpci
[ 1996.518805]  michael_mic
[ 1996.532561]  blocklayoutdriver
[ 1996.535197]  nfs_layout_nfsv41_files nfs fscache auth_rpcgss nfs_acl lockd ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables dm_mirror dm_region_hash dm_log btrfs zlib_deflate libcrc32c coretemp snd_hda_codec_idt snd_hda_intel kvm_intel snd_hda_codec kvm i5000_edac snd_hwdep snd_seq tg3 snd_seq_device snd_pcm edac_core dcdbas snd_timer snd iTCO_wdt iTCO_vendor_support lpc_ich mfd_core serio_raw ppdev raid0 pcspkr i5k_amb soundcore sunrpc i2c_i801 microcode parport_pc snd_page_alloc parport shpchp firewire_ohci firewire_core crc_itu_t floppy nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core mxm_wmi video wmi [last unloaded: scsi_wait_scan]
[ 1996.543384] Pid: 25682, comm: trinity-main Tainted: P      D WC   3.5.0-rc6+ #78
[ 1996.544715] Call Trace:
[ 1996.546032]  [<ffffffff816ab1b3>] __schedule_bug+0x67/0x75
[ 1996.547334]  [<ffffffff816b69e5>] __schedule+0x9f5/0xa20
[ 1996.548627]  [<ffffffff811c61b9>] ? fput+0x29/0x360
[ 1996.549886]  [<ffffffff810a190a>] __cond_resched+0x2a/0x40
[ 1996.551189]  [<ffffffff816b6a92>] _cond_resched+0x32/0x40
[ 1996.552380]  [<ffffffff8106ae2b>] put_files_struct+0x15b/0x460
[ 1996.553594]  [<ffffffff8106ad08>] ? put_files_struct+0x38/0x460
[ 1996.554781]  [<ffffffff8106b1f2>] exit_files+0x52/0x60
[ 1996.555950]  [<ffffffff8106b785>] do_exit+0x195/0xbb0
[ 1996.557121]  [<ffffffff810683e8>] ? kmsg_dump+0x1c8/0x250
[ 1996.558271]  [<ffffffff81068244>] ? kmsg_dump+0x24/0x250
[ 1996.559398]  [<ffffffff816b99dc>] oops_end+0xac/0xf0
[ 1996.560539]  [<ffffffff8101d978>] die+0x58/0x90
[ 1996.561613]  [<ffffffff816b94a2>] do_general_protection+0x162/0x170
[ 1996.562685]  [<ffffffff816b8ae0>] ? restore_args+0x30/0x30
[ 1996.563744]  [<ffffffff816b8d25>] general_protection+0x25/0x30
[ 1996.564786]  [<ffffffff810df39e>] ? try_module_get+0x3e/0x1b0
[ 1996.565817]  [<ffffffff81099f83>] ? lg_local_unlock+0x23/0x50
[ 1996.566819]  [<ffffffff811c160c>] do_dentry_open+0xec/0x370
[ 1996.567822]  [<ffffffff816b81fb>] ? _raw_spin_unlock+0x2b/0x50
[ 1996.568810]  [<ffffffff811c2f9e>] nameidata_to_filp+0x7e/0xc0
[ 1996.569756]  [<ffffffff811d2bfc>] do_last+0x44c/0xa10
[ 1996.570740]  [<ffffffff811d50f9>] path_openat+0xd9/0x460
[ 1996.571656]  [<ffffffff811d55a2>] do_filp_open+0x42/0xa0
[ 1996.572564]  [<ffffffff816b81fb>] ? _raw_spin_unlock+0x2b/0x50
[ 1996.573459]  [<ffffffff811e42fe>] ? alloc_fd+0x16e/0x220
[ 1996.574342]  [<ffffffff811c30d8>] do_sys_open+0xf8/0x1d0
[ 1996.575195]  [<ffffffff811c31d1>] sys_open+0x21/0x30
[ 1996.576023]  [<ffffffff816c15e9>] system_call_fastpath+0x16/0x1b
