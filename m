Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab2GGMG2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 08:06:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51955 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab2GGMFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 08:05:50 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 5/8] staging/ft1000: fix the no brace needed warning in ft1000_read_fifo_len
Date: Sat,  7 Jul 2012 17:35:16 +0530
Message-Id: <1341662719-25752-5-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341662719-25752-1-git-send-email-devendra.aaru@gmail.com>
References: <1341662719-25752-1-git-send-email-devendra.aaru@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as the if else statements enclose only one line, so braces around them are not
needed.

The following warning is fixed

drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c:100: WARNING: braces {} are not necessary for any arm of this statement

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index c709671..67ad7ee 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -97,11 +97,10 @@ static inline u16 ft1000_read_fifo_len(struct net_device *dev)
 {
 	struct ft1000_info *info = netdev_priv(dev);
 
-	if (info->AsicID == ELECTRABUZZ_ID) {
+	if (info->AsicID == ELECTRABUZZ_ID)
 		return (ft1000_read_reg(dev, FT1000_REG_UFIFO_STAT) - 16);
-	} else {
+	else
 		return (ft1000_read_reg(dev, FT1000_REG_MAG_UFSR) - 16);
-	}
 }
 
 //---------------------------------------------------------------------------
-- 
1.7.9.5

