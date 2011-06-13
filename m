Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab1FMKzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 06:55:18 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:54061 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002Ab1FMKzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 06:55:15 -0400
From: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
To: <grant.likely@secretlab.ca>
Cc: <spi-devel-general@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <linus.walleij@linaro.org>, <virupax.sadashivpetimath@stericsson.com>
Subject: [PATCH] spi-pl022: Add missing return value update
Date: Mon, 13 Jun 2011 16:23:46 +0530
Message-ID: <1307962426-19230-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
X-Mailer: git-send-email 1.7.4.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return error on out of range cpsdvsr value.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
---
 drivers/spi/spi-pl022.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 2541705..b3bd8d8 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -1859,6 +1859,7 @@ static int pl022_setup(struct spi_device *spi)
 	}
 	if ((clk_freq.cpsdvsr < CPSDVR_MIN)
 	    || (clk_freq.cpsdvsr > CPSDVR_MAX)) {
+		status = -EINVAL;
 		dev_err(&spi->dev,
 			"cpsdvsr is configured incorrectly\n");
 		goto err_config_params;
-- 
1.7.4.3

