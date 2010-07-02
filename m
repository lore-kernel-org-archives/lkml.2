Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954Ab0GBUEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 16:04:44 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55528 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231Ab0GBUEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 16:04:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=En++O+kDF7+uFeKAAYPZcRonYM2cMsHbJpEzWhk3Y0A21EgAwPArfbuYK2AYDdwhKv
         0nVe6HiXf7ueFAJaYxoKUQhwC/7JXDamcxRDkgG/EcUgymUmshvJDigNtSOo2EmylH3V
         LurrgUq7NlYovx9NMpArazfi74FBwEjrqUNbY=
Message-ID: <4C2E464A.8090900@gmail.com>
Date: Fri, 02 Jul 2010 13:04:26 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100621 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: airlied@linux.ie, dri-devel@lists.freedesktop.org
Subject: X:2252 conflicting memory types 40000000-48000000 uncached-minus<->write-combining
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this is new(below) has anybody reported/bisected hit this yet
(if not I'll bisect it)

[drm] Num pipes: 1
[   29.742432] [drm] writeback test succeeded in 1 usecs
[   30.089717] X:2252 conflicting memory types 40000000-48000000 
uncached-minus<->write-combining
[   30.089721] reserve_memtype failed 0x40000000-0x48000000, track 
uncached-minus, req uncached-minus
[   30.123517] [drm] Num pipes: 1
[   30.351017] X:2252 freeing invalid memtype 40000000-48000000
[   30.354255] CPU 0
[   30.354255] Modules linked in: radeon ttm drm_kms_helper drm sco xcbc 
bnep rmd160 sha512_generic xt_tcpudp ipt_LOG iptable_nat nf_nat xt_state 
nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 
iptable_filter ip_tables x_tables firewire_ohci firewire_core video 
battery ath9k ac ath9k_common joydev sky2 ath9k_hw ohci1394 ath thermal 
evdev button i2c_i801 hid_magicmouse aes_x86_64 lzo lzo_compress zlib 
ipcomp xfrm_ipcomp crypto_null sha256_generic cbc des_generic cast5 
blowfish serpent camellia twofish twofish_common ctr ah4 esp4 authenc 
raw1394 ieee1394 uhci_hcd ehci_hcd hci_uart rfcomm btusb hidp l2cap 
bluetooth coretemp acpi_cpufreq processor mperf appletouch applesmc 
uvcvideo[   30.354255]
[   30.354255] Pid: 2252, comm: X Not tainted 2.6.35-rc3-00397-g123f94f 
#3 Mac-F42187C8/MacBookPro2,2
[   30.354255] RIP: 0010:[<ffffffffa035811b>]  [<ffffffffa035811b>] 
radeon_read_ring_rptr+0x2b/0x2f [radeon]
[   30.354255] RSP: 0018:ffff8800360dfc80  EFLAGS: 00010202
[   30.354255] RAX: ffff88003e0085d8 RBX: ffff8800385e8848 RCX: 
ffffc90000cf8000
[   30.354255] RDX: 0000000000000028 RSI: 6b6b6b6b6b6b6b6b RDI: 
ffff8800385e8848
[   30.354255] RBP: ffff8800360dfc80 R08: ffff8800385e8a28 R09: 
0000000000000010
[   30.354255] R10: ffffffffffffffff R11: ffffea0000930af0 R12: 
0000000000000010
[   30.354255] R13: ffff8800385e8000 R14: ffff8800385e89c8 R15: 
ffff8800385e8178
[   30.354255] FS:  00007f0aaa823840(0000) GS:ffff880001a00000(0000) 
knlGS:0000000000000000
[   30.354255] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   30.354255] CR2: 00007f0a9ad67118 CR3: 000000000166d000 CR4: 
00000000000006f0
[   30.354255] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   30.354255] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[   30.354255] Process X (pid: 2252, threadinfo ffff8800360de000, task 
ffff880033dc5c40)
[   30.354255]  ffff8800360dfc90 ffffffffa0358130 ffff8800360dfca8 
ffffffffa035881c
[   30.354255] <0> ffff8800385e8848 ffff8800360dfcc8 ffffffffa0359ac7 
0000000000000000
[   30.354255] <0> ffff8800385e8848 ffff8800360dfce8 ffffffffa035c961 
ffff8800385e8848
[   30.354255]  [<ffffffffa0358130>] radeon_get_ring_head+0x11/0x3c [radeon]
[   30.354255]  [<ffffffffa035881c>] radeon_commit_ring+0x48/0x97 [radeon]
[   30.354255]  [<ffffffffa0359ac7>] radeon_do_cp_idle+0x140/0x14d [radeon]
[   30.354255]  [<ffffffffa035c961>] 
radeon_apply_surface_regs+0x22/0x138 [radeon]
[   30.354255]  [<ffffffffa035cb4f>] free_surface+0xd8/0xee [radeon]
[   30.354255]  [<ffffffffa0365036>] radeon_driver_lastclose+0x3c/0x56 
[radeon]
[   30.354255]  [<ffffffffa031440b>] drm_lastclose+0x44/0x2ad [drm]
[   30.354255]  [<ffffffffa0314eda>] drm_release+0x656/0x6a3 [drm]
[   30.354255]  [<ffffffff8105abaf>] put_files_struct+0x65/0xb3
[   30.354255]  [<ffffffff8105ac43>] exit_files+0x46/0x4e
[   30.354255]  [<ffffffff8105c2e6>] do_exit+0x214/0x69f
[   30.354255]  [<ffffffff810ebc2e>] ? fput+0x1e2/0x1f1
[   30.354255]  [<ffffffff8105c7e3>] do_group_exit+0x72/0x9a
[   30.354255]  [<ffffffff8105c81d>] sys_exit_group+0x12/0x16
[   30.354255]  [<ffffffff81026442>] system_call_fastpath+0x16/0x1b
[   30.354255]  RSP <ffff8800360dfc80>
[   31.312879] ---[ end trace 9a7b92300d4121f6 ]---
[   30.354255]  [<ffffffff810ebb6e>] fput+0x122/0x1f1
[   30.354255]  [<ffffffff810e9181>] filp_close+0x63/0x6d

Justin P. Mattock
