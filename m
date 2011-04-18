Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab1DRQMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:12:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab1DRQMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:12:45 -0400
Date: Mon, 18 Apr 2011 12:12:39 -0400
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: WARN_ON report from clockevents_program_event
Message-ID: <20110418161238.GB1903@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20110417182958.GA1821@redhat.com>
 <alpine.LFD.2.00.1104180934010.2744@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1104180934010.2744@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 09:35:19AM +0200, Thomas Gleixner wrote:
 > On Sun, 17 Apr 2011, Dave Jones wrote:
 > 
 > > I just hit this warning on a box under heavy load.
 > > 
 > > WARNING: at kernel/time/clockevents.c:110 clockevents_program_event+0x37/0x90()
 > > Hardware name: GA-MA78GM-S2H
 > > Modules linked in: microcode fuse btrfs zlib_deflate tun uinput rfcomm pn_pep can_raw cmtp kernelcapi sctp libcrc32c hidp can pppoe pppox ppp_generic slhc appletalk rds rose ax25 decnet irda crc_ccitt af_key phonet bluetooth rfkill af_802154 ipx p8022 psnap llc p8023 atm nfsd lockd nfs_acl auth_rpcgss sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ppdev snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore edac_core pcspkr snd_page_alloc edac_mce_amd k10temp sp5100_tco i2c_piix4 r8169 mii parport_pc parport wmi lm63 ipv6 pata_acpi firewire_ohci ata_generic firewire_core crc_itu_t pata_atiixp floppy radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
 > > Pid: 16066, comm: trinity Not tainted 2.6.39-rc3+ #3
 > > Call Trace:
 > >  <IRQ>  [<ffffffff810569ac>] warn_slowpath_common+0x83/0x9b
 > >  [<ffffffff810569de>] warn_slowpath_null+0x1a/0x1c
 > >  [<ffffffff81080380>] clockevents_program_event+0x37/0x90
 > >  [<ffffffff8108144d>] tick_dev_program_event+0x3c/0xfb
 > >  [<ffffffff8108152b>] tick_program_event+0x1f/0x21
 > >  [<ffffffff81076c41>] hrtimer_interrupt+0x127/0x1c2
 > >  [<ffffffff814c410e>] smp_apic_timer_interrupt+0x79/0x8c
 > >  [<ffffffff814c2f93>] apic_timer_interrupt+0x13/0x20
 > >  <EOI>  [<ffffffff814c257a>] ? sysret_check+0x2e/0x69
 > > ---[ end trace 76ca0db688fca8df ]---
 > > hrtimer: interrupt took 47180328 ns
 > 
 > Huch, what did you do to make the timer interrupt run 47ms ? There is
 > something badly wrong.

This is probably a 'root shot himself in the foot' thing.

I ran my system call fuzzer from a wrong shell, which was a very bad idea.
(It seems to have actually destroyed the hardware, no longer even POSTs. oops).

	Dave

