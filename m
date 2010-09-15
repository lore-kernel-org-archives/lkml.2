Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab0IOO7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 10:59:00 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58708 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753292Ab0IOO67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 10:58:59 -0400
X-Sasl-enc: T2dzK2dPVAGHu8pYB/E1pAWHCf6Evm5qaBrOiwbtOHz2 1284562736
Message-ID: <4C90DF2B.2020505@eml.cc>
Date: Wed, 15 Sep 2010 16:58:51 +0200
From: Martin Kepplinger <martinkepplinger@eml.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100826 Lightning/1.0b1 Thunderbird/3.0.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: johnstul@us.ibm.com, damm@opensource.se, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] [BISECTED] System gets unresponsive since 2.6.35-rc1
References: <4C90A228.1050809@eml.cc> <alpine.LFD.2.00.1009151309100.2416@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1009151309100.2416@localhost6.localdomain6>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/mixed;
 boundary="------------010107010803050203010705"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010107010803050203010705
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Am 2010-09-15 13:14, schrieb Thomas Gleixner:
> On Wed, 15 Sep 2010, Martin Kepplinger wrote:
> 
>> Hi,
>>
>> My Ubuntu 10.04, 32bit on a Lenovo G550 Laptop has the following
>> issue since .35-rc1: After a short uptime doing little things like
>> video playback, the system gets slow and stuck after some time. At
>> first, compiz-animations and everything (video playback,
>> terminal-commands) gets unusably slow. /var/log/messages comes up
>> with the following _during_ video playback. These warnings stop when
>> the video is stopped. The system stays (quite) unresponsive /
>> unusable.
>>
>> Sep 15 12:15:51 mobil pulseaudio[1456]: ratelimit.c: 19 events suppressed
>> Sep 15 12:15:57 mobil pulseaudio[1456]: ratelimit.c: 25 events suppressed
>> Sep 15 12:16:02 mobil pulseaudio[1456]: ratelimit.c: 6 events suppressed
>> Sep 15 12:16:07 mobil pulseaudio[1456]: ratelimit.c: 11 events suppressed
>> Sep 15 12:16:17 mobil pulseaudio[1456]: ratelimit.c: 12 events suppressed
>> Sep 15 12:16:23 mobil pulseaudio[1456]: ratelimit.c: 3 events suppressed
>>
>> Shutdown also hangs very soon. The problem is still present in
>> 2.6.36-rc3! I'm about to test -rc4. The last "good" one is 2.6.34.
>>
>> I bisected the problem. Unfortunately I could not revert the
>> patch. Additionally, I'm only 90% sure about the result because I
>> had to skip one step of the bisect (but since the toplevel-Makefile
>> showed "2.6.34-something", I could guess it to be "good")
>>
>> The rest of this E-Mail is the result (git show). I can only report
>> it. I'd happily test patches to it and hope this makes sense to
>> someone of you.
> 
> I doubt that this is the real culprit. We just decoded a HPET problem,
> which might be the real cause. Patch is below.
> 
> Can you provide the output of /proc/timer_list please ?
> 
> Thanks,
> 
> 	tglx
> ---
> commit 54ff7e595d763d894104d421b103a89f7becf47c
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Tue Sep 14 22:10:21 2010 +0200
> 
>     x86: hpet: Work around hardware stupidity
>     

I tested this against 2.6.35. Since I can write this after watching half an
hour of LinuxCon Videos, this fixes the problem. I hope it to get merged soon.
I'll test it against the current tree as well and will stay happy and quiet as
long as I can't find a problem.

Thanks a lot!

	Martin

--------------010107010803050203010705
Content-Type: text/plain;
 name="timer_list.dump"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="timer_list.dump"

Timer List Version: v0.6
HRTIMER_MAX_CLOCK_BASES: 2
now at 48763215587 nsecs

cpu: 0
 clock 0:
  .base:       c78042c4
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1284553359316792381 nsecs
active timers:
 clock 1:
  .base:       c78042f0
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <c7804380>, tick_sched_timer, S:01, hrtimer_start_range_ns, swapper/0
 # expires at 48764000000-48764000000 nsecs [in 784413 to 784413 nsecs]
 #1: <f687db64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, gedit/1508
 # expires at 48770791462-48770841462 nsecs [in 7575875 to 7625875 nsecs]
 #2: <c2117b64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, nautilus/1416
 # expires at 48770851246-48770901246 nsecs [in 7635659 to 7685659 nsecs]
 #3: <c1f0df40>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, gvfs-afc-volume/1454
 # expires at 48916775057-48916825057 nsecs [in 153559470 to 153609470 nsecs]
 #4: <c2217b64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, empathy/1408
 # expires at 49186991118-49188951116 nsecs [in 423775531 to 425735529 nsecs]
 #5: <c2359acc>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, Xorg/996
 # expires at 49257833999-49258333997 nsecs [in 494618412 to 495118410 nsecs]
 #6: <c1fc9e9c>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, indicator-apple/1481
 # expires at 49692030085-49692080085 nsecs [in 928814498 to 928864498 nsecs]
 #7: <c1f53e9c>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, nautilus/1467
 # expires at 50120922876-50120972876 nsecs [in 1357707289 to 1357757289 nsecs]
 #8: <c1f9db64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, indicator-apple/1474
 # expires at 50186662984-50189457982 nsecs [in 1423447397 to 1426242395 nsecs]
 #9: <c2241b64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, gnome-panel/1413
 # expires at 50187007949-50189971947 nsecs [in 1423792362 to 1426756360 nsecs]
 #10: <c1f9bb64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, clock-applet/1473
 # expires at 50187184403-50190150401 nsecs [in 1423968816 to 1426934814 nsecs]
 #11: <c20efb64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, udisks-daemon/1433
 # expires at 50684122950-50686110948 nsecs [in 1920907363 to 1922895361 nsecs]
 #12: <c1e85b64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, rtkit-daemon/1406
 # expires at 51892055563-51897055561 nsecs [in 3128839976 to 3133839974 nsecs]
 #13: <c2243b64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, gnome-power-man/1414
 # expires at 52186614186-52191578184 nsecs [in 3423398599 to 3428362597 nsecs]
 #14: <c1df3b64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, gconfd-2/1376
 # expires at 61187451824-61201413821 nsecs [in 12424236237 to 12438198234 nsecs]
 #15: <c1dc7b64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, gnome-session/1335
 # expires at 62187405694-62202365692 nsecs [in 13424190107 to 13439150105 nsecs]
 #16: <c20edb64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, udisks-daemon/1432
 # expires at 62683451247-62698908245 nsecs [in 13920235660 to 13935692658 nsecs]
 #17: <c1e87f40>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, sleep/1235
 # expires at 83560438223-83560488223 nsecs [in 34797222636 to 34797272636 nsecs]
 #18: <c1fd3b64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, indicator-appli/1486
 # expires at 94187527252-94234493250 nsecs [in 45424311665 to 45471277663 nsecs]
 #19: <c1fd1b64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, gvfsd-metadata/1485
 # expires at 94187214347-94246851345 nsecs [in 45423998760 to 45483635758 nsecs]
 #20: <c223bf40>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, gdm-session-wor/1301
 # expires at 330478636536-330478686536 nsecs [in 281715420949 to 281715470949 nsecs]
 #21: <c20e1b64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, nm-applet/1411
 # expires at 332187153847-332287153847 nsecs [in 283423938260 to 283523938260 nsecs]
 #22: <c1f51b64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, gnome-screensav/1506
 # expires at 637404954416-637504954416 nsecs [in 588641738829 to 588741738829 nsecs]
  .expires_next   : 48764000000 nsecs
  .hres_active    : 1
  .nr_events      : 8949
  .nr_retries     : 1
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 2
  .idle_tick      : 48708000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 4294904473
  .idle_calls     : 18731
  .idle_sleeps    : 5026
  .idle_entrytime : 48761860185 nsecs
  .idle_waketime  : 48757284701 nsecs
  .idle_exittime  : 48757313126 nsecs
  .idle_sleeptime : 36258257723 nsecs
  .iowait_sleeptime: 10879152787 nsecs
  .last_jiffies   : 4294904486
  .next_jiffies   : 4294904487
  .idle_expires   : 48760000000 nsecs
jiffies: 4294904486

cpu: 1
 clock 0:
  .base:       c7a042c4
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1284553359316792381 nsecs
active timers:
 clock 1:
  .base:       c7a042f0
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <c7a04380>, tick_sched_timer, S:01, hrtimer_start_range_ns, swapper/0
 # expires at 48765000000-48765000000 nsecs [in 1784413 to 1784413 nsecs]
 #1: <f68adb64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, gnome-terminal/1517
 # expires at 48780988348-48781038348 nsecs [in 17772761 to 17822761 nsecs]
 #2: <c2199f40>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, syndaemon/1426
 # expires at 48789418137-48789468137 nsecs [in 26202550 to 26252550 nsecs]
 #3: <c1effb64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, indicator-sessi/1495
 # expires at 48988676165-48990277163 nsecs [in 225460578 to 227061576 nsecs]
 #4: <c1df7acc>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, gpsd/1108
 # expires at 49660673314-49661673312 nsecs [in 897457727 to 898457725 nsecs]
 #5: <f68ffb64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, gnome-user-shar/1542
 # expires at 50187366844-50190321842 nsecs [in 1424151257 to 1427106255 nsecs]
 #6: <c2283acc>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, rsyslogd/774
 # expires at 50857704507-50887704504 nsecs [in 2094488920 to 2124488917 nsecs]
 #7: <c1e83acc>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, ssh-agent/1369
 # expires at 50952443949-50962443947 nsecs [in 2189228362 to 2199228360 nsecs]
 #8: <c1de1b64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, gnome-settings-/1383
 # expires at 52185885821-52189313819 nsecs [in 3422670234 to 3426098232 nsecs]
 #9: <c1df5b64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, compiz/1394
 # expires at 52757945535-52761945533 nsecs [in 3994729948 to 3998729946 nsecs]
 #10: <c1df1acc>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, winbindd/1099
 # expires at 52994025916-53024025914 nsecs [in 4230810329 to 4260810327 nsecs]
 #11: <f684de9c>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, gedit/1509
 # expires at 55496508225-55496558225 nsecs [in 6733292638 to 6733342638 nsecs]
 #12: <c1e89b64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, rtkit-daemon/1407
 # expires at 56892083151-56892083151 nsecs [in 8128867564 to 8128867564 nsecs]
 #13: <c1eafb64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, upowerd/1246
 # expires at 59683477647-59695934645 nsecs [in 10920262060 to 10932719058 nsecs]
 #14: <c1fcbe9c>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, indicator-apple/1490
 # expires at 62890059877-62890109877 nsecs [in 14126844290 to 14126894290 nsecs]
 #15: <c1efbb64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, gnome-clock-app/1498
 # expires at 64682362549-64699818547 nsecs [in 15919146962 to 15936602960 nsecs]
 #16: <c2331f40>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, cron/961
 # expires at 82143942281-82143992281 nsecs [in 33380726694 to 33380776694 nsecs]
 #17: <c2251e9c>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, rsyslogd/786
 # expires at 92488203208-92488253208 nsecs [in 43724987621 to 43725037621 nsecs]
 #18: <c22b3b64>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, polipo/967
 # expires at 1521115124444-1521215124444 nsecs [in 1472351908857 to 1472451908857 nsecs]
 #19: <c1d19f40>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, atd/962
 # expires at 3621115433141-3621115483141 nsecs [in 3572352217554 to 3572352267554 nsecs]
  .expires_next   : 48765000000 nsecs
  .hres_active    : 1
  .nr_events      : 8218
  .nr_retries     : 1
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 2
  .idle_tick      : 48709000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 4294904473
  .idle_calls     : 16954
  .idle_sleeps    : 3813
  .idle_entrytime : 48761516638 nsecs
  .idle_waketime  : 48756053407 nsecs
  .idle_exittime  : 48757476973 nsecs
  .idle_sleeptime : 37238099743 nsecs
  .iowait_sleeptime: 7873142111 nsecs
  .last_jiffies   : 4294904486
  .next_jiffies   : 4294904487
  .idle_expires   : 48756000000 nsecs
jiffies: 4294904486


Tick Device: mode:     1
Broadcast device
Clock Event Device: hpet
 max_delta_ns:   149983005959
 min_delta_ns:   5000
 mult:           61496114
 shift:          32
 mode:           3
 next_event:     48764000000 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
 retries:        1706
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000001


Tick Device: mode:     1
Per CPU device: 0
Clock Event Device: lapic
 max_delta_ns:   672747792
 min_delta_ns:   1202
 mult:           53554680
 shift:          32
 mode:           1
 next_event:     48764000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
 retries:        1917

Tick Device: mode:     1
Per CPU device: 1
Clock Event Device: lapic
 max_delta_ns:   672747792
 min_delta_ns:   1202
 mult:           53554680
 shift:          32
 mode:           3
 next_event:     48765000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
 retries:        1780


--------------010107010803050203010705--
