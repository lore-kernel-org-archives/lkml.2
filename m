Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab0DFG5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 02:57:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51463 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab0DFG5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 02:57:46 -0400
Date: Mon, 5 Apr 2010 23:57:19 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: ebiederm@xmission.com
Subject: 2.6.34-rc: key ffff8801fefc0310 not in .data!
Message-ID: <alpine.DEB.2.01.1004052344210.29272@bogon.housecafe.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/B3jrDyaeRXwt4ub361z5Cb7QwKGMGHbZYjpi
 D75GifLlOndswsv3Q5fGJ3NL9DBhY0568Kizv5ZmUmRPYXKBHG
 UwClm9u7ijGf3+ns3iUMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

similar messages have been reported for CONFIG_MICROCODE [0] and 
CONFIG_THERMAL [1], this one is for something else, I guess:


BUG: key ffff8801fefc0310 not in .data!
------------[ cut here ]------------
WARNING: at /usr/local/src/linux-2.6-git/kernel/lockdep.c:2696 lockdep_init_map+0x11c/0x140()
Hardware name: Sun Fire V40z
Modules linked in: k8temp lpfc(+) amd64_edac_mod hwmon edac_core 
ipmi_si(+) ipmi_msghandler
Pid: 2919, comm: work_for_cpu Not tainted 2.6.34-rc3 #1
Call Trace:
 [<ffffffff81038d48>] warn_slowpath_common+0x78/0xb0
 [<ffffffff81038d8f>] warn_slowpath_null+0xf/0x20
 [<ffffffff81061fec>] lockdep_init_map+0x11c/0x140
 [<ffffffff811268da>] sysfs_add_file_mode+0x6a/0xc0
 [<ffffffff8139b1d2>] ? put_device+0x12/0x20
 [<ffffffff813a2450>] ? transport_add_class_device+0x0/0x50
 [<ffffffff8112693c>] sysfs_add_file+0xc/0x10
 [<ffffffff81126a11>] sysfs_create_file+0x21/0x30
 [<ffffffff8139c234>] device_create_file+0x14/0x20
 [<ffffffff813a1d8f>] attribute_container_add_attrs+0x6f/0x90
 [<ffffffff813a1dcd>] attribute_container_add_class_device+0x1d/0x30
 [<ffffffff813a246f>] transport_add_class_device+0x1f/0x50
 [<ffffffff813a1f08>] attribute_container_device_trigger+0x98/0xe0
 [<ffffffff813a23d0>] transport_add_device+0x10/0x20
 [<ffffffff813b26f7>] scsi_sysfs_add_host+0x87/0xa0
 [<ffffffff813a70d7>] scsi_add_host_with_dma+0x167/0x290
 [<ffffffffa0078ad5>] lpfc_create_port+0x1e5/0x2f0 [lpfc]
 [<ffffffffa0078c2b>] lpfc_create_shost+0x4b/0x90 [lpfc]
 [<ffffffffa0098b17>] lpfc_pci_probe_one+0x10b9/0x1423 [lpfc]
 [<ffffffff814ccbb1>] ? schedule+0x2a1/0x6b0
 [<ffffffff814cfa9b>] ? _raw_spin_unlock_irqrestore+0x3b/0x60
 [<ffffffff8104c950>] ? do_work_for_cpu+0x0/0x30
 [<ffffffff81361832>] local_pci_probe+0x12/0x20
 [<ffffffff8104c963>] do_work_for_cpu+0x13/0x30
 [<ffffffff81050f7e>] kthread+0xae/0xc0
 [<ffffffff81064605>] ? trace_hardirqs_on_caller+0x155/0x1a0
 [<ffffffff81003b54>] kernel_thread_helper+0x4/0x10
 [<ffffffff814cfd3c>] ? restore_args+0x0/0x30
 [<ffffffff81050ed0>] ? kthread+0x0/0xc0
 [<ffffffff81003b50>] ? kernel_thread_helper+0x0/0x10

Maybe drivers/base/attribute_container.c needs the same annotations too?

I've put a ful dmesg, .config and more on:
http://nerdbynature.de/bits/2.6.34-rc3/v40z/

Btw, this happened since -rc1 and when I searched the archives for it I 
assumed that a fix was already underway - and did not realize that my 
issue is somehwat different.

Thanks,
Christian.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=15494
    https://git.kernel.org/linus/e1955ca0ee55286cbc65a8ed7471d540ae83dac8
[1] https://bugzilla.kernel.org/show_bug.cgi?id=15548
    https://patchwork.kernel.org/patch/87424/
-- 
BOFH excuse #240:

Too many little pins on CPU confusing it, bend back and forth until 10-20% are neatly removed. Do _not_ leave metal bits visible!
