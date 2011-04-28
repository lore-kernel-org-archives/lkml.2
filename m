Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab1D1Uo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 16:44:59 -0400
Received: from legolas.restena.lu ([158.64.1.34]:56216 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525Ab1D1Uo5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 16:44:57 -0400
Date: Thu, 28 Apr 2011 22:44:44 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: sedat.dilek@gmail.com, Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning,
 regression?
Message-ID: <20110428224444.43107883@neptune.home>
In-Reply-To: <alpine.LFD.2.02.1104282227340.3005@ionos>
References: <20110426112756.GF4308@linux.vnet.ibm.com>
	<20110426183859.6ff6279b@neptune.home>
	<20110426190918.01660ccf@neptune.home>
	<BANLkTikjuqWP+PAsObJH4EAOyzgr2RbYNA@mail.gmail.com>
	<alpine.LFD.2.02.1104262314110.3323@ionos>
	<20110427081501.5ba28155@pluto.restena.lu>
	<20110427204139.1b0ea23b@neptune.home>
	<alpine.LFD.2.02.1104272351290.3323@ionos>
	<alpine.LFD.2.02.1104281051090.19095@ionos>
	<BANLkTinB5S7q88dch78i-h28jDHx5dvfQw@mail.gmail.com>
	<20110428102609.GJ2135@linux.vnet.ibm.com>
	<1303997401.7819.5.camel@marge.simson.net>
	<BANLkTik4+PAGHF-9KREYk8y+KDQLDAp2Mg@mail.gmail.com>
	<alpine.LFD.2.02.1104282044120.3005@ionos>
	<20110428222301.0b745a0a@neptune.home>
	<alpine.LFD.2.02.1104282227340.3005@ionos>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 April 2011 Thomas Gleixner wrote:
> On Thu, 28 Apr 2011, Bruno Prémont wrote:
> > On Thu, 28 April 2011 Thomas Gleixner wrote:
> > > -	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
> > > +	return HRTIMER_RESTART;
> > 
> > This doesn't help here.
> > Be it applied on top of the others, full diff attached
> > or applied alone (with throttling printk).
> > 
> > Could it be that NO_HZ=y has some importance in this matter?
> 
> Might be. Can you try with nohz=off on the kernel command line ?

Doesn't make any visible difference (tested with "applied alone" kernel
as of above).

> Can you please provide the output of /proc/timer_list ?

See below,
Bruno



Timer List Version: v0.6
HRTIMER_MAX_CLOCK_BASES: 3
now at 1150126155286 nsecs

cpu: 0
 clock 0:
  .base:       c1559360
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1304021489280954699 nsecs
active timers:
 #0: def_rt_bandwidth, sched_rt_period_timer, S:01, enqueue_task_rt, swapper/1
 # expires at 1304028703000000000-1304028703000000000 nsecs [in 1304027552873844714 to 1304027552873844714 nsecs]
 clock 1:
  .base:       c155938c
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: tick_cpu_sched, tick_sched_timer, S:01, hrtimer_start_range_ns, swapper/0
 # expires at 1150130000000-1150130000000 nsecs [in 3844714 to 3844714 nsecs]
 #1: <dd612844>, it_real_fn, S:01, hrtimer_start, ntpd/1623
 # expires at 1150443573670-1150443573670 nsecs [in 317418384 to 317418384 nsecs]
 #2: <dd443ad4>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, init/1
 # expires at 1150450113736-1150455113735 nsecs [in 323958450 to 328958449 nsecs]
 #3: <db6bbad4>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, slabtop/1817
 # expires at 1152632990798-1152635990795 nsecs [in 2506835512 to 2509835509 nsecs]
 #4: watchdog_hrtimer, watchdog_timer_fn, S:01, hrtimer_start, watchdog/0/7
 # expires at 1152742107906-1152742107906 nsecs [in 2615952620 to 2615952620 nsecs]
 #5: <dce4be54>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, collectd/1647
 # expires at 1159748146627-1159748196627 nsecs [in 9621991341 to 9622041341 nsecs]
 #6: <daf75e54>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, collectd/1644
 # expires at 1159748971801-1159749021801 nsecs [in 9622816515 to 9622866515 nsecs]
 #7: <dce49e54>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, collectd/1646
 # expires at 1159749646863-1159749696863 nsecs [in 9623491577 to 9623541577 nsecs]
 #8: <daf77e54>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, collectd/1645
 # expires at 1159750273989-1159750323989 nsecs [in 9624118703 to 9624168703 nsecs]
 #9: <dbd51e54>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, collectd/1643
 # expires at 1159751170319-1159751220319 nsecs [in 9625015033 to 9625065033 nsecs]
 #10: <db687f44>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, collectd/1641
 # expires at 1159884463552-1159884513552 nsecs [in 9758308266 to 9758358266 nsecs]
 #11: <db6bdb6c>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, rpcbind/1699
 # expires at 1164510072442-1164540072440 nsecs [in 14383917156 to 14413917154 nsecs]
 #12: <dccbbb6c>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, syslog-ng/1599
 # expires at 1859759077032-1859859077032 nsecs [in 709632921746 to 709732921746 nsecs]
 #13: <dce2bb6c>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, dhcpcd/1557
 # expires at 86432406451906-86432506451906 nsecs [in 85282280296620 to 85282380296620 nsecs]
 #14: <dccbdad4>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, gpm/1659
 # expires at 86440042646716-86440142646716 nsecs [in 85289916491430 to 85290016491430 nsecs]
 clock 2:
  .base:       c15593b8
  .index:      7
  .resolution: 1 nsecs
  .get_time:   ktime_get_boottime
  .offset:     0 nsecs
active timers:
  .expires_next   : 1150130000000 nsecs
  .hres_active    : 1
  .nr_events      : 62851
  .nr_retries     : 1232
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 2
  .idle_tick      : 1150120000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 85011
  .idle_calls     : 59192
  .idle_sleeps    : 23733
  .idle_entrytime : 1150123805083 nsecs
  .idle_waketime  : 1150123805083 nsecs
  .idle_exittime  : 1150123876750 nsecs
  .idle_sleeptime : 861310470458 nsecs
  .iowait_sleeptime: 72683738430 nsecs
  .last_jiffies   : 85011
  .next_jiffies   : 85017
  .idle_expires   : 1150170000000 nsecs
jiffies: 85012


Tick Device: mode:     1
Broadcast device
Clock Event Device: pit
 max_delta_ns:   27461866
 min_delta_ns:   12571
 mult:           5124677
 shift:          32
 mode:           3
 next_event:     9223372036854775807 nsecs
 set_next_event: pit_next_event
 set_mode:       init_pit_timer
 event_handler:  tick_handle_oneshot_broadcast
 retries:        0
tick_broadcast_mask: 00000000
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     1
Per CPU device: 0
Clock Event Device: lapic
 max_delta_ns:   128554655331
 min_delta_ns:   1000
 mult:           71746698
 shift:          32
 mode:           3
 next_event:     1150130000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
 retries:        1
