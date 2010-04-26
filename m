Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab0DZTYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:24:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45021 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066Ab0DZTYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:24:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [Bug #15704] [r8169] WARNING: at net/sched/sch_generic.c
Date: Mon, 26 Apr 2010 21:24:46 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.62H.yRSzLB@tosh> <20100426125119.GA3291@swordfish.minsk.epam.com>
In-Reply-To: <20100426125119.GA3291@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201004262124.46744.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 April 2010, Sergey Senozhatsky wrote:
> Hello,
> 
> On (04/20/10 05:19), Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.33.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> >
> 
> .34-rc5-git7
> 
> kernel: [12887.906682] pktgen 2.72: Packet Generator for packet performance testing.
> kernel: [12938.998730] ------------[ cut here ]------------
> kernel: [12938.998741] WARNING: at net/sched/sch_generic.c:256 dev_watchdog+0xc1/0x129()
> kernel: [12938.998745] Hardware name: F3JC                
> kernel: [12938.998748] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
> kernel: [12938.998751] Modules linked in: pktgen usb_storage ipv6 snd_hwdep snd_hda_codec_si3054 snd_hda_codec_realtek asus_laptop sparse_keymap sdhci_pci sdhci snd_hda_intel mmc_core led_class psmouse snd_hda_codec snd_pcm snd_timer snd
> soundcore snd_page_alloc serio_raw rng_core sg i2c_i801 evdev r8169 mii usbhid hid uhci_hcd ehci_hcd sr_mod cdrom sd_mod usbcore ata_piix
> kernel: [12938.998808] Pid: 4617, comm: kpktgend_0 Not tainted 2.6.34-rc5-dbg-r8169-git7 #97
> kernel: [12938.998811] Call Trace:
> kernel: [12938.998819]  [<c102e1b2>] warn_slowpath_common+0x65/0x7c
> kernel: [12938.998824]  [<c1268085>] ? dev_watchdog+0xc1/0x129
> kernel: [12938.998829]  [<c102e1fd>] warn_slowpath_fmt+0x24/0x27
> kernel: [12938.998834]  [<c1268085>] dev_watchdog+0xc1/0x129
> kernel: [12938.998841]  [<c1040039>] ? __kfifo_from_user_generic+0x30/0x5c
> kernel: [12938.998848]  [<c1036ae3>] ? run_timer_softirq+0x136/0x203
> kernel: [12938.998853]  [<c1036b3c>] run_timer_softirq+0x18f/0x203
> kernel: [12938.998858]  [<c1036ae3>] ? run_timer_softirq+0x136/0x203
> kernel: [12938.998864]  [<c1267fc4>] ? dev_watchdog+0x0/0x129
> kernel: [12938.998870]  [<c1032a72>] __do_softirq+0x88/0x10c
> kernel: [12938.998875]  [<c1032b25>] do_softirq+0x2f/0x47
> kernel: [12938.998883]  [<f8095488>] ? pktgen_xmit+0xd3e/0xe0b [pktgen]
> kernel: [12938.998888]  [<c1032d08>] _local_bh_enable_ip+0x8b/0xb3
> kernel: [12938.998894]  [<c1032d38>] local_bh_enable_ip+0x8/0xa
> kernel: [12938.998900]  [<c12c3818>] _raw_spin_unlock_bh+0x2f/0x32
> kernel: [12938.998906]  [<f8095488>] pktgen_xmit+0xd3e/0xe0b [pktgen]
> kernel: [12938.998913]  [<c104463c>] ? sched_clock_cpu+0x121/0x131
> kernel: [12938.998922]  [<fd1cf5e4>] ? rtl8169_start_xmit+0x0/0x2f9 [r8169]
> kernel: [12938.998928]  [<f8095793>] ? pktgen_thread_worker+0xd9/0x5e8 [pktgen]
> kernel: [12938.998934]  [<c1044679>] ? cpu_clock+0x2d/0x4e
> kernel: [12938.998941]  [<c104d1f7>] ? put_lock_stats+0xd/0x21
> kernel: [12938.998946]  [<c104d2c0>] ? lock_release_holdtime+0xb5/0xba
> kernel: [12938.998952]  [<f8095793>] ? pktgen_thread_worker+0xd9/0x5e8 [pktgen]
> kernel: [12938.998959]  [<f809582a>] pktgen_thread_worker+0x170/0x5e8 [pktgen]
> kernel: [12938.998965]  [<c103fa46>] ? autoremove_wake_function+0x0/0x2f
> kernel: [12938.998971]  [<c103fa46>] ? autoremove_wake_function+0x0/0x2f
> kernel: [12938.998977]  [<f80956ba>] ? pktgen_thread_worker+0x0/0x5e8 [pktgen]
> kernel: [12938.998982]  [<c103f76a>] kthread+0x6a/0x6f
> kernel: [12938.998988]  [<c103f700>] ? kthread+0x0/0x6f
> kernel: [12938.998994]  [<c1002dc2>] kernel_thread_helper+0x6/0x10
> kernel: [12938.998998] ---[ end trace 030ae30a64f8cf05 ]---
> kernel: [12939.012657] r8169 0000:02:00.0: eth0: link up
> kernel: [12951.012273] r8169 0000:02:00.0: eth0: link up
> kernel: [12951.475547] pktgen: interface: eth0 is already stopped

Thanks for the update.

Rafael
