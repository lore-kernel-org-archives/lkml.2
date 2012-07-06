Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab2GFP2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:28:18 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60842 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab2GFP2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:28:16 -0400
MIME-Version: 1.0
In-Reply-To: <20120704143339.513439b4@pixies.home.jungo.com>
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
 <4FF4005E.1070106@nod.at> <20120704143339.513439b4@pixies.home.jungo.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Fri, 6 Jul 2012 17:27:59 +0200
Message-ID: <CACQ1gAhm-EsNPpDW26NSf-LJnxvJf0Y+tOnR9ZKPYdT_adPp7g@mail.gmail.com>
Subject: Re: [PATCH 0/5] ubi: Fix bad PEBs reserve caclulation
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: Richard Weinberger <richard@nod.at>,
        Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got an oops...
this is my dev-kernel in 3.5-rc5 + some work to be able to boot on my board
NB: If I use ubi_format it's ok.
the mtd1 device has 1984 PEB
the 4 last are UBI reserved + BBT

I didn't test without your patch, but anyway something is wrong there.

# flash_erase /dev/mtd1 0 1980
Erasing 128 Kibyte @ f760000 -- 100 % complete
# ubiattach /dev/ubi_ctrl -m1
[   35.671875] UBI: attaching mtd1 to ubi0
[   35.671875] UBI DBG (pid 419): ubi_attach_mtd_dev: sizeof(struct
ubi_ainf_peb) 48
[   35.679687] UBI DBG (pid 419): ubi_attach_mtd_dev: sizeof(struct
ubi_wl_entry) 20
[   35.687500] UBI DBG (pid 419): io_init: min_io_size      2048
[   35.695312] UBI DBG (pid 419): io_init: max_write_size   2048
[   35.703125] UBI DBG (pid 419): io_init: hdrs_min_io_size 2048
[   35.703125] UBI DBG (pid 419): io_init: ec_hdr_alsize    2048
[   35.710937] UBI DBG (pid 419): io_init: vid_hdr_alsize   2048
[   35.718750] UBI DBG (pid 419): io_init: vid_hdr_offset   2048
[   35.718750] UBI DBG (pid 419): io_init: vid_hdr_aloffset 2048
[   35.726562] UBI DBG (pid 419): io_init: vid_hdr_shift    0
[   35.734375] UBI DBG (pid 419): io_init: leb_start        4096
[   35.742187] UBI DBG (pid 419): io_init: max_erroneous    198
[   35.742187] UBI: physical eraseblock size:   131072 bytes (128 KiB)
[   35.750000] UBI: logical eraseblock size:    126976 bytes
[   35.757812] UBI: smallest flash I/O unit:    2048
[   35.757812] UBI: VID header offset:          2048 (aligned 2048)
[   35.765625] UBI: data offset:                4096
[   36.210937] UBI DBG (pid 419): scan_all: scanning is finished
[   36.218750] UBI: empty MTD device detected
[   36.226562] UBI: max. sequence number:       0
[   36.226562] UBI: create volume table (copy #1)
[   36.242187] UBI: create volume table (copy #2)
[   36.257812] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[   36.265625] pgd = c7520000
[   36.265625] [00000000] *pgd=27bb7831, *pte=00000000, *ppte=00000000
[   36.273437] Internal error: Oops: 17 [#1] ARM
[   36.273437] CPU: 0    Not tainted  (3.5.0-rc5+ #14)
[   36.273437] PC is at ubi_wl_init+0x138/0x36c
[   36.273437] LR is at schedule_erase+0x50/0x64
[   36.273437] pc : [<c0195a7c>]    lr : [<c0194388>]    psr: 60000013
[   36.273437] sp : c7501ee8  ip : 00008000  fp : 00000000
[   36.273437] r10: c753fef8  r9 : c0361364  r8 : ffffffe0
[   36.273437] r7 : c7537020  r6 : c7537034  r5 : c7538280  r4 : c7bd3540
[   36.273437] r3 : 00000000  r2 : c7bd3938  r1 : c75382c0  r0 : 00000000
[   36.273437] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   36.273437] Control: 0005317f  Table: 27520000  DAC: 00000015
[   36.273437] Process ubiattach (pid: 419, stack limit = 0xc7500270)
[   36.273437] Stack: (0xc7501ee8 to 0xc7502000)
[   36.273437] 1ee0:                   00000000 c7537020 c7bd3540
c7537020 c7bd3540 00000000
[   36.273437] 1f00: c757caa0 c0009388 c7500000 00000000 00000000
c019800c c7bd3540 00000000
[   36.273437] 1f20: 00000000 c018d79c c757caa0 00000000 becdaaf8
c757caa0 40186f40 00000003
[   36.273437] 1f40: c0009388 c018dccc ffffffff 00000001 00000000
00000000 00000000 00000000
[   36.273437] 1f60: becdaaf8 00000003 40186f40 c0076890 c7ba4dc0
00000003 40186f40 c7ba4dc0
[   36.273437] 1f80: becdaaf8 c0076900 00000003 00000000 becdaaf8
becdaaf8 40186f40 00000003
[   36.273437] 1fa0: 00000036 c00091e0 becdaaf8 40186f40 00000003
40186f40 becdaaf8 00000000
[   36.273437] 1fc0: becdaaf8 40186f40 00000003 00000036 00000002
becdadb4 00000001 00000000
[   36.273437] 1fe0: b6f39ec4 becdaab0 000098c8 b6f39f08 60000010
00000003 00000000 00000000
[   36.273437] [<c0195a7c>] (ubi_wl_init+0x138/0x36c) from
[<c019800c>] (ubi_attach+0x74/0xbc)
[   36.273437] [<c019800c>] (ubi_attach+0x74/0xbc) from [<c018d79c>]
(ubi_attach_mtd_dev+0x1dc/0x4bc)
[   36.273437] [<c018d79c>] (ubi_attach_mtd_dev+0x1dc/0x4bc) from
[<c018dccc>] (ctrl_cdev_ioctl+0xd4/0x164)
[   36.273437] [<c018dccc>] (ctrl_cdev_ioctl+0xd4/0x164) from
[<c0076890>] (do_vfs_ioctl+0x270/0x2ac)
[   36.273437] [<c0076890>] (do_vfs_ioctl+0x270/0x2ac) from
[<c0076900>] (sys_ioctl+0x34/0x54)
[   36.273437] [<c0076900>] (sys_ioctl+0x34/0x54) from [<c00091e0>]
(ret_fast_syscall+0x0/0x2c)
[   36.273437] Code: e1a01005 e5930000 ebfb44ff ea000074 (e5983020)
[   36.281250] ---[ end trace f540180ccfcbf7f6 ]---
Segmentation fault





2012/7/4 Shmulik Ladkani <shmulik.ladkani@gmail.com>:
> On Wed, 04 Jul 2012 10:35:42 +0200 Richard Weinberger <richard@nod.at> wrote:
>> Has this patch set an impact on UBI fastmap?
>
> Not sure yet. Maybe. Need to medidate on this :-)
>
>> ...wondering why I'm CC'd. :-)
>
> Heads-up.
> As this is a bit delicate, you may review if the parts modified relate
> to your fastmap work.
>
> Regards,
> Shmulik



-- 
for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?
