Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762399Ab2FVObb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 10:31:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58047 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab2FVOb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 10:31:27 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFC 1/4] remoteproc: Bugfix assign device address to carveout (noiommu)
Date: Fri, 22 Jun 2012 16:31:07 +0200
Message-Id: <1340375470-13097-2-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Carveout did not set device address when IOMMU is not supported.
Fix this by assigning dma address to device address to carveout
if IOMMU is not supported.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index bee4644..8185c11 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -628,6 +628,10 @@ static int rproc_handle_carveout(struct rproc *rproc,
 		 * dual M3 subsystem).
 		 */
 		rsc->pa = dma;
+	} else {
+		rsc->da = dma;
+		dev_dbg(dev, "carveout: %s va %p dma %x\n",
+					rsc->name, va, rsc->da);
 	}
 
 	carveout->va = va;
-- 
1.7.5.4

