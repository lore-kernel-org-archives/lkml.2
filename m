Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1769030Ab2K3TSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:18:34 -0500
Received: from mail.kernel.org ([198.145.19.201]:58650 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992757Ab2K3S4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Chris Ball <cjb@laptop.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 52/56] mmc: sdhci-s3c: fix the wrong number of max bus clocks
Date: Fri, 30 Nov 2012 10:55:44 -0800
Message-Id: <20121130185123.612701523@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaehoon Chung <jh80.chung@samsung.com>

commit 5feb54a1ab91a237e247c013b8c4fb100ea347b1 upstream.

We can use up to four bus-clocks; but on module remove, we didn't
disable the fourth bus clock.

Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-s3c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -656,7 +656,7 @@ static int __devexit sdhci_s3c_remove(st
 
 	pm_runtime_disable(&pdev->dev);
 
-	for (ptr = 0; ptr < 3; ptr++) {
+	for (ptr = 0; ptr < MAX_BUS_CLK; ptr++) {
 		if (sc->clk_bus[ptr]) {
 			clk_disable(sc->clk_bus[ptr]);
 			clk_put(sc->clk_bus[ptr]);


