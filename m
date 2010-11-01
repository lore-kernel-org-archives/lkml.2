Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab0KARPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 13:15:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50250 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab0KARPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 13:15:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-disposition:content-type:content-transfer-encoding
         :message-id;
        b=EHRt2vi5f9xtbSHr/8Oq4WRzpUXB67Xo2+SB0ZiVgQi1HuVtqaIQZVf72kQ42D5Xec
         vPQwiMPGET4Ha4BHuh0s4ZfuD2W+DFoZaGvN2BT3RiwLOLuV5TZWhwySeSIpXzSOUCp0
         Kzv0Zo3pAWJnxbTl08+Jl7MEQcejXdVqcU+9E=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: linux-media@vger.kernel.org
Subject: 2.6.37-rc1: NULL pointer dereference
Date: Mon, 1 Nov 2010 17:14:51 +0000
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011011714.51260.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just built, installed and booted 2.6.37-rc1 and I got this BUG report

BUG: unable to handle kernel NULL pointer dereference at   (null)
IP: [<c12339b8>] i2c_transfer+0x18/0xe0
*pdpt = 0000000033caf001 *pde = 0000000000000000
Oops: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1d.0/usb3/manufacturer
Modules linked in: mt2060 videodev v4l1_compat dvb_usb_dib0700(+) dib7000p 
dib0090 dib7000m dib0070 dvb_usb dib8000 dvb_core dib3000mc dibx000_common 
ir_lirc_codec lirc_dev ir_core uhci_hcd ehci_hcd floppy evdev [last unloaded: 
microcode]

Pid: 1377, comm: modprobe Not tainted 2.6.37-rc1 #456 EG41MF-US2H/EG41MF-US2H
EIP: 0060:[<c12339b8>] EFLAGS: 00010286 CPU: 0
EIP is at i2c_transfer+0x18/0xe0
EAX: 00000000 EBX: ffffffa1 ECX: 00000002 EDX: f42cfd24
ESI: f4401ad4 EDI: f88d9af2 EBP: f4401800 ESP: f42cfd00
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 1377, ti=f42ce000 task=f4054dc0 task.ti=f42ce000)
Stack:
 f42cfd24 00000002 f88d9af2 f4401ad4 f88d9af2 f4401800 f8a54093 f42cfd5c
 f4d0ee00 00000060 c10a0001 f42cfd20 00010060 f4400001 f42cfd53 f4d0ee00
gspca: v2.10.0 registered
 f8a54639 f42cfd53 00000000 04cee0a9 00000001 f469889c f8a545c0 000004ce
Call Trace:
 [<f8a54093>] ? mt2060_readreg.clone.2+0x53/0x80 [mt2060]
 [<c10a0001>] ? sys_swapoff+0x931/0x9b0
 [<f8a54639>] ? mt2060_attach+0x79/0x344 [mt2060]
 [<f8a545c0>] ? mt2060_attach+0x0/0x344 [mt2060]
 [<f88d102d>] ? bristol_tuner_attach+0x6d/0x120 [dvb_usb_dib0700]
 [<f88741f3>] ? dvb_usb_adapter_frontend_init+0x73/0xf0 [dvb_usb]
 [<f88737d5>] ? dvb_usb_device_init+0x325/0x5d0 [dvb_usb]
 [<f88ceea8>] ? dib0700_probe+0x58/0xe0 [dvb_usb_dib0700]
 [<c121976a>] ? usb_match_one_id+0x2a/0xb0
 [<c12199df>] ? usb_probe_interface+0x9f/0x130
 [<c11c86a5>] ? driver_probe_device+0x65/0x160
 [<c1219899>] ? usb_match_id+0x39/0x60
 [<c1219923>] ? usb_device_match+0x63/0x80
 [<c11c8819>] ? __driver_attach+0x79/0x80
 [<c11c87a0>] ? __driver_attach+0x0/0x80
 [<c11c79ab>] ? bus_for_each_dev+0x4b/0x70
 [<c11c8416>] ? driver_attach+0x16/0x20
 [<c11c87a0>] ? __driver_attach+0x0/0x80
 [<c11c811f>] ? bus_add_driver+0x16f/0x250
 [<c11c8a1f>] ? driver_register+0x5f/0x100
 [<c1219151>] ? usb_register_driver+0x81/0x130
 [<f88dd02d>] ? dib0700_module_init+0x2d/0x4a [dvb_usb_dib0700]
 [<c1001203>] ? do_one_initcall+0x33/0x170
 [<c109b548>] ? __vunmap+0xb8/0xf0
 [<f88dd000>] ? dib0700_module_init+0x0/0x4a [dvb_usb_dib0700]
 [<c105e949>] ? sys_init_module+0x129/0x1850
 [<c1002d10>] ? sysenter_do_call+0x12/0x26
Code: 00 00 00 83 ea 34 74 eb 89 d0 eb d7 8d b4 26 00 00 00 00 55 57 56 89 c6 53 
bb a1 ff ff ff 83 ec 08 89 4c 24 04 8b 40 0c 8914 24 <8b> 08 85 c9 74 7b 64 a1 
cc f4 4b c1 89 e2 8b 40 14 81 e2 00 e0
EIP: [<c12339b8>] i2c_transfer+0x18/0xe0 SS:ESP 0068:f42cfd00
CR2: 0000000000000000
---[ end trace eb2261dd66891417 ]---

The hardware is Hauppauge WinTv NOva-T-500.

I'm happy to test any patches, but please cc me as I'm not subscribed.

Chris
-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
