Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab2G2N2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 09:28:19 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54690 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab2G2N2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 09:28:18 -0400
MIME-Version: 1.0
From: Vladimir Volovich <vladimir.volovich@gmail.com>
Date: Sun, 29 Jul 2012 17:27:56 +0400
Message-ID: <CAECQtKrF2FMfOBDChPC7CcCwwsBir6-MBVU_-5aieefPTaqJzQ@mail.gmail.com>
Subject: [BUG] hard LOCKUP occurred multiple times on linux 3.4
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've got several hard lockups on a system running kernel
3.4-trunk-amd64, from debian package linux-image-3.4-trunk-amd64
version 3.4.1-1~experimental.1

Apparently the lockups happened when opening a gmail page in iceweasel
(could possibly be related to google talk plugin, since I saw it
mentioned on the stack traces page). When the lockup happens,
keyboard, mouse, become non-functional (nothing could be typed,
keyboard leds are not switchable, etc). Then system was running gnome,
and for some time it was updating the current time on the gnome panel;
after some time it switches to a text console full of stack traces.

The system is built on ASUS motherboard P8Z77-V PRO, with Intel
i5-2310 CPU and 16 GB memory.

I've made some photos of the stacktraces, and you could see them at

https://lh5.googleusercontent.com/-DTJfg105hBo/UBUzE9LZogI/AAAAAAAAAbc/r5ojQ3K7Wvg/s0/DSC07729.JPG
https://lh5.googleusercontent.com/-YbNxHj4d0Z0/UBUzFE_LDqI/AAAAAAAAAbg/A3CpFQuBvvA/s0/DSC07732.JPG
https://lh5.googleusercontent.com/-f54rk_z-XbU/UBUzFIouYfI/AAAAAAAAAbk/6R9tM1apBtI/s0/DSC07733.JPG
https://lh5.googleusercontent.com/-ux5LjtCEIOM/UBUzFzwcZPI/AAAAAAAAAbw/ONYS-u5sDoI/s0/DSC07734.JPG
https://lh5.googleusercontent.com/-YioVDyEC_Gs/UBUzFxzBYhI/AAAAAAAAAb0/emYMsda06dw/s0/DSC07735.JPG
https://lh5.googleusercontent.com/-uA2tB5dXSWY/UBUzGMgytzI/AAAAAAAAAb8/dVYNo1mJI_A/s0/DSC07737.JPG
https://lh5.googleusercontent.com/-eax9J10ji7U/UBUzHKwWNhI/AAAAAAAAAcI/eWjsVpkOxcI/s0/DSC07738.JPG
https://lh5.googleusercontent.com/-yrCy-evNvPw/UBUzHNjMExI/AAAAAAAAAcE/KjopS-oEF1U/s0/DSC07740.JPG

and I've typed the call trace from the photo, if that helps:

Call Trace:
 <NMI>  [<ffffffff81039697>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffff81039743>] ? warn_slowpath_fmt+0x45/0x4a
 [<ffffffff8105fb9a>] ? sched_clock_cpu+0xb/0xc3
 [<ffffffff810136ed>] ? paravirt_read_tsc+0x5/0x8
 [<ffffffff8109307d>] ? watchdog_overflow_callback+0x93/0x9e
 [<ffffffff81092fea>] ? touch_nmi_watchdog+0x62/0x62
 [<ffffffff810b3551>] ? __perf_event_overflow+0x12c/0x1ae
 [<ffffffff8101a7c1>] ? x86_perf_event_set_period+0x101/0x10c
 [<ffffffff8101e44a>] ? intel_pmu_handle_irq+0x227/0x28a
 [<ffffffff8135a6cf>] ? nmi_handle.isra.0+0x3e/0x61
 [<ffffffff8135a79b>] ? do_nmi+0xa9/0x2a9
 [<ffffffff81359f3c>] ? end_repeat_nmi+0x1a/0x1e
 <<EOE>>

I hope that this could help finding and fixing a bug, if it is indeed
a software bug rather than a hardware issue - which I hope it is not
:).

Please let me know (by email) if you need any further info.

Best wishes,
Vladimir
