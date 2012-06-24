Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab2FXFV5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 01:21:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:56468 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab2FXFV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 01:21:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="169364107"
Date: Sun, 24 Jun 2012 13:21:38 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: boot hang on CONFIG_FB_VGA16
Message-ID: <20120624052138.GA6965@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I can reproduce this easily when running CONFIG_FB_VGA16=y kernels
inside KVM. Older kernels like 3.2, 3.3, 3.4 don't have these warning
messages, but just randomly hang during boot.

I'm not sure if this is a relevant problem, but anyway, here is the
bug report.

INFO: rcu_sched self-detected stall on CPU { 1}  (t=15003 jiffies)
Pid: 8, comm: kworker/1:0 Not tainted 3.5.0-rc3-wl+ #11
Call Trace:
 <IRQ>  [<ffffffff810a1e35>] __rcu_pending+0xc2/0x3c3
 [<ffffffff8107a1bc>] ? tick_nohz_handler+0xd5/0xd5
 [<ffffffff810a3052>] rcu_check_callbacks+0x9d/0x149
 [<ffffffff81061b01>] ? sched_clock_cpu+0xbb/0xcc
 [<ffffffff8103db27>] update_process_times+0x3e/0x72
 [<ffffffff8107a228>] tick_sched_timer+0x6c/0x95
 [<ffffffff81061b21>] ? local_clock+0xf/0x3c
 [<ffffffff810537d3>] __run_hrtimer+0xcf/0x1d1
 [<ffffffff810541c6>] hrtimer_interrupt+0xc6/0x191
 [<ffffffff817bc52a>] smp_apic_timer_interrupt+0x86/0x99
 [<ffffffff817bb51c>] apic_timer_interrupt+0x6c/0x80
 <EOI>  [<ffffffff81030a8c>] ? console_unlock+0x21b/0x2c5
 [<ffffffff813304a1>] ? update_attr.isra.1+0x8a/0x8a
 [<ffffffff8132b7a7>] fb_flashcursor+0x114/0x123
 [<ffffffff81048529>] process_one_work+0x238/0x45c
 [<ffffffff8104848c>] ? process_one_work+0x19b/0x45c
 [<ffffffff8132b693>] ? get_color+0xfd/0xfd
 [<ffffffff8104876e>] process_scheduled_works+0x21/0x2f
 [<ffffffff810488f5>] worker_thread+0x179/0x240

Thanks,
Fengguang
