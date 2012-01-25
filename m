Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab2AYAMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:12:40 -0500
Received: from mailout-eu.gmx.com ([213.165.64.42]:55211 "HELO
	mailout-eu.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754467Ab2AYAMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:12:39 -0500
X-Authenticated: #50610217
X-Provags-ID: V01U2FsdGVkX1/Z7E8UY+zZMFGj8vAm6hz8TAL7RYojya/xxvimLd
	jfB+MAPpF6G+86
Date: Wed, 25 Jan 2012 01:12:34 +0100
From: Martin Nyhus <martin.nyhus@gmx.com>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [next] Null pointer dereference in nouveau_vm_map_sg
Message-ID: <20120125011234.3580e104@callisto>
In-Reply-To: <20120124223319.GA10002@homer.localdomain>
References: <201201152231.08561.martin.nyhus@gmx.com>
	<20120116203059.GC4482@homer.localdomain>
	<201201170057.51404.martin.nyhus@gmx.com>
	<20120122183316.GA12594@phenom.dumpdata.com>
	<20120124223319.GA10002@homer.localdomain>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jan 2012 17:33:19 -0500 Jerome Glisse <j.glisse@gmail.com>
wrote:
> Can you please both test if attached patch fix it for you ?

Thanks. It looks good too me, but it crashes a little later due to vma->node
being invalid:

Jan 25 00:54:21 callisto kernel: [  119.038357] [drm] nouveau_vm_unmap vma ffff880057502f50
Jan 25 00:54:21 callisto kernel: [  119.038360] [drm] nouveau_vm_unmap vma->node ffff8800576b87a8
Jan 25 00:54:21 callisto kernel: [  119.038363] [drm] nouveau_vm_unmap vma->node->length 58
Jan 25 00:54:21 callisto kernel: [  119.038477] [drm] nouveau_vm_unmap vma ffff8800577beab8
Jan 25 00:54:21 callisto kernel: [  119.038479] [drm] nouveau_vm_unmap vma->node ffff8800577bf880
Jan 25 00:54:21 callisto kernel: [  119.038482] [drm] nouveau_vm_unmap vma->node->length 1
Jan 25 00:54:21 callisto kernel: [  119.078025] [drm] nouveau_vm_unmap vma ffffffff8148df45
Jan 25 00:54:21 callisto kernel: [  119.078029] [drm] nouveau_vm_unmap vma->node 8b48084b8b480000
Jan 25 00:54:21 callisto kernel: [  119.078040] general protection fault: 0000 [#1] SMP 
Jan 25 00:54:21 callisto kernel: [  119.078133] CPU 0 
Jan 25 00:54:21 callisto kernel: [  119.078138] Modules linked in: tun iwl4965 iwlegacy mac80211 cfg80211 tg3 psmouse rtc_cmos evdev ehci_hcd uhci_hcd usbcore usb_common [last unloaded: scsi_wait_scan]
Jan 25 00:54:21 callisto kernel: [  119.078542] 
Jan 25 00:54:21 callisto kernel: [  119.078914] Pid: 3220, comm: Xorg Tainted: G        W    3.3.0-rc1-00076-g44d4826-dirty #75 Dell Inc. XPS M1330 /0PU073
Jan 25 00:54:21 callisto kernel: [  119.079331] RIP: 0010:[<ffffffff814b2f7f>]  [<ffffffff814b2f7f>] nouveau_vm_unmap+0x4f/0x80
Jan 25 00:54:21 callisto kernel: [  119.079778] RSP: 0018:ffff88005c167868  EFLAGS: 00010292
Jan 25 00:54:21 callisto kernel: [  119.080266] RAX: 8b48084b8b480000 RBX: ffffffff8148df45 RCX: 0000000000000006
Jan 25 00:54:21 callisto kernel: [  119.080712] RDX: 0000000000000000 RSI: ffffffff81868740 RDI: ffffffff81a6e040
Jan 25 00:54:21 callisto kernel: [  119.081218] RBP: ffff88005c167878 R08: 0000000000000001 R09: 0000000000000000
Jan 25 00:54:21 callisto kernel: [  119.081320] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
Jan 25 00:54:21 callisto kernel: [  119.081320] R13: ffff88006c309c80 R14: ffff88006c309a40 R15: ffff880037180590
Jan 25 00:54:21 callisto kernel: [  119.081320] FS:  00007f141232f880(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
Jan 25 00:54:21 callisto kernel: [  119.081320] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jan 25 00:54:21 callisto kernel: [  119.081320] CR2: 00007fb09c1de000 CR3: 000000005ce28000 CR4: 00000000000006f0
Jan 25 00:54:21 callisto kernel: [  119.081320] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 25 00:54:21 callisto kernel: [  119.081320] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 25 00:54:21 callisto kernel: [  119.081320] Process Xorg (pid: 3220, threadinfo ffff88005c166000, task ffff88005f502180)
Jan 25 00:54:21 callisto kernel: [  119.081320] Stack:
Jan 25 00:54:21 callisto kernel: [  119.081320]  ffff88005f502180 ffffffff8148df45 ffff88005c1678a8 ffffffff8148c0e8
Jan 25 00:54:21 callisto kernel: [  119.081320]  ffff88006c309a40 0000000000000002 ffff880037180b00 ffff880079ff5e68
Jan 25 00:54:21 callisto kernel: [  119.081320]  ffff88005c1678c8 ffffffff814792b1 ffff880079ff5e68 ffff88006c309a40
Jan 25 00:54:21 callisto kernel: [  119.081320] Call Trace:
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff8148df45>] ? nouveau_bo_move+0xb5/0x270
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff8148c0e8>] nouveau_bo_move_ntfy+0x38/0xc0
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff814792b1>] ttm_bo_cleanup_memtype_use+0x21/0xa0
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff8147a5b5>] ttm_bo_cleanup_refs_or_queue+0x165/0x190
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff8147a675>] ttm_bo_release+0x95/0xd0
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff8147a6ef>] ttm_bo_unref+0x3f/0x60
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff8147cae3>] ttm_bo_move_accel_cleanup+0x213/0x240
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff8148db28>] nouveau_bo_move_m2mf+0x148/0x1b0
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff817bfd49>] ? mutex_unlock+0x9/0x10
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff8148df45>] nouveau_bo_move+0xb5/0x270
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff8147ab66>] ttm_bo_handle_move_mem+0x1e6/0x3d0
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff8147bcba>] ttm_bo_move_buffer+0x14a/0x160
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff8147bdb7>] ttm_bo_validate+0xe7/0xf0
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff8148cbdd>] nouveau_bo_validate+0x1d/0x20
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff8148f2a0>] validate_list+0xc0/0x360
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff8148fafa>] nouveau_gem_pushbuf_validate+0x9a/0x210
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff8149064d>] nouveau_gem_ioctl_pushbuf+0x1bd/0x8d0
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff810960c1>] ? __lock_release+0xc1/0xe0
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff8145f994>] drm_ioctl+0x444/0x510
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff81490490>] ? nouveau_gem_ioctl_new+0x170/0x170
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff81152147>] do_vfs_ioctl+0x87/0x330
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff81344e78>] ? selinux_file_ioctl+0x68/0x140
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff81152481>] sys_ioctl+0x91/0xa0
Jan 25 00:54:21 callisto kernel: [  119.081320]  [<ffffffff817cade2>] system_call_fastpath+0x16/0x1b
Jan 25 00:54:21 callisto kernel: [  119.081320] Code: 48 8b 53 20 48 c7 c6 40 87 86 81 48 c7 c7 17 3a a5 81 31 c0 e8 05 77 2f 00 48 8b 43 20 48 c7 c6 40 87 86 81 48 c7 c7 40 e0 a6 81 <8b> 50 38 31 c0 e8 e9 76 2f 00 48 8b 43 20 48 89 df 31 f6 8b 50 
Jan 25 00:54:21 callisto kernel: [  119.081320] RIP  [<ffffffff814b2f7f>] nouveau_vm_unmap+0x4f/0x80
Jan 25 00:54:21 callisto kernel: [  119.081320]  RSP <ffff88005c167868>
Jan 25 00:54:21 callisto kernel: [  119.128824] ---[ end trace a7919e7f17c0a727 ]---

The taint is because of a failing self test (debug_objects_selftest) and the
-dirty and extra lines at the start of the log are from this patch:

diff --git a/drivers/gpu/drm/nouveau/nouveau_vm.c b/drivers/gpu/drm/nouveau/nouveau_vm.c
index 2bf6c03..2b788c3 100644
--- a/drivers/gpu/drm/nouveau/nouveau_vm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_vm.c
@@ -150,6 +150,9 @@ nouveau_vm_unmap_at(struct nouveau_vma *vma, u64 delta, u64 length)
 void
 nouveau_vm_unmap(struct nouveau_vma *vma)
 {
+	DRM_INFO("%s vma %p\n", __func__, vma);
+	DRM_INFO("%s vma->node %p\n", __func__, vma->node);
+	DRM_INFO("%s vma->node->length %u\n", __func__, vma->node->length);
 	nouveau_vm_unmap_at(vma, 0, (u64)vma->node->length << 12);
 }

To reproduce I do exactly the same as before, it just takes a little longer
before it crashes.

	Martin
