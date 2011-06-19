Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab1FSGkH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 02:40:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45873 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab1FSGkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 02:40:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=NAAcVKzqRGBUkq0JkAHtVkH5uh2k7g25jVoPuRvr8dTHi/lMSgw+OzrfzlC05DC2HC
         8ENqjckfYF7VdAOl2DYSB+kLv90GaxDtkwydxpWXXK/ijtTYJI3mnQ0RZBCB815Dc7n6
         rXQ3XV9dlVeg7peZgQKuooAhAdHRUQ+1VVj0o=
Message-ID: <4DFD99B2.1050902@gmail.com>
Date: Sat, 18 Jun 2011 23:39:46 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: WARNING: at kernel/timer.c:1011 del_timer_sync+0xa9/0xc4()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this just fired off with the latest..:
http://fpaste.org/CPE0/

[ 1118.316635] ------------[ cut here ]------------
[ 1118.316654] WARNING: at kernel/timer.c:1011 del_timer_sync+0xa9/0xc4()
[ 1118.316659] Hardware name: MacBookPro2,2
[ 1118.316664] Modules linked in: fuse cpufreq_ondemand 8021q 
acpi_cpufreq freq_table mperf garp stp llc ipt_REJECT nf_conntrack_ipv4 
nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables arc4 
radeon ath9k mac80211 ath9k_common ttm ath9k_hw btusb drm_kms_helper 
bluetooth drm uvcvideo videodev ath cfg80211 v4l2_compat_ioctl32 
i2c_algo_bit iTCO_wdt joydev i2c_i801 rfkill i2c_core appletouch 
applesmc iTCO_vendor_support input_polldev sky2 video apple_bl microcode 
[last unloaded: scsi_wait_scan]
[ 1118.316780] Pid: 0, comm: swapper Not tainted 3.0.0-rc3-00256-gde505e7 #1
[ 1118.316785] Call Trace:
[ 1118.316790]  <IRQ>  [<ffffffff8104c560>] warn_slowpath_common+0x83/0x9b
[ 1118.316809]  [<ffffffff8104c592>] warn_slowpath_null+0x1a/0x1c
[ 1118.316817]  [<ffffffff81059409>] del_timer_sync+0xa9/0xc4
[ 1118.316826]  [<ffffffff81059360>] ? process_timeout+0x10/0x10
[ 1118.316845]  [<ffffffffa0078971>] ath_reset+0x43/0x1d0 [ath9k]
[ 1118.316854]  [<ffffffff810524b6>] ? _local_bh_enable_ip+0xca/0xce
[ 1118.316871]  [<ffffffffa007ce71>] ath_tx_complete_aggr+0x7c3/0x7dd 
[ath9k]
[ 1118.316887]  [<ffffffffa007c6ae>] ? ath_tx_flush_tid+0xe0/0xe0 [ath9k]
[ 1118.316905]  [<ffffffffa007e396>] ath_tx_tasklet+0x235/0x2cb [ath9k]
[ 1118.316921]  [<ffffffffa0078d23>] ath9k_tasklet+0xf4/0x135 [ath9k]
[ 1118.316930]  [<ffffffff81052112>] tasklet_action+0x8d/0xed
[ 1118.316938]  [<ffffffff810526d4>] __do_softirq+0xdb/0x1ec
[ 1118.316948]  [<ffffffff8107bf55>] ? lock_release+0x165/0x18e
[ 1118.316959]  [<ffffffff814a93dc>] call_softirq+0x1c/0x30
[ 1118.316968]  [<ffffffff8100ab5a>] do_softirq+0x4b/0xa1
[ 1118.316976]  [<ffffffff810529f5>] irq_exit+0x5d/0xa8
[ 1118.316984]  [<ffffffff814a9c7e>] do_IRQ+0x8e/0xa5
[ 1118.316994]  [<ffffffff814a1953>] common_interrupt+0x13/0x13
[ 1118.316999]  <EOI>  [<ffffffff8129afab>] ? arch_local_irq_enable+0x8/0xd
[ 1118.317017]  [<ffffffff8107c471>] ? trace_hardirqs_on+0xd/0xf
[ 1118.317025]  [<ffffffff8129b981>] acpi_idle_enter_c1+0xa0/0xbe
[ 1118.317036]  [<ffffffff813a35a0>] cpuidle_idle_call+0xdb/0x175
[ 1118.317047]  [<ffffffff810082e9>] cpu_idle+0xaa/0xe4
[ 1118.317057]  [<ffffffff8147dfe3>] rest_init+0xb7/0xbe
[ 1118.317066]  [<ffffffff8147df2c>] ? csum_partial_copy_generic+0x16c/0x16c
[ 1118.317078]  [<ffffffff81b6db9a>] start_kernel+0x3d9/0x3e4
[ 1118.317088]  [<ffffffff81b6d2c4>] x86_64_start_reservations+0xaf/0xb3
[ 1118.317097]  [<ffffffff81b6d140>] ? early_idt_handlers+0x140/0x140
[ 1118.317106]  [<ffffffff81b6d3ca>] x86_64_start_kernel+0x102/0x111
[ 1118.317112] ---[ end trace efebbef7cc9c1d4c ]---
[ 1118.317120] ------------[ cut here ]------------
[ 1118.317129] WARNING: at kernel/softirq.c:98 
__local_bh_disable+0x45/0xb1()
[ 1118.317135] Hardware name: MacBookPro2,2
[ 1118.317139] Modules linked in: fuse cpufreq_ondemand 8021q 
acpi_cpufreq freq_table mperf garp stp llc ipt_REJECT nf_conntrack_ipv4 
nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables arc4 
radeon ath9k mac80211 ath9k_common ttm ath9k_hw btusb drm_kms_helper 
bluetooth drm uvcvideo videodev ath cfg80211 v4l2_compat_ioctl32 
i2c_algo_bit iTCO_wdt joydev i2c_i801 rfkill i2c_core appletouch 
applesmc iTCO_vendor_support input_polldev sky2 video apple_bl microcode 
[last unloaded: scsi_wait_scan]
[ 1118.317245] Pid: 0, comm: swapper Tainted: G        W 
3.0.0-rc3-00256-gde505e7 #1
[ 1118.317250] Call Trace:
[ 1118.317254]  <IRQ>  [<ffffffff8104c560>] warn_slowpath_common+0x83/0x9b
[ 1118.317269]  [<ffffffff814a11f9>] ? _raw_spin_lock_bh+0x16/0x45
[ 1118.317277]  [<ffffffff8104c592>] warn_slowpath_null+0x1a/0x1c
[ 1118.317286]  [<ffffffff810522aa>] __local_bh_disable+0x45/0xb1
[ 1118.317294]  [<ffffffff8105232d>] local_bh_disable+0x17/0x19
[ 1118.317303]  [<ffffffff814a11f9>] _raw_spin_lock_bh+0x16/0x45
[ 1118.317318]  [<ffffffffa007898c>] ath_reset+0x5e/0x1d0 [ath9k]
[ 1118.317327]  [<ffffffff810524b6>] ? _local_bh_enable_ip+0xca/0xce
[ 1118.317343]  [<ffffffffa007ce71>] ath_tx_complete_aggr+0x7c3/0x7dd 
[ath9k]
[ 1118.317359]  [<ffffffffa007c6ae>] ? ath_tx_flush_tid+0xe0/0xe0 [ath9k]
[ 1118.317376]  [<ffffffffa007e396>] ath_tx_tasklet+0x235/0x2cb [ath9k]
[ 1118.317392]  [<ffffffffa0078d23>] ath9k_tasklet+0xf4/0x135 [ath9k]
[ 1118.317401]  [<ffffffff81052112>] tasklet_action+0x8d/0xed
[ 1118.317410]  [<ffffffff810526d4>] __do_softirq+0xdb/0x1ec
[ 1118.317418]  [<ffffffff8107bf55>] ? lock_release+0x165/0x18e
[ 1118.317427]  [<ffffffff814a93dc>] call_softirq+0x1c/0x30
[ 1118.317435]  [<ffffffff8100ab5a>] do_softirq+0x4b/0xa1
[ 1118.317443]  [<ffffffff810529f5>] irq_exit+0x5d/0xa8
[ 1118.317450]  [<ffffffff814a9c7e>] do_IRQ+0x8e/0xa5
[ 1118.317459]  [<ffffffff814a1953>] common_interrupt+0x13/0x13
[ 1118.317464]  <EOI>  [<ffffffff8129afab>] ? arch_local_irq_enable+0x8/0xd
[ 1118.317479]  [<ffffffff8107c471>] ? trace_hardirqs_on+0xd/0xf
[ 1118.317487]  [<ffffffff8129b981>] acpi_idle_enter_c1+0xa0/0xbe
[ 1118.317497]  [<ffffffff813a35a0>] cpuidle_idle_call+0xdb/0x175
[ 1118.317506]  [<ffffffff810082e9>] cpu_idle+0xaa/0xe4
[ 1118.317514]  [<ffffffff8147dfe3>] rest_init+0xb7/0xbe
[ 1118.317522]  [<ffffffff8147df2c>] ? csum_partial_copy_generic+0x16c/0x16c
[ 1118.317531]  [<ffffffff81b6db9a>] start_kernel+0x3d9/0x3e4
[ 1118.317540]  [<ffffffff81b6d2c4>] x86_64_start_reservations+0xaf/0xb3
[ 1118.317549]  [<ffffffff81b6d140>] ? early_idt_handlers+0x140/0x140
[ 1118.317558]  [<ffffffff81b6d3ca>] x86_64_start_kernel+0x102/0x111
[ 1118.317560] ---[ end trace efebbef7cc9c1d4d ]---


I'm not on the list so please Cc's me if you have/need any info.

Justin P. Mattock
