Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab0G1FnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 01:43:17 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54508 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab0G1FnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 01:43:15 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>,
        Francisco Jerez <currojerez@riseup.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: mmotm 2010-07-27 - nouveau lockdep issues.
In-Reply-To: Your message of "Tue, 27 Jul 2010 14:56:50 PDT."
             <201007272226.o6RMQRBm008735@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201007272226.o6RMQRBm008735@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1280295723_4558P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 28 Jul 2010 01:42:03 -0400
Message-ID: <31845.1280295723@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4C4FC334.01D7,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1280295723_4558P
Content-Type: text/plain; charset=us-ascii

On Tue, 27 Jul 2010 14:56:50 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-07-27-14-56 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

Hit this while the X server was on its way down during a 'shutdown -r now'. Worked fine
in -rc5-mmotm0719. 'e16' is the Enlightenment window manager, if that matters.

[   93.181787] [drm:output_poll_execute] *ERROR* delayed enqueue failed 1
[   99.802836] [drm] nouveau 0000:01:00.0: Allocating FIFO number 4
[   99.808875] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 4
[  103.262226] [drm:output_poll_execute] *ERROR* delayed enqueue failed 1
[  113.341948] [drm:output_poll_execute] *ERROR* delayed enqueue failed 1
[  123.421836] [drm:output_poll_execute] *ERROR* delayed enqueue failed 1
[  123.550520] [drm] nouveau 0000:01:00.0: nouveau_channel_free: freeing fifo 4
[  123.551253] 
[  123.551253] ======================================================
[  123.551253] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
[  123.551253] 2.6.35-rc6-mmotm0727 #1
[  123.551253] ------------------------------------------------------
[  123.551253] e16/3822 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[  123.551253]  (&(&mm->unused_lock)->rlock){+.+...}, at: [<ffffffff812a94bc>] drm_mm_put_block+0x10e/0x142
[  123.551253] 
[  123.551253] and this task is already holding:
[  123.551253]  (&(&dev_priv->context_switch_lock)->rlock){-.....}, at: [<ffffffff812bdbab>] nouveau_channel_free+0x10f/0x233
[  123.551253] which would create a new lock dependency:
[  123.551253]  (&(&dev_priv->context_switch_lock)->rlock){-.....} -> (&(&mm->unused_lock)->rlock){+.+...}
[  123.551253] 
[  123.551253] but this new dependency connects a HARDIRQ-irq-safe lock:
[  123.551253]  (&(&dev_priv->context_switch_lock)->rlock){-.....}
[  123.551253] ... which became HARDIRQ-irq-safe at:
[  123.551253]   [<ffffffff81065043>] __lock_acquire+0x301/0xd6a
[  123.551253]   [<ffffffff81065fca>] lock_acquire+0x10a/0x130
[  123.551253]   [<ffffffff81594dda>] _raw_spin_lock_irqsave+0x44/0x57
[  123.551253]   [<ffffffff812c264b>] nouveau_irq_handler+0x63/0x1920
[  123.551253]   [<ffffffff810817bb>] handle_IRQ_event+0xad/0x213
[  123.551253]   [<ffffffff81083bd2>] handle_fasteoi_irq+0xd1/0x115
[  123.551253]   [<ffffffff81004b6e>] handle_irq+0x122/0x133
[  123.551253]   [<ffffffff8100499f>] do_IRQ+0x57/0xaf
[  123.551253]   
[  123.604031] [drm] nouveau 0000:01:00.0: GPU lockup - switching to software fbcon
[  123.604031] [<ffffffff81595cd3>] ret_from_intr+0x0/0xf
[  123.604031]   [<ffffffff81000c73>] cpu_idle+0x85/0x169
[  123.604031]   [<ffffffff81b62061>] start_secondary+0x1b1/0x1b5
[  123.604031] 
[  123.604031] to a HARDIRQ-irq-unsafe lock:
[  123.604031]  (&(&mm->unused_lock)->rlock){+.+...}
[  123.604031] ... which became HARDIRQ-irq-unsafe at:
[  123.604031] ...  [<ffffffff810650c4>] __lock_acquire+0x382/0xd6a
[  123.604031]   [<ffffffff81065fca>] lock_acquire+0x10a/0x130
[  123.604031]   [<ffffffff81594ce1>] _raw_spin_lock+0x36/0x45
[  123.604031]   [<ffffffff812a9669>] drm_mm_pre_get+0x24/0xb2
[  123.604031]   [<ffffffff812b748b>] ttm_bo_init+0x1fe/0x3c0
[  123.604031]   [<ffffffff812c5dce>] nouveau_bo_new+0x3ae/0x423
[  123.604031]   [<ffffffff812bf2c8>] nouveau_mem_init+0x293/0x487
[  123.604031]   [<ffffffff812bce55>] nouveau_card_init+0xa5e/0xd52
[  123.604031]   [<ffffffff812bd675>] nouveau_load+0x519/0x528
[  123.604031]   [<ffffffff812a74af>] drm_get_pci_dev+0x174/0x26a
[  123.604031]   [<ffffffff8158a14e>] nouveau_pci_probe+0x10/0x12
[  123.604031]   [<ffffffff812228ce>] local_pci_probe+0x3f/0x70
[  123.604031]   [<ffffffff81222c4c>] pci_device_probe+0x65/0x96
[  123.604031]   [<ffffffff8130a840>] driver_probe_device+0xe8/0x182
[  123.604031]   [<ffffffff8130a924>] __driver_attach+0x4a/0x6b
[  123.604031]   [<ffffffff81309a2f>] bus_for_each_dev+0x57/0x83
[  123.604031]   [<ffffffff8130a505>] driver_attach+0x19/0x1b
[  123.604031]   [<ffffffff8130a147>] bus_add_driver+0xae/0x205
[  123.604031]   [<ffffffff8130ab80>] driver_register+0xb5/0x122
[  123.604031]   [<ffffffff81222e82>] __pci_register_driver+0x61/0xcd
[  123.604031]   [<ffffffff812a7839>] drm_pci_init+0x31/0x98
[  123.604031]   [<ffffffff812a003f>] drm_init+0x5d/0x61
[  123.604031]   [<ffffffff81b4e59a>] nouveau_init+0x48/0x4a
[  123.604031]   [<ffffffff810002ff>] do_one_initcall+0x7a/0x12f
[  123.604031]   [<ffffffff81b2ccae>] kernel_init+0x138/0x1c2
[  123.604031]   [<ffffffff81003554>] kernel_thread_helper+0x4/0x10
[  123.604031] 
[  123.604031] other info that might help us debug this:
[  123.604031] 
[  123.604031] 1 lock held by e16/3822:
[  123.604031]  #0:  (&(&dev_priv->context_switch_lock)->rlock){-.....}, at: [<ffffffff812bdbab>] nouveau_channel_free+0x10f/0x233
[  123.604031] 
[  123.604031] the dependencies between HARDIRQ-irq-safe lock and the holding lock:
[  123.604031] -> (&(&dev_priv->context_switch_lock)->rlock){-.....} ops: 15 {
[  123.604031]    IN-HARDIRQ-W at:
[  123.604031]                                        [<ffffffff81065043>] __lock_acquire+0x301/0xd6a
[  123.604031]                                        [<ffffffff81065fca>] lock_acquire+0x10a/0x130
[  123.604031]                                        [<ffffffff81594dda>] _raw_spin_lock_irqsave+0x44/0x57
[  123.604031]                                        [<ffffffff812c264b>] nouveau_irq_handler+0x63/0x1920
[  123.604031]                                        [<ffffffff810817bb>] handle_IRQ_event+0xad/0x213
[  123.604031]                                        [<ffffffff81083bd2>] handle_fasteoi_irq+0xd1/0x115
[  123.604031]                                        [<ffffffff81004b6e>] handle_irq+0x122/0x133
[  123.604031]                                        [<ffffffff8100499f>] do_IRQ+0x57/0xaf
[  123.604031]                                        [<ffffffff81595cd3>] ret_from_intr+0x0/0xf
[  123.604031]                                        [<ffffffff81000c73>] cpu_idle+0x85/0x169
[  123.604031]                                        [<ffffffff81b62061>] start_secondary+0x1b1/0x1b5
[  123.604031]    INITIAL USE at:
[  123.604031]                                       [<ffffffff81065145>] __lock_acquire+0x403/0xd6a
[  123.604031]                                       [<ffffffff81065fca>] lock_acquire+0x10a/0x130
[  123.604031]                                       [<ffffffff81594dda>] _raw_spin_lock_irqsave+0x44/0x57
[  123.604031]                                       [<ffffffff812c264b>] nouveau_irq_handler+0x63/0x1920
[  123.604031]                                       [<ffffffff810817bb>] handle_IRQ_event+0xad/0x213
[  123.604031]                                       [<ffffffff81083bd2>] handle_fasteoi_irq+0xd1/0x115
[  123.604031]                                       [<ffffffff81004b6e>] handle_irq+0x122/0x133
[  123.604031]                                       [<ffffffff8100499f>] do_IRQ+0x57/0xaf
[  123.604031]                                       [<ffffffff81595cd3>] ret_from_intr+0x0/0xf
[  123.604031]                                       [<ffffffff81000c73>] cpu_idle+0x85/0x169
[  123.604031]                                       [<ffffffff81b62061>] start_secondary+0x1b1/0x1b5
[  123.604031]  }
[  123.604031]  ... key      at: [<ffffffff8243b758>] __key.32520+0x0/0x8
[  123.604031]  ... acquired at:
[  123.604031]    [<ffffffff810648cd>] check_irq_usage+0x42/0x89
[  123.604031]    [<ffffffff810657d6>] __lock_acquire+0xa94/0xd6a
[  123.604031]    [<ffffffff81065fca>] lock_acquire+0x10a/0x130
[  123.604031]    [<ffffffff81594ce1>] _raw_spin_lock+0x36/0x45
[  123.604031]    [<ffffffff812a94bc>] drm_mm_put_block+0x10e/0x142
[  123.604031]    [<ffffffff812bf7e2>] nouveau_gpuobj_del+0x14c/0x179
[  123.604031]    [<ffffffff812c02ad>] nouveau_gpuobj_ref_del+0x25d/0x284
[  123.604031]    [<ffffffff812e3fb2>] nv50_graph_destroy_context+0xd0/0xdc
[  123.604031]    [<ffffffff812bdbdd>] nouveau_channel_free+0x141/0x233
[  123.604031]    [<ffffffff812be5bf>] nouveau_ioctl_fifo_free+0x79/0x86
[  123.604031]    [<ffffffff8129fdab>] drm_ioctl+0x2b3/0x36b
[  123.604031]    [<ffffffff810ec6fc>] vfs_ioctl+0x31/0xa2
[  123.604031]    [<ffffffff810ed07b>] do_vfs_ioctl+0x496/0x4c9
[  123.604031]    [<ffffffff810ed105>] sys_ioctl+0x57/0x96
[  123.604031]    [<ffffffff8100272b>] system_call_fastpath+0x16/0x1b
[  123.604031] 
[  123.604031] 
[  123.604031] the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:
[  123.604031] -> (&(&mm->unused_lock)->rlock){+.+...} ops: 10338 {
[  123.604031]    HARDIRQ-ON-W at:
[  123.604031]                                        [<ffffffff810650c4>] __lock_acquire+0x382/0xd6a
[  123.604031]                                        [<ffffffff81065fca>] lock_acquire+0x10a/0x130
[  123.604031]                                        [<ffffffff81594ce1>] _raw_spin_lock+0x36/0x45
[  123.604031]                                        [<ffffffff812a9669>] drm_mm_pre_get+0x24/0xb2
[  123.604031]                                        [<ffffffff812b748b>] ttm_bo_init+0x1fe/0x3c0
[  123.604031]                                        [<ffffffff812c5dce>] nouveau_bo_new+0x3ae/0x423
[  123.604031]                                        [<ffffffff812bf2c8>] nouveau_mem_init+0x293/0x487
[  123.604031]                                        [<ffffffff812bce55>] nouveau_card_init+0xa5e/0xd52
[  123.604031]                                        [<ffffffff812bd675>] nouveau_load+0x519/0x528
[  123.604031]                                        [<ffffffff812a74af>] drm_get_pci_dev+0x174/0x26a
[  123.604031]                                        [<ffffffff8158a14e>] nouveau_pci_probe+0x10/0x12
[  123.604031]                                        [<ffffffff812228ce>] local_pci_probe+0x3f/0x70
[  123.604031]                                        [<ffffffff81222c4c>] pci_device_probe+0x65/0x96
[  123.604031]                                        [<ffffffff8130a840>] driver_probe_device+0xe8/0x182
[  123.604031]                                        [<ffffffff8130a924>] __driver_attach+0x4a/0x6b
[  123.604031]                                        [<ffffffff81309a2f>] bus_for_each_dev+0x57/0x83
[  123.604031]                                        [<ffffffff8130a505>] driver_attach+0x19/0x1b
[  123.604031]                                        [<ffffffff8130a147>] bus_add_driver+0xae/0x205
[  123.604031]                                        [<ffffffff8130ab80>] driver_register+0xb5/0x122
[  123.604031]                                        [<ffffffff81222e82>] __pci_register_driver+0x61/0xcd
[  123.604031]                                        [<ffffffff812a7839>] drm_pci_init+0x31/0x98
[  123.604031]                                        [<ffffffff812a003f>] drm_init+0x5d/0x61
[  123.604031]                                        [<ffffffff81b4e59a>] nouveau_init+0x48/0x4a
[  123.604031]                                        [<ffffffff810002ff>] do_one_initcall+0x7a/0x12f
[  123.604031]                                        [<ffffffff81b2ccae>] kernel_init+0x138/0x1c2
[  123.604031]                                        [<ffffffff81003554>] kernel_thread_helper+0x4/0x10
[  123.604031]    SOFTIRQ-ON-W at:
[  123.604031]                                        [<ffffffff810650e5>] __lock_acquire+0x3a3/0xd6a
[  123.604031]                                        [<ffffffff81065fca>] lock_acquire+0x10a/0x130
[  123.604031]                                        [<ffffffff81594ce1>] _raw_spin_lock+0x36/0x45
[  123.604031]                                        [<ffffffff812a9669>] drm_mm_pre_get+0x24/0xb2
[  123.604031]                                        [<ffffffff812b748b>] ttm_bo_init+0x1fe/0x3c0
[  123.604031]                                        [<ffffffff812c5dce>] nouveau_bo_new+0x3ae/0x423
[  123.604031]                                        [<ffffffff812bf2c8>] nouveau_mem_init+0x293/0x487
[  123.604031]                                        [<ffffffff812bce55>] nouveau_card_init+0xa5e/0xd52
[  123.604031]                                        [<ffffffff812bd675>] nouveau_load+0x519/0x528
[  123.604031]                                        [<ffffffff812a74af>] drm_get_pci_dev+0x174/0x26a
[  123.604031]                                        [<ffffffff8158a14e>] nouveau_pci_probe+0x10/0x12
[  123.604031]                                        [<ffffffff812228ce>] local_pci_probe+0x3f/0x70
[  123.604031]                                        [<ffffffff81222c4c>] pci_device_probe+0x65/0x96
[  123.604031]                                        [<ffffffff8130a840>] driver_probe_device+0xe8/0x182
[  123.604031]                                        [<ffffffff8130a924>] __driver_attach+0x4a/0x6b
[  123.604031]                                        [<ffffffff81309a2f>] bus_for_each_dev+0x57/0x83
[  123.604031]                                        [<ffffffff8130a505>] driver_attach+0x19/0x1b
[  123.604031]                                        [<ffffffff8130a147>] bus_add_driver+0xae/0x205
[  123.604031]                                        [<ffffffff8130ab80>] driver_register+0xb5/0x122
[  123.604031]                                        [<ffffffff81222e82>] __pci_register_driver+0x61/0xcd
[  123.604031]                                        [<ffffffff812a7839>] drm_pci_init+0x31/0x98
[  123.604031]                                        [<ffffffff812a003f>] drm_init+0x5d/0x61
[  123.604031]                                        [<ffffffff81b4e59a>] nouveau_init+0x48/0x4a
[  123.604031]                                        [<ffffffff810002ff>] do_one_initcall+0x7a/0x12f
[  123.604031]                                        [<ffffffff81b2ccae>] kernel_init+0x138/0x1c2
[  123.604031]                                        [<ffffffff81003554>] kernel_thread_helper+0x4/0x10
[  123.604031]    INITIAL USE at:
[  123.604031]                                       [<ffffffff81065145>] __lock_acquire+0x403/0xd6a
[  123.604031]                                       [<ffffffff81065fca>] lock_acquire+0x10a/0x130
[  123.604031]                                       [<ffffffff81594ce1>] _raw_spin_lock+0x36/0x45
[  123.604031]                                       [<ffffffff812a9669>] drm_mm_pre_get+0x24/0xb2
[  123.604031]                                       [<ffffffff812b748b>] ttm_bo_init+0x1fe/0x3c0
[  123.604031]                                       [<ffffffff812c5dce>] nouveau_bo_new+0x3ae/0x423
[  123.604031]                                       [<ffffffff812bf2c8>] nouveau_mem_init+0x293/0x487
[  123.604031]                                       [<ffffffff812bce55>] nouveau_card_init+0xa5e/0xd52
[  123.604031]                                       [<ffffffff812bd675>] nouveau_load+0x519/0x528
[  123.604031]                                       [<ffffffff812a74af>] drm_get_pci_dev+0x174/0x26a
[  123.604031]                                       [<ffffffff8158a14e>] nouveau_pci_probe+0x10/0x12
[  123.604031]                                       [<ffffffff812228ce>] local_pci_probe+0x3f/0x70
[  123.604031]                                       [<ffffffff81222c4c>] pci_device_probe+0x65/0x96
[  123.604031]                                       [<ffffffff8130a840>] driver_probe_device+0xe8/0x182
[  123.604031]                                       [<ffffffff8130a924>] __driver_attach+0x4a/0x6b
[  123.604031]                                       [<ffffffff81309a2f>] bus_for_each_dev+0x57/0x83
[  123.604031]                                       [<ffffffff8130a505>] driver_attach+0x19/0x1b
[  123.604031]                                       [<ffffffff8130a147>] bus_add_driver+0xae/0x205
[  123.604031]                                       [<ffffffff8130ab80>] driver_register+0xb5/0x122
[  123.604031]                                       [<ffffffff81222e82>] __pci_register_driver+0x61/0xcd
[  123.604031]                                       [<ffffffff812a7839>] drm_pci_init+0x31/0x98
[  123.604031]                                       [<ffffffff812a003f>] drm_init+0x5d/0x61
[  123.604031]                                       [<ffffffff81b4e59a>] nouveau_init+0x48/0x4a
[  123.604031]                                       [<ffffffff810002ff>] do_one_initcall+0x7a/0x12f
[  123.604031]                                       [<ffffffff81b2ccae>] kernel_init+0x138/0x1c2
[  123.604031]                                       [<ffffffff81003554>] kernel_thread_helper+0x4/0x10
[  123.604031]  }
[  123.604031]  ... key      at: [<ffffffff8243b408>] __key.30042+0x0/0x8
[  123.604031]  ... acquired at:
[  123.604031]    [<ffffffff810648cd>] check_irq_usage+0x42/0x89
[  123.604031]    [<ffffffff810657d6>] __lock_acquire+0xa94/0xd6a
[  123.604031]    [<ffffffff81065fca>] lock_acquire+0x10a/0x130
[  123.604031]    [<ffffffff81594ce1>] _raw_spin_lock+0x36/0x45
[  123.604031]    [<ffffffff812a94bc>] drm_mm_put_block+0x10e/0x142
[  123.604031]    [<ffffffff812bf7e2>] nouveau_gpuobj_del+0x14c/0x179
[  123.604031]    [<ffffffff812c02ad>] nouveau_gpuobj_ref_del+0x25d/0x284
[  123.604031]    [<ffffffff812e3fb2>] nv50_graph_destroy_context+0xd0/0xdc
[  123.604031]    [<ffffffff812bdbdd>] nouveau_channel_free+0x141/0x233
[  123.604031]    [<ffffffff812be5bf>] nouveau_ioctl_fifo_free+0x79/0x86
[  123.604031]    [<ffffffff8129fdab>] drm_ioctl+0x2b3/0x36b
[  123.604031]    [<ffffffff810ec6fc>] vfs_ioctl+0x31/0xa2
[  123.604031]    [<ffffffff810ed07b>] do_vfs_ioctl+0x496/0x4c9
[  123.604031]    [<ffffffff810ed105>] sys_ioctl+0x57/0x96
[  123.604031]    [<ffffffff8100272b>] system_call_fastpath+0x16/0x1b
[  123.604031] 
[  123.604031] 
[  123.604031] stack backtrace:
[  123.604031] Pid: 3822, comm: e16 Tainted: G        W   2.6.35-rc6-mmotm0727 #1
[  123.604031] Call Trace:
[  123.604031]  [<ffffffff81064876>] check_usage+0x351/0x366
[  123.604031]  [<ffffffff8106313b>] ? register_lock_class+0x1e/0x2c7
[  123.604031]  [<ffffffff810648cd>] check_irq_usage+0x42/0x89
[  123.604031]  [<ffffffff810657d6>] __lock_acquire+0xa94/0xd6a
[  123.604031]  [<ffffffff810652ba>] ? __lock_acquire+0x578/0xd6a
[  123.604031]  [<ffffffff812a94bc>] ? drm_mm_put_block+0x10e/0x142
[  123.604031]  [<ffffffff81065fca>] lock_acquire+0x10a/0x130
[  123.604031]  [<ffffffff812a94bc>] ? drm_mm_put_block+0x10e/0x142
[  123.604031]  [<ffffffff81594ce1>] _raw_spin_lock+0x36/0x45
[  123.604031]  [<ffffffff812a94bc>] ? drm_mm_put_block+0x10e/0x142
[  123.604031]  [<ffffffff812a94bc>] drm_mm_put_block+0x10e/0x142
[  123.604031]  [<ffffffff812bf7e2>] nouveau_gpuobj_del+0x14c/0x179
[  123.604031]  [<ffffffff812c02ad>] nouveau_gpuobj_ref_del+0x25d/0x284
[  123.604031]  [<ffffffff812e3fb2>] nv50_graph_destroy_context+0xd0/0xdc
[  123.604031]  [<ffffffff812bdbdd>] nouveau_channel_free+0x141/0x233
[  123.604031]  [<ffffffff8109a0f9>] ? trace_preempt_off+0x15/0x28
[  123.604031]  [<ffffffff8129fd9c>] ? drm_ioctl+0x2a4/0x36b
[  123.604031]  [<ffffffff812be5bf>] nouveau_ioctl_fifo_free+0x79/0x86
[  123.604031]  [<ffffffff8129fdab>] drm_ioctl+0x2b3/0x36b
[  123.604031]  [<ffffffff812be546>] ? nouveau_ioctl_fifo_free+0x0/0x86
[  123.604031]  [<ffffffff81064b97>] ? mark_lock+0x2d/0x1d8
[  123.604031]  [<ffffffff810ec6fc>] vfs_ioctl+0x31/0xa2
[  123.604031]  [<ffffffff810ed07b>] do_vfs_ioctl+0x496/0x4c9
[  123.604031]  [<ffffffff810ed105>] sys_ioctl+0x57/0x96
[  123.604031]  [<ffffffff8100272b>] system_call_fastpath+0x16/0x1b


--==_Exmh_1280295723_4558P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMT8MrcC3lWbTT17ARAquzAJ9sRANPKqgrhV+ai7dau4g5cjy7QACgpnk6
Npq9taTrd5jwtZDq9qbhqNM=
=oNL9
-----END PGP SIGNATURE-----

--==_Exmh_1280295723_4558P--

