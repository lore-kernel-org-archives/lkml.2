Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab2AXCpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:45:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180Ab2AXCpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:45:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:29 2012
Message-Id: <20120124023929.198015956@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alexander Elbs <alex@segv.de>,
        Philip Rakity <prakity@marvell.com>,
        Arindam Nath <arindam.nath@amd.com>, Chris Ball <cjb@laptop.org>
Subject: [060/129] mmc: sd: Fix SDR12 timing regression
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1174
Lines: 32

From: Alexander Elbs <alex@segv.de>

commit dd8df17fe83483d7ea06ff229895e35a42071599 upstream.

This patch fixes a failure to recognize SD cards reported on a Dell
Vostro with O2 Micro SD card reader.  Patch 49c468f ("mmc: sd: add
support for uhs bus speed mode selection") caused the problem, by
setting the SDHCI_CTRL_HISPD flag even for legacy timings.

Signed-off-by: Alexander Elbs <alex@segv.de>
Acked-by: Philip Rakity <prakity@marvell.com>
Acked-by: Arindam Nath <arindam.nath@amd.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/sdhci.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1364,8 +1364,7 @@ static void sdhci_do_set_ios(struct sdhc
 		if ((ios->timing == MMC_TIMING_UHS_SDR50) ||
 		    (ios->timing == MMC_TIMING_UHS_SDR104) ||
 		    (ios->timing == MMC_TIMING_UHS_DDR50) ||
-		    (ios->timing == MMC_TIMING_UHS_SDR25) ||
-		    (ios->timing == MMC_TIMING_UHS_SDR12))
+		    (ios->timing == MMC_TIMING_UHS_SDR25))
 			ctrl |= SDHCI_CTRL_HISPD;
 
 		ctrl_2 = sdhci_readw(host, SDHCI_HOST_CONTROL2);


