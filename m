Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab1KUVkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:40:37 -0500
Received: from fmmailgate07.web.de ([217.72.192.248]:58472 "EHLO
	fmmailgate07.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1KUVkg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:40:36 -0500
Date: Mon, 21 Nov 2011 22:40:34 +0100 (CET)
From: "Nicolas Kalkhof" <nkalkhof@web.de>
To: maciej.rutecki@gmail.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <615350841.1406384.1321911635013.JavaMail.fmail@mwmweb021>
Subject: Re: [REGRESSION] sudden cpu hogging in kernel 3.2 rc-series
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: normal
Sensitivity: Normal
X-Provags-ID: V01U2FsdGVkX1/eT2i3B54JlSBqDmTfk0u4CkV2lbnJIi7V5BUzgWtxIKoSCLfL0gnG
 BYCB8mfP63RXX8Ew3xkAtw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This happens on my machine after some minutes, too when running X and the trinity desktop. the cpu continuously uses up additional ~10 watts comparing to older 3.1 kernels. The issue remains high even after I kill X. A closer investigation shows that poll_idle uses up the cpu (see dump below). Is it normal for poll_idle to use up all ressources?

CPU: Intel Sandy Bridge microarchitecture, speed 2.701e+06 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit mask of 0x00 (No unit mask) count 100000
samples  %        app name                 symbol name
524625   96.8279  vmlinux                  poll_idle
7807      1.4409  cfbimgblt                /cfbimgblt
813       0.1501  vmlinux                  rb_get_reader_page
806       0.1488  vmlinux                  fbcon_redraw.clone.30
616       0.1137  vmlinux                  i8042_interrupt
454       0.0838  vmlinux                  bit_putcs
414       0.0764  vmlinux                  ring_buffer_consume
373       0.0688  vmlinux                  _cond_resched
301       0.0556  cfbcopyarea              /cfbcopyarea
277       0.0511  libstdc++.so.6.0.14      /usr/lib64/gcc/x86_64-pc-linux-gnu/4.5.3/libstdc++.so.6.0.14
239       0.0441  cfbfillrect              /cfbfillrect
....

Regards
Nic

-----Ursprüngliche Nachricht-----
Von: "Maciej Rutecki" <maciej.rutecki@gmail.com>
Gesendet: Nov 21, 2011 10:11:17 PM
An: "Nicolas Kalkhof" <nkalkhof@web.de>
Betreff: Re: [REGRESSION] sudden cpu hogging in kernel 3.2 rc-series

>On piątek, 18 listopada 2011 o 21:33:15 Nicolas Kalkhof wrote:
>> Hello,
>>
>> since the merges for kernel 3.2 came in late october, my mobile i7 2620M
>> sandybridge cpu/gpu seems to run hotter (approx 10 °C) when idling and
>> after some minutes according to top the cpu load goes up on all cores but
>> the cpu frequency stays low (800 MHz) as well as the gpu (650MHz) and the
>> system is responding well. Yet still additional 5-8 watts are continously
>> drained from the power supply. Something is throttling up :(. Oprofile
>> shows that the kernel hogs the cpu (see dump below). This happens with
>> every kernel since the 3.2 merge window closed up to latest linux-next. I
>> wasn't able to track the bad commit down yet.
>>
>> Could someone please confirm the issue?
>>
>
>I observed similar behaviour, few minutes after boot, when KDE is working
>plasma-desktop process (sometimes another) uses 20-50% cpu. System and kernel
>works without any kernel, but cpu usage is greater than in 3.1 (and older).
>
>Hardware: old hp/compaq nx6310
>
>Add this mail to regression list.
>
>Regards
>--
>Maciej Rutecki
>http://www.mrutecki.pl


___________________________________________________________
SMS schreiben mit WEB.DE FreeMail - einfach, schnell und
kostenguenstig. Jetzt gleich testen! http://f.web.de/?mc=021192
