Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab1LNLts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 06:49:48 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43585 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873Ab1LNLt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 06:49:27 -0500
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Mark Grosen <mgrosen@ti.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 1/7] remoteproc: do not require an iommu
Date: Wed, 14 Dec 2011 13:48:29 +0200
Message-Id: <1323863315-8159-2-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323863315-8159-1-git-send-email-ohad@wizery.com>
References: <1323863315-8159-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Grosen <mgrosen@ti.com>

Not all remote processors employ an IOMMU, so do not error out
on !iommu_present().

Note: we currently still use iommu_present() to tell whether we need
to configure an IOMMU or not. That works for simple cases, but will
easily fail with more complicated ones (e.g. where an IOMMU exists,
but not all remote processors use it). When those use cases show up,
we will solve them by introducing something like remoteproc hw
capabilities.

[ohad@wizery.com: write commit log]

Signed-off-by: Mark Grosen <mgrosen@ti.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/remoteproc/remoteproc_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index ad93d7d..0d9a955 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -105,8 +105,8 @@ static int rproc_enable_iommu(struct rproc *rproc)
 	 * that will be set by the remoteproc driver.
 	 */
 	if (!iommu_present(dev->bus)) {
-		dev_err(dev, "iommu not found\n");
-		return -ENODEV;
+		dev_dbg(dev, "iommu not found\n");
+		return 0;
 	}
 
 	domain = iommu_domain_alloc(dev->bus);
-- 
1.7.5.4

