Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab0EMLdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 07:33:06 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:58431 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758737Ab0EMLdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 07:33:03 -0400
Date: Thu, 13 May 2010 13:32:57 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: reinette.chatre@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel BUG in iwl-agn-rs.c:2076, WAS: iwlagn + some
 accesspoint == hardlock
Message-ID: <20100513113257.GA7535@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273706072.2295.67.camel@rchatre-DESK>
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  short feedback:

  - recompiled kernel and config80211 as M
  - debug symbols included. Yet to try.
  - reboot
    Linux mypole 2.6.33.3 #22 SMP PREEMPT Thu May 13 12:52:22 CEST 2010 i686 GNU/Linux
  - renamed in-tree iwlagn and iwlcore, ran depmod -a, confirmed by looking into modules.dep
  - compat wireless compiled ok, modprobe fails w/:

[   23.665814] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   23.665817] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   23.665869] BUG: unable to handle kernel NULL pointer dereference at (null)
[   23.665934] IP: [<f8931b40>] iwl_alloc_all+0x20/0x50 [iwlcore]
[   23.665980] *pdpt = 0000000036448001 *pde = 0000000000000000 
[   23.666019] Oops: 0002 [#1] PREEMPT SMP 
[   23.666019] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/type
[   23.666019] Modules linked in: iwlagn(+) iwlcore mac80211 uhci_hcd e1000e cfg80211
[   23.666019] 
[   23.666019] Pid: 356, comm: modprobe Not tainted 2.6.33.3 #22 7666B4G/7666B4G
[   23.666019] EIP: 0060:[<f8931b40>] EFLAGS: 00010282 CPU: 0
[   23.666019] EIP is at iwl_alloc_all+0x20/0x50 [iwlcore]
[   23.666019] EAX: 00000000 EBX: f8998f20 ECX: f61d0280 EDX: f88e1870
[   23.666019] ESI: f61d0280 EDI: f8998f20 EBP: 00000000 ESP: f64ede38
[   23.666019]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   23.666019] Process modprobe (pid: 356, ti=f64ec000 task=f64b2030 task.ti=f64ec000)
[   23.666019] Stack:
[   23.666019]  c114241c f64ede58 f752bc00 f89987c0 f897eed5 00000000 a1ffde9c f65affe0
[   23.666019] <0> 000033bf f606dbbc f7535b0c c16f06bd c16f03fc c134d180 f752bc00 f89987c0
[   23.666019] <0> f897ee90 00000000 c134d02b c134d851 f89987c0 f752bc00 f8997e9c f752bc5c
[   23.666019] Call Trace:
[   23.666019]  [<c114241c>] ? sysfs_add_one+0x1c/0x140
[   23.666019]  [<f897eed5>] ? iwl_pci_probe+0x45/0x9c0 [iwlagn]
[   23.666019]  [<c16f06bd>] ? _raw_spin_lock+0xd/0x30
[   23.666019]  [<c16f03fc>] ? _raw_spin_unlock+0xc/0x20
[   23.666019]  [<c134d180>] ? pci_match_device+0xa0/0xc0
[   23.666019]  [<f897ee90>] ? iwl_pci_probe+0x0/0x9c0 [iwlagn]
[   23.666019]  [<c134d02b>] ? local_pci_probe+0xb/0x10
[   23.666019]  [<c134d851>] ? pci_device_probe+0x61/0x80
[   23.666019]  [<c1415dbb>] ? driver_probe_device+0x7b/0x170
[   23.666019]  [<c134d180>] ? pci_match_device+0xa0/0xc0
[   23.666019]  [<c16f0689>] ? _raw_spin_lock_irqsave+0x19/0x40
[   23.671155]  [<c1415f29>] ? __driver_attach+0x79/0x80
[   23.671155]  [<c1415eb0>] ? __driver_attach+0x0/0x80
[   23.671155]  [<c1415622>] ? bus_for_each_dev+0x52/0x80
[   23.671155]  [<c1415c56>] ? driver_attach+0x16/0x20
[   23.671155]  [<c1415eb0>] ? __driver_attach+0x0/0x80
[   23.671155]  [<c1414f1c>] ? bus_add_driver+0xcc/0x2b0
[   23.671155]  [<c134d790>] ? pci_device_remove+0x0/0x40
[   23.671155]  [<c14161c3>] ? driver_register+0x63/0x120
[   23.671155]  [<f899e000>] ? iwl_init+0x0/0x6a [iwlagn]
[   23.671155]  [<f899e000>] ? iwl_init+0x0/0x6a [iwlagn]
[   23.671155]  [<c134da7d>] ? __pci_register_driver+0x3d/0xb0
[   23.671155]  [<f899e04d>] ? iwl_init+0x4d/0x6a [iwlagn]
[   23.671155]  [<c100112f>] ? do_one_initcall+0x2f/0x190
[   23.671155]  [<c107ad54>] ? sys_init_module+0xb4/0x220
[   23.671155]  [<c1002c8c>] ? sysenter_do_call+0x12/0x22
[   23.671155] Code: b6 00 00 00 00 8d bf 00 00 00 00 83 ec 10 89 5c 24 08 89 c3 b8 24 63 00 00 89 74 24 0c e8 59 fa fa ff 85 c0 89 c6 74 13 8b 40 30 <89> 30 89 f0 8b 5c 24 08 8b 74 24 0c 83 c4 10 c3 8b 03 c7 04 24 
[   23.671155] EIP: [<f8931b40>] iwl_alloc_all+0x20/0x50 [iwlcore] SS:ESP 0068:f64ede38
[   23.671155] CR2: 0000000000000000
[   23.693150] ---[ end trace 2f287167f09b7fb3 ]---


So, suspending test w/ compat-wireless drivers, doing w/ those in-tree w/ dbg symbols included and activated.

  Cheers,

              Nils

