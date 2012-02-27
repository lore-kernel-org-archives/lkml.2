Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab2B0N73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 08:59:29 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50343 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab2B0N72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 08:59:28 -0500
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-kernel@vger.kernel.org>, Shubhrajyoti D <shubhrajyoti@ti.com>,
        Vitaly Wool <vwool@ru.mvista.com>
Subject: [PATCH] spi: Trivial warning fix
Date: Mon, 27 Feb 2012 19:29:05 +0530
Message-ID: <1330351145-3564-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The loop count i traverses for ntrans which is unsigned
so make the loop count i also unsigned.

Fix the below warning
In file included from drivers/spi/spi-omap2-mcspi.c:38:
include/linux/spi/spi.h: In function 'spi_message_alloc':
include/linux/spi/spi.h:556: warning: comparison between signed and unsigned integer expressions

Cc: Vitaly Wool <vwool@ru.mvista.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
Untested !

 include/linux/spi/spi.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 176fce9..6ae4993 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -549,7 +549,7 @@ static inline struct spi_message *spi_message_alloc(unsigned ntrans, gfp_t flags
 			+ ntrans * sizeof(struct spi_transfer),
 			flags);
 	if (m) {
-		int i;
+		unsigned i;
 		struct spi_transfer *t = (struct spi_transfer *)(m + 1);
 
 		INIT_LIST_HEAD(&m->transfers);
-- 
1.7.0.4

