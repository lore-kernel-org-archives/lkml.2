Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab1KUM0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 07:26:21 -0500
Received: from server655-han.de-nserver.de ([85.158.177.45]:56306 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751586Ab1KUM0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 07:26:20 -0500
Message-ID: <4ECA4362.2050307@profihost.ag>
Date: Mon, 21 Nov 2011 13:26:10 +0100
From: Stefan Priebe <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Stable Tree <stable@kernel.org>
CC: stable@vger.kernel.org, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Jesse Brandeburg <jesse.brandeburg@intel.com> Bruce Allan" 
	<bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>
Subject: Kernel v3.0.8 igb driver dies when pulling network cable
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by s.priebe@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi List,

i triggered this bug nultiple times by just pulling out the network 
cable while running v3.0.8.

[  838.740689] igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow 
Control: RX/TX
[  838.761489] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  848.654167] ------------[ cut here ]------------
[  848.673476] WARNING: at net/sched/sch_generic.c:255 
dev_watchdog+0x25d/0x270()
[  848.692857] Hardware name: X8DTN
[  848.712062] NETDEV WATCHDOG: eth0 (igb): transmit queue 0 timed out
[  848.731613] Modules linked in: xt_tcpudp iptable_filter ip_tables 
x_tables coretemp k8temp ipv6 dm_snapshot dm_mod
[  848.752265] Pid: 0, comm: swapper Not tainted 2.6.40.8intel #3
[  848.773156] Call Trace:
[  848.793730]  <IRQ>  [<ffffffff8153be3d>] ? dev_watchdog+0x25d/0x270
[  848.793740]  [<ffffffff81045eb0>] warn_slowpath_common+0x80/0xc0
[  848.793744]  [<ffffffff81045fe9>] warn_slowpath_fmt+0x69/0x70
[  848.793749]  [<ffffffff81012288>] ? intel_pmu_nhm_enable_all+0x158/0x190
[  848.793755]  [<ffffffff81469917>] ? igb_poll+0x807/0xde0
[  848.793758]  [<ffffffff810125e4>] ? x86_pmu_enable+0x1f4/0x270
[  848.793763]  [<ffffffff810b1666>] ? perf_event_task_tick+0xa6/0x2e0
[  848.793767]  [<ffffffff8153be3d>] dev_watchdog+0x25d/0x270
[  848.793772]  [<ffffffff8105511c>] run_timer_softirq+0x1cc/0x320
[  848.793776]  [<ffffffff8153bbe0>] ? __netdev_watchdog_up+0x80/0x80
[  848.793782]  [<ffffffff8101d0d8>] ? lapic_next_event+0x18/0x20
[  848.793787]  [<ffffffff8104c390>] __do_softirq+0xd0/0x1c0
[  848.793793]  [<ffffffff815e288c>] call_softirq+0x1c/0x30
[  848.793798]  [<ffffffff810047b5>] do_softirq+0x55/0x90
[  848.793801]  [<ffffffff8104c16d>] irq_exit+0xad/0xe0
[  848.793805]  [<ffffffff8101ddc9>] smp_apic_timer_interrupt+0x69/0xa0
[  848.793809]  [<ffffffff815e2053>] apic_timer_interrupt+0x13/0x20
[  848.793811]  <EOI>  [<ffffffff81317093>] ? intel_idle+0xb3/0x120
[  848.793820]  [<ffffffff81317075>] ? intel_idle+0x95/0x120
[  848.793824]  [<ffffffff814f7d5c>] cpuidle_idle_call+0xdc/0x1a0
[  848.793829]  [<ffffffff81002091>] cpu_idle+0xb1/0x110
[  848.793833]  [<ffffffff815c54dd>] rest_init+0x6d/0x80
[  848.793837]  [<ffffffff81acbc5d>] start_kernel+0x3a2/0x44c
[  848.793847]  [<ffffffff81acb295>] x86_64_start_reservations+0xa5/0xc9
[  848.793851]  [<ffffffff81acb3a2>] x86_64_start_kernel+0xe9/0xfb
[  848.793853] ---[ end trace 737c145f3289e2ce ]---
[  848.794085] igb 0000:0a:00.0: eth0: Reset adapter
[  849.019407] eth0: no IPv6 routers present
[  851.626949] igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow 
Control: RX/TX
[  861.637255] igb 0000:0a:00.0: eth0: Reset adapter
[  864.479252] igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow 
Control: RX/TX

Greet Stefan
