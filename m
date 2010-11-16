Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab0KPRAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 12:00:22 -0500
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:57151 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755267Ab0KPRAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 12:00:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=t6hqbdfa1Qy/922KccIDS70ynjatjcvcPFHUFKiXav5+7okPBa1arHfeHtzTmQNLDP8H0QSP8CqZOROfrSxYfimSTSAyYMOt6QvpTirjZjZ5DAcJraqL/TrBjRDQmvDI;
Date: Tue, 16 Nov 2010 09:00:01 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] PCI fixes
Message-ID: <20101116090001.5cbcea23@jbarnes-desktop>
In-Reply-To: <m28w0tzffv.fsf@whitebox.home>
References: <20101115094527.49464ed2@jbarnes-desktop>
	<m28w0tzffv.fsf@whitebox.home>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010 12:16:36 +0100
Andreas Schwab <schwab@linux-m68k.org> wrote:

> Jesse Barnes <jbarnes@virtuousgeek.org> writes:
> 
> > Martin Wilck (1):
> >       PCI: fix size checks for mmap() on /proc/bus/pci files
> 
> That breaks X.
> 
> process "X" tried to map 0x00010000 bytes at page 0x00000000 on 0000:00:10.0 BAR 2 (start 0x        90000000, size 0x           10000)
> ------------[ cut here ]------------
> WARNING: at drivers/pci/pci-sysfs.c:758
> Modules linked in: usb_storage uas uinput cpufreq_conservative rfcomm cpufreq_userspace cpufreq_powersave sco bridge stp llc bnep l2cap crc16 snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device tun nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_REJECT ip6t_LOG ip6table_filter ip6_tables xt_TCPMSS xt_recent ipt_MASQUERADE xt_state ipt_REJECT ipt_LOG xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables loop dm_mod btusb bluetooth arc4 snd_aoa_codec_tas ecb snd_aoa_fabric_layout snd_aoa snd_aoa_i2sbus snd_pcm b43 joydev mac80211 snd_timer snd_page_alloc firewire_ohci appletouch snd soundcore cfg80211 sungem sungem_phy firewire_core rfkill sr_mod crc_itu_t sg snd_aoa_soundbus ssb cdrom sd_mod pata_macio libata scsi_mod
> NIP: c0177b10 LR: c0177b10 CTR: 00000001
> REGS: c2461d90 TRAP: 0700   Tainted: G        W    (2.6.37-rc2)
> MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 20000824  XER: 20000000
> TASK = c2568d00[2009] 'X' THREAD: c2460000
> GPR00: c0177b10 c2461e40 c2568d00 0000008a 00006a86 ffffffff c055fb36 c055febc 
> GPR08: 000069fe c0440000 c055febc c2461e00 ffffffff 1022e9e4 10226a14 00000000 
> GPR16: 103eadc0 00000000 00000001 1022bf1c ef136688 00000000 ffffffea 00000001 
> GPR24: 00000000 00000000 00000000 00010000 ef806d68 ef136688 00000002 ef806c38 
> NIP [c0177b10] pci_mmap_resource+0xf0/0x174
> LR [c0177b10] pci_mmap_resource+0xf0/0x174
> Call Trace:
> [c2461e40] [c0177b10] pci_mmap_resource+0xf0/0x174 (unreliable)
> [c2461e80] [c00f7514] mmap+0x74/0xfc
> [c2461eb0] [c008e3e4] mmap_region+0x1e4/0x3bc
> [c2461f00] [c008e93c] sys_mmap_pgoff+0xa4/0xe0
> [c2461f30] [c00060a0] sys_mmap+0x28/0x40
> [c2461f40] [c0010bc4] ret_from_syscall+0x0/0x40
> --- Exception: c01 at 0xfa95f24
>     LR = 0xfd897c8
> Instruction dump:
> 3b400000 7fff0214 813f0134 38090001 7f6a0050 3c60c03d 7fc8f378 93410008 
> 39200000 3863bd36 9361000c 4819c31d <0fe00000> 3800ffea 48000070 7fc4f378 
> ---[ end trace a096109c06ace62c ]---

Oops, I think there's a fix here in my inbox, will either revert or
send the fix asap.

-- 
Jesse Barnes, Intel Open Source Technology Center
