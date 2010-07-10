Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab0GJNAv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 09:00:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35734 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988Ab0GJNAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 09:00:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [Bug #15704] [r8169] WARNING: at net/sched/sch_generic.c
Date: Sat, 10 Jul 2010 14:59:29 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <xkNyyYrLiTN.A.s_G.7p7NMB@chimera> <Hc02ROPrUsG.A.F4.bt7NMB@chimera> <20100710095244.GA4121@swordfish>
In-Reply-To: <20100710095244.GA4121@swordfish>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201007101459.29375.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 10, 2010, Sergey Senozhatsky wrote:
> On (07/10/10 02:33), Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15704
> > Subject		: [r8169] WARNING: at net/sched/sch_generic.c
> > Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > Date		: 2010-03-31 10:21 (101 days old)
> > Message-ID	: <20100331102142.GA3294@swordfish.minsk.epam.com>
> > References	: http://marc.info/?l=linux-kernel&m=127003090406108&w=2
> > 
> > 
> 
> Hello,
> 
> [ 3564.850086] pktgen 2.73: Packet Generator for packet performance testing.
> [ 3580.993027] ------------[ cut here ]------------
> [ 3580.993039] WARNING: at net/sched/sch_generic.c:258 dev_watchdog+0xc1/0x129()
> [ 3580.993043] Hardware name: F3JC                
> [ 3580.993046] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
> [ 3580.993049] Modules linked in: pktgen ppp_async crc_ccitt ipv6 ppp_generic slhc usb_storage snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_hwdep snd_hda_codec_si3054 snd_pcm_oss snd_mixer_oss
> snd_hda_codec_realtek sdhci_pci sdhci mmc_core asus_laptop sparse_keymap led_class snd_hda_intel snd_hda_codec snd_pcm psmouse rng_core i2c_i801 snd_timer snd_page_alloc sg snd soundcore serio_raw evdev r8169 mii usbhid hid uhci_hcd
> ehci_hcd sr_mod usbcore cdrom sd_mod ata_piix
> [ 3580.993120] Pid: 0, comm: swapper Not tainted 2.6.35-rc4-dbg-git4-00247-g5bbf43d-dirty #72
> [ 3580.993124] Call Trace:
> [ 3580.993132]  [<c102e3a6>] warn_slowpath_common+0x65/0x7a
> [ 3580.993137]  [<c12694af>] ? dev_watchdog+0xc1/0x129
> [ 3580.993143]  [<c102e41f>] warn_slowpath_fmt+0x26/0x2a
> [ 3580.993148]  [<c12694af>] dev_watchdog+0xc1/0x129
> [ 3580.993155]  [<c10370ab>] ? run_timer_softirq+0x136/0x22b
> [ 3580.993160]  [<c1037104>] run_timer_softirq+0x18f/0x22b
> [ 3580.993165]  [<c10370ab>] ? run_timer_softirq+0x136/0x22b
> [ 3580.993171]  [<c12693ee>] ? dev_watchdog+0x0/0x129
> [ 3580.993177]  [<c1032c2d>] __do_softirq+0x88/0x10c
> [ 3580.993183]  [<c1032ce0>] do_softirq+0x2f/0x47
> [ 3580.993188]  [<c1032f9d>] irq_exit+0x38/0x75
> [ 3580.993193]  [<c10159b8>] smp_apic_timer_interrupt+0x5f/0x6d
> [ 3580.993200]  [<c12c732a>] apic_timer_interrupt+0x36/0x3c
> [ 3580.993207]  [<c104007b>] ? __kfifo_peek_n+0x1b/0x2b
> [ 3580.993213]  [<c11dd5f6>] ? acpi_idle_enter_simple+0x117/0x14b
> [ 3580.993220]  [<c12468e9>] cpuidle_idle_call+0x6a/0xa0
> [ 3580.993225]  [<c100170d>] cpu_idle+0x89/0xbe
> [ 3580.993232]  [<c12c1e6d>] start_secondary+0x1f4/0x1fb
> [ 3580.993237] ---[ end trace 0e0b0610391f3050 ]---
> [ 3581.009527] r8169 0000:02:00.0: eth0: link up

Thanks for the update, but I'm not really sure if r8169 is involved.
It seems that cpuidle is the source of the warning.

Rafael
