Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab0KBTGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 15:06:34 -0400
Received: from www17.your-server.de ([213.133.104.17]:34491 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab0KBTG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 15:06:27 -0400
Message-ID: <50AA24C585B14210A44AB599605C7CBD@hugo>
From: "Thomas Meyer" <thomas@m3y3r.de>
To: <linux-kernel@vger.kernel.org>
Subject: 2.6.37-rc1: BUG: scheduling while atomic (kvm_init)
Date: Tue, 2 Nov 2010 20:06:22 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Windows Mail 6.0.6002.18197
X-MimeOLE: Produced By Microsoft MimeOLE V6.0.6002.18263
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[    0.488115] Freeing initrd memory: 7080k freed
[    0.492203] PCI-DMA: Disabling AGP.
[    0.492369] PCI-DMA: aperture base @ b4000000 size 65536 KB
[    0.492370] PCI-DMA: using GART IOMMU.
[    0.492374] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.495803] kvm: Nested Virtualization enabled
[    0.495821] BUG: scheduling while atomic: swapper/1/0x00000002
[    0.495846] Modules linked in:
[    0.495850] Pid: 1, comm: swapper Not tainted 2.6.37-rc1 #71
[    0.495851] Call Trace:
[    0.495860]  [<ffffffff816dc00c>] ? schedule+0xdf/0x566
[    0.495865]  [<ffffffff812b6193>] ? put_dec+0x2e/0x33
[    0.495868]  [<ffffffff816dc69c>] ? schedule_timeout+0x2d/0xd7
[    0.495872]  [<ffffffff810553a0>] ? try_to_wake_up+0x197/0x1b2
[    0.495876]  [<ffffffff816dbd56>] ? wait_for_common+0x9d/0x10c
[    0.495878]  [<ffffffff810553bb>] ? default_wake_function+0x0/0x11
[    0.495882]  [<ffffffff8106ab5c>] ? queue_work+0x2f/0x52
[    0.495885]  [<ffffffff810688e6>] ? call_usermodehelper_exec+0x6e/0xb3
[    0.495888]  [<ffffffff812b2d6d>] ? kobject_uevent_env+0x3da/0x41f
[    0.495892]  [<ffffffff812b21be>] ? kset_register+0x34/0x3d
[    0.495896]  [<ffffffff81379cbc>] ? sysdev_class_register+0x61/0x83
[    0.495899]  [<ffffffff81001a81>] ? kvm_init+0x18c/0x314
[    0.495903]  [<ffffffff81d3a51e>] ? irqfd_module_init+0x0/0x34
[    0.495906]  [<ffffffff81d3a552>] ? svm_init+0x0/0x20
[    0.495908]  [<ffffffff81000209>] ? do_one_initcall+0x78/0x129
[    0.495911]  [<ffffffff81d37693>] ? kernel_init+0x15c/0x1e8
[    0.495915]  [<ffffffff81025814>] ? kernel_thread_helper+0x4/0x10
[    0.495919]  [<ffffffff81d37537>] ? kernel_init+0x0/0x1e8
[    0.495922]  [<ffffffff81025810>] ? kernel_thread_helper+0x0/0x10
[    0.495934] BUG: scheduling while atomic: swapper/1/0x00000002
[    0.495958] Modules linked in:
[    0.495960] Pid: 1, comm: swapper Not tainted 2.6.37-rc1 #71
[    0.495962] Call Trace:
[    0.495965]  [<ffffffff816dc00c>] ? schedule+0xdf/0x566
[    0.495968]  [<ffffffff812b10bb>] ? idr_get_empty_slot+0x16a/0x250
[    0.495971]  [<ffffffff816dc69c>] ? schedule_timeout+0x2d/0xd7
[    0.495974]  [<ffffffff810553a0>] ? try_to_wake_up+0x197/0x1b2
[    0.495977]  [<ffffffff816dbd56>] ? wait_for_common+0x9d/0x10c
[    0.495980]  [<ffffffff810553bb>] ? default_wake_function+0x0/0x11
[    0.495983]  [<ffffffff8106ab5c>] ? queue_work+0x2f/0x52
[    0.495986]  [<ffffffff810688e6>] ? call_usermodehelper_exec+0x6e/0xb3
[    0.495989]  [<ffffffff812b2d6d>] ? kobject_uevent_env+0x3da/0x41f
[    0.495993]  [<ffffffff81379b24>] ? sysdev_register+0xa6/0xb2
[    0.495995]  [<ffffffff81001a99>] ? kvm_init+0x1a4/0x314
[    0.495998]  [<ffffffff81d3a51e>] ? irqfd_module_init+0x0/0x34
[    0.496001]  [<ffffffff81d3a552>] ? svm_init+0x0/0x20
[    0.496016]  [<ffffffff81000209>] ? do_one_initcall+0x78/0x129
[    0.496019]  [<ffffffff81d37693>] ? kernel_init+0x15c/0x1e8
[    0.496022]  [<ffffffff81025814>] ? kernel_thread_helper+0x4/0x10
[    0.496025]  [<ffffffff81d37537>] ? kernel_init+0x0/0x1e8
[    0.496028]  [<ffffffff81025810>] ? kernel_thread_helper+0x0/0x10
[    0.496059] BUG: scheduling while atomic: swapper/1/0x00000002
[    0.496084] Modules linked in:
[    0.496086] Pid: 1, comm: swapper Not tainted 2.6.37-rc1 #71
[    0.496087] Call Trace:
[    0.496090]  [<ffffffff816dc00c>] ? schedule+0xdf/0x566
[    0.496094]  [<ffffffff816dc69c>] ? schedule_timeout+0x2d/0xd7
[    0.496096]  [<ffffffff810553a0>] ? try_to_wake_up+0x197/0x1b2
[    0.496100]  [<ffffffff816dbd56>] ? wait_for_common+0x9d/0x10c
[    0.496103]  [<ffffffff810553bb>] ? default_wake_function+0x0/0x11
[    0.496105]  [<ffffffff8106ab5c>] ? queue_work+0x2f/0x52
[    0.496108]  [<ffffffff810688e6>] ? call_usermodehelper_exec+0x6e/0xb3
[    0.496111]  [<ffffffff812b2d6d>] ? kobject_uevent_env+0x3da/0x41f
[    0.496115]  [<ffffffff8137907d>] ? device_add+0x37a/0x511
[    0.496118]  [<ffffffff813792b1>] ? device_create_vargs+0x8b/0xbc
[    0.496121]  [<ffffffff8137930e>] ? device_create+0x2c/0x31
[    0.496125]  [<ffffffff810deaae>] ? kmem_cache_create+0x23e/0x29c
[    0.496128]  [<ffffffff81335df6>] ? misc_register+0xb9/0x113
[    0.496130]  [<ffffffff81001afc>] ? kvm_init+0x207/0x314
[    0.496134]  [<ffffffff81d3a51e>] ? irqfd_module_init+0x0/0x34
[    0.496137]  [<ffffffff81d3a552>] ? svm_init+0x0/0x20
[    0.496140]  [<ffffffff81000209>] ? do_one_initcall+0x78/0x129
[    0.496143]  [<ffffffff81d37693>] ? kernel_init+0x15c/0x1e8
[    0.496146]  [<ffffffff81025814>] ? kernel_thread_helper+0x4/0x10
[    0.496149]  [<ffffffff81d37537>] ? kernel_init+0x0/0x1e8
[    0.496152]  [<ffffffff81025810>] ? kernel_thread_helper+0x0/0x10
[    0.496222] initcall svm_init+0x0/0x20 returned with preemption imbalance

