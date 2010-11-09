Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab0KIQHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:07:33 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56282 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab0KIQHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:07:31 -0500
MIME-Version: 1.0
From: Joey <joey@dogsplayingpoker.org>
Date: Tue, 9 Nov 2010 10:06:59 -0600
Message-ID: <AANLkTi=gZdGdfztWEM057QRzAgd+JTa03PGxcR9neEdw@mail.gmail.com>
Subject: RT Linux and Oprofile
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am running oprofile 0.9.6 on kernel 2.6.33.7 with RT patch 29 on an
OMAP 3430 (ARM7) processor.

The problem I am running into seems to be from the RT patch. According
to the documentation
(https://rt.wiki.kernel.org/index.php/CONFIG_PREEMPT_RT_Patch), the RT
patch works by "moving all interrupt and software interrupts to kernel
threads." So on my architecture when
arch/arm/oprofile/op_model_v7.c:armv7_pmnc_interrupt() executes,
get_irq_regs() always returns null since the kernel is not in an
interrupt context.

At first the module was crashing with a null pointer dereference, but
I manually applied the patch from
http://old.nabble.com/Re%3A--GIT-PULL--updates-for-oprofile-p28391667.html
(which is now in the latest kernel version) to catch null pointers.
Now it seems to run, but I don't actually get any valid data in the
logs.

Running opreport after gathering samples gives "no sample files found:
profile specification too strict?" I looked through the oprofile FAQ
on "What to do when you don't get any results" but none of those seems
to apply, especially given my setup. Also, if I check
/var/lib/oprofile/samples/current/stats/cpu0/sample_invalid_eip, that
value is the same as in sample_received in the same directory.

So is oprofile compatible with the RT patch? I don't see how given how
the the RT patch affects the kernel. Any ideas or suggestions on how
to proceed?

I have also tired timer mode (insmod oprofile.ko timer=1) as
aworkaround, but after I gather stats and run opreport, I always get
"Invalid sample file, bad magic number" Not sure if that is related or
a separate issue.

This issue was posted to the oprofile list, but they couldn't help, so
I'm seeing if the kernel community knows.

Please CC me on responses, as I'm not subscribed to LKML

Thanks in advance,

Joey
