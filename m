Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab0LWPgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 10:36:21 -0500
Received: from tomasu.net ([64.85.170.234]:52629 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab0LWPgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 10:36:20 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: intermittent problem with skge driver/hardware
Date: Thu, 23 Dec 2010 08:36:14 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36.1+; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
References: <201012220856.38279.thomas@fjellstrom.ca>
In-Reply-To: <201012220856.38279.thomas@fjellstrom.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012230836.14668.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On December 22, 2010, you wrote:
> I've been getting a strange issue, where traffic over one of the built in
> skge nics in my server will just die. No traffic can make it over, but
> it'll claim the device is up:
> 
> dmesg:
> [85007.362349] skge 0000:05:06.0: PCI error cmd=0x7 status=0x22b0
> [85007.362735] skge 0000:05:06.0: unable to clear error (so ignoring them)
> [85076.960083] ------------[ cut here ]------------
> [85076.960963] WARNING: at net/sched/sch_generic.c:258
> dev_watchdog+0xfc/0x19b() [85076.961799] Hardware name: GA-MA790FXT-UD5P
> [85076.962654] NETDEV WATCHDOG: eth2 (skge): transmit queue 0 timed out
> [85076.963520] Modules linked in: tun ip6table_filter ip6_tables
> iptable_filter ip_tables x_tables powernow_k8 mperf cpufreq_conservative
> cpufreq_stats cpufreq_userspace cpufreq_$ [85076.970411] Pid: 0, comm:
> kworker/0:1 Not tainted 2.6.36.1+ #5
> [85076.971401] Call Trace:
> [85076.971406]  <IRQ>  [<ffffffff8103687e>] ?
> warn_slowpath_common+0x78/0x8c [85076.971426]  [<ffffffff81036931>] ?
> warn_slowpath_fmt+0x45/0x4a [85076.971434]  [<ffffffff8122b866>] ?
> netif_tx_lock+0x3d/0x64
> [85076.971442]  [<ffffffff8122b989>] ? dev_watchdog+0xfc/0x19b
> [85076.971450]  [<ffffffff8104097a>] ? cascade+0x60/0x7a
> [85076.971458]  [<ffffffff81026bda>] ? check_preempt_curr+0x1a/0x31
> [85076.971466]  [<ffffffff8104232e>] ? run_timer_softirq+0x1c2/0x284
> [85076.971475]  [<ffffffff8109cece>] ? perf_event_task_tick+0x6a/0x185
> [85076.971483]  [<ffffffff8122b88d>] ? dev_watchdog+0x0/0x19b
> [85076.971493]  [<ffffffff8103bec4>] ? __do_softirq+0xde/0x19e
> [85076.971501]  [<ffffffff81059f8a>] ? tick_dev_program_event+0x33/0xf0
> [85076.971510]  [<ffffffff8100384c>] ? call_softirq+0x1c/0x28
> [85076.971517]  [<ffffffff81004c01>] ? do_softirq+0x31/0x63
> [85076.971525]  [<ffffffff8103bd4b>] ? irq_exit+0x36/0x79
> [85076.971534]  [<ffffffff81017b4b>] ? smp_apic_timer_interrupt+0x87/0x95
> [85076.971541]  [<ffffffff81003313>] ? apic_timer_interrupt+0x13/0x20
> [85076.971545]  <EOI>  [<ffffffff8100942c>] ? default_idle+0x36/0x4c
> [85076.971557]  [<ffffffff8100940c>] ? default_idle+0x16/0x4c
> [85076.971563]  [<ffffffff81001a73>] ? cpu_idle+0xa9/0x11b
> [85076.971572]  [<ffffffff81290cc0>] ? _raw_spin_unlock_irqrestore+0x4/0x5
> [85076.971580]  [<ffffffff8128a265>] ? start_secondary+0x1db/0x1e1
> [85076.971586] ---[ end trace b7c537207c4cd873 ]---
> [88574.943219] skge 0000:05:06.0: eth2: Link is down
> [88574.983011] wan_bridge: port 1(eth2) entering forwarding state
> [88579.652590] skge 0000:05:06.0: eth2: Link is up at 100 Mbps, full
> duplex, flow control both [88579.656363] wan_bridge: port 1(eth2) entering
> forwarding state
> [88579.657347] wan_bridge: port 1(eth2) entering forwarding state
> 
> lspci:
> 05:06.0 Ethernet controller: D-Link System Inc DGE-530T Gigabit Ethernet
> Adapter (rev 11) (rev 11)
> 
> I'm wondering if this is a hardware issue, and I'll just have to use a
> different nic, or maybe some kind of driver issue? I don't know.
> 
> I've tried rmmoding the driver and reloading, but it never seems to get
> me my networking back, maybe due to the bridging+kvm setup I have.

I should make a quick correction, the skge adapter is not built in, rather its 
a plain old D-Link GbE pci card. If it happens again, I'll try one of my 
spares (bought several D-Link cards prior to upgrading all my hardware, so 
most of them are redundant now, as the boards all have GbE built in).

If anyone else knows what might be the cause, please let me know.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
