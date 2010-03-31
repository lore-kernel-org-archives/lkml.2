Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab0CaJSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 05:18:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:39060 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932976Ab0CaJSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 05:18:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=m/CWywILUZ2YDHs6Lv96EdfcTGnQtKOQcqJb2KxrAre41I+r2NBZLx7fMxvudI6ned
         ofxi2ESsAgIPNAVe0uX2nPAzhAyYnDSYbQGWfy/Xb7LGuBUqNp3UQuIOf0yCJTW6lPrZ
         VX+Yg6OulCjgY3TjP6IV0myQ8/Mzg2s/p5bBA=
MIME-Version: 1.0
Date: Wed, 31 Mar 2010 11:18:06 +0200
Message-ID: <y2r40a4ed591003310218he411c263p62915a3e0a5a8de3@mail.gmail.com>
Subject: 2.6.34-rc3 - nvidia: module license 'NVIDIA' taints kernel.
From: Zeno Davatz <zdavatz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I just booted into the new 2.6.34-rc3 Kernel. Looks Lovely!

my nvidia output with lspci -v is:

05:00.0 VGA compatible controller: nVidia Corporation G98 [GeForce
8400 GS] (rev a1) (prog-if 00 [VGA controller])
        Subsystem: ASUSTeK Computer Inc. Device 8321
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
        Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Memory at f8000000 (64-bit, non-prefetchable) [size=32M]
        I/O ports at ec00 [size=128]
        [virtual] Expansion ROM at fb000000 [disabled] [size=128K]
        Capabilities: [60] Power Management version 3
        Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [78] Express Endpoint, MSI 00
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [128] Power Budgeting <?>
        Capabilities: [600] Vendor Specific Information <?>
        Kernel driver in use: nvidia
        Kernel modules: nvidia

My new Nvidia in dmesg gives me:

nvidia: module license 'NVIDIA' taints kernel.
Disabling lock debugging due to kernel taint
nvidia 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
nvidia 0000:05:00.0: setting latency timer to 64
vgaarb: device changed decodes:
PCI:0000:05:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
NVRM: loading NVIDIA UNIX x86 Kernel Module  195.36.15  Thu Mar 11
21:41:46 PST 2010
resource map sanity check conflict: 0x9f800 0xa07ff 0xa0000 0xbffff
PCI Bus 0000:00
------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:98 __ioremap_caller+0x331/0x3b3()
Hardware name: To Be Filled By O.E.M.
Info: mapping multiple BARs. Your kernel is fine.
Modules linked in: nvidia(P)
Pid: 7562, comm: X Tainted: P           2.6.34-rc3 #86

Call Trace:
 [<c1040205>] ? __ioremap_caller+0x331/0x3b3
 [<c1040205>] ? __ioremap_caller+0x331/0x3b3
 [<c1052828>] warn_slowpath_common+0x66/0xae
 [<c1040205>] ? __ioremap_caller+0x331/0x3b3
 [<c10528ad>] warn_slowpath_fmt+0x26/0x28
 [<c1040205>] __ioremap_caller+0x331/0x3b3
 [<c11e2034>] ? prio_tree_remove+0x96/0xd9
 [<f97f9580>] ? os_map_kernel_space+0xc1/0x129 [nvidia]
 [<c104032a>] ioremap_nocache+0x1a/0x20
 [<f97f9580>] ? os_map_kernel_space+0xc1/0x129 [nvidia]
 [<f97f9580>] os_map_kernel_space+0xc1/0x129 [nvidia]
 [<c1424bd0>] ? kmemleak_free+0x2f/0x50
 [<f97f9580>] ? os_map_kernel_space+0xc1/0x129 [nvidia]
 [<f97157c9>] _nv006553rm+0x4a/0x51 [nvidia]
 [<f96a6e05>] ? _nv004314rm+0x3d/0x169 [nvidia]
 [<f96a6fa3>] ? _nv007498rm+0x72/0xa9 [nvidia]
 [<f96a7401>] ? _nv007499rm+0x55/0xb8 [nvidia]
 [<f96a3c29>] ? _nv007478rm+0xb5/0x2e2 [nvidia]
 [<f96a3ee6>] ? _nv007428rm+0x90/0x16f [nvidia]
 [<f96a400a>] ? _nv007479rm+0x45/0x53 [nvidia]
 [<f96af641>] ? _nv007487rm+0x5f/0x6a [nvidia]
 [<f97212f4>] ? _nv010979rm+0x44/0xe0 [nvidia]
 [<f972129d>] ? _nv010925rm+0xb2/0xc5 [nvidia]
 [<f96a7a48>] ? _nv025164rm+0x4a/0x152 [nvidia]
 [<f96c548f>] ? _nv014199rm+0x12f/0x37d [nvidia]
 [<f96c4c35>] ? _nv013776rm+0xa9/0x107 [nvidia]
 [<f95a694a>] ? _nv014009rm+0xb/0xf [nvidia]
 [<f972106f>] ? _nv004517rm+0x127/0x23b [nvidia]
 [<f9721c8c>] ? _nv004523rm+0x3dc/0x5b4 [nvidia]
 [<f971cc3a>] ? rm_init_adapter+0x62/0xab [nvidia]
 [<f97f6e3c>] ? nv_kern_open+0x389/0x5da [nvidia]
 [<c10b7e73>] ? chrdev_open+0xab/0x146
 [<c10b3f94>] ? __dentry_open+0x9c/0x23f
 [<c10b41fe>] ? nameidata_to_filp+0x45/0x4f
 [<c10b7dc8>] ? chrdev_open+0x0/0x146
 [<c10be18f>] ? do_last+0x36e/0x5df
 [<c10b69a7>] ? get_empty_filp+0x6e/0x129
 [<c10bfde1>] ? do_filp_open+0x198/0x4d9
 [<c10b39ab>] ? create_object+0x17f/0x234
 [<c1424cdc>] ? kmemleak_alloc+0x3a/0x50
 [<c10c8394>] ? alloc_fd+0x72/0xf1
 [<c10b3dc1>] ? do_sys_open+0x57/0x118
 [<c10b3ece>] ? sys_open+0x23/0x2b
 [<c1024b9c>] ? sysenter_do_call+0x12/0x2c
---[ end trace 6c31a23caa04ac0a ]---

Can I ignore this or is this of any use for the list and the Kernel improvement?

Best
Zeno
