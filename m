Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab0EXNBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 09:01:09 -0400
Received: from ns.hanzlici.cz ([212.158.159.56]:52647 "EHLO hanzlici.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab0EXNBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 09:01:06 -0400
X-Greylist: delayed 1411 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 May 2010 09:01:06 EDT
Message-ID: <4BFA730C.1010906@hanzlici.cz>
Date: Mon, 24 May 2010 14:37:32 +0200
From: Frantisek Hanzlik <franta@hanzlici.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.9.1.9) Gecko/20100317 SeaMonkey/2.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: fs/fs-writeback oopses in kernel 2.6.33.4-95.fc13.i686.PAE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.5 (hanzlici.cz [192.168.1.254]); Mon, 24 May 2010 14:37:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I upgrade from kernel 2.6.33.3 to 2.6.33.4 (2.6.33.4-95.fc13.i686.PAE, 
Fedora 13 distro) and now I see several these messages every day in 
/var/log/messages:

May 24 14:01:32 ns kernel: ------------[ cut here ]------------
May 24 14:01:32 ns kernel: WARNING: at fs/fs-writeback.c:597 
writeback_inodes_wb+0x202/0x30e()
May 24 14:01:32 ns kernel: Hardware name: GA-MA785GMT-UD2H
May 24 14:01:32 ns kernel: Modules linked in: nfs fscache bluetooth rfkill 
inet_diag nfsd lockd nfs_acl auth_rpcgss exportfs a
utofs4 it87 hwmon_vid sunrpc cpufreq_ondemand powernow_k8 ppp_synctty 
ppp_async crc_ccitt ppp_generic slhc nf_conntrack_ftp ip
t_LOG xt_limit xt_recent ipt_MASQUERADE ipt_REDIRECT iptable_nat nf_nat 
xt_TCPMSS xt_helper xt_MARK xt_DSCP iptable_mangle kvm
_amd kvm uinput snd_hda_codec_atihdmi snd_hda_codec_realtek snd_hda_intel 
snd_hda_codec snd_hwdep snd_seq ppdev snd_seq_device
  parport_pc snd_pcm snd_timer i2c_piix4 r8169 parport snd soundcore 
snd_page_alloc e100 mii k10temp microcode raid1 ata_generi
c pata_acpi firewire_ohci firewire_core crc_itu_t pata_atiixp radeon ttm 
drm_kms_helper drm i2c_algo_bit i2c_core [last unload
ed: scsi_wait_scan]
May 24 14:01:32 ns kernel: Pid: 30516, comm: flush-9:3 Tainted: G        W 
  2.6.33.4-95.fc13.i686.PAE #1
May 24 14:01:32 ns kernel: Call Trace:
May 24 14:01:32 ns kernel: [<c043d629>] warn_slowpath_common+0x65/0x7c
May 24 14:01:32 ns kernel: [<c04e6dd9>] ? writeback_inodes_wb+0x202/0x30e
May 24 14:01:32 ns kernel: [<c043d64d>] warn_slowpath_null+0xd/0x10
May 24 14:01:32 ns kernel: [<c04e6dd9>] writeback_inodes_wb+0x202/0x30e
May 24 14:01:32 ns kernel: [<c04e6fe8>] wb_writeback+0x103/0x162
May 24 14:01:32 ns kernel: [<c0482e6d>] ? call_rcu+0x8/0xa
May 24 14:01:32 ns kernel: [<c04e70c4>] ? wb_clear_pending+0x6a/0x6f
May 24 14:01:32 ns kernel: [<c04e712e>] wb_do_writeback+0x65/0x128
May 24 14:01:32 ns kernel: [<c04e7219>] bdi_writeback_task+0x28/0x84
May 24 14:01:32 ns kernel: [<c04b0aed>] ? bdi_start_fn+0x0/0xa3
May 24 14:01:32 ns kernel: [<c04b0b42>] bdi_start_fn+0x55/0xa3
May 24 14:01:32 ns kernel: [<c04b0aed>] ? bdi_start_fn+0x0/0xa3
May 24 14:01:32 ns kernel: [<c045271f>] kthread+0x5f/0x64
May 24 14:01:32 ns kernel: [<c04526c0>] ? kthread+0x0/0x64
May 24 14:01:32 ns kernel: [<c0408dfe>] kernel_thread_helper+0x6/0x10
May 24 14:01:32 ns kernel: ---[ end trace 8bd04b585937393a ]---

HW is Gigabyte GA-MA785GMT-UD2H MB, AMD Athlon II X2 240e CPU, 2x2GB DDR3 
1066 nonECC RAM, 2x ST31500341AS 1.5TB SATA II HDD in SW RAID1 (md).
lspi:
00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge Alternate
00:01.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge 
(int gfx)
00:04.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge 
(PCIE port 0)
00:0a.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge 
(PCIE port 5)
00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller 
[AHCI mode]
00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3c)
00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 Controller
00:18.0 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, 
Sempron] HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, 
Sempron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, 
Sempron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, 
Sempron] Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, 
Sempron] Link Control
01:05.0 VGA compatible controller: ATI Technologies Inc RS880 [Radeon HD 4200]
01:05.1 Audio device: ATI Technologies Inc RS880 Audio Device [Radeon HD 4200]
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B 
PCI Express Gigabit Ethernet controller (rev 01)
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B 
PCI Express Gigabit Ethernet controller (rev 02)
04:06.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet Pro 
100 (rev 08)
04:07.0 Serial controller: 3Com Corp, Modem Division 56K FaxModem Model 
5610 (rev 01)
04:0e.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000 
Controller (PHY/Link)

It is not fatal error, system still continue work, but I not know, when it 
can be any dangerous for my disk data. Can anyone give any advice about this?

Thanks in advance, Franta Hanzlik
