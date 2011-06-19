Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab1FSTCx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 15:02:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64621 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab1FSTCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 15:02:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH 07/19] OpenRISC: DMA
Date: Sun, 19 Jun 2011 21:02:30 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1308483825-6023-1-git-send-email-jonas@southpole.se> <1308483825-6023-8-git-send-email-jonas@southpole.se>
In-Reply-To: <1308483825-6023-8-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106192102.30953.arnd@arndb.de>
X-Provags-ID: V02:K0:h4jQHONpQU7glJKSj2csi5a114is0LKLCA6A3aDDhVa
 6bFY1IOKwUl033hPD+N8W4VB0hDBft9O44Z1OaZ/4U8x2OBQzJ
 ddNxLXIFwyT7u/b0HBS8saYR2psOfa7U6BOBCZY/u6AsOjD/wP
 d9m6UQhhZRxq0EXaBVJ/j/zZhDxSkTa+kSesMVRwBOAs/oI/bX
 sh0oLM8kPb/sUmGa/SQCg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 June 2011 13:43:33 Jonas Bonn wrote:
> 
> Simple DMA implementation.  There's some work to do here, but
> this allows for allocation of coherent memory (simply uncached) for DMA
> operations.
> 
> Signed-off-by: Jonas Bonn <jonas@southpole.se>
> ---
>  arch/openrisc/include/asm/dma-mapping.h |  129 ++++++++++++++++++++++++++
>  arch/openrisc/kernel/dma.c              |  152 +++++++++++++++++++++++++++++++
>  2 files changed, 281 insertions(+), 0 deletions(-)
>  create mode 100644 arch/openrisc/include/asm/dma-mapping.h
>  create mode 100644 arch/openrisc/kernel/dma.c

If you don't have an IOMMU or the need for swiotlb, you can probably eliminate
the use of dma_map_ops and just provide the simple implementation.

For the operations that you have not implemented properly, I would leave
a forward-declaration but remove the implementation that causes a runtime
error, so you turn that into a link time error.

	Arnd
