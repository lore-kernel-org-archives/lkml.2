Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab2ICRYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 13:24:55 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33308 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753273Ab2ICRYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 13:24:53 -0400
X-Sasl-enc: u+TSfFWrXs4CfsOr8K5lo2W5oG83aOL8IBoplbz/sDUm 1346693092
Date: Mon, 3 Sep 2012 14:24:41 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: rcu_bh stalls on 3.2.28
Message-ID: <20120903172441.GA19614@khazad-dum.debian.net>
References: <1345467862.22400.139.camel@deadeye.wl.decadent.org.uk>
 <20120831230256.GA7016@khazad-dum.debian.net>
 <50444897.6070803@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50444897.6070803@linux.vnet.ibm.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Sep 2012, Michael Wang wrote:
> On 09/01/2012 07:02 AM, Henrique de Moraes Holschuh wrote:
> > Just got one of these:
> > 
> > kernel: INFO: rcu_bh detected stall on CPU 2 (t=0 jiffies)
> > kernel: Pid: 0, comm: swapper/2 Not tainted 3.2.28+ #2
> > kernel: Call Trace:
> > kernel: <IRQ>  [<ffffffff810d1609>] __rcu_pending+0x159/0x400
> > kernel: [<ffffffff810d20bb>] rcu_check_callbacks+0x9b/0x120
> > kernel: [<ffffffff81089673>] update_process_times+0x43/0x80
> > kernel: [<ffffffff810a836f>] tick_sched_timer+0x5f/0xb0
> > kernel: [<ffffffff8109c097>] __run_hrtimer.isra.30+0x57/0x100
> > kernel: [<ffffffff8109c8f5>] hrtimer_interrupt+0xe5/0x220
> > kernel: [<ffffffff8104ce14>] smp_apic_timer_interrupt+0x64/0xa0
> > kernel: [<ffffffff8159b5cb>] apic_timer_interrupt+0x6b/0x70
> > kernel: <EOI>  [<ffffffff81315645>] ? intel_idle+0xe5/0x140
> > kernel: [<ffffffff81315623>] ? intel_idle+0xc3/0x140
> > kernel: [<ffffffff814420ee>] cpuidle_idle_call+0x8e/0xf0
> > kernel: [<ffffffff81032425>] cpu_idle+0xa5/0x110
> > kernel: [<ffffffff8158a9ac>] start_secondary+0x1e5/0x1ec
> 
> Hi, Henrique
> 
> rsp->gp_start and rsp->jiffies_stall should already set before we start
> check stall for this gp, but the INFO show that we have a current
> jiffies which bigger then rsp->jiffies_stall but equal to rsp->gp_start,
> really strange...
> 
> Could you please have a try on the latest kernel and confirm whether
> this issue still exist?

It is a production box, it is difficult to run a -rc kernel there.

And the stalls are very rare, too.  That's the only one I got, so at this
point I cannot tell you whether something fixed the problem or not, just try
to give you clues if a stall does happen.

> BTW:
> 	Is this stall info comes from a virtual machine?

No, it runs on baremetal.  The box has one Xeon X5550 processor, 4 cores, 8
threads, and it is allowed to go into C1, C3 and C6 (which it does very very
often).

It might be some sort of race related to SMIs?  The worst-case SMM-induced
delay on this box is quite high (I don't recall if that means 150ms or
150us), as measured by the Intel BITS[1].

[1] http://biosbits.org/

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
