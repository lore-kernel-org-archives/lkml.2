Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab0FNOJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:09:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33960 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab0FNOJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:09:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [Bug #15704] [r8169] WARNING: at net/sched/sch_generic.c
Date: Mon, 14 Jun 2010 16:07:47 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera> <YPGdyfWGvNK.A.lOB.b8OFMB@chimera> <20100614074155.GA3352@swordfish.minsk.epam.com>
In-Reply-To: <20100614074155.GA3352@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201006141607.47679.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 14, 2010, Sergey Senozhatsky wrote:
> On (06/13/10 16:48), Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15704
> > Subject		: [r8169] WARNING: at net/sched/sch_generic.c
> > Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > Date		: 2010-03-31 10:21 (75 days old)
> > Message-ID	: <<<20100331102142.GA3294@swordfish.minsk.epam.com>>>
> > References	: http://marc.info/?l=linux-kernel&m=127003090406108&w=2
> > 
> > 
> 
> 
> Hello,
> 
> .35-rc3
> 
> kernel: [  109.024175] pktgen 2.73: Packet Generator for packet performance testing.
> kernel: [  144.360001] ------------[ cut here ]------------
> kernel: [  144.360012] WARNING: at net/sched/sch_generic.c:258 dev_watchdog+0xc1/0x129()
> kernel: [  144.360016] Hardware name: F3JC                
> kernel: [  144.360019] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
> kernel: [  144.360022] Modules linked in: pktgen snd_hwdep snd_hda_codec_si3054 snd_hda_codec_realtek snd_hda_intel asus_laptop sparse_keymap sdhci_pci sdhci mmc_core led_class snd_hda_codec i2c_i801 rng_core snd_pcm snd_timer
> snd_page_alloc snd soundcore psmouse sg serio_raw evdev r8169 mii usbhid hid uhci_hcd ehci_hcd sr_mod usbcore cdrom sd_mod ata_piix
> kernel: [  144.360073] Pid: 3424, comm: kpktgend_0 Not tainted 2.6.35-rc3-dbg-00106-ga75e02b #2
> kernel: [  144.360076] Call Trace:
> kernel: [  144.360085]  [<c102dc0a>] warn_slowpath_common+0x65/0x7a
> kernel: [  144.360090]  [<c1266683>] ? dev_watchdog+0xc1/0x129
> kernel: [  144.360095]  [<c102dc83>] warn_slowpath_fmt+0x26/0x2a
> kernel: [  144.360100]  [<c1266683>] dev_watchdog+0xc1/0x129
> kernel: [  144.360107]  [<c10365af>] ? run_timer_softirq+0x136/0x22b
> kernel: [  144.360113]  [<c1036608>] run_timer_softirq+0x18f/0x22b
> kernel: [  144.360118]  [<c10365af>] ? run_timer_softirq+0x136/0x22b
> kernel: [  144.360123]  [<c12665c2>] ? dev_watchdog+0x0/0x129
> kernel: [  144.360129]  [<c10322d2>] __do_softirq+0x79/0xec
> kernel: [  144.360135]  [<c103236f>] do_softirq+0x2a/0x2f
> kernel: [  144.360140]  [<c1032519>] _local_bh_enable_ip+0x65/0x86
> kernel: [  144.360145]  [<c1032542>] local_bh_enable_ip+0x8/0xa
> kernel: [  144.360151]  [<c12c354b>] _raw_spin_unlock_bh+0x2f/0x32
> kernel: [  144.360158]  [<f808e5c7>] pktgen_xmit+0xda2/0xe6f [pktgen]
> kernel: [  144.360168]  [<fd1d57b8>] ? rtl8169_start_xmit+0x0/0x307 [r8169]
> kernel: [  144.360174]  [<c1002d70>] ? common_interrupt+0x30/0x38
> kernel: [  144.360180]  [<c104c65d>] ? __lock_acquire+0x1d6/0x3ca
> kernel: [  144.360187]  [<f808e88f>] ? pktgen_thread_worker+0x96/0x5c3 [pktgen]
> kernel: [  144.360193]  [<c1028a2f>] ? get_parent_ip+0xb/0x31
> kernel: [  144.360198]  [<c1028ad1>] ? sub_preempt_count+0x7c/0x89
> kernel: [  144.360205]  [<f808e969>] pktgen_thread_worker+0x170/0x5c3 [pktgen]
> kernel: [  144.360209]  [<c12c1e13>] ? schedule+0x535/0x545
> kernel: [  144.360216]  [<c103f1d2>] ? autoremove_wake_function+0x0/0x2f
> kernel: [  144.360221]  [<c103f1d2>] ? autoremove_wake_function+0x0/0x2f
> kernel: [  144.360227]  [<f808e7f9>] ? pktgen_thread_worker+0x0/0x5c3 [pktgen]
> kernel: [  144.360232]  [<c103eee2>] kthread+0x6a/0x6f
> kernel: [  144.360238]  [<c103ee78>] ? kthread+0x0/0x6f
> kernel: [  144.360243]  [<c1002d7e>] kernel_thread_helper+0x6/0x10
> kernel: [  144.360247] ---[ end trace a692664bf7dac635 ]---

Thanks for the update.

Rafael
