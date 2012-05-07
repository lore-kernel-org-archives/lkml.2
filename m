Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab2EGO5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:57:48 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42297 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756467Ab2EGO5q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:57:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120507135238.GC361@phenom.dumpdata.com>
References: <20120507135238.GC361@phenom.dumpdata.com>
Date: Mon, 7 May 2012 22:57:46 +0800
X-Google-Sender-Auth: nBoHkctfEBMt3cNahS83JpyqcV8
Message-ID: <CAF1ivSZNH3R-U=d=yBW4m9PO8TQSbSP=dHR3okdsO7EkOm2RMQ@mail.gmail.com>
Subject: Re: Regression introduced by 6f381fa344911d5a234b13574433cf23036f9467
 [[SCSI] scsi_lib: use correct DMA device in __scsi_alloc_queue]
From: Lin Ming <ming.m.lin@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: JBottomley@parallels.com, joerg@alea.gnuu.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 9:52 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> Hey James,
>
> I am using iSCSI and I keep on getting this:
>
> scsi4 : iSCSI Initiator over TCP/IP
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000118
> IP: [<ffffffffa0056da1>] __scsi_alloc_queue+0xa1/0x190 [scsi_mod]
> PGD 226cfb067 PUD 229300067 PMD 0
> Oops: 0000 [#1] SMP
> CPU 3
> Modules linked in: dm_multipath dm_mod iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi libcrc32c crc32c nouveau mxm_wmi wmi radeon ttm sg sr_mod sd_mod cdrom ata_generic ata_piix libata fbcon i915 tileblit font bitblit softcursor atl1c drm_kms_helper scsi_mod crc32c_intel e1000e video acpi_cpufreq mperf [last unloaded: dump_dma]
>
> Pid: 3065, comm: iscsid Tainted: G           O 3.4.0-rc6upstream-00007-gf4f77c4 #1 MSI MS-7680/H61M-P23 (MS-7680)
> RIP: 0010:[<ffffffffa0056da1>]  [<ffffffffa0056da1>] __scsi_alloc_queue+0xa1/0x190 [scsi_mod]
> RSP: 0018:ffff88022e92fa78  EFLAGS: 00010296
> RAX: 000000000023fe00 RBX: ffff88022748f800 RCX: 0000000000000010
> RDX: 0000000000000067 RSI: 00000000ffffffff RDI: ffff8802292ca078
> RBP: ffff88022e92fa98 R08: 0000000000000000 R09: 0000000000000008
> R10: ffff8802292b5000 R11: 0000000000000001 R12: 0000000000000000
> R13: ffff8802292ca078 R14: ffff880229094828 R15: 0000000000000000
> FS:  00007ffb5eea6700(0000) GS:ffff88023fb80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000118 CR3: 000000022924e000 CR4: 00000000000407e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process iscsid (pid: 3065, threadinfo ffff88022e92e000, task ffff88022736d820)
> Stack:
>  ffff88022e92fb78 ffff88022f182000 ffff880229094800 ffff88022748f800
>  ffff88022e92fab8 ffffffffa0056ea8 ffff88022e92fab8 ffff88022f182000
>  ffff88022e92fb08 ffffffffa0058faf 0000000000000282 0000000000000000
> Call Trace:
>  [<ffffffffa0056ea8>] scsi_alloc_queue+0x18/0x70 [scsi_mod]
>  [<ffffffffa0058faf>] scsi_alloc_sdev+0x19f/0x280 [scsi_mod]
>  [<ffffffffa0059508>] scsi_probe_and_add_lun+0x478/0xd50 [scsi_mod]
>
> reverting above mentioned git commit fixes the issue.

Does Jame's below patch help?

http://www.spinics.net/lists/linux-scsi/msg59106.html
