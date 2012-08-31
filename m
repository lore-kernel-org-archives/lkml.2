Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab2HaXDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 19:03:11 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49098 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753714Ab2HaXDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 19:03:08 -0400
X-Sasl-enc: GgwWuaQEdUHHgc0Y9s1ISuyaGUAA4+EB1mKVxxD6y510 1346454187
Date: Fri, 31 Aug 2012 20:02:57 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: rcu_bh stalls on 3.2.28
Message-ID: <20120831230256.GA7016@khazad-dum.debian.net>
References: <1345467862.22400.139.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345467862.22400.139.camel@deadeye.wl.decadent.org.uk>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just got one of these:

kernel: INFO: rcu_bh detected stall on CPU 2 (t=0 jiffies)
kernel: Pid: 0, comm: swapper/2 Not tainted 3.2.28+ #2
kernel: Call Trace:
kernel: <IRQ>  [<ffffffff810d1609>] __rcu_pending+0x159/0x400
kernel: [<ffffffff810d20bb>] rcu_check_callbacks+0x9b/0x120
kernel: [<ffffffff81089673>] update_process_times+0x43/0x80
kernel: [<ffffffff810a836f>] tick_sched_timer+0x5f/0xb0
kernel: [<ffffffff8109c097>] __run_hrtimer.isra.30+0x57/0x100
kernel: [<ffffffff8109c8f5>] hrtimer_interrupt+0xe5/0x220
kernel: [<ffffffff8104ce14>] smp_apic_timer_interrupt+0x64/0xa0
kernel: [<ffffffff8159b5cb>] apic_timer_interrupt+0x6b/0x70
kernel: <EOI>  [<ffffffff81315645>] ? intel_idle+0xe5/0x140
kernel: [<ffffffff81315623>] ? intel_idle+0xc3/0x140
kernel: [<ffffffff814420ee>] cpuidle_idle_call+0x8e/0xf0
kernel: [<ffffffff81032425>] cpu_idle+0xa5/0x110
kernel: [<ffffffff8158a9ac>] start_secondary+0x1e5/0x1ec

There are previous reports of these weird rcu_bh stalls with t=0 in the 3.2
and 3.3 branches as well:

https://lkml.org/lkml/2012/2/18/34
http://lkml.org/lkml/2012/3/28/175

another data point:
https://bugzilla.redhat.com/show_bug.cgi?id=806610

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
