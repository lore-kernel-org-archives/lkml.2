Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab2JQILo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 04:11:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23572 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab2JQILl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 04:11:41 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-ce-507e683b3e5d
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        linux-samsung-soc@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
References: <1349813638-4617-1-git-send-email-arnd@arndb.de>
 <1349813638-4617-9-git-send-email-arnd@arndb.de>
In-reply-to: <1349813638-4617-9-git-send-email-arnd@arndb.de>
Subject: RE: [PATCH v2 v2 v2 8/8] spi/s3c64xx: use correct
 dma_transfer_direction type
Date: Wed, 17 Oct 2012 17:11:39 +0900
Message-id: <003a01cdac3f$08fe40d0$1afac270$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2mWq3+S999Xs45RBasvicnMI8UgAF48AMA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t9jQV3rjLoAg7efJC0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLWzn3LUvBOsOL8tTksDYyP+LoYOTkkBEwk5s7Yywph
	i0lcuLeerYuRi0NIYDqjxPV9KxghnL+MEpdb9rCBVLEJaEgcfv+MHcQWETCWWPd+FVgRs8BT
	Rok92+4zdTFyAHXkS0z/Ew9icgrYSnx6FAlSLiwQIfF6xXNGEJtFQFVi3donTCA2L1DJw3tr
	WCBsQYkfk++B2cwCWhLrdx5ngrDlJTavecsMMlJCQF3i0V9dEFNEwEji9d1IiAoRiX0v3jFO
	YBSahWTQLCSDZiEZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYweH8THoH46oG
	i0OMAhyMSjy8AUtrA4RYE8uKK3MPMUpwMCuJ8Cql1QUI8aYkVlalFuXHF5XmpBYfYpTmYFES
	5232SAkQEkhPLEnNTk0tSC2CyTJxcEo1ME78O/39/W0lv+8HprJZJN28WSZ67/nCGLktHwsW
	1/T4tS44mODSmiTG4af7wjd+zY4Flu+eb7ikt7vhj5DAg5PGppm/3t5Y/ETYL0bh67mlCauW
	znqt2hfZoqB/+tYsn56+vx5sds2v13hcmrFsmkNI/v9npt98krZrN1gnTimcMyVCSz7qN6MS
	S3FGoqEWc1FxIgDCVnRAYwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> There is a subtle difference between dma_transfer_direction and
> dma_data_direction: the former is used by the dmaengine framework,
> while the latter is used by the dma-mapping API. Although the
> purpose is comparable, the actual values are different and must
> not be mixed. In this case, the driver just wants to use
> dma_transfer_direction.
> 
> Without this patch, building s3c6400_defconfig results in:
> 
> drivers/spi/spi-s3c64xx.c: In function 's3c64xx_spi_dmacb':
> drivers/spi/spi-s3c64xx.c:239:21: warning: comparison between
> 	'enum dma_data_direction' and 'enum dma_transfer_direction' [-
> Wenum-compare]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

BTW, don't we need following accordingly?

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 1a81c90..a0bb55e 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1067,11 +1067,11 @@ static int __devinit s3c64xx_spi_get_dmares(

 	if (tx) {
 		dma_data = &sdd->tx_dma;
-		dma_data->direction = DMA_TO_DEVICE;
+		dma_data->direction = DMA_MEM_TO_DEV;
 		chan_str = "tx";
 	} else {
 		dma_data = &sdd->rx_dma;
-		dma_data->direction = DMA_FROM_DEVICE;
+		dma_data->direction = DMA_DEV_TO_MEM;
 		chan_str = "rx";
 	}

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: spi-devel-general@lists.sourceforge.net
> ---
>  drivers/spi/spi-s3c64xx.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
> index d1c8441f..2e44dd6 100644
> --- a/drivers/spi/spi-s3c64xx.c
> +++ b/drivers/spi/spi-s3c64xx.c
> @@ -132,7 +132,7 @@
> 
>  struct s3c64xx_spi_dma_data {
>  	unsigned		ch;
> -	enum dma_data_direction direction;
> +	enum dma_transfer_direction direction;
>  	enum dma_ch	dmach;
>  	struct property		*dma_prop;
>  };
> --
> 1.7.10

