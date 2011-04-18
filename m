Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab1DRHf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 03:35:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:39078 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1DRHfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 03:35:22 -0400
Date: Mon, 18 Apr 2011 09:35:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: WARN_ON report from clockevents_program_event
In-Reply-To: <20110417182958.GA1821@redhat.com>
Message-ID: <alpine.LFD.2.00.1104180934010.2744@localhost6.localdomain6>
References: <20110417182958.GA1821@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Apr 2011, Dave Jones wrote:

> I just hit this warning on a box under heavy load.
> 
> WARNING: at kernel/time/clockevents.c:110 clockevents_program_event+0x37/0x90()
> Hardware name: GA-MA78GM-S2H
> Modules linked in: microcode fuse btrfs zlib_deflate tun uinput rfcomm pn_pep can_raw cmtp kernelcapi sctp libcrc32c hidp can pppoe pppox ppp_generic slhc appletalk rds rose ax25 decnet irda crc_ccitt af_key phonet bluetooth rfkill af_802154 ipx p8022 psnap llc p8023 atm nfsd lockd nfs_acl auth_rpcgss sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ppdev snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore edac_core pcspkr snd_page_alloc edac_mce_amd k10temp sp5100_tco i2c_piix4 r8169 mii parport_pc parport wmi lm63 ipv6 pata_acpi firewire_ohci ata_generic firewire_core crc_itu_t pata_atiixp floppy radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
> Pid: 16066, comm: trinity Not tainted 2.6.39-rc3+ #3
> Call Trace:
>  <IRQ>  [<ffffffff810569ac>] warn_slowpath_common+0x83/0x9b
>  [<ffffffff810569de>] warn_slowpath_null+0x1a/0x1c
>  [<ffffffff81080380>] clockevents_program_event+0x37/0x90
>  [<ffffffff8108144d>] tick_dev_program_event+0x3c/0xfb
>  [<ffffffff8108152b>] tick_program_event+0x1f/0x21
>  [<ffffffff81076c41>] hrtimer_interrupt+0x127/0x1c2
>  [<ffffffff814c410e>] smp_apic_timer_interrupt+0x79/0x8c
>  [<ffffffff814c2f93>] apic_timer_interrupt+0x13/0x20
>  <EOI>  [<ffffffff814c257a>] ? sysret_check+0x2e/0x69
> ---[ end trace 76ca0db688fca8df ]---
> hrtimer: interrupt took 47180328 ns

Huch, what did you do to make the timer interrupt run 47ms ? There is
something badly wrong.

> which is ..
> 
> 109         if (unlikely(expires.tv64 < 0)) {
> 110                 WARN_ON_ONCE(1);
> 111                 return -ETIME;
> 112         }
> 
> 
> 	Dave
> 
