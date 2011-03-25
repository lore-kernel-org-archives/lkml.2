Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab1CYQIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:08:35 -0400
Received: from smtp.nokia.com ([147.243.1.48]:17087 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255Ab1CYQId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:08:33 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Date: Fri, 25 Mar 2011 18:10:06 +0200
Message-Id: <20110325161006.5639.95105.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] MTD changes for 2.6.39
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the MTD updates for 2.6.39. David Woodhouse is unable to take
care for the pull request right now for private reasons, so he asked
me do do this (I'm an active member of the MTD community).

The pull request contains one merge commit. The reason for this commit
is that the changes in the block tree broke the MTD tree compilation.
The block tree is already merged upstream. The MTD tree was published,
so re-basing it is not possible.

To fix the situation I did the following:
1. Pulled your tree to the mtd tree (for-linus-1 branch) with
   --no-commit option.
2. Applied the compilation fix on top (the patch is below).
3. And committed the result.

I've also put the description to the merge commit which explains these
reasons. Hopefully this is acceptable. Note, in the e-mail David dropped
me (you was in CC) he did tell me to "NOT push back the results of that
merge", but I did not really understand how could that work. Probably he
meant that I should send you the pull request which does not build plus
a separate build fix-up patch. If this is what you indeed expect, pleas,
let me know.

Most of the patches in the mtd tree are just small fixes and improvements.
But 2 things stand out:

1. The BCH ECC library which implements strong ECC codes which can
   correct 4-bits per 512-bit chunks. This is important for modern NAND
   flashes which become crappier and crappier and require stronger and
   stronger ECC.
2. The mtdswap driver which implements swap on top of raw flash.

Please, pull.


The following changes since commit d39dd11c3e6a7af5c20bfac40594db36cf270f42:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6 (2011-03-24 19:01:30 -0700)

are available in the git repository at:

  git://git.infradead.org/mtd-2.6.git for-linus-1

Adrian Hunter (2):
      mtd: OneNAND: return read error for 4KiB page read
      mtd: tests: add count parameter to mtd_speedtest

Anatolij Gustschin (1):
      mtd: cfi: fix writebufsize initialization

Artem Bityutskiy (3):
      mtd: mtdram: initialize writebufsize field
      mtd: mtdswap: fix compilation warning
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6 into for-linus-1

Baruch Siach (2):
      mtd: mxc_nand: fix read past buffer end
      mtd: mxc_nand: fix OOB corruption when page size > 2KiB

David Griego (1):
      mtd: NOR flash driver for OMAP-L137/AM17x

David Lambert (1):
      mtd: speedtest: fix integer overflow

David Woodhouse (1):
      mtd: fix printf format warnings, mostly lack of %zd for size_t, in mtdswap

Dmitry Eremin-Solenikov (5):
      mtd: make MTD_CONCAT support mandatory
      mtd: drop MTD_CONCAT dependencies from Kconfig
      mtd: drop CONFIG_MTD_CONCAT ifdefs
      CRIS: stop checking for MTD_CONCAT
      mtd: drop MTD_CONCAT from Kconfig entirely

Gabor Juhos (1):
      mtd: m25p80: add support for the EON EN25F32 chip

H Hartley Sweeten (2):
      mtd: local symbols should be static
      mtd: mtd_blkdevs: local symbols should be static

Holger Brunck (1):
      mtd: adapt writebufsize calculation for concat

Hong Xu (1):
      mtd: atmel_nand: Add DMA support to access Nandflash

Ivan Djelic (3):
      lib: add shared BCH ECC library
      mtd: nand: add software BCH ECC support
      mtd: nand: enable software BCH ECC in nand simulator

Jamie Iles (1):
      mtd: mpc5121_nfc: don't treat NULL clk as an error

Jarkko Lavinen (3):
      mtd_blkdevs: Add background processing support
      mtd_blkdevs: Set the maximum discards size
      mtd: Add mtdswap block driver

Jason Liu (1):
      mtd: nand: fix a typo in a commentary

John Ogness (1):
      mtd: omap3: nand: report corrected ecc errors

Julia Lawall (1):
      mtd: ts5500_flash: avoid calling map_destroy on NULL

Lei Wen (6):
      mtd: pxa3xx_nand: make scan procedure more clear
      mtd: pxa3xx_nand: rework irq logic
      mtd: pxa3xx_nand: discard wait_for_event,write_cmd,__readid function
      mtd: pxa3xx_nand: unify prepare command
      mtd: pxa3xx_nand: mtd scan id process could be defined by driver itself
      mtd: pxa3xx_nand: clean the keep configure code

Mathias Krause (1):
      mtd: phram: fix memory leak

Roman Tereshonkov (5):
      mtd: tests: print correct values
      mtd: onenand_base: onenand_verify bugfix for writepage non-aligned address
      mtd: tests: add multiblock erase test to the mtd_speedtest
      mtd: onenand: add new option to control initial onenand unlocking
      mtd: omap: add new variable to platform data to control onenand unlocking

Sandeep Paulraj (1):
      mtd: DaVinci: Removed header file that is not required

Stanislav Fomichev (1):
      mtd: nand: fix pointer NULL pointer dereferencing

Steffen Sledz (1):
      mtd: cfi: add support for AMIC flashes (e.g. A29L160AT)

Tracey Dent (1):
      jffs2: remove a trailing white space in commentaries

Xiaochen Wang (1):
      mtd: sm_rtl: check kmalloc return value

Yang Ruirui (1):
      mtdswap: kill strict error handling option

Yoshihiro Shimoda (1):
      mtd: m25p80: add support for M25PX64

 arch/arm/plat-omap/include/plat/onenand.h    |    1 +
 arch/arm/plat-pxa/include/plat/pxa3xx_nand.h |    2 +-
 arch/cris/Kconfig                            |    1 -
 arch/cris/arch-v10/drivers/axisflashmap.c    |    6 -
 arch/cris/arch-v32/drivers/Kconfig           |    1 -
 arch/cris/arch-v32/drivers/axisflashmap.c    |    6 -
 drivers/mtd/Kconfig                          |   18 +-
 drivers/mtd/Makefile                         |    4 +-
 drivers/mtd/chips/cfi_cmdset_0001.c          |    2 +-
 drivers/mtd/chips/cfi_cmdset_0002.c          |    3 +-
 drivers/mtd/chips/cfi_cmdset_0020.c          |    2 +-
 drivers/mtd/devices/m25p80.c                 |    5 +-
 drivers/mtd/devices/mtdram.c                 |    1 +
 drivers/mtd/devices/phram.c                  |    3 +
 drivers/mtd/maps/Kconfig                     |   13 +-
 drivers/mtd/maps/Makefile                    |    1 +
 drivers/mtd/maps/ceiva.c                     |    6 -
 drivers/mtd/maps/integrator-flash.c          |   10 -
 drivers/mtd/maps/latch-addr-flash.c          |  272 +++++
 drivers/mtd/maps/physmap.c                   |    8 -
 drivers/mtd/maps/physmap_of.c                |    8 -
 drivers/mtd/maps/sa1100-flash.c              |    8 -
 drivers/mtd/maps/ts5500_flash.c              |    1 -
 drivers/mtd/mtd_blkdevs.c                    |   42 +-
 drivers/mtd/mtdconcat.c                      |    8 +-
 drivers/mtd/mtdcore.c                        |    6 +-
 drivers/mtd/mtdswap.c                        | 1587 ++++++++++++++++++++++++++
 drivers/mtd/nand/Kconfig                     |   15 +
 drivers/mtd/nand/Makefile                    |    1 +
 drivers/mtd/nand/atmel_nand.c                |  166 +++-
 drivers/mtd/nand/davinci_nand.c              |    3 -
 drivers/mtd/nand/mpc5121_nfc.c               |    5 +-
 drivers/mtd/nand/mxc_nand.c                  |   31 +-
 drivers/mtd/nand/nand_base.c                 |   42 +-
 drivers/mtd/nand/nand_bbt.c                  |    8 +-
 drivers/mtd/nand/nand_bch.c                  |  243 ++++
 drivers/mtd/nand/nandsim.c                   |   43 +-
 drivers/mtd/nand/omap2.c                     |   16 +-
 drivers/mtd/nand/pxa3xx_nand.c               |  977 ++++++++---------
 drivers/mtd/onenand/omap2.c                  |    7 +-
 drivers/mtd/onenand/onenand_base.c           |   15 +-
 drivers/mtd/sm_ftl.c                         |   18 +
 drivers/mtd/tests/mtd_speedtest.c            |   80 ++-
 drivers/mtd/tests/mtd_subpagetest.c          |   10 +-
 fs/jffs2/xattr.c                             |    2 +-
 include/linux/bch.h                          |   79 ++
 include/linux/mtd/blktrans.h                 |    3 +
 include/linux/mtd/cfi.h                      |    1 +
 include/linux/mtd/latch-addr-flash.h         |   29 +
 include/linux/mtd/nand.h                     |    3 +
 include/linux/mtd/nand_bch.h                 |   72 ++
 include/linux/mtd/onenand.h                  |    1 +
 lib/Kconfig                                  |   39 +
 lib/Makefile                                 |    1 +
 lib/bch.c                                    | 1368 ++++++++++++++++++++++
 55 files changed, 4655 insertions(+), 648 deletions(-)
 create mode 100644 drivers/mtd/maps/latch-addr-flash.c
 create mode 100644 drivers/mtd/mtdswap.c
 create mode 100644 drivers/mtd/nand/nand_bch.c
 create mode 100644 include/linux/bch.h
 create mode 100644 include/linux/mtd/latch-addr-flash.h
 create mode 100644 include/linux/mtd/nand_bch.h
 create mode 100644 lib/bch.c


And below is the fix-up patch which I used in the merge commit.


From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Subject: [PATCH] mtd_blkdev: fix compilation error

The 'elv_queue_empty()' function has been removed from upstream,
so the MTD tree does not compile when it is merged with upstream,
becaue 'mtdswap' uses this removed function.

The 'elv_queue_empty()' function was used to check whether the device
queue is empty to decide when it is good time to do garbage collection -
mtdswap tries to do it only when there are no other activites.

This patch fixes the issue by introducing a separate flag to signal
that background operations should be stopped when a new request
appears.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Reviewd-by: Adrian Hunter <adrian.hunter@nokia.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 drivers/mtd/mtd_blkdevs.c    |    9 ++++++---
 include/linux/mtd/blktrans.h |    1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 6505113..a534e1f 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -124,7 +124,7 @@ int mtd_blktrans_cease_background(struct mtd_blktrans_dev *dev)
 	if (kthread_should_stop())
 		return 1;
 
-	return !elv_queue_empty(dev->rq);
+	return dev->bg_stop;
 }
 EXPORT_SYMBOL_GPL(mtd_blktrans_cease_background);
 
@@ -141,6 +141,7 @@ static int mtd_blktrans_thread(void *arg)
 	while (!kthread_should_stop()) {
 		int res;
 
+		dev->bg_stop = false;
 		if (!req && !(req = blk_fetch_request(rq))) {
 			if (tr->background && !background_done) {
 				spin_unlock_irq(rq->queue_lock);
@@ -152,7 +153,7 @@ static int mtd_blktrans_thread(void *arg)
 				 * Do background processing just once per idle
 				 * period.
 				 */
-				background_done = 1;
+				background_done = !dev->bg_stop;
 				continue;
 			}
 			set_current_state(TASK_INTERRUPTIBLE);
@@ -198,8 +199,10 @@ static void mtd_blktrans_request(struct request_queue *rq)
 	if (!dev)
 		while ((req = blk_fetch_request(rq)) != NULL)
 			__blk_end_request_all(req, -ENODEV);
-	else
+	else {
+		dev->bg_stop = true;
 		wake_up_process(dev->thread);
+	}
 }
 
 static int blktrans_open(struct block_device *bdev, fmode_t mode)
diff --git a/include/linux/mtd/blktrans.h b/include/linux/mtd/blktrans.h
index 66bec4b..1bbd9f2 100644
--- a/include/linux/mtd/blktrans.h
+++ b/include/linux/mtd/blktrans.h
@@ -36,6 +36,7 @@ struct mtd_blktrans_dev {
 	struct mtd_info *mtd;
 	struct mutex lock;
 	int devnum;
+	bool bg_stop;
 	unsigned long size;
 	int readonly;
 	int open;
-- 
1.7.2.3

Thanks,
Artem.
