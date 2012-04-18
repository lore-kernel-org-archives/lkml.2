Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216Ab2DRF12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 01:27:28 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:52256 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750748Ab2DRF11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 01:27:27 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1+5EZMZy0y51T/KmxdESxL3k7Teeh1PiQjoor+18n
	j1ENdAZMfuW0A8
From: Sven Joachim <svenjoac@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel panic after suspend/resume
References: <CA+55aFzsjpJt09b6e4NA0T50M3w0xtASSYXz_=UWVDqKRywo=A@mail.gmail.com>
	<87pqb6fkji.fsf@turtle.gmx.de>
	<CA+55aFxhb6hriqHHwVtNeYHmtcy5JCEJX-zABBcG2Zjw_gawPw@mail.gmail.com>
	<878vhufcrk.fsf@turtle.gmx.de>
	<CA+55aFychSQgAG8raDq9rvXm3Lq7GFdByCd3-NZERieyTdAc2g@mail.gmail.com>
	<alpine.LFD.2.02.1204180013180.2542@ionos>
Date: Wed, 18 Apr 2012 07:27:18 +0200
In-Reply-To: <alpine.LFD.2.02.1204180013180.2542@ionos> (Thomas Gleixner's
	message of "Wed, 18 Apr 2012 00:13:30 +0200 (CEST)")
Message-ID: <87d375wqx5.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 18.04.2012 um 00:13 schrieb Thomas Gleixner:

> Sven, can you please provide the output of /proc/timer_list befor you
> suspend ?

Here it comes:

Timer List Version: v0.6
HRTIMER_MAX_CLOCK_BASES: 3
now at 81995036645 nsecs

cpu: 0
 clock 0:
  .base:       ffff8800cfc0d340
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <ffff8800c89d1c30>, hrtimer_wakeup, S:01
 # expires at 81995397325-81995397325 nsecs [in 360680 to 360680 nsecs]
 #1: <ffff8800cfc0d4b0>, tick_sched_timer, S:01
 # expires at 81996658467-81996658467 nsecs [in 1621822 to 1621822 nsecs]
 #2: <ffff8800cae0b9c0>, hrtimer_wakeup, S:01
 # expires at 82023333276-82024333268 nsecs [in 28296631 to 29296623 nsecs]
 #3: <ffff880037b2de00>, hrtimer_wakeup, S:01
 # expires at 82114048503-82174048502 nsecs [in 119011858 to 179011857 nsecs]
 #4: <ffff8800cf07d9c0>, hrtimer_wakeup, S:01
 # expires at 86883337295-86888337294 nsecs [in 4888300650 to 4893300649 nsecs]
 #5: <ffff8800c89db9c0>, hrtimer_wakeup, S:01
 # expires at 91650005420-91660005419 nsecs [in 9654968775 to 9664968774 nsecs]
 #6: <ffff880037b979c0>, hrtimer_wakeup, S:01
 # expires at 95657838418-95683567075 nsecs [in 13662801773 to 13688530430 nsecs]
 #7: <ffff8800379e3e00>, hrtimer_wakeup, S:01
 # expires at 122114051634-122214051633 nsecs [in 40119014989 to 40219014988 nsecs]
 #8: <ffff8800c4f29ec0>, hrtimer_wakeup, S:01
 # expires at 130964395088-130964445088 nsecs [in 48969358443 to 48969408443 nsecs]
 #9: <ffff88003780de00>, hrtimer_wakeup, S:01
 # expires at 322114018164-322214018164 nsecs [in 240118981519 to 240218981519 nsecs]
 #10: <ffff880037900878>, it_real_fn, S:01
 # expires at 355113963435-355113963435 nsecs [in 273118926790 to 273118926790 nsecs]
 #11: <ffff880037b8e078>, it_real_fn, S:01
 # expires at 355114047850-355114047850 nsecs [in 273119011205 to 273119011205 nsecs]
 #12: <ffff8800c8a5bd78>, hrtimer_wakeup, S:01
 # expires at 1220144115318-1220144165318 nsecs [in 1138149078673 to 1138149128673 nsecs]
 #13: <ffff8800c8a4dec0>, hrtimer_wakeup, S:01
 # expires at 3614665611022-3614665661022 nsecs [in 3532670574377 to 3532670624377 nsecs]
 #14: <ffff8800caee4478>, it_real_fn, S:01
 # expires at 6022114050963-6022114050963 nsecs [in 5940119014318 to 5940119014318 nsecs]
 #15: <ffff8800c89ed9c0>, hrtimer_wakeup, S:01
 # expires at 86413679665299-86413779665299 nsecs [in 86331684628654 to 86331784628654 nsecs]
 clock 1:
  .base:       ffff8800cfc0d380
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1334726690075951041 nsecs
active timers:
 clock 2:
  .base:       ffff8800cfc0d3c0
  .index:      2
  .resolution: 1 nsecs
  .get_time:   ktime_get_boottime
  .offset:     0 nsecs
active timers:
  .expires_next   : 81995397325 nsecs
  .hres_active    : 1
  .nr_events      : 29067
  .nr_retries     : 1
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .iowait_sleeptime: 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294901894

cpu: 1
 clock 0:
  .base:       ffff8800cfd0d340
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <ffff8800cfd0d4b0>, tick_sched_timer, S:01
 # expires at 81996658467-81996658467 nsecs [in 1621822 to 1621822 nsecs]
 #1: <ffff8800cb27c478>, it_real_fn, S:01
 # expires at 82014305559-82014305559 nsecs [in 19268914 to 19268914 nsecs]
 #2: <ffff8800c49539c0>, hrtimer_wakeup, S:01
 # expires at 82022017927-82024017926 nsecs [in 26981282 to 28981281 nsecs]
 #3: <ffff8800c49219c0>, hrtimer_wakeup, S:01
 # expires at 82924056526-82927053897 nsecs [in 929019881 to 932017252 nsecs]
 #4: <ffff8800379179c0>, hrtimer_wakeup, S:01
 # expires at 84536672114-84546672113 nsecs [in 2541635469 to 2551635468 nsecs]
 #5: <ffff880037a4bae0>, hrtimer_wakeup, S:01
 # expires at 111463341078-111493341077 nsecs [in 29468304433 to 29498304432 nsecs]
 #6: <ffff8800ca9899c0>, hrtimer_wakeup, S:01
 # expires at 138319743995879-138319843995879 nsecs [in 138237748959234 to 138237848959234 nsecs]
 clock 1:
  .base:       ffff8800cfd0d380
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1334726690075951041 nsecs
active timers:
 clock 2:
  .base:       ffff8800cfd0d3c0
  .index:      2
  .resolution: 1 nsecs
  .get_time:   ktime_get_boottime
  .offset:     0 nsecs
active timers:
  .expires_next   : 81996658467 nsecs
  .hres_active    : 1
  .nr_events      : 27145
  .nr_retries     : 2
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .iowait_sleeptime: 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294901894


Tick Device: mode:     1
Broadcast device
Clock Event Device: hpet
 max_delta_ns:   149983013276
 min_delta_ns:   13409
 mult:           61496111
 shift:          32
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  <0000000000000000>
 retries:        0
tick_broadcast_mask: 00000000
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     1
Per CPU device: 0
Clock Event Device: lapic
 max_delta_ns:   102938855910
 min_delta_ns:   1000
 mult:           89600491
 shift:          32
 mode:           3
 next_event:     81995397325 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
 retries:        0

Tick Device: mode:     1
Per CPU device: 1
Clock Event Device: lapic
 max_delta_ns:   102938855910
 min_delta_ns:   1000
 mult:           89600491
 shift:          32
 mode:           3
 next_event:     81996658467 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
 retries:        0

