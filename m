Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299Ab1D2RXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:23:49 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:51328 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753950Ab1D2RXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:23:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=HC/FOFeKzw2xDaqlWcdJ3KiBxJa18TbtmO9Tv6D3sNHYStbjlVB1v9XS83taqxvQ7R/fn1qXqfwdIDuvd8H8i4t86O9hlBJgLHDd5RihGL82l+cCxLFpPtHq+oI25Dx2;
Date: Fri, 29 Apr 2011 10:23:43 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Panic in input handling
Message-ID: <20110429102343.5ee9e34c@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just booted up a relatively fresh kernel and hit this when trying to
shut down X; maybe it's been fixed already?  I'd be happy to try any
patches...

Thanks,
Jesse

[  116.326650] BUG: unable to handle kernel NULL pointer dereference at 0000000000000228
[  116.326697] IP: [<ffffffff815a4e2b>] mutex_lock_interruptible+0x1b/0x50
[  116.326732] PGD b5a85067 PUD 309d3067 PMD 0 
[  116.326758] Oops: 0002 [#1] SMP 
[  116.326778] last sysfs file: /sys/devices/virtual/wmi/DF4E63B6-3BBC-4858-9737-C74F82F821F3/uevent
[  116.326816] CPU 0 
[  116.326826] Modules linked in: i915 drm_kms_helper drm joydev psmouse ppdev tpm_infineon tpm_tis parport_pc lp i2c_algo_bit tpm video parport hp_wmi tpm_bios sparse_keymap serio_raw usbhid hid ahci firewire_ohci libahci sdhci_pci firewire_core e1000e sdhci crc_itu_t
[  116.326978] 
[  116.326988] Pid: 849, comm: Xorg Not tainted 2.6.39-rc2+ #18 Hewlett-Packard HP ProBook 6360b/1621
[  116.327031] RIP: 0010:[<ffffffff815a4e2b>]  [<ffffffff815a4e2b>] mutex_lock_interruptible+0x1b/0x50
[  116.327072] RSP: 0018:ffff8800b5b67e88  EFLAGS: 00010246
[  116.327095] RAX: 00000000ffffffff RBX: 0000000000000228 RCX: ffff880030cefa50
[  116.327125] RDX: ffff8800b5b67fd8 RSI: ffff88009e6a79c0 RDI: 0000000000000228
[  116.327155] RBP: ffff8800b5b67e98 R08: 0000000000000012 R09: 0000000001441650
[  116.327185] R10: 0000000000000008 R11: 0000000000003246 R12: 0000000000000228
[  116.327215] R13: ffff88009e6a79c0 R14: 0000000000000010 R15: 00000000007f0e80
[  116.327245] FS:  00007f4a6e96f8a0(0000) GS:ffff8800bbc00000(0000) knlGS:0000000000000000
[  116.327279] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  116.327304] CR2: 0000000000000228 CR3: 00000000b0998000 CR4: 00000000000406f0
[  116.327334] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  116.327364] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  116.327394] Process Xorg (pid: 849, threadinfo ffff8800b5b66000, task ffff88009e56c440)
[  116.327426] Stack:
[  116.327437]  ffff88009e6a79c0 0000000000000000 ffff8800b5b67ed8 ffffffff8143ed9f
[  116.327474]  ffff8800b5b67ee8 ffffffff81164930 ffff8800b5b67ed8 ffff8800b5949ec0
[  116.327512]  ffff8800b5949e38 ffff88009e6a79c0 ffff8800b5b67f18 ffffffff814443bd
[  116.327550] Call Trace:
[  116.327565]  [<ffffffff8143ed9f>] input_flush_device+0x2f/0x70
[  116.327593]  [<ffffffff81164930>] ? fasync_remove_entry+0xb0/0xd0
[  116.327620]  [<ffffffff814443bd>] evdev_flush+0x7d/0x80
[  116.327644]  [<ffffffff81164b0b>] ? fasync_helper+0x8b/0x90
[  116.327670]  [<ffffffff811517df>] filp_close+0x3f/0x90
[  116.327693]  [<ffffffff81151dd7>] sys_close+0xb7/0x120
[  116.327718]  [<ffffffff815ae342>] system_call_fastpath+0x16/0x1b
[  116.327743] Code: 84 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 53 48 83 ec 08 0f 1f 44 00 00 48 89 fb e8 3a f1 ff ff b8 ff ff ff ff <f0> 0f c1 03 83 e8 01 78 1c 65 48 8b 04 25 c8 b5 00 00 48 2d d8 
[  116.327943] RIP  [<ffffffff815a4e2b>] mutex_lock_interruptible+0x1b/0x50
[  116.327975]  RSP <ffff8800b5b67e88>
[  116.327990] CR2: 0000000000000228
[  116.391787] ---[ end trace 13e865efd42b8faf ]---
