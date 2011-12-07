Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab1LGQpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:45:41 -0500
Received: from lo.gmane.org ([80.91.229.12]:57681 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756436Ab1LGQpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:45:15 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Yuri D'Elia" <wavexx@users.sf.net>
Subject: "Reproducible" kernel panic with RHEL6's kernel.
Date: Wed, 7 Dec 2011 17:41:18 +0100
Message-ID: <20111207174118.c2f85530721c4bebc9e38dd8@users.sf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: bgx-irt.net.eurac.edu
X-Newsreader: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone. I apologize for posting this here, but I figured somebody from RH may be interested (I'm currently trying to reproduce if the issue is still present in the current kernels).

We are currently running** the latest RHEL6 kernel (2.6.32-131.21.1), and experiencing repeated kernel panics which appear to be VM related under heavy stress. The panics only occur when fully loading the system (in this case, several Sun Fire X4600 M2 systems) with at least 32 running processes and using 90-100% of the free memory (64g):

http://www.thregr.org/~wavexx/tmp/crash.png
http://www.thregr.org/~wavexx/tmp/crash2.png

The system panics after 10 days on average, usually shortly preceded by one of the following:

------------[ cut here ]------------
WARNING: at mm/page-writeback.c:1161 __set_page_dirty_nobuffers+0x11b/0x150() (Not tainted)
Hardware name: Sun Fire X4600 M2
Modules linked in: ip6table_filter(U) ip6_tables(U) ipt_REJECT(U) nf_conntrack_ipv4(U) nf_defrag_ipv4(U) xt_state(U) nf_conntrack(U) iptable_filter(U) ip_tables(U) lustre(U) lov(U) osc(U) lquota(U) mdc(U) nfs(U) fid(U) fld(U) lockd(U) fscache(U) ksocklnd(U) nfs_acl(U) auth_rpcgss(U) ptlrpc(U) sunrpc(U) obdclass(U) ipv6(U) lnet(U) lvfs(U) dm_round_robin(U) scsi_dh_emc(U) libcfs(U) mptctl(U) ext3(U) jbd(U) amd64_edac_mod(U) serio_raw(U) shpchp(U) i2c_nforce2(U) edac_core(U) k10temp(U) ghes(U) dm_multipath(U) i2c_core(U) edac_mce_amd(U) hwmon(U) hed(U) dm_mod(U) ext4(U) mbcache(U) jbd2(U) sd_mod(U) crc_t10dif(U) sg(U) sr_mod(U) cdrom(U) mptsas(U) ata_generic(U) mptscsih(U) qla2xxx(U) pata_acpi(U) mptbase(U) scsi_transport_sas(U) e1000(U) scsi_transport_fc(U) scsi_tgt(U) pata_amd(U)
Pid: 23494, comm: merlin Not tainted 2.6.32 #1
Call Trace:
 [<ffffffff81067128>] ? warn_slowpath_common+0x88/0xc0
 [<ffffffff8106717a>] ? warn_slowpath_null+0x1a/0x20
 [<ffffffff81122a9b>] ? __set_page_dirty_nobuffers+0x11b/0x150
 [<ffffffff8115fba0>] ? migrate_page_copy+0x1e0/0x1f0
 [<ffffffff8115fbe5>] ? migrate_page+0x35/0x50
 [<ffffffffa06d34ae>] ? nfs_migrate_page+0x5e/0xf0 [nfs]
 [<ffffffff8115fef8>] ? move_to_new_page+0x98/0x180
 [<ffffffff811603f4>] ? migrate_pages+0x414/0x4a0
 [<ffffffff811565d0>] ? compaction_alloc+0x0/0x3e0
 [<ffffffff81155edb>] ? compact_zone+0x4fb/0x780
 [<ffffffff81156401>] ? compact_zone_order+0xa1/0xe0
 [<ffffffff8115655c>] ? try_to_compact_pages+0x11c/0x190
 [<ffffffff81120458>] ? __alloc_pages_nodemask+0x5f8/0x8c0
 [<ffffffff81166348>] ? __mem_cgroup_try_charge+0x78/0x420
 [<ffffffff81154c6a>] ? alloc_pages_vma+0x9a/0x150
 [<ffffffff8116d75e>] ? do_huge_pmd_anonymous_page+0x13e/0x350
 [<ffffffff811388b3>] ? handle_mm_fault+0x263/0x2c0
 [<ffffffff8100bc4e>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff810414f9>] ? __do_page_fault+0x139/0x490
 [<ffffffff8113fc84>] ? move_vma+0x164/0x270
 [<ffffffff81140196>] ? do_mremap+0x406/0x550
 [<ffffffff814e310e>] ? do_page_fault+0x3e/0xa0
 [<ffffffff814e0445>] ? page_fault+0x25/0x30
---[ end trace 17b7a1ad49708df3 ]---

------------[ cut here ]------------
WARNING: at mm/page-writeback.c:1161 __set_page_dirty_nobuffers+0x11b/0x150() (Not tainted)
Hardware name: Sun Fire X4600 M2
Modules linked in: ip6table_filter(U) ip6_tables(U) iptable_filter(U) ip_tables(U) nfs(U) lockd(U) fscache(U) nfs_acl(U) auth_rpcgss(U) sunrpc(U) ipv6(U) ext3(U) jbd(U) dm_round_robin(U) scsi_dh_emc(U) mptctl(U) amd64_edac_mod(U) i2c_nforce2(U) dm_multipath(U) shpchp(U) serio_raw(U) edac_core(U) k10temp(U) ghes(U) dm_mod(U) i2c_core(U) hed(U) hwmon(U) edac_mce_amd(U) ext4(U) mbcache(U) jbd2(U) sd_mod(U) crc_t10dif(U) sg(U) sr_mod(U) cdrom(U) ata_generic(U) mptsas(U) mptscsih(U) pata_acpi(U) mptbase(U) qla2xxx(U) scsi_transport_fc(U) scsi_transport_sas(U) e1000(U) scsi_tgt(U) pata_amd(U)
Pid: 13542, comm: merlin Not tainted 2.6.32 #1
Call Trace:
 [<ffffffff810670c8>] ? warn_slowpath_common+0x88/0xc0
 [<ffffffff8106711a>] ? warn_slowpath_null+0x1a/0x20
 [<ffffffff81122a4b>] ? __set_page_dirty_nobuffers+0x11b/0x150
 [<ffffffff8115fb90>] ? migrate_page_copy+0x1e0/0x1f0
 [<ffffffff8115fbd5>] ? migrate_page+0x35/0x50
 [<ffffffffa03664ae>] ? nfs_migrate_page+0x5e/0xf0 [nfs]
 [<ffffffff8115fee8>] ? move_to_new_page+0x98/0x180
 [<ffffffff811603e4>] ? migrate_pages+0x414/0x4a0
 [<ffffffff811565c0>] ? compaction_alloc+0x0/0x3e0
 [<ffffffff81155ecb>] ? compact_zone+0x4fb/0x780 
 [<ffffffff811563f1>] ? compact_zone_order+0xa1/0xe0
 [<ffffffff8115654c>] ? try_to_compact_pages+0x11c/0x190
 [<ffffffff81120408>] ? __alloc_pages_nodemask+0x5f8/0x8c0
 [<ffffffff81166338>] ? __mem_cgroup_try_charge+0x78/0x420
 [<ffffffff81154c5a>] ? alloc_pages_vma+0x9a/0x150
 [<ffffffff8116d74e>] ? do_huge_pmd_anonymous_page+0x13e/0x350
 [<ffffffff8100bc4e>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff81138863>] ? handle_mm_fault+0x263/0x2c0
 [<ffffffff81104016>] ? __perf_event_task_sched_out+0x36/0x50
 [<ffffffff81041509>] ? __do_page_fault+0x139/0x490
 [<ffffffff8100985e>] ? __switch_to+0x26e/0x320
 [<ffffffff814dd727>] ? thread_return+0x4e/0x787 
 [<ffffffff81140146>] ? do_mremap+0x406/0x550
 [<ffffffff814e30fe>] ? do_page_fault+0x3e/0xa0
 [<ffffffff814e0435>] ? page_fault+0x25/0x30
---[ end trace 770c7f9d5d97136f ]---

If anybody is interested, I'm prepared to help doing whatever I can to debug this issue.

Thanks, and sorry for the noise.

** We're not RHEL customers, we're just trying to evaluate the LUSTRE filesystem on our cluster and thus running the recommended configuration. The tests (the second trace in particular), however, were done under the *stock* RHEL kernel (just rebuilt from source). We're not actually using any of RHEL's userland.

