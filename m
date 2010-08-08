Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0HHOOZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 10:14:25 -0400
Received: from imap.ru.mvista.com ([213.79.90.228]:30619 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754103Ab0HHOOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 10:14:23 -0400
Date: Sun, 8 Aug 2010 18:14:22 +0400
From: Anton Vorontsov <avorontsov@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: [PATCH] mmc_spi: Fix unterminated of_match_table
Message-ID: <20100808141422.GA9670@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 2ffe8c5f323c3b9749bf7bc2375d909d20bdbb15 ("of: refactor
of_modalias_node() and remove explicit match table"), introduced
an unterminated of_match_table, which may cause kernel to oops.

This patch fixes the issue by adding an empty device ID.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---
 drivers/mmc/host/mmc_spi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 7b0f3ef..1145ea0 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1536,6 +1536,7 @@ static int __devexit mmc_spi_remove(struct spi_device *spi)
 #if defined(CONFIG_OF)
 static struct of_device_id mmc_spi_of_match_table[] __devinitdata = {
 	{ .compatible = "mmc-spi-slot", },
+	{},
 };
 #endif
 
-- 
1.7.0.5
