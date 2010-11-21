Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab0KULIJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 06:08:09 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42554 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab0KULIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 06:08:07 -0500
Date: Sun, 21 Nov 2010 19:07:58 +0800
From: Arun Bhanu <ab@arunbhanu.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Francisco Jerez <currojerez@riseup.net>,
        Dave Airlie <airlied@redhat.com>,
        Marcin =?utf-8?Q?Ko=C5=9Bcielnicki?= <koriakin@0x04.net>
Subject: [BUG?] [Nouveau] INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order
 detected
Message-ID: <20101121110758.GA4267@deepthought.bhanu.net>
Reply-To: Arun Bhanu <ab@arunbhanu.com>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	Ben Skeggs <bskeggs@redhat.com>,
	Francisco Jerez <currojerez@riseup.net>,
	Dave Airlie <airlied@redhat.com>,
	Marcin =?utf-8?Q?Ko=C5=9Bcielnicki?= <koriakin@0x04.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am seeing the following in kernel log messages every time I reboot.
I am running 2.6.37-rc2.
(commit 589136bfa784a4558b397f017ca2f06f0ca9080e).

Please let me know if you need more info or want me to test any
patches.

[ 1043.994049] ======================================================
[ 1043.995596] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
[ 1043.996203] 2.6.37-rc2-ab3-589136bfa784a4558b397f017ca2f06f0ca9080e+ #2
[ 1043.996817] ------------------------------------------------------
[ 1043.997432] Xorg/2097 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[ 1043.998038]  (&(&dev_priv->ramin_lock)->rlock){+.+...}, at: [<f0887014>] nouveau_gpuobj_del+0xb8/0xe2 [nouveau]
[ 1043.998658] 
[ 1043.998658] and this task is already holding:
[ 1043.999891]  (&(&ramht->lock)->rlock){-.....}, at: [<f089fe4f>] nouveau_ramht_remove+0x23/0x3e [nouveau]
[ 1043.999906] which would create a new lock dependency:
[ 1043.999907]  (&(&ramht->lock)->rlock){-.....} -> (&(&dev_priv->ramin_lock)->rlock){+.+...}
[ 1043.999913] 
[ 1043.999913] but this new dependency connects a HARDIRQ-irq-safe lock:
[ 1043.999914]  (&(&ramht->lock)->rlock){-.....}
[ 1043.999916] ... which became HARDIRQ-irq-safe at:
[ 1043.999917]   [<c0472027>] __lock_acquire+0x27a/0xc06
[ 1043.999921]   [<c0472e10>] lock_acquire+0xbc/0xdc
[ 1043.999923]   [<c0824efb>] _raw_spin_lock_irqsave+0x48/0x78
[ 1043.999927]   [<f089fe93>] nouveau_ramht_find+0x29/0x6d [nouveau]
[ 1043.999941]   [<f0888e74>] nouveau_irq_handler+0x16a/0x17aa [nouveau]
[ 1043.999953]   [<c049da82>] handle_IRQ_event+0x51/0x10f
[ 1043.999956]   [<c049f7bb>] handle_fasteoi_irq+0x95/0xcc
[ 1043.999959] 
[ 1043.999960] to a HARDIRQ-irq-unsafe lock:
[ 1043.999961]  (&(&dev_priv->ramin_lock)->rlock){+.+...}
[ 1043.999962] ... which became HARDIRQ-irq-unsafe at:
[ 1043.999963] ...  [<c047209b>] __lock_acquire+0x2ee/0xc06
[ 1043.999966]   [<c0472e10>] lock_acquire+0xbc/0xdc
[ 1043.999968]   [<c0824d98>] _raw_spin_lock+0x3b/0x68
[ 1043.999970]   [<f0887167>] nouveau_gpuobj_new+0x129/0x39b [nouveau]
[ 1043.999981]   [<f08b583f>] nv50_instmem_init+0x11a/0x7db [nouveau]
[ 1043.999996]   [<f088371c>] nouveau_card_init+0xeda/0x1214 [nouveau]
[ 1044.000007]   [<f0884158>] nouveau_load+0x6e7/0x73e [nouveau]
[ 1044.000017]   [<ef819b8f>] drm_get_pci_dev+0x165/0x257 [drm]
[ 1044.000029]   [<f08c5c12>] nouveau_pci_probe+0x12/0x14 [nouveau]
[ 1044.000043]   [<c060c794>] local_pci_probe+0x34/0x5f
[ 1044.000046]   [<c060cc70>] pci_device_probe+0x4d/0x70
[ 1044.000048]   [<c06b1a9a>] driver_probe_device+0x119/0x1e9
[ 1044.000052]   [<c06b1bae>] __driver_attach+0x44/0x60
[ 1044.000053]   [<c06b0c44>] bus_for_each_dev+0x42/0x65
[ 1044.000055]   [<c06b1707>] driver_attach+0x1e/0x20
[ 1044.000057]   [<c06b1369>] bus_add_driver+0xc0/0x218
[ 1044.000059]   [<c06b1d9d>] driver_register+0x84/0xe3
[ 1044.000061]   [<c060ce6d>] __pci_register_driver+0x51/0xae
[ 1044.000063]   [<ef819f11>] drm_pci_init+0x37/0x96 [drm]
[ 1044.000074]   [<ef8135ae>] drm_init+0x5c/0x5e [drm]
[ 1044.000083]   [<f08e4042>] 0xf08e4042
[ 1044.000086]   [<c0403192>] do_one_initcall+0x8c/0x146
[ 1044.000088]   [<c047c610>] sys_init_module+0x12e9/0x1486
[ 1044.000091]   [<c040971f>] sysenter_do_call+0x12/0x38
[ 1044.000094] 
[ 1044.000095] other info that might help us debug this:
[ 1044.000096] 
[ 1044.000097] 2 locks held by Xorg/2097:
[ 1044.000098]  #0:  (drm_global_mutex){+.+.+.}, at: [<ef8138f8>] drm_ioctl+0x2f1/0x3c5 [drm]
[ 1044.000107]  #1:  (&(&ramht->lock)->rlock){-.....}, at: [<f089fe4f>] nouveau_ramht_remove+0x23/0x3e [nouveau]
[ 1044.000123] 
[ 1044.000123] the dependencies between HARDIRQ-irq-safe lock and the holding lock:
[ 1044.000147] -> (&(&ramht->lock)->rlock){-.....} ops: 61 {
[ 1044.000149]    IN-HARDIRQ-W at:
[ 1044.000150]                                        [<c0472027>] __lock_acquire+0x27a/0xc06
[ 1044.000154]                                        [<c0472e10>] lock_acquire+0xbc/0xdc
[ 1044.000156]                                        [<c0824efb>] _raw_spin_lock_irqsave+0x48/0x78
[ 1044.000159]                                        [<f089fe93>] nouveau_ramht_find+0x29/0x6d [nouveau]
[ 1044.000173]                                        [<f0888e74>] nouveau_irq_handler+0x16a/0x17aa [nouveau]
[ 1044.000186]                                        [<c049da82>] handle_IRQ_event+0x51/0x10f
[ 1044.000189]                                        [<c049f7bb>] handle_fasteoi_irq+0x95/0xcc
[ 1044.000192]    INITIAL USE at:
[ 1044.000193]                                       [<c047210f>] __lock_acquire+0x362/0xc06
[ 1044.000196]                                       [<c0472e10>] lock_acquire+0xbc/0xdc
[ 1044.000199]                                       [<c0824efb>] _raw_spin_lock_irqsave+0x48/0x78
[ 1044.000201]                                       [<f089fe93>] nouveau_ramht_find+0x29/0x6d [nouveau]
[ 1044.000216]                                       [<f089ff10>] nouveau_ramht_insert+0x39/0x2dd [nouveau]
[ 1044.000230]                                       [<f08b9b84>] nv50_evo_dmaobj_new.clone.4+0xe7/0xfd [nouveau]
[ 1044.000246]                                       [<f08babd8>] nv50_display_create+0x289/0x5bd [nouveau]
[ 1044.000262]                                       [<f08837bd>] nouveau_card_init+0xf7b/0x1214 [nouveau]
[ 1044.000273]                                       [<f0884158>] nouveau_load+0x6e7/0x73e [nouveau]
[ 1044.000284]                                       [<ef819b8f>] drm_get_pci_dev+0x165/0x257 [drm]
[ 1044.000295]                                       [<f08c5c12>] nouveau_pci_probe+0x12/0x14 [nouveau]
[ 1044.000308]                                       [<c060c794>] local_pci_probe+0x34/0x5f
[ 1044.000311]                                       [<c060cc70>] pci_device_probe+0x4d/0x70
[ 1044.000313]                                       [<c06b1a9a>] driver_probe_device+0x119/0x1e9
[ 1044.000315]                                       [<c06b1bae>] __driver_attach+0x44/0x60
[ 1044.000318]                                       [<c06b0c44>] bus_for_each_dev+0x42/0x65
[ 1044.000320]                                       [<c06b1707>] driver_attach+0x1e/0x20
[ 1044.000323]                                       [<c06b1369>] bus_add_driver+0xc0/0x218
[ 1044.000325]                                       [<c06b1d9d>] driver_register+0x84/0xe3
[ 1044.000327]                                       [<c060ce6d>] __pci_register_driver+0x51/0xae
[ 1044.000329]                                       [<ef819f11>] drm_pci_init+0x37/0x96 [drm]
[ 1044.000341]                                       [<ef8135ae>] drm_init+0x5c/0x5e [drm]
[ 1044.000351]                                       [<f08e4042>] 0xf08e4042
[ 1044.000354]                                       [<c0403192>] do_one_initcall+0x8c/0x146
[ 1044.000356]                                       [<c047c610>] sys_init_module+0x12e9/0x1486
[ 1044.000360]                                       [<c040971f>] sysenter_do_call+0x12/0x38
[ 1044.000362]  }
[ 1044.000363]  ... key      at: [<f08d6c60>] __key.34354+0x0/0xfffeefd6 [nouveau]
[ 1044.000373]  ... acquired at:
[ 1044.000374]    [<c0471975>] check_irq_usage+0x40/0x86
[ 1044.000376]    [<c047274c>] __lock_acquire+0x99f/0xc06
[ 1044.000379]    [<c0472e10>] lock_acquire+0xbc/0xdc
[ 1044.000381]    [<c0824d98>] _raw_spin_lock+0x3b/0x68
[ 1044.000382]    [<f0887014>] nouveau_gpuobj_del+0xb8/0xe2 [nouveau]
[ 1044.000393]    [<c05f2f2d>] kref_put+0x39/0x42
[ 1044.000396]    [<f088683b>] nouveau_gpuobj_ref+0x2d/0x33 [nouveau]
[ 1044.000407]    [<f089fc4f>] nouveau_ramht_remove_locked+0x50/0x1d7 [nouveau]
[ 1044.000422]    [<f089fe5b>] nouveau_ramht_remove+0x2f/0x3e [nouveau]
[ 1044.000436]    [<f0886aab>] nouveau_ioctl_gpuobj_free+0x89/0x93 [nouveau]
[ 1044.000447]    [<ef81390c>] drm_ioctl+0x305/0x3c5 [drm]
[ 1044.000456]    [<c050af42>] do_vfs_ioctl+0x591/0x5c2
[ 1044.000459]    [<c050afbb>] sys_ioctl+0x48/0x69
[ 1044.000461]    [<c040971f>] sysenter_do_call+0x12/0x38
[ 1044.000463] 
[ 1044.000464] 
[ 1044.000464] the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:
[ 1044.000486] -> (&(&dev_priv->ramin_lock)->rlock){+.+...} ops: 20682 {
[ 1044.000489]    HARDIRQ-ON-W at:
[ 1044.000490]                                        [<c047209b>] __lock_acquire+0x2ee/0xc06
[ 1044.000492]                                        [<c0472e10>] lock_acquire+0xbc/0xdc
[ 1044.000495]                                        [<c0824d98>] _raw_spin_lock+0x3b/0x68
[ 1044.000498]                                        [<f0887167>] nouveau_gpuobj_new+0x129/0x39b [nouveau]
[ 1044.000509]                                        [<f08b583f>] nv50_instmem_init+0x11a/0x7db [nouveau]
[ 1044.000524]                                        [<f088371c>] nouveau_card_init+0xeda/0x1214 [nouveau]
[ 1044.000536]                                        [<f0884158>] nouveau_load+0x6e7/0x73e [nouveau]
[ 1044.000546]                                        [<ef819b8f>] drm_get_pci_dev+0x165/0x257 [drm]
[ 1044.000557]                                        [<f08c5c12>] nouveau_pci_probe+0x12/0x14 [nouveau]
[ 1044.000571]                                        [<c060c794>] local_pci_probe+0x34/0x5f
[ 1044.000574]                                        [<c060cc70>] pci_device_probe+0x4d/0x70
[ 1044.000577]                                        [<c06b1a9a>] driver_probe_device+0x119/0x1e9
[ 1044.000579]                                        [<c06b1bae>] __driver_attach+0x44/0x60
[ 1044.000581]                                        [<c06b0c44>] bus_for_each_dev+0x42/0x65
[ 1044.000585]                                        [<c06b1707>] driver_attach+0x1e/0x20
[ 1044.000587]                                        [<c06b1369>] bus_add_driver+0xc0/0x218
[ 1044.000589]                                        [<c06b1d9d>] driver_register+0x84/0xe3
[ 1044.000591]                                        [<c060ce6d>] __pci_register_driver+0x51/0xae
[ 1044.000595]                                        [<ef819f11>] drm_pci_init+0x37/0x96 [drm]
[ 1044.000606]                                        [<ef8135ae>] drm_init+0x5c/0x5e [drm]
[ 1044.000615]                                        [<f08e4042>] 0xf08e4042
[ 1044.000617]                                        [<c0403192>] do_one_initcall+0x8c/0x146
[ 1044.000621]                                        [<c047c610>] sys_init_module+0x12e9/0x1486
[ 1044.000624]                                        [<c040971f>] sysenter_do_call+0x12/0x38
[ 1044.000626]    SOFTIRQ-ON-W at:
[ 1044.000627]                                        [<c04720ba>] __lock_acquire+0x30d/0xc06
[ 1044.000630]                                        [<c0472e10>] lock_acquire+0xbc/0xdc
[ 1044.000633]                                        [<c0824d98>] _raw_spin_lock+0x3b/0x68
[ 1044.000636]                                        [<f0887167>] nouveau_gpuobj_new+0x129/0x39b [nouveau]
[ 1044.000646]                                        [<f08b583f>] nv50_instmem_init+0x11a/0x7db [nouveau]
[ 1044.000662]                                        [<f088371c>] nouveau_card_init+0xeda/0x1214 [nouveau]
[ 1044.000672]                                        [<f0884158>] nouveau_load+0x6e7/0x73e [nouveau]
[ 1044.000682]                                        [<ef819b8f>] drm_get_pci_dev+0x165/0x257 [drm]
[ 1044.000693]                                        [<f08c5c12>] nouveau_pci_probe+0x12/0x14 [nouveau]
[ 1044.000707]                                        [<c060c794>] local_pci_probe+0x34/0x5f
[ 1044.000710]                                        [<c060cc70>] pci_device_probe+0x4d/0x70
[ 1044.000712]                                        [<c06b1a9a>] driver_probe_device+0x119/0x1e9
[ 1044.000715]                                        [<c06b1bae>] __driver_attach+0x44/0x60
[ 1044.000717]                                        [<c06b0c44>] bus_for_each_dev+0x42/0x65
[ 1044.000720]                                        [<c06b1707>] driver_attach+0x1e/0x20
[ 1044.000722]                                        [<c06b1369>] bus_add_driver+0xc0/0x218
[ 1044.000724]                                        [<c06b1d9d>] driver_register+0x84/0xe3
[ 1044.000726]                                        [<c060ce6d>] __pci_register_driver+0x51/0xae
[ 1044.000729]                                        [<ef819f11>] drm_pci_init+0x37/0x96 [drm]
[ 1044.000740]                                        [<ef8135ae>] drm_init+0x5c/0x5e [drm]
[ 1044.000750]                                        [<f08e4042>] 0xf08e4042
[ 1044.000755]                                        [<c0403192>] do_one_initcall+0x8c/0x146
[ 1044.000760]                                        [<c047c610>] sys_init_module+0x12e9/0x1486
[ 1044.000762]                                        [<c040971f>] sysenter_do_call+0x12/0x38
[ 1044.000765]    INITIAL USE at:
[ 1044.000766]                                       [<c047210f>] __lock_acquire+0x362/0xc06
[ 1044.000769]                                       [<c0472e10>] lock_acquire+0xbc/0xdc
[ 1044.000772]                                       [<c0824d98>] _raw_spin_lock+0x3b/0x68
[ 1044.000775]                                       [<f0887167>] nouveau_gpuobj_new+0x129/0x39b [nouveau]
[ 1044.000786]                                       [<f08b583f>] nv50_instmem_init+0x11a/0x7db [nouveau]
[ 1044.000801]                                       [<f088371c>] nouveau_card_init+0xeda/0x1214 [nouveau]
[ 1044.000811]                                       [<f0884158>] nouveau_load+0x6e7/0x73e [nouveau]
[ 1044.000821]                                       [<ef819b8f>] drm_get_pci_dev+0x165/0x257 [drm]
[ 1044.000832]                                       [<f08c5c12>] nouveau_pci_probe+0x12/0x14 [nouveau]
[ 1044.000845]                                       [<c060c794>] local_pci_probe+0x34/0x5f
[ 1044.000848]                                       [<c060cc70>] pci_device_probe+0x4d/0x70
[ 1044.000851]                                       [<c06b1a9a>] driver_probe_device+0x119/0x1e9
[ 1044.000854]                                       [<c06b1bae>] __driver_attach+0x44/0x60
[ 1044.000856]                                       [<c06b0c44>] bus_for_each_dev+0x42/0x65
[ 1044.000858]                                       [<c06b1707>] driver_attach+0x1e/0x20
[ 1044.000861]                                       [<c06b1369>] bus_add_driver+0xc0/0x218
[ 1044.000864]                                       [<c06b1d9d>] driver_register+0x84/0xe3
[ 1044.000866]                                       [<c060ce6d>] __pci_register_driver+0x51/0xae
[ 1044.000868]                                       [<ef819f11>] drm_pci_init+0x37/0x96 [drm]
[ 1044.000879]                                       [<ef8135ae>] drm_init+0x5c/0x5e [drm]
[ 1044.000887]                                       [<f08e4042>] 0xf08e4042
[ 1044.000891]                                       [<c0403192>] do_one_initcall+0x8c/0x146
[ 1044.000893]                                       [<c047c610>] sys_init_module+0x12e9/0x1486
[ 1044.000896]                                       [<c040971f>] sysenter_do_call+0x12/0x38
[ 1044.000899]  }
[ 1044.000900]  ... key      at: [<f08d6c2c>] __key.34274+0x0/0xfffef00a [nouveau]
[ 1044.000910]  ... acquired at:
[ 1044.000911]    [<c0471975>] check_irq_usage+0x40/0x86
[ 1044.000914]    [<c047274c>] __lock_acquire+0x99f/0xc06
[ 1044.000916]    [<c0472e10>] lock_acquire+0xbc/0xdc
[ 1044.000918]    [<c0824d98>] _raw_spin_lock+0x3b/0x68
[ 1044.000920]    [<f0887014>] nouveau_gpuobj_del+0xb8/0xe2 [nouveau]
[ 1044.000930]    [<c05f2f2d>] kref_put+0x39/0x42
[ 1044.000932]    [<f088683b>] nouveau_gpuobj_ref+0x2d/0x33 [nouveau]
[ 1044.000942]    [<f089fc4f>] nouveau_ramht_remove_locked+0x50/0x1d7 [nouveau]
[ 1044.000956]    [<f089fe5b>] nouveau_ramht_remove+0x2f/0x3e [nouveau]
[ 1044.000970]    [<f0886aab>] nouveau_ioctl_gpuobj_free+0x89/0x93 [nouveau]
[ 1044.000980]    [<ef81390c>] drm_ioctl+0x305/0x3c5 [drm]
[ 1044.000988]    [<c050af42>] do_vfs_ioctl+0x591/0x5c2
[ 1044.000991]    [<c050afbb>] sys_ioctl+0x48/0x69
[ 1044.000993]    [<c040971f>] sysenter_do_call+0x12/0x38
[ 1044.000995] 
[ 1044.000995] 
[ 1044.000996] stack backtrace:
[ 1044.000998] Pid: 2097, comm: Xorg Not tainted 2.6.37-rc2-ab3-589136bfa784a4558b397f017ca2f06f0ca9080e+ #2
[ 1044.000999] Call Trace:
[ 1044.001002]  [<c0822e61>] ? printk+0x2d/0x34
[ 1044.001005]  [<c0471928>] check_usage+0x2d9/0x2e6
[ 1044.001007]  [<c0471c18>] ? mark_lock+0x26/0x1bb
[ 1044.001011]  [<c040ea48>] ? sched_clock+0x8/0xb
[ 1044.001013]  [<c0471975>] check_irq_usage+0x40/0x86
[ 1044.001016]  [<c047274c>] __lock_acquire+0x99f/0xc06
[ 1044.001018]  [<c046ff1f>] ? register_lock_class+0x17/0x2a1
[ 1044.001030]  [<f0887014>] ? nouveau_gpuobj_del+0xb8/0xe2 [nouveau]
[ 1044.001032]  [<c0472e10>] lock_acquire+0xbc/0xdc
[ 1044.001043]  [<f0887014>] ? nouveau_gpuobj_del+0xb8/0xe2 [nouveau]
[ 1044.001046]  [<c0824d98>] _raw_spin_lock+0x3b/0x68
[ 1044.001057]  [<f0887014>] ? nouveau_gpuobj_del+0xb8/0xe2 [nouveau]
[ 1044.001068]  [<f0887014>] nouveau_gpuobj_del+0xb8/0xe2 [nouveau]
[ 1044.001071]  [<c04653da>] ? local_clock+0x32/0x49
[ 1044.001082]  [<f0886f5c>] ? nouveau_gpuobj_del+0x0/0xe2 [nouveau]
[ 1044.001084]  [<c05f2f2d>] kref_put+0x39/0x42
[ 1044.001095]  [<f088683b>] nouveau_gpuobj_ref+0x2d/0x33 [nouveau]
[ 1044.001110]  [<f089fc4f>] nouveau_ramht_remove_locked+0x50/0x1d7 [nouveau]
[ 1044.001125]  [<f089fe5b>] nouveau_ramht_remove+0x2f/0x3e [nouveau]
[ 1044.001136]  [<f0886aab>] nouveau_ioctl_gpuobj_free+0x89/0x93 [nouveau]
[ 1044.001139]  [<c0824018>] ? mutex_lock_nested+0x3b/0x40
[ 1044.001149]  [<ef81390c>] drm_ioctl+0x305/0x3c5 [drm]
[ 1044.001162]  [<f0886a22>] ? nouveau_ioctl_gpuobj_free+0x0/0x93 [nouveau]
[ 1044.001166]  [<c040ea3b>] ? native_sched_clock+0x4d/0x52
[ 1044.001168]  [<c040ea48>] ? sched_clock+0x8/0xb
[ 1044.001170]  [<c046529d>] ? sched_clock_cpu+0x42/0x14d
[ 1044.001173]  [<c0824dbe>] ? _raw_spin_lock+0x61/0x68
[ 1044.001175]  [<c046fc0e>] ? trace_hardirqs_off+0xb/0xd
[ 1044.001177]  [<c04653da>] ? local_clock+0x32/0x49
[ 1044.001180]  [<c046fe3e>] ? lock_release_holdtime+0x30/0xb5
[ 1044.001189]  [<ef813607>] ? drm_ioctl+0x0/0x3c5 [drm]
[ 1044.001191]  [<c050af42>] do_vfs_ioctl+0x591/0x5c2
[ 1044.001195]  [<c0463e8d>] ? up_read+0x22/0x25
[ 1044.001198]  [<c082864c>] ? do_page_fault+0x330/0x36e
[ 1044.001200]  [<c046fde7>] ? lock_is_held+0x70/0x78
[ 1044.001202]  [<c04ff199>] ? fcheck_files+0xab/0xdc
[ 1044.001204]  [<c04ff815>] ? fget_light+0x2f/0x6d
[ 1044.001206]  [<c050afbb>] sys_ioctl+0x48/0x69
[ 1044.001209]  [<c040971f>] sysenter_do_call+0x12/0x38
[ 1044.001822] [drm] nouveau 0000:08:00.0: nouveau_channel_free: freeing fifo 2

-Arun
