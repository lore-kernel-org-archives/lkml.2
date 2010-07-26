Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab0GZOek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 10:34:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44394 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab0GZOei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 10:34:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=w7Pzipsx4rXoniALc3v44+GuR4Tr2lKplhDg6BCdJR6c/yTBfW9NneWlMQsieOoIxq
         k49Smyi6UQveuUeMygZiXNO3iVb9VfJGMkIXPtuqMdXB45rlDk7KqtExgZlu0dZXsfhr
         I0ZhJSZTHrEZ4Sjt/nno/i9MLQ0qdPJS1gmlw=
Subject: Re: [Bug #15704] [r8169] WARNING: at net/sched/sch_generic.c
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <20100726131629.GA4398@swordfish.minsk.epam.com>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
	 <PRbv8sgxY6G.A.UEH.mYYSMB@chimera>
	 <20100726131629.GA4398@swordfish.minsk.epam.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Jul 2010 16:34:33 +0200
Message-ID: <1280154873.2899.390.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 26 juillet 2010 à 16:16 +0300, Sergey Senozhatsky a écrit :
> On (07/23/10 14:15), Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15704
> > Subject		: [r8169] WARNING: at net/sched/sch_generic.c
> > Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > Date		: 2010-03-31 10:21 (115 days old)
> > Message-ID	: <20100331102142.GA3294@swordfish.minsk.epam.com>
> > References	: http://marc.info/?l=linux-kernel&m=127003090406108&w=2
> > 
> > 
> 
> Hello,
> Sorry for the dealy - I've been away.
> So, the bad news are that this is probably the last time I can test this bug. This laptop will
> no longer be available. Sorry.
> 
> 
> [ 2599.495508] pktgen 2.73: Packet Generator for packet performance testing.
> [ 2630.016019] ------------[ cut here ]------------
> [ 2630.016031] WARNING: at net/sched/sch_generic.c:258 dev_watchdog+0xc1/0x129()
> [ 2630.016035] Hardware name: F3JC                
> [ 2630.016038] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
> [ 2630.016041] Modules linked in: pktgen ipv6 arc4 ecb iwl3945 snd_hwdep iwlcore snd_seq_dummy snd_hda_codec_si3054 snd_hda_codec_realtek snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device mac80211 snd_pcm_oss snd_mixer_oss asus_laptop
> snd_hda_intel sparse_keymap sdhci_pci sdhci mmc_core led_class cfg80211 snd_hda_codec snd_pcm snd_timer snd_page_alloc snd rng_core soundcore usb_storage sg psmouse evdev i2c_i801 serio_raw r8169 mii uhci_hcd ehci_hcd sd_mod sr_mod usbcore
> cdrom ata_piix
> [ 2630.016114] Pid: 4282, comm: kpktgend_0 Not tainted 2.6.35-rc6-dbg-git1-00136-g459ab2a-dirty #75
> [ 2630.016118] Call Trace:
> [ 2630.016125]  [<c102e3ae>] warn_slowpath_common+0x65/0x7a
> [ 2630.016131]  [<c12695f3>] ? dev_watchdog+0xc1/0x129
> [ 2630.016136]  [<c102e427>] warn_slowpath_fmt+0x26/0x2a
> [ 2630.016142]  [<c12695f3>] dev_watchdog+0xc1/0x129
> [ 2630.016149]  [<c10370b3>] ? run_timer_softirq+0x136/0x22b
> [ 2630.016154]  [<c103710c>] run_timer_softirq+0x18f/0x22b
> [ 2630.016160]  [<c10370b3>] ? run_timer_softirq+0x136/0x22b
> [ 2630.016165]  [<c1269532>] ? dev_watchdog+0x0/0x129
> [ 2630.016171]  [<c1032c35>] __do_softirq+0x88/0x10c
> [ 2630.016177]  [<c1032ce8>] do_softirq+0x2f/0x47
> [ 2630.016182]  [<c1032fa5>] irq_exit+0x38/0x75
> [ 2630.016187]  [<c10159b8>] smp_apic_timer_interrupt+0x5f/0x6d
> [ 2630.016195]  [<f80555e4>] ? pktgen_xmit+0xda2/0xe6f [pktgen]
> [ 2630.016202]  [<c12c75a2>] apic_timer_interrupt+0x36/0x3c
> [ 2630.016208]  [<f80555e4>] ? pktgen_xmit+0xda2/0xe6f [pktgen]
> [ 2630.016214]  [<f80555e4>] ? pktgen_xmit+0xda2/0xe6f [pktgen]
> [ 2630.016220]  [<c104007b>] ? __kfifo_peek_n+0x13/0x2b
> [ 2630.016226]  [<c1032edd>] ? _local_bh_enable_ip+0x9d/0xb3
> [ 2630.016231]  [<c1032efb>] local_bh_enable_ip+0x8/0xa
> [ 2630.016236]  [<c12c6aaa>] _raw_spin_unlock_bh+0x2f/0x32
> [ 2630.016242]  [<f80555e4>] pktgen_xmit+0xda2/0xe6f [pktgen]
> [ 2630.016253]  [<f91707b8>] ? rtl8169_start_xmit+0x0/0x307 [r8169]
> [ 2630.016261]  [<c11800d8>] ? plist_add+0x85/0x87
> [ 2630.016267]  [<f80558ac>] ? pktgen_thread_worker+0x96/0x5c3 [pktgen]
> [ 2630.016273]  [<c1029096>] ? get_parent_ip+0xb/0x31
> [ 2630.016279]  [<c1029138>] ? sub_preempt_count+0x7c/0x89
> [ 2630.016285]  [<f8055986>] pktgen_thread_worker+0x170/0x5c3 [pktgen]
> [ 2630.016290]  [<c12c52bb>] ? schedule+0x535/0x545
> [ 2630.016296]  [<c103fd96>] ? autoremove_wake_function+0x0/0x2f
> [ 2630.016301]  [<c103fd96>] ? autoremove_wake_function+0x0/0x2f
> [ 2630.016307]  [<f8055816>] ? pktgen_thread_worker+0x0/0x5c3 [pktgen]
> [ 2630.016313]  [<c103faa6>] kthread+0x6a/0x6f
> [ 2630.016318]  [<c103fa3c>] ? kthread+0x0/0x6f
> [ 2630.016324]  [<c1002d82>] kernel_thread_helper+0x6/0x10
> [ 2630.016328] ---[ end trace 0bdadff7f249bd0d ]---
> [ 2630.032549] r8169 0000:02:00.0: eth0: link up
> 
> 
> 	Sergey

r8169 driver misses a netif_carrier_off() call somewhere, probably when
adapter is reset

Sergey, do you run a pktgen only test (sending packets, and not
receiving packets during the test), or a mixed workload ?

r8169 is known to reset if the RX ring buffer is stressed too much.




