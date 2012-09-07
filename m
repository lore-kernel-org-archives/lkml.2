Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601Ab2IGLaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:30:24 -0400
Received: from gw1.zacglen.com ([220.233.85.112]:51886 "EHLO zacglen.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752798Ab2IGLaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:30:20 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Sep 2012 07:30:20 EDT
Date: Fri, 7 Sep 2012 21:24:13 +1000
Message-Id: <201209071124.q87BODFm028421.zacglen.com@localhost>
To: linux-kernel@vger.kernel.org
Subject: Freeze or Oops on recent kernels
From: yvahk-xreary@zacglen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am getting either a a kernel Oops or freeze (without any console output)
on recent kernels.  I have tested on 2.6.32.26 PAE, 3.1.9 PAE, and 3.4.9 PAE
all with similar results.

The hardware involved comprises mainly:

	12 GB ram
	Intel DX58S02 motherboard
	Intel Xeon E5220
	2 x onboard ethernet
	Intel PRO/1000 PT Dual Port ethernet
	Hauppauge HVR1700 DVB-T PCIe card
	Technisat SkyStar2 DVB-T PCI card

The oops or freeze occurs when both DVB cards are recording
simultaneously. With either card installed on their own there
is never any problem.

I should also add that the exact same kernel and cards on
a Gigabyte GA-P31-S3G motherboard + Intel Pentium 4 the problem
NEVER occurs. So there may be a DX58S02/timing/interrupt issue.

When there is an oops it is like this (hand-transcribed
from 2.6.32.26 PAE kernel):

c0789444	panic + 3e/e9
		oops_end + 97/a6
		no_context + 13b/145
		__bad_area_nosemaphore + ec/f4
		? do_page_fault + 0/29f
		bad_area_nosemaphore + 12/15
		do_page_fault + 139/29f
		? do_page_fault + 139/29f
c078b54b	error_code + 73/78
f82084fb	? cx23885_video_irq + d8/1dc
f820b04d	cx23885_irq + 3df/3fe
c04834ac	handle_irq_event + 57/fd
		handle_fasteoi_irq + 6f/a2
		handle_irq + 40/4d
		do_IRQ + 46/9a
		common_interrupt + 30/38
c045b7a9	? prepare_to_wait + 14c
f7fef5a5	? videobug_waitm + 90/133
c045b601	? autoremove_waker_function + 0/34
f805e5bc	videobuf_dvb_thread + 73/135
f805e4f9	? videobuf_dvb_thread + 0/135
c045b3c9	kthread + 64/69
		? kthread + 0/69
		kernel_thread_helper + 7/10

Although I am a very experienced programmer I have next to zero
kernel expertise except for minor patching of a few drivers.

My guess from the stack trace is that there might be an issue
with page fault recursion (if that is at all possible).

Anyhow I don't want to waste too much of my time or anybody elses
on this - although with the problem occuring with 3.4.9 kernel which
has significant interrupt handling changes it probably is something
that somebody might want to know about. If anybody can spot a clue
as to where I should be looking and how I should go about isolating
the problem (if only kernel core dumped!) please let me know and
I will possibly try and assist. I need some guidance.

Regards
John W.

