Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1E3CvH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 22:51:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51207 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab1E3CvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 22:51:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NU9OCpcV28QMoM5uYl/IeqdRX8E9kdk00fuGWMu8BhxruiyjDhNpIllC0vgGpZonvD
         cFpzktoiB4aJp4Jgzpiihzp9w/wkbF2qDuA003znxqXyeFRVxFJb/bdEQDpkU5cwNpLm
         88JXFMcDgbZvTsnipMmwRzWDuIcKDV2tO882c=
Subject: Re: [GIT PULL] Follow up block fixes
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4DDFA2B6.3000404@fusionio.com>
References: <4DDFA2B6.3000404@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 May 2011 04:50:59 +0200
Message-ID: <1306723859.6368.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 27 mai 2011 à 15:10 +0200, Jens Axboe a écrit :
> Hi Linus,
> 
> Mainly pushing this a bit early to resolve an oops that has been
> reported by Eric Dumazet. 

Hi Jens

3.0.0-rc1 on another machine gives similar problem, but at least machine
survives.

This is a different driver this time (cciss)

[    3.371604] BUG: unable to handle kernel paging request at 000103b9
[    3.371724] IP: [<c0334160>] part_discard_alignment_show+0x20/0x70
[    3.371818] *pdpt = 00000000346db001 *pde = 0000000000000000 
[    3.371936] Oops: 0000 [#1] SMP 
[    3.372050] Modules linked in:
[    3.372131] 
[    3.372180] Pid: 1288, comm: udevstart Not tainted 3.0.0-rc1-00074-gde5113a-dirty #585 HP ProLiant BL460c G1
[    3.372323] EIP: 0060:[<c0334160>] EFLAGS: 00010202 CPU: 0
[    3.372378] EIP is at part_discard_alignment_show+0x20/0x70
[    3.372433] EAX: f4549318 EBX: 00010101 ECX: f4022000 EDX: 00000000
[    3.372490] ESI: c0334140 EDI: c060c7cc EBP: f426ff20 ESP: f426ff08
[    3.372546]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    3.372601] Process udevstart (pid: 1288, ti=f426e000 task=f4e80000 task.ti=f426e000)
[    3.372673] Stack:
[    3.372722]  f426ff20 c02c2515 00000000 c07c6c94 c0334140 c060c7cc f426ff30 c041e35f
[    3.373043]  f3f63210 f4485e80 f426ff64 c0336c3b f426ff64 c02e45cc c02ee25b 00000005
[    3.373364]  c060c7cc 00001000 08205888 f4485e94 00001000 f4e4a0c0 08205888 f426ff8c
[    3.378241] Call Trace:
[    3.378294]  [<c02c2515>] ? page_address+0x15/0xf0
[    3.378349]  [<c0334140>] ? part_inflight_show+0x40/0x40
[    3.378405]  [<c041e35f>] dev_attr_show+0x1f/0x50
[    3.378460]  [<c0336c3b>] sysfs_read_file+0x7b/0x120
[    3.378515]  [<c02e45cc>] ? rw_verify_area+0x6c/0x120
[    3.378570]  [<c02ee25b>] ? putname+0x2b/0x40
[    3.378624]  [<c02e4a38>] vfs_read+0x88/0x150
[    3.378678]  [<c0336bc0>] ? sysfs_open_file+0x240/0x240
[    3.378733]  [<c02e4b3d>] sys_read+0x3d/0x70
[    3.378793]  [<c05d79f5>] syscall_call+0x7/0xb
[    3.378846] Code: 90 90 90 90 90 90 90 90 90 90 90 55 89 e5 83 ec 18 89 5d f4 89 75 f8 89 7d fc 3e 8d 74 26 00 31 d2 8b 98 ec 00 00 00 85 db 74 13 <8b> bb b8 02 00 00 8b 40 e8 8b b3 bc 02 00 00 85 ff 75 25 89 54 
[    3.380013] EIP: [<c0334160>] part_discard_alignment_show+0x20/0x70 SS:ESP 0068:f426ff08
[    3.380013] CR2: 00000000000103b9
[    3.381173] ---[ end trace e0e7dbf11c30779f ]---
[    3.402346] BUG: unable to handle kernel paging request at 000103b9
[    3.402465] IP: [<c0334160>] part_discard_alignment_show+0x20/0x70
[    3.402559] *pdpt = 000000003475b001 *pde = 0000000000000000 
[    3.402677] Oops: 0000 [#2] SMP 
[    3.402789] Modules linked in:
[    3.402870] 
[    3.402919] Pid: 1289, comm: udevstart Tainted: G      D     3.0.0-rc1-00074-gde5113a-dirty #585 HP ProLiant BL460c G1
[    3.403059] EIP: 0060:[<c0334160>] EFLAGS: 00010202 CPU: 0
[    3.403114] EIP is at part_discard_alignment_show+0x20/0x70
[    3.403169] EAX: f4549318 EBX: 00010101 ECX: f45e8000 EDX: 00000000
[    3.403226] ESI: c0334140 EDI: c060c7cc EBP: f4311f20 ESP: f4311f08
[    3.403282]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    3.403337] Process udevstart (pid: 1289, ti=f4310000 task=f4e80c20 task.ti=f4310000)
[    3.403409] Stack:
[    3.403457]  f4311f20 c02c2515 00000000 c07c6c94 c0334140 c060c7cc f4311f30 c041e35f
[    3.403779]  f3f63210 f4485e80 f4311f64 c0336c3b f4311f64 c02e45cc c02ee25b 00000004
[    3.404101]  c060c7cc 00001000 08205888 f4485e94 00001000 f45ef300 08205888 f4311f8c
[    3.404422] Call Trace:
[    3.404473]  [<c02c2515>] ? page_address+0x15/0xf0
[    3.404527]  [<c0334140>] ? part_inflight_show+0x40/0x40
[    3.404583]  [<c041e35f>] dev_attr_show+0x1f/0x50
[    3.404637]  [<c0336c3b>] sysfs_read_file+0x7b/0x120
[    3.404692]  [<c02e45cc>] ? rw_verify_area+0x6c/0x120
[    3.404749]  [<c02ee25b>] ? putname+0x2b/0x40
[    3.404803]  [<c02e4a38>] vfs_read+0x88/0x150
[    3.404856]  [<c0336bc0>] ? sysfs_open_file+0x240/0x240
[    3.404911]  [<c02e4b3d>] sys_read+0x3d/0x70
[    3.404965]  [<c05d79f5>] syscall_call+0x7/0xb
[    3.405018] Code: 90 90 90 90 90 90 90 90 90 90 90 55 89 e5 83 ec 18 89 5d f4 89 75 f8 89 7d fc 3e 8d 74 26 00 31 d2 8b 98 ec 00 00 00 85 db 74 13 <8b> bb b8 02 00 00 8b 40 e8 8b b3 bc 02 00 00 85 ff 75 25 89 54 
[    3.407137] EIP: [<c0334160>] part_discard_alignment_show+0x20/0x70 SS:ESP 0068:f4311f08
[    3.407274] CR2: 00000000000103b9
[    3.407325] ---[ end trace e0e7dbf11c3077a0 ]---
[    3.511098] EXT3-fs: barriers not enabled
[    3.516279] kjournald starting.  Commit interval 5 seconds

Thanks


