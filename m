Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab1C1HQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 03:16:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61737 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1C1HQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 03:16:47 -0400
Date: Mon, 28 Mar 2011 09:16:33 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Chris Ball <cjb@laptop.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: [PATCH] mmc: SDHI should depend on SUPERH || ARCH_SHMOBILE
In-Reply-To: <20110328131018.96742ebb.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.1103280913170.6625@axis700.grange>
References: <20110328131018.96742ebb.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:upSGzvfBre9wBu7ciGpnwwlxAJZHcNUOXENTmRoQcyi
 rIw5+8VhrEgB1UPst/vHnX7Fg5To26oWrt1oppUH+j0iBeY3hE
 +KpfAzvKOtn3AWvZ4QRprPQh7CVdYZB+LnRaBnf4tuWxvCa+h+
 s/gL+AAhevbxBsnzaC4Y5U8O3P6/e2gR/k4pveWoQ/3QSRrCdW
 1r+3vUUcKaiqhtDRcG7vJ6nWlmxweEGRvAnAZc8Fwk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build breakage on platforms, not providing readsw and writesw
functions, e.g., on x86(_64).

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Subject: Re: linux-next: build failure after merge of the mmc tree

On Mon, 28 Mar 2011, Stephen Rothwell wrote:

> Hi Chris,
> 
> After merging the mmc tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/mmc/host/tmio_mmc_pio.c: In function 'sd_ctrl_read16_rep':
> drivers/mmc/host/tmio_mmc_pio.c:56: error: implicit declaration of function 'readsw'
> drivers/mmc/host/tmio_mmc_pio.c: In function 'sd_ctrl_write16_rep':
> drivers/mmc/host/tmio_mmc_pio.c:73: error: implicit declaration of function 'writesw'
> 
> Presumably caused by commit b6147490e6aa ("mmc: tmio: split core
> functionality, DMA and MFD glue").
> 
> I have used the mmc tree from next-20110325 for tdoay.

Stephen, please verify, that this fixes your problem.

 drivers/mmc/host/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 0b03cee..94df405 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -452,6 +452,7 @@ config MMC_TMIO
 
 config MMC_SDHI
 	tristate "SH-Mobile SDHI SD/SDIO controller support"
+	depends on SUPERH || ARCH_SHMOBILE
 	select MMC_TMIO_CORE
 	help
 	  This provides support for the SDHI SD/SDIO controller found in
-- 
1.7.2.5

