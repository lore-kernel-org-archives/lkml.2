Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab1GNCl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 22:41:26 -0400
Received: from ppp118-208-123-30.lns20.bne4.internode.on.net ([118.208.123.30]:34713
	"EHLO mail.psychogeeks.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752459Ab1GNClY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 22:41:24 -0400
Message-ID: <4E1E574E.9010403@psychogeeks.com>
Date: Thu, 14 Jul 2011 12:41:18 +1000
From: Chris W <lkml@psychogeeks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110620 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: Imon module Oops and kernel hang
References: <4E1B978C.2030407@psychogeeks.com> <20110712080309.d538fec9.rdunlap@xenotime.net> <7B814F02-408C-434F-B813-8630B60914DA@wilsonet.com> <4E1CCC26.4060506@psychogeeks.com> <1B380AD0-FE0D-47DF-B2C3-605253C9C783@wilsonet.com> <4E1D3045.7050507@psychogeeks.com> <2E869B1F-D476-4645-BE26-B1DD77DF1735@wilsonet.com>
In-Reply-To: <2E869B1F-D476-4645-BE26-B1DD77DF1735@wilsonet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/07/11 08:11, Jarod Wilson wrote:
> On Jul 13, 2011, at 1:42 AM, Chris W wrote:
> Just noticed your report is for 2.6.39.x and 2.6.38.x only, but I'm
> not aware of any relevant imon changes between 2.6.39 and 3.0.

I just tried 3.0.0-rc7 with the same result (used defaults for new
config items.  I manually loaded both keymaps before imon.  I looks like
the mystery T889 has become a T886... compiler generated temporary name
perhaps?

> Looks like I'll probably have to give that a spin, since I'm not
> seeing the problem here (I can also switch to an 0xffdc device, which
> is actually handled a bit differently by the driver).

I understand that the 0xffdc device covers a multitude of physical
variants.   Is there any information from the device itself that drives
the selected keymap?  If so, how do I extract it?

Regards,
Chris


Jul 14 11:19:38 kepler BUG: unable to handle kernel
Jul 14 11:19:38 kepler NULL pointer dereference
Jul 14 11:19:38 kepler at 000000dc
Jul 14 11:19:38 kepler IP:
Jul 14 11:19:38 kepler [<f8f1949e>] rc_g_keycode_from_table+0x1e/0xe0
[rc_core]
Jul 14 11:19:38 kepler *pde = 00000000
Jul 14 11:19:38 kepler
Jul 14 11:19:38 kepler Oops: 0000 [#1]
Jul 14 11:19:38 kepler PREEMPT
Jul 14 11:19:38 kepler
Jul 14 11:19:38 kepler Modules linked in:
Jul 14 11:19:38 kepler imon(+)
Jul 14 11:19:38 kepler rc_imon_pad
Jul 14 11:19:38 kepler rc_imon_mce
Jul 14 11:19:38 kepler netconsole
Jul 14 11:19:38 kepler asb100
Jul 14 11:19:38 kepler hwmon_vid
Jul 14 11:19:38 kepler cx22702
Jul 14 11:19:38 kepler dvb_pll
Jul 14 11:19:38 kepler mt352
Jul 14 11:19:38 kepler cx88_dvb
Jul 14 11:19:38 kepler cx88_vp3054_i2c
Jul 14 11:19:38 kepler videobuf_dvb
Jul 14 11:19:38 kepler snd_via82xx
Jul 14 11:19:38 kepler snd_ac97_codec
Jul 14 11:19:38 kepler cx8800
Jul 14 11:19:38 kepler cx8802
Jul 14 11:19:38 kepler cx88xx
Jul 14 11:19:38 kepler ac97_bus
Jul 14 11:19:38 kepler snd_mpu401_uart
Jul 14 11:19:38 kepler snd_rawmidi
Jul 14 11:19:38 kepler b44
Jul 14 11:19:38 kepler ssb
Jul 14 11:19:38 kepler rc_core
Jul 14 11:19:38 kepler i2c_algo_bit
Jul 14 11:19:38 kepler mii
Jul 14 11:19:38 kepler tveeprom
Jul 14 11:19:38 kepler btcx_risc
Jul 14 11:19:38 kepler i2c_viapro
Jul 14 11:19:38 kepler videobuf_dma_sg
Jul 14 11:19:38 kepler videobuf_core
Jul 14 11:19:38 kepler [last unloaded: ir_nec_decoder]
Jul 14 11:19:38 kepler
Jul 14 11:19:38 kepler
Jul 14 11:19:38 kepler Pid: 2885, comm: modprobe Not tainted 3.0.0-rc7 #1
Jul 14 11:19:38 kepler System Manufacturer System Name
Jul 14 11:19:38 kepler /A7V8X
Jul 14 11:19:38 kepler
Jul 14 11:19:38 kepler EIP: 0060:[<f8f1949e>] EFLAGS: 00010002 CPU: 0
Jul 14 11:19:38 kepler EIP is at rc_g_keycode_from_table+0x1e/0xe0 [rc_core]
Jul 14 11:19:38 kepler EAX: 00000000 EBX: f5610800 ECX: 00000008 EDX:
00000000
Jul 14 11:19:38 kepler ESI: 00000000 EDI: 00000000 EBP: f7009e48 ESP:
f7009e18
Jul 14 11:19:38 kepler DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Jul 14 11:19:38 kepler Process modprobe (pid: 2885, ti=f7008000
task=f708ada0 task.ti=f5706000)
Jul 14 11:19:38 kepler Stack:
Jul 14 11:19:38 kepler f71cc8c0
Jul 14 11:19:38 kepler 00000082
Jul 14 11:19:38 kepler 00000002
Jul 14 11:19:38 kepler f7009e2c
Jul 14 11:19:38 kepler c101eabb
Jul 14 11:19:38 kepler f71cc8c0
Jul 14 11:19:38 kepler 00000000
Jul 14 11:19:38 kepler 00000086
Jul 14 11:19:38 kepler
Jul 14 11:19:38 kepler 00000086
Jul 14 11:19:38 kepler f5610800
Jul 14 11:19:38 kepler 00000000
Jul 14 11:19:38 kepler 00000000
Jul 14 11:19:38 kepler f7009e58
Jul 14 11:19:38 kepler f87be59c
Jul 14 11:19:38 kepler f5610800
Jul 14 11:19:38 kepler f5610841
Jul 14 11:19:38 kepler
Jul 14 11:19:38 kepler f7009edc
Jul 14 11:19:38 kepler f87be6dc
Jul 14 11:19:38 kepler f68c00a4
Jul 14 11:19:38 kepler f7009e6c
Jul 14 11:19:38 kepler f68c5760
Jul 14 11:19:38 kepler f7009e74
Jul 14 11:19:38 kepler f68c00a4
Jul 14 11:19:38 kepler f7009e98
Jul 14 11:19:38 kepler
Jul 14 11:19:38 kepler Call Trace:
Jul 14 11:19:38 kepler [<c101eabb>] ? T.886+0x1b/0x30
Jul 14 11:19:38 kepler [<f87be59c>] imon_remote_key_lookup+0x1c/0x70 [imon]
Jul 14 11:19:38 kepler [<f87be6dc>] imon_incoming_packet+0x5c/0xe20 [imon]
Jul 14 11:19:38 kepler [<c1259cc8>] ? atapi_qc_complete+0x58/0x2b0
Jul 14 11:19:38 kepler [<c1251d23>] ? __ata_qc_complete+0x73/0x110
Jul 14 11:19:38 kepler [<f87bf573>] usb_rx_callback_intf0+0x63/0x70 [imon]
Jul 14 11:19:38 kepler [<c1275848>] usb_hcd_giveback_urb+0x48/0xb0
Jul 14 11:19:38 kepler [<c128d29e>] uhci_giveback_urb+0x8e/0x220
Jul 14 11:19:38 kepler [<c128d896>] uhci_scan_schedule+0x366/0x9e0
Jul 14 11:19:38 kepler [<c12900e1>] uhci_irq+0x91/0x170
Jul 14 11:19:38 kepler [<c1274961>] usb_hcd_irq+0x21/0x50
Jul 14 11:19:38 kepler [<c1052a36>] handle_irq_event_percpu+0x36/0x140
Jul 14 11:19:38 kepler [<c1016570>] ? __io_apic_modify_irq+0x80/0x90
Jul 14 11:19:38 kepler [<c10548c0>] ? handle_edge_irq+0x100/0x100
Jul 14 11:19:38 kepler [<c1052b72>] handle_irq_event+0x32/0x60
Jul 14 11:19:38 kepler [<c1054905>] handle_fasteoi_irq+0x45/0xc0
Jul 14 11:19:38 kepler <IRQ>
Jul 14 11:19:38 kepler
Jul 14 11:19:38 kepler [<c1003c8a>] ? do_IRQ+0x3a/0xb0
Jul 14 11:19:38 kepler [<c1065c93>] ? zone_watermark_ok+0x23/0x30
Jul 14 11:19:38 kepler [<c13ddf29>] ? common_interrupt+0x29/0x30
Jul 14 11:19:38 kepler [<c11b3d3e>] ? mmx_clear_page+0x7e/0x120
Jul 14 11:19:38 kepler [<c1068222>] ? get_page_from_freelist+0x1f2/0x480
Jul 14 11:19:38 kepler [<c12206d3>] ? extract_buf+0x83/0xd0
Jul 14 11:19:38 kepler [<c1068585>] ? __alloc_pages_nodemask+0xd5/0x5a0
Jul 14 11:19:38 kepler [<c10802f5>] ? anon_vma_prepare+0xc5/0x150
Jul 14 11:19:38 kepler [<c10782f0>] ? handle_pte_fault+0x440/0x590
Jul 14 11:19:38 kepler [<c10b0a9d>] ? __find_get_block+0xad/0x1c0
Jul 14 11:19:38 kepler [<c10787d4>] ? handle_mm_fault+0x74/0xb0
Jul 14 11:19:38 kepler [<c10194a0>] ? mm_fault_error+0x130/0x130
Jul 14 11:19:38 kepler [<c101959a>] ? do_page_fault+0xfa/0x3c0
Jul 14 11:19:38 kepler [<c1065c93>] ? zone_watermark_ok+0x23/0x30
Jul 14 11:19:38 kepler [<c10e8d35>] ? ext3fs_dirhash+0x115/0x240
Jul 14 11:19:38 kepler [<c10e8ae0>] ? ext3_follow_link+0x20/0x20
Jul 14 11:19:38 kepler [<c10194a0>] ? mm_fault_error+0x130/0x130
Jul 14 11:19:38 kepler [<c13dd7c4>] ? error_code+0x58/0x60
Jul 14 11:19:38 kepler [<c10194a0>] ? mm_fault_error+0x130/0x130
Jul 14 11:19:38 kepler [<c1061f95>] ? file_read_actor+0x25/0xe0
Jul 14 11:19:38 kepler [<c10623dc>] ? find_get_page+0x5c/0xa0
Jul 14 11:19:38 kepler [<c106423e>] ? generic_file_aio_read+0x2be/0x720
Jul 14 11:19:38 kepler [<c10a54d3>] ? mntput+0x13/0x30
Jul 14 11:19:38 kepler [<c108af0c>] ? do_sync_read+0x9c/0xd0
Jul 14 11:19:38 kepler [<c108afa3>] ? rw_verify_area+0x63/0x110
Jul 14 11:19:38 kepler [<c108ba87>] ? vfs_read+0x97/0x140
Jul 14 11:19:38 kepler [<c108ae70>] ? do_sync_write+0xd0/0xd0
Jul 14 11:19:38 kepler [<c108bbed>] ? sys_read+0x3d/0x70
Jul 14 11:19:38 kepler [<c13dda10>] ? sysenter_do_call+0x12/0x26
Jul 14 11:19:38 kepler Code:
Jul 14 11:19:38 kepler 8d
Jul 14 11:19:38 kepler b6
Jul 14 11:19:38 kepler 00
Jul 14 11:19:38 kepler 00
Jul 14 11:19:38 kepler 00
Jul 14 11:19:38 kepler 00
Jul 14 11:19:38 kepler 8d
Jul 14 11:19:38 kepler bc
Jul 14 11:19:38 kepler 27
Jul 14 11:19:38 kepler 00
Jul 14 11:19:38 kepler 00
Jul 14 11:19:38 kepler 00
Jul 14 11:19:38 kepler 00
Jul 14 11:19:38 kepler 55
Jul 14 11:19:38 kepler 89
Jul 14 11:19:38 kepler e5
Jul 14 11:19:38 kepler 57
Jul 14 11:19:38 kepler 56
Jul 14 11:19:38 kepler 53
Jul 14 11:19:38 kepler 83
Jul 14 11:19:38 kepler ec
Jul 14 11:19:38 kepler 24
Jul 14 11:19:38 kepler 89
Jul 14 11:19:38 kepler 45
Jul 14 11:19:38 kepler e8
Jul 14 11:19:38 kepler 9c
Jul 14 11:19:38 kepler 8f
Jul 14 11:19:38 kepler 45
Jul 14 11:19:38 kepler ec
Jul 14 11:19:38 kepler fa
Jul 14 11:19:38 kepler 89
Jul 14 11:19:38 kepler e0
Jul 14 11:19:38 kepler 25
Jul 14 11:19:38 kepler 00
Jul 14 11:19:38 kepler e0
Jul 14 11:19:38 kepler ff
Jul 14 11:19:38 kepler ff
Jul 14 11:19:38 kepler ff
Jul 14 11:19:38 kepler 40
Jul 14 11:19:38 kepler 14
Jul 14 11:19:38 kepler 8b
Jul 14 11:19:38 kepler 45
Jul 14 11:19:38 kepler e8
Jul 14 11:19:38 kepler syslog-ng[1931]: Error processing log message: <8b>
Jul 14 11:19:38 kepler 80
Jul 14 11:19:38 kepler dc
Jul 14 11:19:38 kepler 00
Jul 14 11:19:38 kepler 00
Jul 14 11:19:38 kepler 00
Jul 14 11:19:38 kepler 89
Jul 14 11:19:38 kepler c3
Jul 14 11:19:38 kepler 89
Jul 14 11:19:38 kepler 45
Jul 14 11:19:38 kepler f0
Jul 14 11:19:38 kepler 4b
Jul 14 11:19:38 kepler 78
Jul 14 11:19:38 kepler 38
Jul 14 11:19:38 kepler 8b
Jul 14 11:19:38 kepler 45
Jul 14 11:19:38 kepler e8
Jul 14 11:19:38 kepler 31
Jul 14 11:19:38 kepler c9
Jul 14 11:19:38 kepler 8b
Jul 14 11:19:38 kepler b0
Jul 14 11:19:38 kepler
Jul 14 11:19:38 kepler EIP: [<f8f1949e>]
Jul 14 11:19:38 kepler rc_g_keycode_from_table+0x1e/0xe0 [rc_core]
Jul 14 11:19:38 kepler SS:ESP 0068:f7009e18
Jul 14 11:19:38 kepler CR2: 00000000000000dc
Jul 14 11:19:38 kepler ---[ end trace 7467312b172b0d0f ]---
Jul 14 11:19:38 kepler Kernel panic - not syncing: Fatal exception in
interrupt
Jul 14 11:19:38 kepler Pid: 2885, comm: modprobe Tainted: G      D
3.0.0-rc7 #1
Jul 14 11:19:38 kepler Call Trace:
Jul 14 11:19:38 kepler [<c13db3a7>] panic+0x61/0x145
Jul 14 11:19:38 kepler [<c1004f30>] oops_end+0x80/0x80
Jul 14 11:19:38 kepler [<c101910e>] no_context+0xbe/0x150
Jul 14 11:19:38 kepler [<c101922f>] __bad_area_nosemaphore+0x8f/0x130
Jul 14 11:19:38 kepler [<c10194a0>] ? mm_fault_error+0x130/0x130
Jul 14 11:19:38 kepler [<c10192e2>] bad_area_nosemaphore+0x12/0x20
Jul 14 11:19:38 kepler [<c1019709>] do_page_fault+0x269/0x3c0
Jul 14 11:19:38 kepler [<c1040d85>] ? T.314+0x15/0x1b0
Jul 14 11:19:38 kepler [<c10194a0>] ? mm_fault_error+0x130/0x130
Jul 14 11:19:38 kepler [<c13dd7c4>] error_code+0x58/0x60
Jul 14 11:19:38 kepler [<c10194a0>] ? mm_fault_error+0x130/0x130
Jul 14 11:19:38 kepler [<f8f1949e>] ? rc_g_keycode_from_table+0x1e/0xe0
[rc_core]
Jul 14 11:19:38 kepler [<c101eabb>] ? T.886+0x1b/0x30
Jul 14 11:19:38 kepler [<f87be59c>] imon_remote_key_lookup+0x1c/0x70 [imon]
Jul 14 11:19:38 kepler [<f87be6dc>] imon_incoming_packet+0x5c/0xe20 [imon]
Jul 14 11:19:38 kepler [<c1259cc8>] ? atapi_qc_complete+0x58/0x2b0
Jul 14 11:19:38 kepler [<c1251d23>] ? __ata_qc_complete+0x73/0x110
Jul 14 11:19:38 kepler [<f87bf573>] usb_rx_callback_intf0+0x63/0x70 [imon]
Jul 14 11:19:38 kepler [<c1275848>] usb_hcd_giveback_urb+0x48/0xb0
Jul 14 11:19:38 kepler [<c128d29e>] uhci_giveback_urb+0x8e/0x220
Jul 14 11:19:38 kepler [<c128d896>] uhci_scan_schedule+0x366/0x9e0
Jul 14 11:19:38 kepler [<c12900e1>] uhci_irq+0x91/0x170
Jul 14 11:19:38 kepler [<c1274961>] usb_hcd_irq+0x21/0x50
Jul 14 11:19:38 kepler [<c1052a36>] handle_irq_event_percpu+0x36/0x140
Jul 14 11:19:38 kepler [<c1016570>] ? __io_apic_modify_irq+0x80/0x90
Jul 14 11:19:38 kepler [<c10548c0>] ? handle_edge_irq+0x100/0x100
Jul 14 11:19:38 kepler [<c1052b72>] handle_irq_event+0x32/0x60
Jul 14 11:19:38 kepler [<c1054905>] handle_fasteoi_irq+0x45/0xc0
Jul 14 11:19:38 kepler <IRQ>
Jul 14 11:19:38 kepler [<c1003c8a>] ? do_IRQ+0x3a/0xb0
Jul 14 11:19:38 kepler [<c1065c93>] ? zone_watermark_ok+0x23/0x30
Jul 14 11:19:38 kepler [<c13ddf29>] ? common_interrupt+0x29/0x30
Jul 14 11:19:38 kepler [<c11b3d3e>] ? mmx_clear_page+0x7e/0x120
Jul 14 11:19:38 kepler [<c1068222>] ? get_page_from_freelist+0x1f2/0x480
Jul 14 11:19:38 kepler [<c12206d3>] ? extract_buf+0x83/0xd0
Jul 14 11:19:38 kepler [<c1068585>] ? __alloc_pages_nodemask+0xd5/0x5a0
Jul 14 11:19:38 kepler [<c10802f5>] ? anon_vma_prep
Jul 14 11:19:38 kepler are+0xc5/0x150
Jul 14 11:19:38 kepler [<c10782f0>] ? handle_pte_fault+0x440/0x590
Jul 14 11:19:38 kepler [<c10b0a9d>] ? __find_get_block+0xad/0x1c0
Jul 14 11:19:38 kepler [<c10787d4>] ? handle_mm_fault+0x74/0xb0
Jul 14 11:19:38 kepler [<c10194a0>] ? mm_fault_error+0x130/0x130
Jul 14 11:19:38 kepler [<c101959a>] ? do_page_fault+0xfa/0x3c0
Jul 14 11:19:38 kepler [<c1065c93>] ? zone_watermark_ok+0x23/0x30
Jul 14 11:19:38 kepler [<c10e8d35>] ? ext3fs_dirhash+0x115/0x240
Jul 14 11:19:38 kepler [<c10e8ae0>] ? ext3_follow_link+0x20/0x20
Jul 14 11:19:38 kepler [<c10194a0>] ? mm_fault_error+0x130/0x130
Jul 14 11:19:38 kepler [<c13dd7c4>] ? error_code+0x58/0x60
Jul 14 11:19:38 kepler [<c10194a0>] ? mm_fault_error+0x130/0x130
Jul 14 11:19:38 kepler [<c1061f95>] ? file_read_actor+0x25/0xe0
Jul 14 11:19:38 kepler [<c10623dc>] ? find_get_page+0x5c/0xa0
Jul 14 11:19:38 kepler [<c106423e>] ? generic_file_aio_read+0x2be/0x720
Jul 14 11:19:38 kepler [<c10a54d3>] ? mntput+0x13/0x30
Jul 14 11:19:38 kepler [<c108af0c>] ? do_sync_read+0x9c/0xd0
Jul 14 11:19:38 kepler [<c108afa3>] ? rw_verify_area+0x63/0x110
Jul 14 11:19:38 kepler [<c108ba87>] ? vfs_read+0x97/0x140
Jul 14 11:19:38 kepler [<c108ae70>] ? do_sync_write+0xd0/0xd0
Jul 14 11:19:38 kepler [<c108bbed>] ? sys_read+0x3d/0x70
Jul 14 11:19:38 kepler [<c13dda10>] ? sysenter_do_call+0x12/0x26

-- 
Chris Williams
Brisbane, Australia
