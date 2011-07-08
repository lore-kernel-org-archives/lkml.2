Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab1GHFDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:03:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab1GHFDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:03:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:57 2011
Message-Id: <20110708001657.652293734@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Chris Ball <cjb@laptop.org>
Subject: [051/107] mmc: tmio: fix regression in TMIO_MMC_WRPROTECT_DISABLE handling
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit 7d8b4c2a4b73da8e3632603691838ca5b2a8c26d upstream.

Commit b6147490e6aac82 ("mmc: tmio: split core functionality, DMA and
MFD glue") broke handling of the TMIO_MMC_WRPROTECT_DISABLE flag by
the tmio-mmc driver. This patch restores the original behaviour.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/tmio_mmc_pio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/tmio_mmc_pio.c
+++ b/drivers/mmc/host/tmio_mmc_pio.c
@@ -760,8 +760,8 @@ static int tmio_mmc_get_ro(struct mmc_ho
 	struct tmio_mmc_host *host = mmc_priv(mmc);
 	struct tmio_mmc_data *pdata = host->pdata;
 
-	return ((pdata->flags & TMIO_MMC_WRPROTECT_DISABLE) ||
-		!(sd_ctrl_read32(host, CTL_STATUS) & TMIO_STAT_WRPROTECT));
+	return !((pdata->flags & TMIO_MMC_WRPROTECT_DISABLE) ||
+		 (sd_ctrl_read32(host, CTL_STATUS) & TMIO_STAT_WRPROTECT));
 }
 
 static int tmio_mmc_get_cd(struct mmc_host *mmc)


