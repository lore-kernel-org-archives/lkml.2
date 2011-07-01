Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab1GAFmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 01:42:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56593 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab1GAFmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 01:42:46 -0400
Message-ID: <4E0D5E42.20702@gmail.com>
Date: Thu, 30 Jun 2011 22:42:26 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: WARNING: at kernel/timer.c:1011 del_timer_sync+0xa9/0xc4()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

not sure if somebody has posted this or not(did post last week, but no 
replies on this) I would bisect, but have no time(maybe in the future).

anyways let me know if you need more info.
dmesg here:
http://fpaste.org/wLxM/


[ 43.108967] SELinux: initialized (dev fusectl, type fusectl), uses 
genfs_contexts
[ 561.844541] ath: Failed to stop TX DMA!
[ 1514.074565] ------------[ cut here ]------------
[ 1514.074584] WARNING: at kernel/timer.c:1011 del_timer_sync+0xa9/0xc4()
[ 1514.074590] Hardware name: MacBookPro2,2
[ 1514.074595] Modules linked in: fuse 8021q cpufreq_ondemand garp stp 
acpi_cpufreq llc freq_table mperf ipt_REJECT nf_conntrack_ipv4 
nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables arc4 
radeon ath9k mac80211 ttm ath9k_common drm_kms_helper ath9k_hw drm ath 
cfg80211 uvcvideo videodev btusb bluetooth sky2 v4l2_compat_ioctl32 
appletouch iTCO_wdt i2c_i801 joydev i2c_algo_bit iTCO_vendor_support 
applesmc rfkill i2c_core input_polldev apple_bl video microcode [last 
unloaded: scsi_wait_scan]
[ 1514.074730] Pid: 1550, comm: threaded-ml Not tainted 
3.0.0-rc5-00080-gca56a95 #6
[ 1514.074735] Call Trace:
[ 1514.074739] <IRQ> [<ffffffff8104c560>] warn_slowpath_common+0x83/0x9b
[ 1514.074758] [<ffffffff8104c592>] warn_slowpath_null+0x1a/0x1c
[ 1514.074767] [<ffffffff81059409>] del_timer_sync+0xa9/0xc4
[ 1514.074775] [<ffffffff81059360>] ? process_timeout+0x10/0x10
[ 1514.074794] [<ffffffffa003c971>] ath_reset+0x43/0x1d0 [ath9k]
[ 1514.074804] [<ffffffff810524b6>] ? _local_bh_enable_ip+0xca/0xce
[ 1514.074821] [<ffffffffa0040e71>] ath_tx_complete_aggr+0x7c3/0x7dd [ath9k]
[ 1514.074837] [<ffffffffa00406ae>] ? ath_tx_flush_tid+0xe0/0xe0 [ath9k]
[ 1514.074855] [<ffffffffa0042396>] ath_tx_tasklet+0x235/0x2cb [ath9k]
[ 1514.074871] [<ffffffffa003cd23>] ath9k_tasklet+0xf4/0x135 [ath9k]
[ 1514.074880] [<ffffffff81052112>] tasklet_action+0x8d/0xed
[ 1514.074889] [<ffffffff810526d4>] __do_softirq+0xdb/0x1ec
[ 1514.074899] [<ffffffff8107c0c9>] ? lock_release+0x165/0x18e
[ 1514.074910] [<ffffffff814a921c>] call_softirq+0x1c/0x30
[ 1514.074919] [<ffffffff8100ab5a>] do_softirq+0x4b/0xa1
[ 1514.074927] [<ffffffff810529f5>] irq_exit+0x5d/0xa8
[ 1514.074935] [<ffffffff814a9abe>] do_IRQ+0x8e/0xa5
[ 1514.074945] [<ffffffff814a1793>] common_interrupt+0x13/0x13
[ 1514.074950] <EOI> [<ffffffff81071178>] ? current_kernel_time+0x13/0x34
[ 1514.074968] [<ffffffff814a7fba>] ? sysret_check+0x2e/0x69
[ 1514.074977] [<ffffffff8107c5b4>] ? trace_hardirqs_on_caller+0x10b/0x12f
[ 1514.074988] [<ffffffff8109e501>] audit_syscall_entry+0x11c/0x148
[ 1514.074998] [<ffffffff8122ef3e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 1514.075076] [<ffffffff814a8089>] auditsys+0x19/0x4a
[ 1514.075084] ---[ end trace 834e058f0ef2c378 ]---
[ 1514.075092] ------------[ cut here ]------------
[ 1514.075101] WARNING: at kernel/softirq.c:98 
__local_bh_disable+0x45/0xb1()
[ 1514.075108] Hardware name: MacBookPro2,2
[ 1514.075113] Modules linked in: fuse 8021q cpufreq_ondemand garp stp 
acpi_cpufreq llc freq_table mperf ipt_REJECT nf_conntrack_ipv4 
nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables arc4 
radeon ath9k mac80211 ttm ath9k_common drm_kms_helper ath9k_hw drm ath 
cfg80211 uvcvideo videodev btusb bluetooth sky2 v4l2_compat_ioctl32 
appletouch iTCO_wdt i2c_i801 joydev i2c_algo_bit iTCO_vendor_support 
applesmc rfkill i2c_core input_polldev apple_bl video microcode [last 
unloaded: scsi_wait_scan]
[ 1514.075271] Pid: 1550, comm: threaded-ml Tainted: G W 
3.0.0-rc5-00080-gca56a95 #6
[ 1514.075278] Call Trace:
[ 1514.075283] <IRQ> [<ffffffff8104c560>] warn_slowpath_common+0x83/0x9b
[ 1514.075303] [<ffffffff814a1061>] ? _raw_spin_lock_bh+0x16/0x45
[ 1514.075313] [<ffffffff8104c592>] warn_slowpath_null+0x1a/0x1c
[ 1514.075324] [<ffffffff810522aa>] __local_bh_disable+0x45/0xb1
[ 1514.075333] [<ffffffff8105232d>] local_bh_disable+0x17/0x19
[ 1514.075344] [<ffffffff814a1061>] _raw_spin_lock_bh+0x16/0x45
[ 1514.075362] [<ffffffffa003c98c>] ath_reset+0x5e/0x1d0 [ath9k]
[ 1514.075372] [<ffffffff810524b6>] ? _local_bh_enable_ip+0xca/0xce
[ 1514.075391] [<ffffffffa0040e71>] ath_tx_complete_aggr+0x7c3/0x7dd [ath9k]
[ 1514.075409] [<ffffffffa00406ae>] ? ath_tx_flush_tid+0xe0/0xe0 [ath9k]
[ 1514.075428] [<ffffffffa0042396>] ath_tx_tasklet+0x235/0x2cb [ath9k]
[ 1514.075445] [<ffffffffa003cd23>] ath9k_tasklet+0xf4/0x135 [ath9k]
[ 1514.075456] [<ffffffff81052112>] tasklet_action+0x8d/0xed
[ 1514.075465] [<ffffffff810526d4>] __do_softirq+0xdb/0x1ec
[ 1514.075476] [<ffffffff8107c0c9>] ? lock_release+0x165/0x18e
[ 1514.075487] [<ffffffff814a921c>] call_softirq+0x1c/0x30
[ 1514.075496] [<ffffffff8100ab5a>] do_softirq+0x4b/0xa1
[ 1514.075505] [<ffffffff810529f5>] irq_exit+0x5d/0xa8
[ 1514.075514] [<ffffffff814a9abe>] do_IRQ+0x8e/0xa5
[ 1514.075524] [<ffffffff814a1793>] common_interrupt+0x13/0x13
[ 1514.075529] <EOI> [<ffffffff81071178>] ? current_kernel_time+0x13/0x34
[ 1514.075548] [<ffffffff814a7fba>] ? sysret_check+0x2e/0x69
[ 1514.075559] [<ffffffff8107c5b4>] ? trace_hardirqs_on_caller+0x10b/0x12f
[ 1514.075570] [<ffffffff8109e501>] audit_syscall_entry+0x11c/0x148
[ 1514.075580] [<ffffffff8122ef3e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 1514.075590] [<ffffffff814a8089>] auditsys+0x19/0x4a
[ 1514.075596] ---[ end trace 834e058f0ef2c379 ]---

Justin P. Mattock
