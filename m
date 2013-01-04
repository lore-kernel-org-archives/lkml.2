Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab3ADSsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 13:48:23 -0500
Received: from [216.228.121.35] ([216.228.121.35]:10332 "EHLO
	hqemgate04.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab3ADSsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 13:48:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 04 Jan 2013 10:47:38 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>
CC: <spi-devel-general@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <swarren@nvidia.com>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/2] spi: make sure all transfer has proper speed set
Date: Sat, 5 Jan 2013 00:17:14 +0530
Message-ID: <1357325235-25485-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When spi client does the spi transfer and if it does not set
the speed for each transfer then set it as default
of spi device in spi core before calling low level transfer.

This will remove the extra check in low level driver for setting
speed.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/spi/spi.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 19ee901..9676a29 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1366,12 +1366,14 @@ static int __spi_async(struct spi_device *spi, struct spi_message *message)
 	}
 
 	/**
-	 * Set transfer bits_per_word as spi device default if it is not
-	 * set for this transfer.
+	 * Set transfer bits_per_word and max speed as spi device default if
+	 * it is not set for this transfer.
 	 */
 	list_for_each_entry(xfer, &message->transfers, transfer_list) {
 		if (!xfer->bits_per_word)
 			xfer->bits_per_word = spi->bits_per_word;
+		if (!xfer->speed_hz)
+			xfer->speed_hz = spi->max_speed_hz;
 	}
 
 	message->spi = spi;
-- 
1.7.1.1

