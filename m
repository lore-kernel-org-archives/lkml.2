Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab2LELLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 06:11:20 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:60567 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2LELLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 06:11:19 -0500
X-AuditID: cbfee61b-b7f616d00000319b-3d-50bf2bd5cb52
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, djbw@fb.com, dwmw2@infradead.org,
        hskinnemoen@gmail.com, iws@ovro.caltech.edu, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH resend 0/7] DMA: DMA unmap fixes for v3.8
Date: Wed, 05 Dec 2012 12:10:38 +0100
Message-id: <1354705845-29439-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t9jAd2r2vsDDC7MlrS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZDz7OZyvo565oalzE1MD4jaOLkZNDQsBEYsa9DlYIW0ziwr31
	bF2MXBxCAosYJW5tPc8M4axmkvg3dTkTSBWbgJXExPZVjCC2iICExPZnfewgRcwC7xglmtb9
	BSsSFrCUuP66B2wsi4CqRO+6v2ANvAIeEtO2XWSGWCcv8fR+H9sERu4FjAyrGEVTC5ILipPS
	c430ihNzi0vz0vWS83M3MYK9+Ex6B+OqBotDjAIcjEo8vBLG+wKEWBPLiitzDzFKcDArifDO
	k9kfIMSbklhZlVqUH19UmpNafIhRmoNFSZy32SMlQEggPbEkNTs1tSC1CCbLxMEp1cBYFP7e
	9FzRka/rF0mWHF+d/MO/6XvZ5uOTxJo3yDtz/ljBUdY930RNvDiRoeRv+NNWbYOtbpcqPrQ+
	yEzqunrzwEKmSPdPc28pltX9P5/PatkptdliBjMry0pe4VbGM7zf9KbXPjLzZq9UOHtFRVP1
	8s6IB81Nd2/ECB1foRg5cfJpzXsNexYpsRRnJBpqMRcVJwIAz0x3j94BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a minimal set of patches from a larger DMA unmap
rework (http://lkml.org/lkml/2012/11/5/111).  There are no
changes from the previous posting (except added Acked-by
and Reviewed-by tags).

Vinod, could you please apply them to v3.8?  Thanks!


patches #1-3 add missing DMA unmap on failure to async_tx core
code (async_memcpy()), ioat and fsmc_nand drivers

patch #4 fixes DMA flags used by carma-fpga driver

patch #5 adds missing DMA unmap on failure to ioat3 driver

patch #6 fixes build for async_memset.c

patch #7 adds missing DMA unmap on failure to async tx core
code (async_memset())


Bartlomiej Zolnierkiewicz (7):
  async_tx: add missing DMA unmap to async_memcpy()
  ioat: add missing DMA unmap to ioat_dma_self_test()
  mtd: fsmc_nand: add missing DMA unmap to dma_xfer()
  carma-fpga: pass correct flags to ->device_prep_dma_memcpy()
  ioat3: add missing DMA unmap to ioat_xor_val_self_test()
  async_tx: fix build for async_memset
  async_tx: add missing DMA unmap to async_memset()

 crypto/async_tx/async_memcpy.c  |  6 ++++
 crypto/async_tx/async_memset.c  |  4 +++
 drivers/dma/ioat/dma.c          | 11 +++---
 drivers/dma/ioat/dma_v3.c       | 76 ++++++++++++++++++++++++++++++++---------
 drivers/misc/carma/carma-fpga.c |  4 ++-
 drivers/mtd/nand/fsmc_nand.c    | 22 +++++++-----
 6 files changed, 93 insertions(+), 30 deletions(-)

-- 
1.8.0

