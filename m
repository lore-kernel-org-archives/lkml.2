Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762235Ab0HGLaz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 07:30:55 -0400
Received: from www17.your-server.de ([213.133.104.17]:33140 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab0HGLay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 07:30:54 -0400
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.36: commit f12a15 makes computer really slow
Date: Sat, 7 Aug 2010 13:29:38 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-04772-gc3ddf62-dirty; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008071329.38590.thomas@m3y3r.de>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need to revert commit f12a15 to have a workable computer:

commit f12a15be63d1de9a35971f35f06b73088fa25c3a
Author: John Stultz <johnstul@us.ibm.com>
Date:   Tue Jul 13 17:56:27 2010 -0700

    x86: Convert common clocksources to use clocksource_register_hz/khz
    
    This converts the most common of the x86 clocksources over to use
    clocksource_register_hz/khz.


/proc/timer_list:
[...]

Tick Device: mode:     1
Broadcast device
Clock Event Device: hpet
 max_delta_ns:   149983005959
 min_delta_ns:   5000
 mult:           61496114
 shift:          32
 mode:           3
 next_event:     271895610827 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
 retries:        1
tick_broadcast_mask: 00000001
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     1
Per CPU device: 0
Clock Event Device: lapic
 max_delta_ns:   672727706
 min_delta_ns:   1202
 mult:           53556279
 shift:          32
 mode:           3
 next_event:     271766639490 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
 retries:        8

This is an x86_32 box.
