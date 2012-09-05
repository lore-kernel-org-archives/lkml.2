Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428Ab2IEKy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:54:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45446 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab2IEKy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:54:56 -0400
Subject: Re: WARNING: cpu_is_offline() at native_smp_send_reschedule()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
In-Reply-To: <5046D69F.9000705@linux.vnet.ibm.com>
References: <20120905011152.GA19853@localhost>
	 <5046D69F.9000705@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Sep 2012 12:54:40 +0200
Message-ID: <1346842480.2461.11.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 12:35 +0800, Michael Wang wrote:
> > [   10.968565] reboot: machine restart
> > [   10.983510] ------------[ cut here ]------------
> > [   10.984218] WARNING: at /c/kernel-tests/src/stable/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x46/0x50()
> > [   10.985880] Pid: 88, comm: kpktgend_0 Not tainted 3.6.0-rc3-00005-gb374aa1 #10
> > [   10.987185] Call Trace:
> > [   10.987506]  [<7902f42a>] warn_slowpath_common+0x5a/0x80
> > [   10.987506]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
> > [   10.987506]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
> > [   10.987506]  [<7902f4fd>] warn_slowpath_null+0x1d/0x20
> > [   10.987506]  [<7901ee16>] native_smp_send_reschedule+0x46/0x50
> 
> So this cpu try to fire a nohz balance kick ipi to an offline cpu?
> 
> May be we are choosing a wrong cpu to kick but that's not the point,
> what I can't understand is why this cpu could do this kick.
> 
> We have nohz_kick_needed() to check whether current cpu should do kick ,
> and the first condition we need to match is that current cpu should be
> idle, but the trace show current pid is 88 not 0.
> 
> We should add Peter to cc list, may be he will be interested on what
> happened.

> > [   10.987506]  [<7905fdad>] trigger_load_balance+0x1bd/0x250
> > [   10.987506]  [<79056d14>] scheduler_tick+0xd4/0x100
> > [   10.987506]  [<7903bde5>] update_process_times+0x55/0x70 

Hmm, added both venki and suresh as they touched it last ;-)

I suppose you're running a hotplug loop along with your workload?

