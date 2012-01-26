Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab2AZPfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 10:35:22 -0500
Received: from bar.sig21.net ([80.81.252.164]:32878 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab2AZPfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 10:35:20 -0500
Date: Thu, 26 Jan 2012 16:35:13 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-3.2.1 + KVM: TSC unstable on Core i5-2400S / H67
Message-ID: <20120126153513.GA2963@sig21.net>
References: <20120124113608.GA16876@sig21.net>
 <20120125122702.GA30888@amt.cnet>
 <20120125132503.GA3399@sig21.net>
 <20120126094659.GA25282@sig21.net>
 <4F21668F.8080005@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F21668F.8080005@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 03:43:27PM +0100, Jan Kiszka wrote:
> On 2012-01-26 10:46, Johannes Stezenbach wrote:
> > [16353.270435] Restarting tasks ... 
> > [16353.270612] BUG: spinlock bad magic on CPU#2, dhclient3/2590
> > [16353.274702]  lock: ffff880127b9ce08, .magic: 00000000, .owner: dhclient3/2590, .owner_cpu: 2
> > [16353.276594] Pid: 2590, comm: dhclient3 Not tainted 3.2.1 #2
> > [16353.278294] done.
> > [16353.278314] video LNXVIDEO:00: Restoring backlight state
> > [16353.281627] Call Trace:
> > [16353.281633]  [<ffffffff81552515>] spin_dump+0x8a/0x8f
> > [16353.281636]  [<ffffffff81552540>] spin_bug+0x26/0x28
> > [16353.281639]  [<ffffffff81285af8>] do_raw_spin_unlock+0x1e/0x83
> > [16353.281643]  [<ffffffff8155912e>] _raw_spin_unlock_irq+0x28/0x5b
> > [16353.281647]  [<ffffffff8105e427>] get_signal_to_deliver+0x546/0x57c
> > [16353.281651]  [<ffffffff81001572>] do_signal+0x3e/0x62f
> > [16353.281654]  [<ffffffff815595b8>] ? retint_restore_args+0x13/0x13
> > [16353.281657]  [<ffffffff81280079>] ? copy_user_generic_string+0x19/0x40
> > [16353.281661]  [<ffffffff81142e8c>] ? poll_select_copy_remaining+0xc5/0xe9
> > [16353.281664]  [<ffffffff81001ba8>] do_notify_resume+0x2c/0x53
> > [16353.281666]  [<ffffffff8128137e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> > [16353.281669]  [<ffffffff8155a1d6>] int_signal+0x12/0x17
> > [16353.472289] tsc = fffffd60248a9f39 last_guest_tsc = 229a823d4b88
> > [    0.006666] Marking TSC unstable due to KVM discovered backwards TSC
> > [16362.155512] Switching to clocksource hpet
> > [16363.617844] atl1c 0000:06:00.0: atl1c: eth0 NIC Link is Up<1000 Mbps Full Duplex>
> > [16363.618145] br0: port 1(eth0) entering forwarding state
> > [16363.618153] br0: port 1(eth0) entering forwarding state
> 
> Are you suspending your host while a VM is running? There is mosto

Yes, that's what I'm doing.

> probably a long-pending bug in the KVM TSC check logic that declares
> that clocksource unstable after resume. I'm seeing this here for ages
> and complained about it from the beginning (but I never debugged it :-/).

Hm, OK.  I hope someone has an idea how to fix it.  I'm ready to test patches.

> Of course, this doesn't explain your corrupted spin lock. That might be
> a different issue.

Yes, most probably it is something different since I haven't seen this
before.  However, I didn't use 3.2.1 long.  Now I updated
to 3.2.2 and enabled a few more debug options.  We'll see if it
triggers again.


Thanks
Johannes
