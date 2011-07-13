Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab1GMRTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 13:19:45 -0400
Received: from mail.candelatech.com ([208.74.158.172]:57656 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab1GMRTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 13:19:44 -0400
Message-ID: <4E1DD3AF.80201@candelatech.com>
Date: Wed, 13 Jul 2011 10:19:43 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: WARNING at watchdog_overflow_callback in 3.0-rc7+
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is on the same nfs testing machine I've been posting about.  This
has some additional nfs patches included, running tests to mount, do io, unmount
over and over again.  Seems that the NFS bugs might be finally fixed, but
system is still un-stable in general:

WARNING: at /home/greearb/git/linux-3.0-nfs/kernel/watchdog.c:240 watchdog_overflow_callback+0x97/0xa2()
Hardware name: X7DBU
Watchdog detected hard LOCKUP on cpu 4
Modules linked in: 8021q garp xt_addrtype xt_TPROXY nf_tproxy_core xt_socket nf_defrag_ipv6 xt_set ip_set nfnetlink xt_connlimit macvlan ip6table_filter 
ip6_tables ebtable_nat ebtables pktgen fuse iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi stp llc nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipv6 
kvm_intel kvm uinput i5k_amb i5000_edac ioatdma pcspkr iTCO_wdt e1000e dca iTCO_vendor_support edac_core microcode shpchp i2c_i801 floppy radeon ttm 
drm_kms_helper drm hwmon i2c_algo_bit i2c_core [last unloaded: xt_connmark]
Pid: 18179, comm: btserver Not tainted 3.0.0-rc7+ #23
Call Trace:
  <NMI>  [<ffffffff81049f56>] warn_slowpath_common+0x80/0x98
  [<ffffffff8104a002>] warn_slowpath_fmt+0x41/0x43
  [<ffffffff810a1bac>] watchdog_overflow_callback+0x97/0xa2
  [<ffffffff810c5fcb>] __perf_event_overflow+0x11f/0x1d1
  [<ffffffff810bf41f>] ? rcu_read_unlock+0x21/0x23
  [<ffffffff810c16e6>] ? perf_event_update_userpage+0xfe/0x103
  [<ffffffff810c6488>] perf_event_overflow+0x14/0x16
  [<ffffffff8101a4a6>] intel_pmu_handle_irq+0x46d/0x4e0
  [<ffffffff814807d6>] perf_event_nmi_handler+0x39/0x81
  [<ffffffff81482027>] notifier_call_chain+0x54/0x81
  [<ffffffff814820b2>] __atomic_notifier_call_chain+0x5e/0x90
  [<ffffffff81482054>] ? notifier_call_chain+0x81/0x81
  [<ffffffff814820f3>] atomic_notifier_call_chain+0xf/0x11
  [<ffffffff81482123>] notify_die+0x2e/0x30
  [<ffffffff8147ff13>] do_nmi+0x80/0x242
  [<ffffffff8147f950>] nmi+0x20/0x39
  [<ffffffff81231ee1>] ? do_raw_spin_lock+0x11d/0x13c
  <<EOE>>  [<ffffffff8147e7ed>] _raw_spin_lock_irqsave+0x56/0x60
  [<ffffffff8106aed5>] ? lock_hrtimer_base+0x25/0x4b
  [<ffffffff8106aed5>] lock_hrtimer_base+0x25/0x4b
  [<ffffffff8106af50>] hrtimer_try_to_cancel+0x15/0x46
  [<ffffffff8106af95>] hrtimer_cancel+0x14/0x20
  [<ffffffff81370abf>] rtc_irq_set_state+0x8b/0xaf
  [<ffffffff81371c10>] rtc_dev_release+0x35/0x58
  [<ffffffff8111b07c>] fput+0x117/0x1b2
  [<ffffffff81117b56>] filp_close+0x6d/0x78
  [<ffffffff8104c2f7>] put_files_struct+0xca/0x190
  [<ffffffff8104c403>] exit_files+0x46/0x4e
  [<ffffffff8104deb7>] do_exit+0x2b5/0x760
  [<ffffffff8111b108>] ? fput+0x1a3/0x1b2
  [<ffffffff8122d744>] ? lockdep_sys_exit_thunk+0x35/0x67
  [<ffffffff8104e3e0>] do_group_exit+0x7e/0xa9
  [<ffffffff8104e41d>] sys_exit_group+0x12/0x16
  [<ffffffff81484fd2>] system_call_fastpath+0x16/0x1b
---[ end trace e90038ab73718706 ]---

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

