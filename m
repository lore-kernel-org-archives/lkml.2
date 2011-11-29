Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab1K2Pn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 10:43:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49151 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219Ab1K2Pnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 10:43:55 -0500
Date: Tue, 29 Nov 2011 16:43:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: Lucas Stach <dev@lynxeye.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: Hangs with Linux 3.2.0-rc3
Message-ID: <20111129154352.GC13958@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Lucas Stach <dev@lynxeye.de>, LKML <linux-kernel@vger.kernel.org>,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <1322552218.1679.5.camel@tellur>
 <20111129080655.GA12809@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111129080655.GA12809@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 09:06:55AM +0100, Borislav Petkov wrote:
> > Nov 29 00:22:04 tellur kernel: [13936.370598] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
> > Nov 29 00:22:04 tellur kernel: [13936.370598] Hardware name: GA-970A-UD3
> > Nov 29 00:22:04 tellur kernel: [13936.370598] Watchdog detected hard LOCKUP on cpu 0
> > Nov 29 00:22:04 tellur kernel: [13936.370598] Modules linked in: tcp_lp ppdev parport_pc lp parport fuse nfs fscache auth_rpcgss nfs_acl ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat iptable_mangle tun lockd bridge stp llc bluetooth rfkill it87 adt7475 hwmon_vid ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm ir_lirc_codec lirc_dev ir_mce_kbd_decoder snd_timer snd ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ata_generic pata_acpi edac_core serio_raw soundcore joydev ir_rc5_decoder pata_atiixp ir_nec_decoder r8169 mii mceusb rc_core virtio_net edac_mce_amd sp5100_tco i2c_piix4 xhci_hcd fam15h_power pcspkr snd_page_alloc microcode k10temp virtio_ring virtio kvm_amd kvm uinput sunrpc ipv6 usb_storage firewire_ohci uas firewire_core crc_itu_t nouveau ttm drm_kms_helper drm hwmon i2c_algo_bit i2c_core mxm_wmi video wmi [last unloaded: scsi_wait_scan]
> > Nov 29 00:22:04 tellur kernel: [13936.370598] Pid: 0, comm: swapper Not tainted 3.2.0-rc3+ #39
> > Nov 29 00:22:04 tellur kernel: [13936.370598] Call Trace:
> > Nov 29 00:22:04 tellur kernel: [13936.370598]  <NMI>  [<ffffffff81050c5a>] warn_slowpath_common+0x83/0x9b
> > Nov 29 00:22:04 tellur kernel: [13936.370598]  [<ffffffff81050d15>] warn_slowpath_fmt+0x46/0x48
> > Nov 29 00:22:04 tellur kernel: [13936.370598]  [<ffffffff81015204>] ? native_sched_clock+0x34/0x36
> > Nov 29 00:22:04 tellur kernel: [13936.370598]  [<ffffffff810a7abb>] watchdog_overflow_callback+0x9b/0xa6
> > Nov 29 00:22:04 tellur kernel: [13936.370598]  [<ffffffff810d28c5>] __perf_event_overflow+0x100/0x17f
> > Nov 29 00:22:04 tellur kernel: [13936.370598]  [<ffffffff8107055b>] ? local_clock+0x27/0x2f
> > Nov 29 00:22:04 tellur kernel: [13936.370598]  [<ffffffff810d0cb6>] ? perf_event_update_userpage+0xf/0xa3
> > Nov 29 00:22:04 tellur kernel: [13936.370598]  [<ffffffff810d2f2e>] perf_event_overflow+0x14/0x16
> > Nov 29 00:22:04 tellur kernel: [13936.370598]  [<ffffffff8101c22a>] x86_pmu_handle_irq+0xbe/0xf9
> > Nov 29 00:22:04 tellur kernel: [13936.370598]  [<ffffffff814aa5ee>] perf_event_nmi_handler+0x19/0x1b
> > Nov 29 00:22:04 tellur kernel: [13936.370598]  [<ffffffff814a9f77>] nmi_handle+0x42/0x67
> > Nov 29 00:22:04 tellur kernel: [13936.370598]  [<ffffffff814aa028>] do_nmi+0x8c/0x26f
> > Nov 29 00:22:04 tellur kernel: [13936.370598]  [<ffffffff814a9830>] nmi+0x20/0x30
> > Nov 29 00:22:04 tellur kernel: [13936.370598]  [<ffffffffa023bf55>] ? rtl8169_interrupt+0x268/0x2a4 [r8169]

Btw,

this looks like the box hanged itself after getting an net IRQ over your
r8169 which reminds me of this other issue being debugged on lkml in
conjunction with r8169:

http://marc.info/?l=linux-kernel&m=132225246211817&w=2

Can you try reproducing the issue without having network traffic. Also,
according to the thread above, 3.1 kernel is also affected so it could
make sense for you go back to 3.0 and see whether it happens with it
too.

HTH.

-- 
Regards/Gruss,
Boris.
