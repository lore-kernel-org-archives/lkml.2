Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab2HNPMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:12:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55758 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200Ab2HNPF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:05:59 -0400
Date: Tue, 14 Aug 2012 17:05:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: wei_wang@realsil.com.cn
Cc: gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        cjb@laptop.org, arnd@arndb.de, sameo@linux.intel.com
Subject: Re: [PATCH v2 0/2] Add modules to support realtek PCIE card reader
Message-ID: <20120814150550.GA4091@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, wei_wang@realsil.com.cn,
	gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
	cjb@laptop.org, arnd@arndb.de, sameo@linux.intel.com
References: <cover.1344939464.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1344939464.git.wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 06:40:36PM +0800, wei_wang@realsil.com.cn wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> Support for Realtek PCI-Express driver-based card readers including rts5209 and rts5229.
> 
> Wei WANG (2):
>   drivers/mfd: Add realtek pcie card reader driver
>   drivers/mmc: Add realtek pcie sdmmc host driver
> 
>  drivers/mfd/Kconfig               |    9 +
>  drivers/mfd/Makefile              |    4 +
>  drivers/mfd/rts5209.c             |  102 +++
>  drivers/mfd/rts5229.c             |  117 +++
>  drivers/mfd/rtsx_pcr.c            | 1464 +++++++++++++++++++++++++++++++++++++
>  drivers/mfd/rtsx_pcr.h            |   31 +
>  drivers/mmc/host/Kconfig          |    7 +
>  drivers/mmc/host/Makefile         |    2 +
>  drivers/mmc/host/rtsx_pci_sdmmc.c | 1348 ++++++++++++++++++++++++++++++++++
>  include/linux/mfd/rtsx_common.h   |   47 ++
>  include/linux/mfd/rtsx_pci.h      |  692 ++++++++++++++++++
>  11 files changed, 3823 insertions(+)
>  create mode 100644 drivers/mfd/rts5209.c
>  create mode 100644 drivers/mfd/rts5229.c
>  create mode 100644 drivers/mfd/rtsx_pcr.c
>  create mode 100644 drivers/mfd/rtsx_pcr.h
>  create mode 100644 drivers/mmc/host/rtsx_pci_sdmmc.c
>  create mode 100644 include/linux/mfd/rtsx_common.h
>  create mode 100644 include/linux/mfd/rtsx_pci.h

Yeah, this thing still has issues though.

When I slide in an SD card and do

$ mkfs.ext3 /dev/mmcblk0p1

after having created the partition with fdisk, we run out of DMA space and the
hung-tasks detector triggers:

...
[  286.244866] mmc0: new ultra high speed SDR50 SDHC card at address e624
[  286.277199] mmcblk0: mmc0:e624 SU16G 14.8 GiB 
[  286.318163]  mmcblk0:
[  363.754647]  mmcblk0: p1
[  379.545510] DMA: Out of SW-IOMMU space for 438272 bytes at device 0000:03:00.0
[  389.578514] DMA: Out of SW-IOMMU space for 380928 bytes at device 0000:03:00.0
[  399.590953] DMA: Out of SW-IOMMU space for 524288 bytes at device 0000:03:00.0
[  409.590698] DMA: Out of SW-IOMMU space for 380928 bytes at device 0000:03:00.0
[  419.589054] DMA: Out of SW-IOMMU space for 380928 bytes at device 0000:03:00.0
[  429.587710] DMA: Out of SW-IOMMU space for 380928 bytes at device 0000:03:00.0
[  439.586748] DMA: Out of SW-IOMMU space for 524288 bytes at device 0000:03:00.0
[  449.603357] DMA: Out of SW-IOMMU space for 516096 bytes at device 0000:03:00.0
[  459.602781] DMA: Out of SW-IOMMU space for 385024 bytes at device 0000:03:00.0
[  469.604105] DMA: Out of SW-IOMMU space for 524288 bytes at device 0000:03:00.0
[  479.602964] DMA: Out of SW-IOMMU space for 385024 bytes at device 0000:03:00.0
[  489.601303] DMA: Out of SW-IOMMU space for 524288 bytes at device 0000:03:00.0
[  499.599617] DMA: Out of SW-IOMMU space for 524288 bytes at device 0000:03:00.0
[  509.597943] DMA: Out of SW-IOMMU space for 524288 bytes at device 0000:03:00.0
[  519.596815] DMA: Out of SW-IOMMU space for 385024 bytes at device 0000:03:00.0
[  529.594130] DMA: Out of SW-IOMMU space for 389120 bytes at device 0000:03:00.0
[  539.593000] DMA: Out of SW-IOMMU space for 524288 bytes at device 0000:03:00.0
[  549.594701] DMA: Out of SW-IOMMU space for 471040 bytes at device 0000:03:00.0
[  559.594068] DMA: Out of SW-IOMMU space for 524288 bytes at device 0000:03:00.0
[  569.592643] DMA: Out of SW-IOMMU space for 389120 bytes at device 0000:03:00.0
[  579.589890] DMA: Out of SW-IOMMU space for 520192 bytes at device 0000:03:00.0
[  589.588743] DMA: Out of SW-IOMMU space for 393216 bytes at device 0000:03:00.0
[  599.587003] DMA: Out of SW-IOMMU space for 524288 bytes at device 0000:03:00.0
[  600.415530] INFO: task flush-179:0:3418 blocked for more than 120 seconds.
[  600.418439] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  600.421516] flush-179:0     D ffff880117c40050     0  3418      2 0x00000000
[  600.424578]  ffff88011578f650 0000000000000086 ffff88011578f5f0 ffffffff810a567d
[  600.426155]  ffff88011578ffd8 ffff880117e459a0 ffff88011578ffd8 ffff88011578ffd8
[  600.427705]  ffffffff81a13420 ffff880117e459a0 ffff88011578f620 ffff880117e459a0
[  600.430917] Call Trace:
[  600.432458]  [<ffffffff810a567d>] ? trace_hardirqs_on+0xd/0x10
[  600.434041]  [<ffffffff81495cc9>] schedule+0x29/0x70
[  600.435627]  [<ffffffff81495d9f>] io_schedule+0x8f/0xd0
[  600.437204]  [<ffffffff8121d35b>] get_request+0x15b/0x5e0
[  600.438766]  [<ffffffff81223ccf>] ? ioc_lookup_icq+0x9f/0xf0
[  600.440340]  [<ffffffff81070320>] ? __init_waitqueue_head+0x60/0x60
[  600.441904]  [<ffffffff81220b2d>] blk_queue_bio+0x7d/0x400
[  600.443486]  [<ffffffff8121edc2>] generic_make_request+0xc2/0x110
[  600.445057]  [<ffffffff8121fb65>] submit_bio+0x75/0x100
[  600.446616]  [<ffffffff8117f54a>] ? bio_alloc_bioset+0x5a/0x100
[  600.448191]  [<ffffffff811799d4>] submit_bh+0xf4/0x130
[  600.449748]  [<ffffffff8117c047>] __block_write_full_page+0x1f7/0x390
[  600.451299]  [<ffffffff8117c1e0>] ? __block_write_full_page+0x390/0x390
[  600.452837]  [<ffffffff81180d20>] ? blkdev_get_blocks+0xc0/0xc0
[  600.452840]  [<ffffffff81180d20>] ? blkdev_get_blocks+0xc0/0xc0
[  600.452845]  [<ffffffff8117ca5f>] block_write_full_page_endio+0x10f/0x130
[  600.452852]  [<ffffffff81104fba>] ? clear_page_dirty_for_io+0xba/0x100
[  600.452856]  [<ffffffff8117ca95>] block_write_full_page+0x15/0x20
[  600.452861]  [<ffffffff81180548>] blkdev_writepage+0x18/0x20
[  600.452865]  [<ffffffff81104aba>] __writepage+0x1a/0x50
[  600.452870]  [<ffffffff81105371>] write_cache_pages+0x241/0x490
[  600.452874]  [<ffffffff81104aa0>] ? mapping_tagged+0x20/0x20
[  600.452880]  [<ffffffff81105603>] generic_writepages+0x43/0x60
[  600.452884]  [<ffffffff81106e41>] do_writepages+0x21/0x50
[  600.452888]  [<ffffffff811728bb>] __writeback_single_inode.isra.32+0x3b/0x190
[  600.452893]  [<ffffffff8107fca9>] ? sub_preempt_count+0x79/0xd0
[  600.452897]  [<ffffffff81173695>] writeback_sb_inodes+0x345/0x4f0
[  600.452901]  [<ffffffff811738d7>] __writeback_inodes_wb+0x97/0xd0
[  600.452905]  [<ffffffff81173b1b>] wb_writeback+0x20b/0x340
[  600.452910]  [<ffffffff811743d5>] wb_do_writeback+0x205/0x260
[  600.452915]  [<ffffffff811744c3>] bdi_writeback_thread+0x93/0x2b0
[  600.452919]  [<ffffffff81174430>] ? wb_do_writeback+0x260/0x260
[  600.452923]  [<ffffffff8106fcaa>] kthread+0xea/0xf0
[  600.452930]  [<ffffffff814990a4>] kernel_thread_helper+0x4/0x10
[  600.452935]  [<ffffffff8107b355>] ? finish_task_switch+0x85/0x110
[  600.452939]  [<ffffffff8149728b>] ? _raw_spin_unlock_irq+0x3b/0x60
[  600.452943]  [<ffffffff8149769d>] ? retint_restore_args+0xe/0xe
[  600.452947]  [<ffffffff8106fbc0>] ? kthread_create_on_node+0x160/0x160
[  600.452951]  [<ffffffff814990a0>] ? gs_change+0xb/0xb
[  600.452978] 1 lock held by flush-179:0/3418:
[  600.452990]  #0:  (&type->s_umount_key#19){.+.+..}, at: [<ffffffff8114ce13>] grab_super_passive+0x43/0x90
[  600.452993] INFO: task mkfs.ext3:3438 blocked for more than 120 seconds.
[  600.452995] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  600.453000] mkfs.ext3       D ffff880117c40098     0  3438   3353 0x00000000
[  600.453005]  ffff880117e519b8 0000000000000082 ffff880117e51958 ffffffff810a567d
[  600.453010]  ffff880117e51fd8 ffff880117e42cd0 ffff880117e51fd8 ffff880117e51fd8
[  600.453015]  ffffffff81a13420 ffff880117e42cd0 ffff880117e51988 ffff880117e42cd0
[  600.453017] Call Trace:
[  600.453021]  [<ffffffff810a567d>] ? trace_hardirqs_on+0xd/0x10
[  600.453026]  [<ffffffff81495cc9>] schedule+0x29/0x70
[  600.453031]  [<ffffffff81495d9f>] io_schedule+0x8f/0xd0
[  600.453034]  [<ffffffff8121d35b>] get_request+0x15b/0x5e0
[  600.453039]  [<ffffffff81223ccf>] ? ioc_lookup_icq+0x9f/0xf0
[  600.453043]  [<ffffffff81070320>] ? __init_waitqueue_head+0x60/0x60
[  600.453047]  [<ffffffff81220b2d>] blk_queue_bio+0x7d/0x400
[  600.453052]  [<ffffffff8121edc2>] generic_make_request+0xc2/0x110
[  600.453055]  [<ffffffff8121fb65>] submit_bio+0x75/0x100
[  600.453060]  [<ffffffff8117f54a>] ? bio_alloc_bioset+0x5a/0x100
[  600.453064]  [<ffffffff811799d4>] submit_bh+0xf4/0x130
[  600.453068]  [<ffffffff8117c047>] __block_write_full_page+0x1f7/0x390
[  600.453073]  [<ffffffff8117c1e0>] ? __block_write_full_page+0x390/0x390
[  600.453076]  [<ffffffff81180d20>] ? blkdev_get_blocks+0xc0/0xc0
[  600.453080]  [<ffffffff81180d20>] ? blkdev_get_blocks+0xc0/0xc0
[  600.453084]  [<ffffffff8117ca5f>] block_write_full_page_endio+0x10f/0x130
[  600.453089]  [<ffffffff81104fba>] ? clear_page_dirty_for_io+0xba/0x100
[  600.453094]  [<ffffffff8117ca95>] block_write_full_page+0x15/0x20
[  600.453098]  [<ffffffff81180548>] blkdev_writepage+0x18/0x20
[  600.453102]  [<ffffffff81104aba>] __writepage+0x1a/0x50
[  600.453106]  [<ffffffff81105371>] write_cache_pages+0x241/0x490
[  600.453111]  [<ffffffff81104aa0>] ? mapping_tagged+0x20/0x20
[  600.453117]  [<ffffffff81105603>] generic_writepages+0x43/0x60
[  600.453121]  [<ffffffff81106e41>] do_writepages+0x21/0x50
[  600.453125]  [<ffffffff810fd6e1>] __filemap_fdatawrite_range+0x51/0x60
[  600.453129]  [<ffffffff810fd742>] filemap_write_and_wait_range+0x52/0x70
[  600.453133]  [<ffffffff81180744>] blkdev_fsync+0x24/0x50
[  600.453137]  [<ffffffff81178110>] do_fsync+0x50/0x80
[  600.453140]  [<ffffffff811783a0>] sys_fsync+0x10/0x20
[  600.453144]  [<ffffffff81497f92>] system_call_fastpath+0x16/0x1b
[  600.453147] no locks held by mkfs.ext3/3438.
[  609.585190] DMA: Out of SW-IOMMU space for 524288 bytes at device 0000:03:00.0

-- 
Regards/Gruss,
Boris.
