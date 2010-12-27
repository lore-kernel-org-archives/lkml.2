Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab0L0L1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 06:27:37 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:30139 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753545Ab0L0L1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 06:27:15 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 3/3] spi_topcliff_pch: fix resource leak issue
Date: Mon, 27 Dec 2010 20:23:47 +0900
Message-Id: <1293449027-3219-3-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1293449027-3219-2-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1293449027-3219-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1293449027-3219-2-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case spi_register_master fails in probe function,
pch_spi_free_resources is not called.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/spi/spi_topcliff_pch.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi_topcliff_pch.c b/drivers/spi/spi_topcliff_pch.c
index a796eaf..e806e31 100644
--- a/drivers/spi/spi_topcliff_pch.c
+++ b/drivers/spi/spi_topcliff_pch.c
@@ -1125,6 +1125,7 @@ static int pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_spi_reg_master:
 	for (j = 0; j < i; j++)
 		spi_unregister_master(master[j]);
+	pch_spi_free_resources(board_dat);
 err_spi_get_resources:
 err_spi_alloc_master:
 	for (j = 0; j < i; j++)
-- 
1.6.0.6

