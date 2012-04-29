Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab2D2NhI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 09:37:08 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:45276 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810Ab2D2NhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 09:37:06 -0400
X-IronPort-AV: E=Sophos;i="4.75,500,1330902000"; 
   d="scan'208";a="156081411"
X-Mozilla-Keys: 
X-IronPort-AV: E=Sophos;i="4.75,499,1330902000"; 
   d="scan'208";a="156077103"
Message-ID: <4F9D2A2B.9090501@loria.fr>
Date: Sun, 29 Apr 2012 13:46:51 +0200
From: Jens Gustedt <jens.gustedt@loria.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: linux.kernel
CC: gregkh@linuxfoundation.org
Subject: BUG in 3.3.4
References: <iTWyS-35l-7@gated-at.bofh.it>
In-Reply-To: <iTWyS-35l-7@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Apparently-To: <Jens.Gustedt@inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)

Hi,
it looks that there is a regression in 3.3.4 compared to 3.3.3.

After migrating I have the BUG as copied below.

If somebody thinks that this would make sense, I could try to bisect this.

Jens

[    9.723430] BUG: unable to handle kernel NULL pointer dereference at
0000000000000012
[    9.723478] IP: [<ffffffff812efa66>] strstr+0x26/0x80
[    9.723485] PGD 11623f067 PUD 1154ad067 PMD 0
[    9.723489] Oops: 0000 [#1] SMP
[    9.723491] CPU 0
[    9.723492] Modules linked in: dell_laptop(+) fscache snd cfg80211
dcdbas v4l2_compat_ioctl32 auth_rpcgss videobuf2_vmalloc
videobuf2_memops nfs_acl soundcore sunrpc psmouse snd_page_alloc
serio_raw lm75 coretemp i915 ahci libahci drm_kms_helper drm sdhci_pci
sdhci e1000e i2c_algo_bit video
[    9.723505]
[    9.723508] Pid: 567, comm: modprobe Not tainted 3.3.4 #6 Dell Inc.
Latitude E6320/0GJF11
[    9.723511] RIP: 0010:[<ffffffff812efa66>]  [<ffffffff812efa66>]
strstr+0x26/0x80
[    9.723515] RSP: 0018:ffff88011e655e60  EFLAGS: 00010206
[    9.723516] RAX: 0000000000000012 RBX: ffffffffa0215e58 RCX:
0000000000000012
[    9.723518] RDX: ffffffffa0215e7a RSI: ffffffffa0215e69 RDI:
0000000000000012
[    9.723520] RBP: ffff88011e655e68 R08: 0000000000000011 R09:
000000000000000a
[    9.723522] R10: ffff880000000000 R11: 0000000000000000 R12:
0000000000000000
[    9.723524] R13: ffffffffa0215e58 R14: 0000000000000000 R15:
0000000000404f2f
[    9.723526] FS:  00007f9b94a04720(0000) GS:ffff88012dc00000(0000)
knlGS:0000000000000000
[    9.723528] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    9.723530] CR2: 0000000000000012 CR3: 0000000114958000 CR4:
00000000000406f0
[    9.723532] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[    9.723534] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[    9.723536] Process modprobe (pid: 567, threadinfo ffff88011e654000,
task ffff880114d4db40)
[    9.723538] Stack:
[    9.723539]  ffffffffa0215e58 ffff88011e655e98 ffffffff814a25fd
ffff88011e655f10
[    9.723542]  ffffffffa0215e58 0000000000000000 ffffffffa022c09e
ffff88011e655eb8
[    9.723544]  ffffffff814a26f8 00000000ffffffed 0000000000000000
ffff88011e655f18
[    9.723547] Call Trace:
[    9.723553]  [<ffffffff814a25fd>] dmi_matches+0x5d/0xd0
[    9.723557]  [<ffffffffa022c09e>] ? find_tokens+0x9e/0x9e [dell_laptop]
[    9.723560]  [<ffffffff814a26f8>] dmi_check_system+0x28/0x60
[    9.723564]  [<ffffffffa022c0db>] dell_init+0x3d/0xf62 [dell_laptop]
[    9.723567]  [<ffffffff8103f1e3>] ? set_memory_nx+0x43/0x50
[    9.723571]  [<ffffffffa022c09e>] ? find_tokens+0x9e/0x9e [dell_laptop]
[    9.723575]  [<ffffffff81002162>] do_one_initcall+0x42/0x180
[    9.723579]  [<ffffffff810a5fe4>] sys_init_module+0xd4/0x230
[    9.723583]  [<ffffffff815c5c29>] system_call_fastpath+0x16/0x1b
[    9.723585] Code: 00 00 00 00 00 55 48 89 f8 48 89 e5 80 3e 00 53 74
13 48 89 f2 48 ff c2 80 3a 00 75 f8 49 89 d0 49 29 f0 75 03 5b c9 c3 48
89 c1 <80> 38 00 74 0d 0f 1f 44 00 00 48 ff c1 80 39 00 75 f8 49 89 c9
[    9.723606] RIP  [<ffffffff812efa66>] strstr+0x26/0x80
[    9.723609]  RSP <ffff88011e655e60>
[    9.723610] CR2: 0000000000000012
[    9.779392] Linux video capture interface: v2.00
[    9.779974] ---[ end trace 5ac2b643564e817f ]---

