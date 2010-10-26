Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760599Ab0JZWTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 18:19:48 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:48875 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760396Ab0JZWTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 18:19:46 -0400
X-Greylist: delayed 508 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Oct 2010 18:19:46 EDT
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4CC751E8.9030505@elektron.elka.pw.edu.pl>
Date: Wed, 27 Oct 2010 00:10:48 +0200
From: "wzabolot@elektron.elka.pw.edu.pl" <W.Zabolotny@elka.pw.edu.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100913 Icedove/3.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: i915 module with modeset=1 freezes machine (kernels 2.6.33 and 2.6.36)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have two machines with intel graphics chipsets.
Below is the output from the lspci:
1st machine:
00:02.0 VGA compatible controller: Intel Corporation 82865G Integrated 
Graphics Controller (rev 02)
2nd machine:
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS, 
943/940GML Express Integrated Graphics Controller (rev 03)

Both machines worked a few years with intel Xorg xserver, with 
/etc/modprobe.d/i915-kms.conf
containing the line "options i915 modeset=0"
Unfortunately last time Xorg removed support for usermode mode setting 
in intel xserver,
and I had to change the above line to "options i915 modeset=1".
After that, both machines during boot simply freeze (screen is blank, no 
access through ssh, so probably the machine is frozen completely).

I tried to recompile the kernel with support for Intel agpgart and i915 
compiled in the kernel
but then the machine freezes even faster (no boot messages appear, 
screen gets black almost immediately after loading of the kernel).

I've tried to investigate the logs, but no error messages are logged.

Well, there is one warning in the logs, but the system worked with that 
warning for at least one year and it didn't cause any additional 
problems...:
Oct 26 21:10:51 wzab kernel: Pid: 1010, comm: modprobe Not tainted 2.6.36 #1
Oct 26 21:10:51 wzab kernel: Call Trace:
Oct 26 21:10:51 wzab kernel:  [<c0133cb8>] ? warn_slowpath_common+0x78/0xb0
Oct 26 21:10:51 wzab kernel:  [<f8392c18>] ? 
intelfbhw_active_pipe+0x58/0x60 [intelfb]
Oct 26 21:10:51 wzab kernel:  [<f8392c18>] ? 
intelfbhw_active_pipe+0x58/0x60 [intelfb]
Oct 26 21:10:51 wzab kernel:  [<c0133d0b>] ? warn_slowpath_null+0x1b/0x20
Oct 26 21:10:51 wzab kernel:  [<f8392c18>] ? 
intelfbhw_active_pipe+0x58/0x60 [intelfb]
Oct 26 21:10:51 wzab kernel:  [<f83954e9>] ? 
intelfb_pci_register+0xc27/0xdc3 [intelfb]
Oct 26 21:10:51 wzab kernel:  [<f83948c2>] ? 
intelfb_pci_register+0x0/0xdc3 [intelfb]
Oct 26 21:10:51 wzab kernel:  [<c026e54b>] ? local_pci_probe+0xb/0x10
Oct 26 21:10:51 wzab kernel:  [<c026ed71>] ? pci_device_probe+0x61/0x80
Oct 26 21:10:51 wzab kernel:  [<c02ccfb5>] ? driver_probe_device+0x65/0x170
Oct 26 21:10:51 wzab kernel:  [<c026e6a0>] ? pci_match_device+0xa0/0xc0
Oct 26 21:10:51 wzab kernel:  [<c02cd139>] ? __driver_attach+0x79/0x80
Oct 26 21:10:51 wzab kernel:  [<c02cd0c0>] ? __driver_attach+0x0/0x80
Oct 26 21:10:51 wzab kernel:  [<c02cc8a2>] ? bus_for_each_dev+0x52/0x80
Oct 26 21:10:51 wzab kernel:  [<c02cce56>] ? driver_attach+0x16/0x20
Oct 26 21:10:51 wzab kernel:  [<c02cd0c0>] ? __driver_attach+0x0/0x80
Oct 26 21:10:51 wzab kernel:  [<c02cc2a7>] ? bus_add_driver+0x177/0x230
Oct 26 21:10:51 wzab kernel:  [<c026ecb0>] ? pci_device_remove+0x0/0x40
Oct 26 21:10:51 wzab kernel:  [<c02cd3c3>] ? driver_register+0x63/0x120
Oct 26 21:10:51 wzab kernel:  [<c026ef9d>] ? __pci_register_driver+0x3d/0xb0
Oct 26 21:10:51 wzab kernel:  [<c0101132>] ? do_one_initcall+0x32/0x160
Oct 26 21:10:51 wzab kernel:  [<c0197808>] ? __vunmap+0xa8/0xe0
Oct 26 21:10:51 wzab kernel:  [<f82ea000>] ? intelfb_init+0x0/0x42 [intelfb]
Oct 26 21:10:51 wzab kernel:  [<c0162893>] ? sys_init_module+0x123/0xfd0
Oct 26 21:10:51 wzab kernel:  [<c0102c10>] ? sysenter_do_call+0x12/0x26
Oct 26 21:10:51 wzab kernel: ---[ end trace ec82370e7b0b3abd ]---
