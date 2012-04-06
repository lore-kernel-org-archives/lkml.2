Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab2DGWOJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 18:14:09 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37122 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab2DGWOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 18:14:07 -0400
Date: Fri, 6 Apr 2012 10:52:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 3.3.0: "INFO: rcu_bh detected stall on CPU 3 (t=0 jiffies)"
Message-ID: <20120406175210.GA2421@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120327141536.GP25457@charite.de>
 <20120328112822.GH16671@charite.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120328112822.GH16671@charite.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040722-4242-0000-0000-000001478CE2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 01:28:22PM +0200, Ralf Hildebrandt wrote:
> * Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>:
> > 
> > Mar 23 11:54:00 mail kernel:
> > Mar 23 11:54:00 mail kernel: [347213.025005] INFO: rcu_bh detected stall on CPU 3 (t=0 jiffies)
> > Mar 23 11:54:00 mail kernel: [347213.025005] Pid: 12654, comm: cleanup Not tainted 3.3.0 #1
> > Mar 23 11:54:00 mail kernel: [347213.025005] Call Trace:
> > Mar 23 11:54:00 mail kernel: [347213.025005]  [<c1062ccb>] ? __rcu_pending+0x10a/0x311
> > Mar 23 11:54:00 mail kernel: [347213.025005]  [<c106388d>] ? rcu_check_callbacks+0x9b/0xa1
> > Mar 23 11:54:00 mail kernel: [347213.025005]  [<c102c434>] ? update_process_times+0x2a/0x53
> > Mar 23 11:54:00 mail kernel: [347213.025005]  [<c104f206>] ? tick_sched_timer+0x4f/0x90
> > Mar 23 11:54:00 mail kernel: [347213.025005]  [<c103a101>] ? __remove_hrtimer+0x25/0x79
> > Mar 23 11:54:00 mail kernel: [347213.025005]  [<c103a2ff>] ? __run_hrtimer.isra.32+0x38/0xbe
> > Mar 23 11:54:00 mail kernel: [347213.025005]  [<c103ad95>] ? hrtimer_interrupt+0xda/0x23d
> > Mar 23 11:54:00 mail kernel: [347213.025005]  [<c1016493>] ? smp_apic_timer_interrupt+0x4c/0x81
> > Mar 23 11:54:00 mail kernel: [347213.025005]  [<c127b5d9>] ? apic_timer_interrupt+0x31/0x38
> 
> I read http://www.kernel.org/doc/Documentation/RCU/stallwarn.txt
> but couldn't find "rcu_bh detected stall" being mentioned there.

The documentation mentions "rcu_bh_state detected stalls".  I will check
this and update if needed.

> I reported the same issue on 3.2.9 (same machine!) on the 13th of march:
> 
> Mar 12 12:58:38 mail kernel: [440746.244002] INFO: rcu_bh detected stall on CPU 2 (t=0 jiffies)
> Mar 12 12:58:38 mail kernel: [440746.244002] Pid: 27980, comm: /usr/sbin/amavi Tainted: G        W    3.2.9 #1
> Mar 12 12:58:38 mail kernel: [440746.244002] Call Trace:
> Mar 12 12:58:38 mail kernel: [440746.244002]  [<c1061d26>] ? __rcu_pending+0x10a/0x30e
> Mar 12 12:58:38 mail kernel: [440746.244002]  [<c10626ca>] ? rcu_check_callbacks+0xd4/0xde
> Mar 12 12:58:38 mail kernel: [440746.244002]  [<c1035cf2>] ? update_process_times+0x2a/0x53
> Mar 12 12:58:38 mail kernel: [440746.244002]  [<c104e1d2>] ? tick_sched_timer+0x4d/0x8e
> Mar 12 12:58:38 mail kernel: [440746.244002]  [<c1043b53>] ? __remove_hrtimer+0x25/0x79
> Mar 12 12:58:38 mail kernel: [440746.244002]  [<c1043d4f>] ? __run_hrtimer.isra.32+0x37/0xbd
> Mar 12 12:58:38 mail kernel: [440746.244002]  [<c10445d5>] ? hrtimer_interrupt+0xdb/0x23d
> Mar 12 12:58:38 mail kernel: [440746.244002]  [<c101b781>] ? vmalloc_sync_all+0x1/0x1
> Mar 12 12:58:38 mail kernel: [440746.244002]  [<c1015e4c>] ? smp_apic_timer_interrupt+0x4c/0x81
> Mar 12 12:58:38 mail kernel: [440746.244002]  [<c1275491>] ? apic_timer_interrupt+0x31/0x38 
> Mar 12 12:58:38 mail kernel: [440746.244002]  [<c101b781>] ? vmalloc_sync_all+0x1/0x1
> Mar 12 12:58:38 mail kernel: [440746.244002]  [<c101b8c2>] ? do_page_fault+0x141/0x38f
> Mar 12 12:58:38 mail kernel: [440746.244002]  [<c1030d8d>] ? irq_exit+0x34/0x87
> Mar 12 12:58:38 mail kernel: [440746.244002]  [<c1015e51>] ? smp_apic_timer_interrupt+0x51/0x81
> Mar 12 12:58:38 mail kernel: [440746.244002]  [<c101b781>] ? vmalloc_sync_all+0x1/0x1
> Mar 12 12:58:38 mail kernel: [440746.244002]  [<c12756b7>] ? error_code+0x67/0x6c

This stack looks interesting -- might be a problem in vmalloc_sync(),
at least if the stack can be trusted.  Could you please reproduce with
frame pointers enabled?

							Thanx, Paul

> and so did Tilman Schmidt in February:
> https://lkml.org/lkml/2012/2/18/34
> 
> -- 
> Ralf Hildebrandt                   Charite Universitätsmedizin Berlin
> ralf.hildebrandt@charite.de        Campus Benjamin Franklin
> http://www.charite.de              Hindenburgdamm 30, 12203 Berlin
> Geschäftsbereich IT, Abt. Netzwerk fon: +49-30-450.570.155
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

