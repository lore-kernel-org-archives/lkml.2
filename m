Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab0EFTbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 15:31:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53103 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811Ab0EFTbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 15:31:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [Bug #15704] [r8169] WARNING: at net/sched/sch_generic.c
Date: Thu, 6 May 2010 21:32:58 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <JzEGxUyyQHG.A.ZtH.YHJ4LB@chimera> <8VO9AsMlpMD.A.zHB.NJJ4LB@chimera> <20100506133102.GA3331@swordfish>
In-Reply-To: <20100506133102.GA3331@swordfish>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201005062132.58717.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 May 2010, Sergey Senozhatsky wrote:
> Hello,
> 
> On (05/04/10 23:21), Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15704
> > Subject		: [r8169] WARNING: at net/sched/sch_generic.c
> > Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > Date		: 2010-03-31 10:21 (35 days old)
> > Message-ID	: <<20100331102142.GA3294@swordfish.minsk.epam.com>>
> > References	: http://marc.info/?l=linux-kernel&m=127003090406108&w=2
> > 
> > 
> 
> .34-rc6-git5
> 
> kernel: [ 1176.647885] pktgen 2.72: Packet Generator for packet performance testing.
> kernel: [ 1210.999903] ------------[ cut here ]------------
> kernel: [ 1210.999914] WARNING: at net/sched/sch_generic.c:256 dev_watchdog+0xc1/0x129()
> kernel: [ 1210.999918] Hardware name: F3JC                
> kernel: [ 1210.999921] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
> kernel: [ 1210.999924] Modules linked in: pktgen ppp_async crc_ccitt ipv6 ppp_generic slhc asus_laptop sparse_keymap snd_hwdep sdhci_pci sdhci snd_hda_codec_si3054 mmc_core led_class snd_hda_codec_realtek snd_hda_intel snd_hda_codec
> snd_pcm rng_core snd_timer snd_page_alloc psmouse snd evdev soundcore sg r8169 serio_raw mii i2c_i801 usbhid hid uhci_hcd sr_mod ehci_hcd cdrom usbcore sd_mod ata_piix
> kernel: [ 1210.999983] Pid: 3819, comm: kpktgend_0 Not tainted 2.6.34-rc6-dbg-git5 #109
> kernel: [ 1210.999987] Call Trace:
> kernel: [ 1210.999994]  [<c102e1c6>] warn_slowpath_common+0x65/0x7c
> kernel: [ 1210.999999]  [<c12690a5>] ? dev_watchdog+0xc1/0x129
> kernel: [ 1211.000005]  [<c102e211>] warn_slowpath_fmt+0x24/0x27
> kernel: [ 1211.000010]  [<c12690a5>] dev_watchdog+0xc1/0x129
> kernel: [ 1211.000017]  [<c1040039>] ? __kfifo_from_user_generic+0x18/0x5c
> kernel: [ 1211.000024]  [<c1036af7>] ? run_timer_softirq+0x136/0x203
> kernel: [ 1211.000029]  [<c1036b50>] run_timer_softirq+0x18f/0x203
> kernel: [ 1211.000034]  [<c1036af7>] ? run_timer_softirq+0x136/0x203
> kernel: [ 1211.000039]  [<c1268fe4>] ? dev_watchdog+0x0/0x129
> kernel: [ 1211.000046]  [<c1032a86>] __do_softirq+0x88/0x10c
> kernel: [ 1211.000051]  [<c1032b39>] do_softirq+0x2f/0x47
> kernel: [ 1211.000059]  [<f80a3488>] ? pktgen_xmit+0xd3e/0xe0b [pktgen]
> kernel: [ 1211.000064]  [<c1032d1c>] _local_bh_enable_ip+0x8b/0xb3
> kernel: [ 1211.000070]  [<c1032d4c>] local_bh_enable_ip+0x8/0xa
> kernel: [ 1211.000076]  [<c12c4858>] _raw_spin_unlock_bh+0x2f/0x32
> kernel: [ 1211.000082]  [<f80a3488>] pktgen_xmit+0xd3e/0xe0b [pktgen]
> kernel: [ 1211.000088]  [<c1044654>] ? sched_clock_cpu+0x121/0x131
> kernel: [ 1211.000098]  [<fd1e75e9>] ? rtl8169_start_xmit+0x0/0x2f9 [r8169]
> kernel: [ 1211.000104]  [<c1044691>] ? cpu_clock+0x2d/0x4e
> kernel: [ 1211.000111]  [<c104d20f>] ? put_lock_stats+0xd/0x21
> kernel: [ 1211.000116]  [<c104d2d8>] ? lock_release_holdtime+0xb5/0xba
> kernel: [ 1211.000122]  [<f80a3793>] ? pktgen_thread_worker+0xd9/0x5e8 [pktgen]
> kernel: [ 1211.000129]  [<f80a382a>] pktgen_thread_worker+0x170/0x5e8 [pktgen]
> kernel: [ 1211.000135]  [<c103fa5e>] ? autoremove_wake_function+0x0/0x2f
> kernel: [ 1211.000141]  [<c103fa5e>] ? autoremove_wake_function+0x0/0x2f
> kernel: [ 1211.000147]  [<f80a36ba>] ? pktgen_thread_worker+0x0/0x5e8 [pktgen]
> kernel: [ 1211.000152]  [<c103f782>] kthread+0x6a/0x6f
> kernel: [ 1211.000158]  [<c103f718>] ? kthread+0x0/0x6f
> kernel: [ 1211.000163]  [<c1002dc2>] kernel_thread_helper+0x6/0x10
> kernel: [ 1211.000167] ---[ end trace adf7c4da01cca262 ]---
> kernel: [ 1211.013760] r8169 0000:02:00.0: eth0: link up

Thanks for the update.

Rafael
