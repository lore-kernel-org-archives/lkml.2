Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab0EGLQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 07:16:52 -0400
Received: from snt0-omc1-s35.snt0.hotmail.com ([65.55.90.46]:19912 "EHLO
	snt0-omc1-s35.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751274Ab0EGLQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 07:16:51 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 May 2010 07:16:51 EDT
X-Originating-IP: [94.195.177.167]
X-Originating-Email: [johnkyr83@hotmail.com]
Message-ID: <SNT111-DS115B558E5855C0FAEA860CA7F60@phx.gbl>
From: "limp" <johnkyr83@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: Weird timer handler used with LAPIC selected
Date: Fri, 7 May 2010 12:10:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acrt1emrAx3mGXk+Rp61THS9NfIdcA==
Content-Language: en-gb
X-OriginalArrivalTime: 07 May 2010 11:10:41.0461 (UTC) FILETIME=[EE422650:01CAEDD5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have configured my kernel (2.6.31.6) so that I get periodic ticks from the
timer interrupt (i.e. tickless is not configured) with a rate determined by
the HZ value. I have also selected the "Local APIC support on uniprocessors"
option so that the LAPIC timer is used as a tick source. The problem is that
the handler used for the timer is not the "local_apic_timer_interrupt"
handler as I was excepted but the "tick_handle_periodic" handler. This can
be verified by seeing the output of /proc/timer_list:

Tick Device: mode:     0
Per CPU device: 0
Clock Event Device: lapic
 max_delta_ns:   1006457290
 min_delta_ns:   1799
 mult:           35797637
 shift:          32
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  tick_handle_periodic

Is there an explanation for that? The board in which I am running the kernel
is a Kontron 986LCD-M/mITX one with an Intel Celeron M 440 installed on it.
I have verified that Intel Celeron M Processors have a LAPIC and
consequently, a LAPIC timer.

--------------------------------------------
Another weird thing that I noticed is that by running the same kernel but
configured for "Core 2/newer Xeon" processors, the timer handler used is the
"hrtimer_interrupt" handler. Again, this is verified by /proc/timer_list: 

Tick Device: mode:     1
Per CPU device: 0
Clock Event Device: lapic
event_handler:  hrtimer_interrupt

I have put some printks inside "local_apic_timer_interrupt" handler which
should never be executed as the handler selected for the timer is
"hrtimer_interrupt" and not "local_apic_timer_interrupt" as verified.
However, when I execute a user process which is just a long time delay, the
printks from the "local_apic_timer_interrupt" are printed. 

If you need more info about something, please ask.

Any help will be much appreciated.

Thanks in advance.

P.S. please CC me.

-John

