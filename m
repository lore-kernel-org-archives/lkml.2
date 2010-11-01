Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab0KASvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:51:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:50683 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973Ab0KASvw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:51:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,275,1286175600"; 
   d="scan'208";a="853057631"
From: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
To: Nix <nix@esperi.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Date: Mon, 1 Nov 2010 12:51:49 -0600
Subject: RE: [E1000-devel] 2.6.36 abrupt total e1000e carrier loss (cured by
	reboot)
Thread-Topic: [E1000-devel] 2.6.36 abrupt total e1000e carrier loss (cured
 by	reboot)
Thread-Index: Act5Wl64uBUssOj4Te2B5IUzlJ1heQAmfgTA
Message-ID: <EA929A9653AAE14F841771FB1DE5A136602815A3C7@rrsmsx501.amr.corp.intel.com>
References: <87ocaaszx1.fsf@spindle.srvr.nix>
In-Reply-To: <87ocaaszx1.fsf@spindle.srvr.nix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Nix [mailto:nix@esperi.org.uk]
>Sent: Sunday, October 31, 2010 4:31 PM
>To: linux-kernel@vger.kernel.org
>Cc: e1000-devel@lists.sourceforge.net
>Subject: [E1000-devel] 2.6.36 abrupt total e1000e carrier loss (cured by
>reboot)
>
>It's the weekend, the time when busy servers get upgraded without
>annoying the users. I was just congratulating myself on an upgrade to
>2.6.36 with only a few problems (the NFS -ESTALE bug I have yet to
>localize, and a watchdog bug causing constant reboots which may well be
>the fault of the daemon), despite my pushing my luck by doing it on
>Halloween.
>
>But then, an hour or so after reboot, the server dropped off the net
>without warning, while it was idle of anything other than a trickle of
>NFS and forwarded web traffic. 'ip link' on the machine itself revealed
>that the interface on the e1000e dedicated to the gigabit subnet was in
>NO-CARRIER state (the other interface, running a 100Mb/s subnet, was
>fine). It was plainly this machine at fault: other machines on the
>gigabit subnet had carrier. Pulling the interface down and up again
>didn't help: nor did pulling the cable and reinserting it. Only a reboot
>cleared it.
>
>The netdev watchdog kicked in, but it wasn't very helpful, telling
>me only what I already knew. No other kernel messages were logged
>at the time the adapter fell off the net, or for minutes on either
>side.

Could you provide the output of lspci -vvv?

>
>Oct 31 22:50:44 spindle warning: [ 9691.647842] ------------[ cut here ]---
>---------
>Oct 31 22:50:44 spindle warning: [ 9691.648086] WARNING: at
>net/sched/sch_generic.c:258 dev_watchdog+0x147/0x1db()
>Oct 31 22:50:44 spindle warning: [ 9691.648511] Hardware name: empty
>Oct 31 22:50:44 spindle info: [ 9691.648746] NETDEV WATCHDOG: fastnet
>(e1000e): transmit queue 0 timed out
>Oct 31 22:50:44 spindle warning: [ 9691.649024] Modules linked in:
>firewire_ohci firewire_core
>Oct 31 22:50:44 spindle warning: [ 9691.649399] Pid: 0, comm: kworker/0:0
>Not tainted 2.6.36-dirty #1
>Oct 31 22:50:44 spindle warning: [ 9691.649639] Call Trace:
>Oct 31 22:50:44 spindle warning: [ 9691.649865]  <IRQ>
>[<ffffffff81062d12>] warn_slowpath_common+0x85/0x9d
>Oct 31 22:50:44 spindle warning: [ 9691.650177]  [<ffffffff81062dcd>]
>warn_slowpath_fmt+0x46/0x48
>Oct 31 22:50:44 spindle warning: [ 9691.650429]  [<ffffffff813c1a01>]
>dev_watchdog+0x147/0x1db
>Oct 31 22:50:44 spindle warning: [ 9691.650671]  [<ffffffff8106ed5a>]
>run_timer_softirq+0x210/0x2d8
>Oct 31 22:50:44 spindle warning: [ 9691.650921]  [<ffffffff813c18ba>] ?
>dev_watchdog+0x0/0x1db
>Oct 31 22:50:44 spindle warning: [ 9691.651185]  [<ffffffff81083776>] ?
>ktime_get+0x65/0xbe
>Oct 31 22:50:44 spindle warning: [ 9691.651429]  [<ffffffff8106845a>]
>__do_softirq+0xe3/0x1a5
>Oct 31 22:50:44 spindle warning: [ 9691.651674]  [<ffffffff810878d5>] ?
>tick_program_event+0x2a/0x2c
>Oct 31 22:50:44 spindle warning: [ 9691.651924]  [<ffffffff8102e18c>]
>call_softirq+0x1c/0x28
>Oct 31 22:50:44 spindle warning: [ 9691.652167]  [<ffffffff8102f4cc>]
>do_softirq+0x38/0x6d
>Oct 31 22:50:44 spindle warning: [ 9691.652412]  [<ffffffff810682cc>]
>irq_exit+0x3b/0x7d
>Oct 31 22:50:44 spindle warning: [ 9691.652658]  [<ffffffff81043b3c>]
>smp_apic_timer_interrupt+0x8d/0x9b
>Oct 31 22:50:44 spindle warning: [ 9691.652909]  [<ffffffff8102dc53>]
>apic_timer_interrupt+0x13/0x20
>Oct 31 22:50:44 spindle warning: [ 9691.653146]  <EOI>
>[<ffffffff8125657d>] ? acpi_idle_enter_bm+0x237/0x26b
>Oct 31 22:50:44 spindle warning: [ 9691.653446]  [<ffffffff81256578>] ?
>acpi_idle_enter_bm+0x232/0x26b
>Oct 31 22:50:44 spindle warning: [ 9691.653686]  [<ffffffff8135704b>]
>cpuidle_idle_call+0xa7/0x110
>Oct 31 22:50:44 spindle warning: [ 9691.653927]  [<ffffffff8102c5ab>]
>cpu_idle+0x63/0xd5
>Oct 31 22:50:44 spindle warning: [ 9691.654172]  [<ffffffff818b4f69>]
>start_secondary+0x1ae/0x1b2
>Oct 31 22:50:44 spindle warning: [ 9691.654415] ---[ end trace
>d27ba9fb6e9bfa53 ]---
>Oct 31 22:50:44 spindle err: [ 9691.654672] e1000e 0000:02:00.0: fastnet:
>Reset adapter
>
>A register dump from the failed adapter:
>
>Offset	Values
>--------	-----
>000:	 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>010:	 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>020:	 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>030:	 08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>040:	 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>050:	 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>060:	 06 88 00 00 06 88 00 00 00 00 00 00 00 00 00 00
>070:	 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

There is a known issue on some systems with ASPM enabled which may cause the device to lose link. If the output of lspci, (which I asked for above) shows ASPM as enabled for the Ethernet devices - make sure to disable it in the BIOS. 

Thanks,
Emil

