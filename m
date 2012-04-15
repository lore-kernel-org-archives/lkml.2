Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab2DOVx7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 17:53:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51002 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2DOVx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 17:53:58 -0400
Date: Sun, 15 Apr 2012 22:53:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Joel Reardon <joel@clambassador.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: mtdchar kernel oops
Message-ID: <20120415215355.GS6589@ZenIV.linux.org.uk>
References: <alpine.DEB.2.00.1204151350450.13924@eristoteles.iwoars.net>
 <20120415153220.GR6589@ZenIV.linux.org.uk>
 <alpine.DEB.2.00.1204151951560.16000@eristoteles.iwoars.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1204151951560.16000@eristoteles.iwoars.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 07:57:51PM +0200, Joel Reardon wrote:
> Nope, still there.
> 
> As example trace:
> 
> [  162.141319] BUG: unable to handle kernel paging request at 367fb000
> [  162.141405] IP: [<c023614f>] mntget+0xf/0x20
> [  162.141463] *pde = 00000000
> [  162.141499] Oops: 0002 [#1] SMP
> [  162.141542] Modules linked in: mtdchar nandsim nand nand_ids mtd
> nand_ecc aes_i586 aes_generic parport_pc ppdev dm_crypt snd_hda_codec_hdmi
> snd_hda_codec_conexant snd_hda_intel snd_hda_codec btusb bluetooth
> snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm thinkpad_acpi binfmt_misc
> snd_seq_dummy snd_seq_oss snd_seq_midi arc4 snd_rawmidi snd_seq_midi_event
> snd_seq iwlwifi mac80211 snd_timer snd_seq_device snd coretemp tpm_tis
> cfg80211 psmouse serio_raw joydev soundcore snd_page_alloc tpm microcode
> tpm_bios nvram lp parport fbcon i915 tileblit font bitblit softcursor
> drm_kms_helper usbhid hid mmc_block drm mxm_wmi crc32c_intel firewire_ohci
> sdhci_pci sdhci ahci libahci firewire_core crc_itu_t i2c_algo_bit video
> intel_agp intel_gtt agpgart e1000e [last unloaded: kvm]
> [  162.142435]
> [  162.142456] Pid: 2260, comm: ubiformat Not tainted
> [  162.142569] EIP: 0060:[<c023614f>] EFLAGS: 00010282 CPU: 1
> [  162.142632] EIP is at mntget+0xf/0x20
> [  162.142674] EAX: f6804c10 EBX: f917ff38 ECX: 00000073 EDX: 00000000
> [  162.142744] ESI: f917ff34 EDI: 00000000 EBP: f0847db8 ESP: f0847db8
> [  162.142815]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [  162.142875] CR0: 80050033 CR2: 367fb000 CR3: 36b56000 CR4: 000007d0
> [  162.142946] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  162.143016] DR6: ffff0ff0 DR7: 00000400
> [  162.143060] Process ubiformat (pid: 2260, ti=f0846000 task=f43fa5e0
> task.ti=f0846000)
> [  162.143146] Stack:
> [  162.143170]  f0847dd8 c023b888 f4834c00 f0847df0 c0a7088c fffffff3
> f3df00c0 00000000
> [  162.143271]  f0847df0 f917fa34 c0220231 00000000 f6f11440 00000000
> f0847e14 c0220252
> [  162.143372]  f3df00c0 f2795b70 c0a706bc 00000000 f3df00c0 f2795b70
> f11ff500 f0847e3c
> [  162.143474] Call Trace:
> [  162.143507]  [<c023b888>] simple_pin_fs+0x38/0xb0
> [  162.143570]  [<f917fa34>] mtdchar_open+0x44/0x1a8 [mtdchar]
> [  162.143636]  [<c0220231>] ? chrdev_open+0x71/0x180
> [  162.143692]  [<c0220252>] chrdev_open+0x92/0x180
> [  162.143749]  [<c021a2ee>] __dentry_open+0x1ee/0x2a0
> [  162.147258]  [<c021b72e>] nameidata_to_filp+0x6e/0x80
> [  162.150750]  [<c02201c0>] ? cdev_put+0x20/0x20
> [  162.154212]  [<c02286a7>] do_last+0x287/0x800
> [  162.157582]  [<c0229c45>] path_openat+0xa5/0x350
> [  162.160949]  [<c022a001>] do_filp_open+0x31/0x80
> [  162.164289]  [<c0234e93>] ? alloc_fd+0xa3/0xe0
> [  162.167577]  [<c0225cf5>] ? getname_flags+0xe5/0x160
> [  162.170862]  [<c021b81a>] do_sys_open+0xda/0x1a0
> [  162.174118]  [<c021b912>] sys_open+0x32/0x40
> [  162.177363]  [<c0615c63>] sysenter_do_call+0x12/0x28
> [  162.180564] Code: fe ff ff 89 d8 31 db e8 40 fa ff ff e9 6c ff ff ff 8d
> 74 26 00 8d bc 27 00 00 00 00 55 89 e5 3e 8d 74 26 00 85 c0 74 06 8b 50 0c
> <64> ff 02 5d c3 8d b6 00 00 00 00 8d bf 00 00 00 00 55 89 e5 53
> [  162.187488] EIP: [<c023614f>] mntget+0xf/0x20 SS:ESP 0068:f0847db8
> [  162.190993] CR2: 00000000367fb000
> [  162.261991] ---[ end trace 1e4490d14c39e9e1 ]---
> 
> 
> It also occasionally does it while modprobing nandsim and claims
> "mtd_probe" as the process.

Interesting...  Can't reproduce here and trace makes very little sense -
instructions around that point are
	8b 50 0c                mov    0xc(%eax),%edx
	64 ff 02                incl   %fs:(%edx)
and values in registers do not match the GFP address at all (well, %cr2
does, of course, but that's it).  How do you reproduce that sucker?
I don't have hardware mtd devices, so I tried to use block2mtd and ran
ubiformat on resulting /dev/mtd0.  Worked fine and it definitely had
done mtdchar_open()...

Could you add printk into mtdchar_open(), dumping mnt and count values
right after simple_pin_fs() call?
