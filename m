Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab2DMIPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 04:15:47 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:59593 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643Ab2DMIPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:15:44 -0400
X-ASG-Debug-ID: 1334304942-03d6a54a8017ca50001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4F87E0A9.4040608@fusionio.com>
Date: Fri, 13 Apr 2012 10:15:37 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block driver bits for 3.4
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] block driver bits for 3.4
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1334304942
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0017 1.0000 -2.0097
X-Barracuda-Spam-Score: -2.01
X-Barracuda-Spam-Status: No, SCORE=-2.01 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.93982
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On top of the core bits, but this time nothing in the drivers
branch depends on any core changes.

- A series of fixes for mtip32xx. Most from Asai at Micron, but also one
  from Greg, getting rid of the dependency on PCIE_HOTPLUG.

- A few bug fixes for xen-blkfront, and blkback.

- A virtio-blk fix for Vivek, making resize actually work.

- Two fixes from Stephen, making larger transfers possible on cciss.
  This is needed for tape drive support.

Please pull.

  git://git.kernel.dk/linux-block.git for-3.4/drivers

Akinobu Mita (1):
      xen-blkfront: use bitmap_set() and bitmap_clear()

Andrew Jones (1):
      xen/blkfront: don't put bdev right after getting it

Asai Thambi S P (8):
      mtip32xx: fix incorrect value set for drv_cleanup_done, and re-initialize and start port in mtip_restart_port()
      mtip32xx: Add new bitwise flag 'dd_flag'
      mtip32xx: make setting comp_time as common
      mtip32xx: Add new sysfs entry 'status'
      mtip32xx: misc changes
      mtip32xx: Shorten macro names
      mtip32xx: fix handling of commands in various scenarios
      mtip32xx: dump tagmap on failure

Daniel De Graaf (2):
      xen/blkback: use grant-table.c hypercall wrappers
      xen/blkback: Enable blkback on HVM guests

Greg Kroah-Hartman (1):
      block: mtip32xx: remove HOTPLUG_PCI_PCIE dependancy

Jens Axboe (1):
      Merge branch 'stable/for-jens-3.4-bugfixes' of git://git.kernel.org/.../konrad/xen into for-3.4/drivers

Konrad Rzeszutek Wilk (2):
      xen/blkback: Squash the discard support for 'file' and 'phy' type.
      xen/blkback: Make optional features be really optional.

Ryosuke Saito (1):
      mtip32xx: fix error handling in mtip_init()

Stephen M. Cameron (2):
      cciss: Initialize scsi host max_sectors for tape drive support
      cciss: Fix scsi tape io with more than 255 scatter gather elements

Steven Noonan (1):
      xen-blkfront: make blkif_io_lock spinlock per-device

Vivek Goyal (1):
      virtio-blk: Call revalidate_disk() upon online disk resize

 Documentation/ABI/testing/sysfs-block-rssd |   18 +
 drivers/block/cciss_scsi.c                 |    3 +-
 drivers/block/mtip32xx/Kconfig             |    2 +-
 drivers/block/mtip32xx/mtip32xx.c          |  860 +++++++++++++++++++++-------
 drivers/block/mtip32xx/mtip32xx.h          |   58 +-
 drivers/block/virtio_blk.c                 |    1 +
 drivers/block/xen-blkback/blkback.c        |   50 +-
 drivers/block/xen-blkback/common.h         |    6 -
 drivers/block/xen-blkback/xenbus.c         |   89 ++-
 drivers/block/xen-blkfront.c               |   41 +-
 10 files changed, 796 insertions(+), 332 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-block-rssd

-- 
Jens Axboe

