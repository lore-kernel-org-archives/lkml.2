Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab1DAFPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 01:15:17 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:33076 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1DAFPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 01:15:13 -0400
Date: Fri, 1 Apr 2011 14:15:11 +0900
From: Norbert Preining <preining@logic.at>
To: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Lenovo resume from suspends hangs in i915_gpu_busy or so
Message-ID: <20110401051511.GE9128@gamma.logic.tuwien.ac.at>
References: <20110401021055.GB6071@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110401021055.GB6071@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

adding dri-devel as I found it is actually not completely dead, 
but hanging in some i915 problem.

Copyied from screen:
Process ips-adjust (....
Stack:
  ....
   ....
  ...
Call Trace:
  <IRQ>
  ... ? tick_program_event
  call_sortirq
  do_softirq
  irq_exit
  smp_apic_timer_interrupt
  apic_timer_interrupt
  <EOI>
  ? _raw_spin_lock
  i915_gpu_busy
  ips_adjust
  ? show_cpu_temp
  kthread
  kernel_thread_helper
  ? kthread_worker_fn
  ? gs_change
Code: ...
(once more more or less the same as above)

Here the original message.

> I got a new laptop, Lenovo Thinkpad Edge (intel , intel graphic)
> and I am running 2.6.39-rc1 on it (but tried also 2.6.38).
> 
> Suspend to RAM, either by pm-suspend or by echo "mem" >/sys/..
> works, both wiht  running or from a recovery session where nothing
> else is running.
> 
> But wake-up hangs the machine. The video comes back, I see the last
> lines I typed before I suspended, but after that no keypress nor
> anything else (Sysrq) does work, but 4sec-hard-off. No traces in the
> log files.

Full logs etc:
kernel config:
	http://www.logic.at/people/preining/lenovo/config.edge
dmesg output after boot:
	http://www.logic.at/people/preining/lenovo/dmesg.edge
lsmod, lspci, lsusb
	http://www.logic.at/people/preining/lenovo/lsmod.edge
	http://www.logic.at/people/preining/lenovo/lspci.edge
	http://www.logic.at/people/preining/lenovo/lsusb.edge
photo of the hang:
	http://www.logic.at/people/preining/lenovo/i915-hang-after-resume.jpg

Hope that helps, looking forward to any suggestions

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
SCREMBY (n.)
The dehydrated felt-tip pen attached by a string to the 'Don't Forget'
board in the kitchen which has never worked in living memory but which
no one can be bothered to throw away.
			--- Douglas Adams, The Meaning of Liff
