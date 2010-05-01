Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab0EAV3J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 17:29:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:60759 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752091Ab0EAV3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 17:29:06 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18LTF5Hq8wLBMx2gaBp02shf+QuqKzl+bsRvs3PPA
	SZq4YsZGKdQVSd
Message-ID: <4BDC9D17.9080000@gmx.de>
Date: Sat, 01 May 2010 23:28:55 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn
Subject: Re: [RFC] Second OLPC Viafb series, v2
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
In-Reply-To: <1272493051-25380-1-git-send-email-corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet schrieb:
> The full series of patches can be pulled from:
> 
> 	git://git.lwn.net/linux-2.6.git viafb-posted

Testing it (newest version) resulted in this bug during module unload

kernel BUG at mm/slub.c:2843!
invalid opcode: 0000 [#1] PREEMPT
last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/bind
Modules linked in: fbcon font bitblit softcursor viafb(-) fb 
i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm mmc_block snd_timer 
rtl8187 snd eeprom_93cx6 via_sdmmc soundcore snd_page_alloc i2c_viapro 
ehci_hcd uhci_hcd mmc_core video output

Pid: 3225, comm: rmmod Not tainted 2.6.34-rc3 #2 IL1/
EIP: 0060:[<c106f62d>] EFLAGS: 00010246 CPU: 0
EIP is at kfree+0x35/0x79
EAX: c180a400 EBX: db9d4f00 ECX: db20f000 EDX: 00000000
ESI: dc998f58 EDI: db191250 EBP: db20fe70 ESP: db20fe64
  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process rmmod (pid: 3225, ti=db20f000 task=db034370 task.ti=db20f000)
Stack:
  db9d4f00 c13c43cc db191250 db20fe7c c11879db dbb92060 db20fe88 c11843d0
<0> db9d4f10 db20fe9c c111f9d6 db9d4f2c c111f996 dc998424 db20feac c11204aa
<0> db9d4f10 dc998424 db20feb8 c111f90b db9d4f00 db20fec0 c1183f60 db20fec8
Call Trace:
  [<c11879db>] ? platform_device_release+0x11/0x26
  [<c11843d0>] ? device_release+0x35/0x5d
  [<c111f9d6>] ? kobject_release+0x40/0x50
  [<c111f996>] ? kobject_release+0x0/0x50
  [<c11204aa>] ? kref_put+0x38/0x43
  [<c111f90b>] ? kobject_put+0x37/0x3c
  [<c1183f60>] ? put_device+0xf/0x11
  [<c11879ff>] ? platform_device_put+0xf/0x11
  [<c1187b4d>] ? platform_device_unregister+0x12/0x15
  [<dc9937bd>] ? via_pci_remove+0x14/0x47 [viafb]
  [<c112ed14>] ? pci_device_remove+0x19/0x39
  [<c1186691>] ? __device_release_driver+0x58/0x8e
  [<c1186741>] ? driver_detach+0x7a/0xa0
  [<c1185c5d>] ? bus_remove_driver+0x6c/0x92
  [<c1186b38>] ? driver_unregister+0x4d/0x54
  [<c112eeee>] ? pci_unregister_driver+0x29/0x7c
  [<dc993759>] ? via_core_exit+0x1c/0x1e [viafb]
  [<c104189b>] ? sys_delete_module+0x180/0x1e4
  [<c1062895>] ? remove_vma+0x41/0x47
  [<c12b012b>] ? do_page_fault+0x312/0x340
  [<c1002750>] ? sysenter_do_call+0x12/0x26
Code: 53 76 64 8d 80 00 00 00 40 c1 e8 0c c1 e0 05 03 05 b0 c9 45 c1 66 
83 38 00 79 03 8b 40 0c 8b 10 84 d2 78 12 66 f7 c2 00 c0 75 04 <0f> 0b 
eb fe e8 35 65 fe ff eb 31 8b 55 04 8b 58 0c 9c 5f fa 8b
EIP: [<c106f62d>] kfree+0x35/0x79 SS:ESP 0068:db20fe64

The only information I can supply so far is that it happened already 
while unregistering the first platform. The registration of it seemed to 
be successful. I did not yet dig deep enough into the subsystem to find 
the bug. Any ideas?


Thanks,

Florian Tobias Schandinat
