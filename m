Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab0LJWe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 17:34:29 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33678 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab0LJWe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 17:34:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=WImHmwuIhwx3sQvy76Wv4Z/ys7ArR65MeARo9ElDsJd/j7jHRayaF5FdpiKfmPwTOR
         5Rk4F+THlPmggBO+VYwq2hxTLZlzolH98eloynfBdvrrhnW+g+evZzsuSTWtJkQV2P/g
         UpU/m8gpmM9rS6vDKCHtXnwtbddRikJC/913E=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: LKML <linux-kernel@vger.kernel.org>
Subject: Oops in 2.6.37-rc{3,4,5}
Date: Fri, 10 Dec 2010 22:34:06 +0000
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201012102234.06446.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not subscribed, so please cc me on any reply.

With rc kernels from 2.6.37, X frequently (approx 3 boots out of every 4) fails 
to start. dmesg shows the oops below. I can bisect over the weekend - probably 
Sunday - if no answer comes up in the meantime. I get the same oops with rc3, 
rc and rc5. rc2 doesn't get as far as trying to start X. Happy to test patches 
or provide additional diagnostics, but I'll be off line soon until 20:00 or so 
UK time tomorrow.

The hardware in my system is:
00:00.0 Host bridge: Intel Corporation 4 Series Chipset DRAM Controller (rev 03)
00:02.0 VGA compatible controller: Intel Corporation 4 Series Chipset Integrated 
Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation 4 Series Chipset Integrated 
Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition 
Audio Controller (rev 01)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 
(rev 01)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 
(rev 01)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #3 (rev 01)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #4 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI 
Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface 
Bridge (rev 01)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller 
(rev 01)
00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family) SATA IDE 
Controller (rev 01)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI 
Express Gigabit Ethernet controller (rev 02)
03:00.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 
Video Broadcast Decoder (rev d1)
03:01.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture 
(rev 11)
03:01.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 
11)
03:07.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000 
Controller (PHY/Link)

==================OOPS==============================
<snip>

[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
BUG: unable to handle kernel NULL pointer dereference at   (null)
IP: [<c13229ef>] __mutex_lock_slowpath+0x9f/0x170
*pdpt = 0000000034676001 *pde = 0000000000000000 
Oops: 0002 [#1] PREEMPT SMP 
last sysfs file: /sys/module/drm_kms_helper/initstate
Modules linked in: i915 drm_kms_helper drm fb fbdev cfbcopyarea video backlight 
output cfbimgblt cfbfillrect xt_state iptable_filter ipt_MASQUERADE iptable_nat 
nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 saa7134_alsa tda10048 
saa7134_dvb videobuf_dvb dvb_core mt20xx tea5767 tda9887 msp3400 gspca_zc3xx 
gspca_main tda18271 tda8290 ir_lirc_codec tuner lirc_dev bttv i2c_algo_bit 
btcx_risc snd_bt87x ir_common uhci_hcd ir_core saa7134 v4l2_common videodev 
v4l1_compat ehci_hcd videobuf_dma_sg videobuf_core tveeprom evdev [last 
unloaded: floppy]

Pid: 1725, comm: X Not tainted 2.6.37-rc5+ #476 EG41MF-US2H/EG41MF-US2H
EIP: 0060:[<c13229ef>] EFLAGS: 00013246 CPU: 3
EIP is at __mutex_lock_slowpath+0x9f/0x170
EAX: 00000000 EBX: f4403410 ECX: f4403420 EDX: f4641dd8
ESI: f4403414 EDI: 00000000 EBP: f4403418 ESP: f4641dd4
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process X (pid: 1725, ti=f4640000 task=f3c67390 task.ti=f4640000)
Stack:
 f3c67390 f4403418 00000000 f46a3800 f4403410 f4fd14f0 f425f600 f4403400
 c13228a6 f4fd1000 f4fd14f0 f8841b6c c10aabb2 ffffffff 05100004 f4c34000
 f4df72c0 c10aabf7 f4403410 00000001 f425f600 ffffffed f425f604 f46bfe40
Call Trace:
 [<c13228a6>] ? mutex_lock+0x16/0x30
 [<f8841b6c>] ? bttv_open+0xac/0x280 [bttv]
 [<c10aabb2>] ? cdev_get+0x52/0x90
 [<c10aabf7>] ? exact_lock+0x7/0x10
 [<f87095a7>] ? v4l2_open+0xb7/0xd0 [videodev]
 [<c10ab2ea>] ? chrdev_open+0xda/0x1b0
 [<c10a5f25>] ? __dentry_open+0xd5/0x280
 [<c10a7068>] ? nameidata_to_filp+0x68/0x70
 [<c10ab210>] ? chrdev_open+0x0/0x1b0
 [<c10b351f>] ? do_last.clone.32+0x34f/0x5a0
 [<c10b3af3>] ? do_filp_open+0x383/0x550
 [<c10b1e58>] ? getname+0x28/0xf0
 [<c10a70c8>] ? do_sys_open+0x58/0x110
 [<c10a5d09>] ? filp_close+0x49/0x70
 [<c10a71ac>] ? sys_open+0x2c/0x40
 [<c1002d10>] ? sysenter_do_call+0x12/0x26
 [<c1320000>] ? timer_cpu_notify+0x1b4/0x233
Code: 83 78 18 63 7f b6 8d b6 00 00 00 00 8d 73 04 8d 6b 08 89 f0 e8 f3 10 00 00 
8b 43 0c 8d 54 24 04 89 44 24 08 89 53 0c 89 6c 24 04 <89> 10 8b 04 24 ba ff ff 
ff ff 89 44 24 0c 89 d0 87 03 83 f8 01 
EIP: [<c13229ef>] __mutex_lock_slowpath+0x9f/0x170 SS:ESP 0068:f4641dd4
CR2: 0000000000000000
---[ end trace 5ac4e44ad0dc7959 ]---
note: X[1725] exited with preempt_count 2
BUG: scheduling while atomic: X/1725/0x10000003
Modules linked in: i915 drm_kms_helper drm fb fbdev cfbcopyarea video backlight 
output cfbimgblt cfbfillrect xt_state iptable_filter ipt_MASQUERADE iptable_nat 
nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 saa7134_alsa tda10048 
saa7134_dvb videobuf_dvb dvb_core mt20xx tea5767 tda9887 msp3400 gspca_zc3xx 
gspca_main tda18271 tda8290 ir_lirc_codec tuner lirc_dev bttv i2c_algo_bit 
btcx_risc snd_bt87x ir_common uhci_hcd ir_core saa7134 v4l2_common videodev 
v4l1_compat ehci_hcd videobuf_dma_sg videobuf_core tveeprom evdev [last 
unloaded: floppy]
Pid: 1725, comm: X Tainted: G      D     2.6.37-rc5+ #476
Call Trace:
 [<c1321f5d>] ? schedule+0x56d/0x8a0
 [<c1038656>] ? walk_system_ram_range+0xb6/0x1b0
 [<c10230d1>] ? free_memtype+0x151/0x1d0
 [<c10230d1>] ? free_memtype+0x151/0x1d0
 [<c1038766>] ? page_is_ram+0x16/0x30
 [<c1037560>] ? __is_ram+0x0/0x10
 [<c10228c3>] ? pat_pagerange_is_ram+0x73/0xa0
 [<c102cb43>] ? __cond_resched+0x13/0x30
 [<c1322340>] ? _cond_resched+0x20/0x30
 [<c10901b9>] ? unmap_vmas+0x659/0x7f0
 [<c11533ce>] ? vsnprintf+0x2ce/0x390
 [<c10963ea>] ? exit_mmap+0xca/0x180
 [<c102fa1e>] ? mmput+0x1e/0xa0
 [<c10339cc>] ? exit_mm+0xec/0x120
 [<c1067c62>] ? acct_collect+0x82/0x160
 [<c103525e>] ? do_exit+0x55e/0x6d0
 [<c1006554>] ? oops_end+0x84/0xc0
 [<c101fc40>] ? no_context+0xc0/0x190
 [<c101fe5f>] ? bad_area_nosemaphore+0xf/0x20
 [<c102027e>] ? do_page_fault+0x25e/0x400
 [<c102c2c9>] ? load_balance+0x99/0x670
 [<c1009bf4>] ? __switch_to_xtra+0xf4/0x120
 [<c1001cca>] ? __switch_to+0x1ba/0x1e0
 [<c1020020>] ? do_page_fault+0x0/0x400
 [<c132484e>] ? error_code+0x5a/0x60
 [<c1020020>] ? do_page_fault+0x0/0x400
 [<c13229ef>] ? __mutex_lock_slowpath+0x9f/0x170
 [<c13228a6>] ? mutex_lock+0x16/0x30
 [<f8841b6c>] ? bttv_open+0xac/0x280 [bttv]
 [<c10aabb2>] ? cdev_get+0x52/0x90
 [<c10aabf7>] ? exact_lock+0x7/0x10
 [<f87095a7>] ? v4l2_open+0xb7/0xd0 [videodev]
 [<c10ab2ea>] ? chrdev_open+0xda/0x1b0
 [<c10a5f25>] ? __dentry_open+0xd5/0x280
 [<c10a7068>] ? nameidata_to_filp+0x68/0x70
 [<c10ab210>] ? chrdev_open+0x0/0x1b0
 [<c10b351f>] ? do_last.clone.32+0x34f/0x5a0
 [<c10b3af3>] ? do_filp_open+0x383/0x550
 [<c10b1e58>] ? getname+0x28/0xf0
 [<c10a70c8>] ? do_sys_open+0x58/0x110
 [<c10a5d09>] ? filp_close+0x49/0x70
 [<c10a71ac>] ? sys_open+0x2c/0x40
 [<c1002d10>] ? sysenter_do_call+0x12/0x26
 [<c1320000>] ? timer_cpu_notify+0x1b4/0x233
BUG: scheduling while atomic: X/1725/0x10000003
Modules linked in: i915 drm_kms_helper drm fb fbdev cfbcopyarea video backlight 
output cfbimgblt cfbfillrect xt_state iptable_filter ipt_MASQUERADE iptable_nat 
nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 saa7134_alsa tda10048 
saa7134_dvb videobuf_dvb dvb_core mt20xx tea5767 tda9887 msp3400 gspca_zc3xx 
gspca_main tda18271 tda8290 ir_lirc_codec tuner lirc_dev bttv i2c_algo_bit 
btcx_risc snd_bt87x ir_common uhci_hcd ir_core saa7134 v4l2_common videodev 
v4l1_compat ehci_hcd videobuf_dma_sg videobuf_core tveeprom evdev [last 
unloaded: floppy]
Pid: 1725, comm: X Tainted: G      D     2.6.37-rc5+ #476
Call Trace:
 [<c1321f5d>] ? schedule+0x56d/0x8a0
 [<c10b83f0>] ? d_kill+0x40/0x50
 [<c10b89aa>] ? dput+0x5a/0x100
 [<c10a918f>] ? fput+0x12f/0x200
 [<c102cb43>] ? __cond_resched+0x13/0x30
 [<c1322340>] ? _cond_resched+0x20/0x30
 [<c1034bef>] ? put_files_struct+0x7f/0xd0
 [<c1035271>] ? do_exit+0x571/0x6d0
 [<c1006554>] ? oops_end+0x84/0xc0
 [<c101fc40>] ? no_context+0xc0/0x190
 [<c101fe5f>] ? bad_area_nosemaphore+0xf/0x20
 [<c102027e>] ? do_page_fault+0x25e/0x400
 [<c102c2c9>] ? load_balance+0x99/0x670
 [<c1009bf4>] ? __switch_to_xtra+0xf4/0x120
 [<c1001cca>] ? __switch_to+0x1ba/0x1e0
 [<c1020020>] ? do_page_fault+0x0/0x400
 [<c132484e>] ? error_code+0x5a/0x60
 [<c1020020>] ? do_page_fault+0x0/0x400
 [<c13229ef>] ? __mutex_lock_slowpath+0x9f/0x170
 [<c13228a6>] ? mutex_lock+0x16/0x30
 [<f8841b6c>] ? bttv_open+0xac/0x280 [bttv]
 [<c10aabb2>] ? cdev_get+0x52/0x90
 [<c10aabf7>] ? exact_lock+0x7/0x10
 [<f87095a7>] ? v4l2_open+0xb7/0xd0 [videodev]
 [<c10ab2ea>] ? chrdev_open+0xda/0x1b0
 [<c10a5f25>] ? __dentry_open+0xd5/0x280
 [<c10a7068>] ? nameidata_to_filp+0x68/0x70
 [<c10ab210>] ? chrdev_open+0x0/0x1b0
 [<c10b351f>] ? do_last.clone.32+0x34f/0x5a0
 [<c10b3af3>] ? do_filp_open+0x383/0x550
 [<c10b1e58>] ? getname+0x28/0xf0
 [<c10a70c8>] ? do_sys_open+0x58/0x110
 [<c10a5d09>] ? filp_close+0x49/0x70
 [<c10a71ac>] ? sys_open+0x2c/0x40
 [<c1002d10>] ? sysenter_do_call+0x12/0x26
 [<c1320000>] ? timer_cpu_notify+0x1b4/0x233

-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
