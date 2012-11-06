Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab2KFKNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 05:13:17 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:50084 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2KFKNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 05:13:15 -0500
X-AuditID: cbfee61b-b7f616d00000319b-15-5098e2b907bf
From: Tomasz Figa <t.figa@samsung.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: linux-kernel@vger.kernel.org, djbw@fb.com, dwmw2@infradead.org,
        hskinnemoen@gmail.com, iws@ovro.caltech.edu, vinod.koul@intel.com,
        vipin.kumar@st.com, kyungmin.park@samsung.com
Subject: Re: [PATCH 00/20] DMA: DMA unmap fixes
Date: Tue, 06 Nov 2012 11:12:52 +0100
Message-id: <1991743.bB6HhaiITg@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.9.2 (Linux/3.6.5-gentoo; KDE/4.9.2; x86_64; ; )
In-reply-to: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jAd2dj2YEGDQfsbG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ85b0sxY8V6842L2CuYFxiUwXIyeHhICJxJb+KWwQtpjEhXvr
	gWwuDiGBRYwS2+fvYoFwljJJzDp2kwWkik1ATeJzwyOwDhEBC4m1K96CFTEL7GCUmH28lR0k
	ISygL/H/Tj8ziM0ioCoxq3cSUBEHB6+ApsSqe7ogYX4BdYl3254ygdiiAs4SK5rvg83kFPCQ
	aGyYwgpiCwm4S1zuPA42hldAUOLH5HtgNzALyEvs2z+VFcLWkli/8zjTBEbBWUjKZiEpm4Wk
	bAEj8ypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4NB8Jr2DcVWDxSFGAQ5GJR5eQbEZAUKs
	iWXFlbmHGCU4mJVEeHdsAwrxpiRWVqUW5ccXleakFh9ilOZgURLnbfZICRASSE8sSc1OTS1I
	LYLJMnFwSjUwCr38tOLoXwPTSqU5xdwXJ+Ue9ewwnfNmU93Kh8sEXc9ErFi1JTi5gitIfHcm
	U1tBEQ9Lz0MW1q0bK0V2SnoerepdbLp32l+Rm3836/C+Ytm2an9xRYuH6n6vz9P7cxfMjFqy
	6QLrxweHV12PFyyXOpye6bo5a3rVFs6WKwkCOokxm801Lzs7KbEUZyQaajEXFScCAKPJ++1J	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

On Monday 05 of November 2012 11:00:11 Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> Currently DMA subsystem does DMA mapping in the core code and DMA
> unmapping is done by device drivers.  This is counterintuitive,
> causes code duplication and subtle errors (some drivers like PL330
> one don't implement DMA unmapping code).  The following patchset
> modifies DMA subsystem to do DMA unmapping in the core code.
> It results in simpler code, less code duplication (more than 400
> LOC is gone) and fixes the issue with missing DMA unmapping code
> in some drivers.  Additionally many cases when DMA wasn't unmapped
> on a failure are also fixed.
> 
> 
> patches #1-3 add missing DMA unmap on failure to async_tx core
> code (async_memcpy()), ioat and fsmc_nand drivers
> 
> patch #4 fixes DMA flags used by carma-fpga driver
> 
> patches #5-7 fix core code and dmatest driver to DMA unmap for
> MEMCPY operations
> 
> patch #8 adds missing DMA unmap on failure to ioat3 driver
> 
> patch #9 fixes build for async_memset.c
> 
> patch #10 adds missing DMA unmap on failure to async tx core
> code (async_memset())
> 
> patches #11-18 fix async_tx core code and dmatest driver to do
> DMA unmap for MEMSET, XOR, XOR_VAL, PQ and PQ_VAL operations
> 
> patches #19-20 remove no longer needed DMA unmap code from
> device drivers and DMA unmap flags from code code
> 
> 
> This patchset was tested on PL330 DMA controller using MEMCPY
> operations.  It would be great if somebody could test it on
> more advanced controller capable of MEMSET, XOR, XOR_VAL,
> PQ and PQ_VAL operations (especially since the conversion of
> XOR and PQ operations was not obvious).
> 
> 
> Bartlomiej Zolnierkiewicz (20):
>   async_tx: add missing DMA unmap to async_memcpy()
>   ioat: add missing DMA unmap to ioat_dma_self_test()
>   mtd: fsmc_nand: add missing DMA unmap to dma_xfer()
>   carma-fpga: pass correct flags to ->device_prep_dma_memcpy()
>   dmatest: do DMA unmap for MEMCPY operations
>   DMA: do DMA unmap in core for MEMCPY operations
>   async_tx: do DMA unmap in core for MEMCPY operations
>   ioat3: add missing DMA unmap to ioat_xor_val_self_test()
>   async_tx: fix build for async_memset
>   async_tx: add missing DMA unmap to async_memset()
>   async_tx: do DMA unmap in core for MEMSET operations
>   dmatest: do DMA unmap for XOR operations
>   async_tx: do DMA unmap in core for XOR operations
>   async_tx: do DMA unmap in core for XOR_VAL operations
>   dmatest: do DMA unmap for PQ operations
>   async_tx: do DMA unmap in async_raid6_recov.c for PQ operations
>   async_tx: do DMA unmap in core for PQ operations
>   async_tx: do DMA unmap in core for PQ_VAL operations
>   DMA: remove DMA unmap from drivers
>   DMA: remove DMA unmap flags
> 
>  arch/arm/include/asm/hardware/iop3xx-adma.h |  30 ----
>  arch/arm/mach-iop13xx/include/mach/adma.h   |  26 ---
>  crypto/async_tx/async_memcpy.c              |  27 ++-
>  crypto/async_tx/async_memset.c              |  23 ++-
>  crypto/async_tx/async_pq.c                  | 129 +++++++++----
>  crypto/async_tx/async_raid6_recov.c         |  42 ++++-
>  crypto/async_tx/async_tx.c                  |  25 ++-
>  crypto/async_tx/async_xor.c                 |  98 +++++++---
>  drivers/ata/pata_arasan_cf.c                |   3 +-
>  drivers/dma/amba-pl08x.c                    |  31 ----
>  drivers/dma/at_hdmac.c                      |  25 ---
>  drivers/dma/dmaengine.c                     |  59 +++++-
>  drivers/dma/dmatest.c                       |  14 +-
>  drivers/dma/dw_dmac.c                       |  20 ---
>  drivers/dma/ep93xx_dma.c                    |  32 +---
>  drivers/dma/fsldma.c                        |  16 --
>  drivers/dma/ioat/dma.c                      |  28 +--
>  drivers/dma/ioat/dma.h                      |  12 --
>  drivers/dma/ioat/dma_v2.c                   |   1 -
>  drivers/dma/ioat/dma_v3.c                   | 179 +++++-------------
>  drivers/dma/iop-adma.c                      |  70 +-------
>  drivers/dma/mv_xor.c                        |  45 +----
>  drivers/dma/ppc4xx/adma.c                   | 270
> ---------------------------- drivers/dma/timb_dma.c                    
>  |  36 ----
>  drivers/dma/txx9dmac.c                      |  24 ---
>  drivers/media/platform/m2m-deinterlace.c    |   3 +-
>  drivers/media/platform/timblogiw.c          |   2 +-
>  drivers/misc/carma/carma-fpga.c             |   3 +-
>  drivers/mtd/nand/atmel_nand.c               |   3 +-
>  drivers/mtd/nand/fsmc_nand.c                |  20 ++-
>  drivers/net/ethernet/micrel/ks8842.c        |   6 +-
>  drivers/spi/spi-dw-mid.c                    |   4 +-
>  include/linux/async_tx.h                    |   4 +
>  include/linux/dmaengine.h                   |  34 ++--
>  34 files changed, 446 insertions(+), 898 deletions(-)

For all patches:

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
-- 
Tomasz Figa
Samsung Poland R&D Center
SW Solution Development, Linux Platform

