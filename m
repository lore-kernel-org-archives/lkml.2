Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab0CXOOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 10:14:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752486Ab0CXOOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 10:14:18 -0400
Date: Wed, 24 Mar 2010 07:12:29 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Dmitry Torokhov <dtor@mail.ru>
Cc: bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       ozgur.yuksel@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 15621] New: BUG: unable to handle kernel
 paging request - comm: pccardd
Message-Id: <20100324071229.5c42e213.akpm@linux-foundation.org>
In-Reply-To: <bug-15621-10286@https.bugzilla.kernel.org/>
References: <bug-15621-10286@https.bugzilla.kernel.org/>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Wed, 24 Mar 2010 10:07:54 GMT bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=15621
> 
>            Summary: BUG: unable to handle kernel paging request  - comm:
>                     pccardd
>            Product: Drivers
>            Version: 2.5
>     Kernel Version: 2.6.34-rc2 ae6be51ed01d6c4aaf249a207b4434bc7785853b
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: PCMCIA
>         AssignedTo: linux-pcmcia@lists.infradead.org
>         ReportedBy: ozgur.yuksel@oracle.com
>         Regression: Yes

It looks like the iomem_resource tree got wrecked.  Has anyone been
changing anything in there lately?

> 
> After building ae6be51ed01d6c4aaf249a207b4434bc7785853b, bootup gives out:
> [   75.245698] BUG: unable to handle kernel paging request at 746f7274
> [   75.249007] IP: [<c014ded0>] iomem_map_sanity_check+0x70/0x170
> [   75.249007] *pdpt = 000000002371c001 *pde = 0000000000000000
> [   75.249007] Oops: 0000 [#1] SMP
> [   75.249007] last sysfs file: /sys/devices/pnp0/00:0e/id
> [   75.272054] Modules linked in: sbp2 ip_tables snd yenta_socket ppdev psmouse
> soundcort
> [   75.272054]
> [   75.272054] Pid: 998, comm: pccardd Not tainted 2.6.34-rc2 #1
> 0KU184/Latitude D630
> [   75.306331] EIP: 0060:[<c014ded0>] EFLAGS: 00010202 CPU: 1
> [   75.306331] EIP is at iomem_map_sanity_check+0x70/0x170
> [   75.306331] EAX: 746f7270 EBX: 000f4800 ECX: 01100018 EDX: 746f7270
> [   75.306331] ESI: 00000000 EDI: 00001000 EBP: e4701d34 ESP: e4701cd0
> [   75.306331]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [   75.306331] Process pccardd (pid: 998, ti=e4700000 task=e36f3fc0
> task.ti=e4700000)
> [   75.306331] Stack:
> [   75.359751]  c04a0f5c 00000004 00000000 00000002 00000000 28172cf5 e47d4390
> 00000013
> [   75.359751] <0> 00000000 e4701d04 f4800fff 00000000 000f4800 00000000
> 000f4800 0000000
> [   75.359751] <0> f4800000 00000000 f4800fff 00000000 f4801000 00000000
> f4800000 0000000
> [   75.359751] Call Trace:
> [   75.359751]  [<c04a0f5c>] ? raw_pci_write+0x7c/0x80
> [   75.359751]  [<c012a02e>] ? __ioremap_caller+0xae/0x3f0
> [   75.359751]  [<c01f001b>] ? kmem_cache_alloc_notrace+0x6b/0xb0
> [   75.421337]  [<c014eb6e>] ? __request_region+0x1e/0x210
> [   75.421337]  [<c043963b>] ? usb_hcd_pci_probe+0x17b/0x3f0
> [   75.436059]  [<c012a43a>] ? ioremap_nocache+0x1a/0x20
> [   75.436059]  [<c043963b>] ? usb_hcd_pci_probe+0x17b/0x3f0
> [   75.436059]  [<c043963b>] ? usb_hcd_pci_probe+0x17b/0x3f0
> [   75.436059]  [<c024de78>] ? sysfs_add_one+0x18/0x100
> [   75.436059]  [<c024d477>] ? sysfs_new_dirent+0x67/0x100
> [   75.436059]  [<c033c0be>] ? local_pci_probe+0xe/0x10
> [   75.436059]  [<c033ce40>] ? pci_device_probe+0x60/0x80
> [   75.436059]  [<c03bba69>] ? driver_probe_device+0x69/0x150
> [   75.436059]  [<c03bbb91>] ? __device_attach+0x41/0x50
> [   75.436059]  [<c03badd8>] ? bus_for_each_drv+0x48/0x70
> [   75.436059]  [<c03bbd8d>] ? device_attach+0x6d/0x80
> [   75.436059]  [<c03bbb50>] ? __device_attach+0x0/0x50
> [   75.436059]  [<c03bac2d>] ? bus_probe_device+0x1d/0x40
> [   75.436059]  [<c03b997a>] ? device_add+0x48a/0x560
> [   75.436059]  [<c033a43e>] ? pci_set_cacheline_size+0x8e/0xe0
> [   75.436059]  [<c03374a7>] ? pci_bus_add_device+0x17/0x40
> [   75.436059]  [<c0337510>] ? pci_bus_add_devices+0x40/0x120
> [   75.436059]  [<f8b3e9ba>] ? cb_alloc+0xca/0xe0 [pcmcia_core]
> [   75.436059]  [<f8b3de29>] ? socket_insert+0xd9/0x100 [pcmcia_core]
> [   75.436059]  [<f8b3e289>] ? pccardd+0x309/0x400 [pcmcia_core]
> [   75.436059]  [<f8b3df80>] ? pccardd+0x0/0x400 [pcmcia_core]
> [   75.436059]  [<c0161e5c>] ? kthread+0x6c/0x80
> [   75.436059]  [<c0161df0>] ? kthread+0x0/0x80
> [   75.436059]  [<c01035c6>] ? kernel_thread_helper+0x6/0x10
> [   75.436059] Code: 55 ec 89 4d d8 8b 4d f0 89 5d dc 89 75 e0 83 c2 ff 83 d1
> ff 89 55 c
> [   75.436059] EIP: [<c014ded0>] iomem_map_sanity_check+0x70/0x170 SS:ESP
> 0068:e4701cd0
> [   75.436059] CR2: 00000000746f7274
> [   75.439957] ---[ end trace c9fcf1971e726fcf ]---
> 
> But kernel continues to boot .. But unfortunately fails with below later on:
> 
> [  141.736006] BUG: soft lockup - CPU#0 stuck for 61s! [modprobe:573]
> [  141.736006] Modules linked in: auth_rpcgss iwl3945(+) snd_timer uinput
> snd_seq_devicet
> [  141.736006] Modules linked in: auth_rpcgss iwl3945(+) snd_timer uinput
> snd_seq_devicet
> [  141.736006]
> [  141.736006] Pid: 573, comm: modprobe Tainted: G      D 2.6.34-rc2 #1
> 0KU184/Latitu
> [  141.736006] EIP: 0060:[<c058ff4c>] EFLAGS: 00000287 CPU: 0
> [  141.736006] EIP is at __write_lock_failed+0xc/0x20
> [  141.736006] EAX: c077e2e4 EBX: fe8fffff ECX: e4713240 EDX: e4713240
> [  141.736006] ESI: 00000000 EDI: c077e2c0 EBP: e454bd70 ESP: e454bd70
> [  141.736006]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [  141.736006] Process modprobe (pid: 573, ti=e454a000 task=e3425940
> task.ti=e454a000)
> [  141.736006] Stack:
> [  141.736006]  e454bd78 c0590151 e454bda8 c014ebc9 00000000 0000000d e4713240
> c04a0f5c
> [  141.736006] <0> 0000000d 00000040 e4713240 00000000 00001000 00000000
> e454bdf0 c0339c8
> [  141.736006] <0> 00001000 00000000 f87b3d33 00000000 00000000 fe8fffff
> 00000000 0000100
> [  141.736006] Call Trace:
> [  141.736006]  [<c0590151>] ? _raw_write_lock+0x11/0x20
> [  141.736006]  [<c014ebc9>] ? __request_region+0x79/0x210
> [  141.736006]  [<c04a0f5c>] ? raw_pci_write+0x7c/0x80
> [  141.736006]  [<c0339cd8>] ? __pci_request_region+0x158/0x1c0
> [  141.736006]  [<c0339f07>] ? __pci_request_selected_regions+0x37/0x70
> [  141.736006]  [<c0339f92>] ? pci_request_selected_regions+0x12/0x20
> [  141.736006]  [<c0339faf>] ? pci_request_regions+0xf/0x20
> [  141.736006]  [<f87a8602>] ? iwl3945_pci_probe+0x112/0x9d0 [iwl3945]
> [  141.736006]  [<c058ed34>] ? mutex_lock+0x14/0x40
> [  141.736006]  [<c033c0be>] ? local_pci_probe+0xe/0x10
> [  141.736006]  [<c033ce40>] ? pci_device_probe+0x60/0x80
> [  141.736006]  [<c03bba69>] ? driver_probe_device+0x69/0x150
> [  141.736006]  [<c03bbe19>] ? __driver_attach+0x79/0x80
> [  141.736006]  [<c03baed8>] ? bus_for_each_dev+0x48/0x70
> [  141.736006]  [<c03bb919>] ? driver_attach+0x19/0x20
> [  141.736006]  [<c03bbda0>] ? __driver_attach+0x0/0x80
> [  141.736006]  [<c03bb21f>] ? bus_add_driver+0xbf/0x2a0
> [  141.736006]  [<c033cd80>] ? pci_device_remove+0x0/0x40
> [  141.736006]  [<c03bbf35>] ? driver_register+0x65/0x120
> [  141.736006]  [<f87cc2e8>] ? ieee80211_rate_control_register+0xc8/0x120
> [mac80211]
> [  141.736006]  [<c033d060>] ? __pci_register_driver+0x40/0xb0
> [  141.736006]  [<f86da050>] ? iwl3945_init+0x50/0x6e [iwl3945]
> [  141.736006]  [<c010112c>] ? do_one_initcall+0x2c/0x190
> [  141.736006]  [<f86da000>] ? iwl3945_init+0x0/0x6e [iwl3945]
> [  141.736006]  [<c017c011>] ? sys_init_module+0xb1/0x220
> [  141.736006]  [<c0102fe3>] ? sysenter_do_call+0x12/0x28
> [  141.736006] Code: c7 45 f8 01 00 00 00 e8 03 fe ff ff 89 d8 83 c4 10 5b 5d
> c3 90 90 9
> 
> And the bootup starts to loop around dumps with similar / same stack ..
> 

