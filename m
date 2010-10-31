Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab0JaEYs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 00:24:48 -0400
Received: from [69.28.251.93] ([69.28.251.93]:38298 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab0JaEYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 00:24:46 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Subject: [PATCH 1/3] mtd: m25p80: Reinstate error print on unrecognized flash
To: David Woodhouse <dwmw2@infradead.org>
Cc: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Date: Sat, 30 Oct 2010 21:11:02 -0700
Message-Id: <fbcf2b0a4d8ebff3378b9522ce81ad82@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b34bc037b26e621e5fc13466767e4da110a7b3d3 removed the
"unrecognized JEDEC id" error message, causing the probe function to
silently abort if the flash ID is unrecognized.

It is desirable to produce diagnostic output in this situation so that
the user has some idea what went wrong.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 drivers/mtd/devices/m25p80.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index bf5a002..80404e1 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -764,6 +764,7 @@ static const struct spi_device_id *__devinit jedec_probe(struct spi_device *spi)
 			return &m25p_ids[tmp];
 		}
 	}
+	dev_err(&spi->dev, "unrecognized JEDEC id %06x\n", jedec);
 	return ERR_PTR(-ENODEV);
 }
 
-- 
1.7.0.4

