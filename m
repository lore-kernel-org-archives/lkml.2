Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab2BXQyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:54:22 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46458 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855Ab2BXQyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:54:20 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.68.213.136 as permitted sender) smtp.mail=glikely@secretlab.ca
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 2/2] mfd: twl-core: Add IRQ_DOMAIN dependency
Date: Fri, 24 Feb 2012 09:54:08 -0700
Message-Id: <1330102448-19172-2-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330102448-19172-1-git-send-email-grant.likely@secretlab.ca>
References: <1330102448-19172-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Cousson <b-cousson@ti.com>

TWL4030 depends on IRQ_DOMAIN support, so this patch selects it in Kconfig.
It used to be that CONFIG_IRQ_DOMAIN must only be selected by the architecture,
but recent cleanups have fixed it so that it is safe to select from anywhere.

Signed-off-by: Benoit Cousson <b-cousson@ti.com>
[grant.likely: Changed from a depends to a select]
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index f147395..1489c35 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -201,6 +201,7 @@ config MENELAUS
 config TWL4030_CORE
 	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
 	depends on I2C=y && GENERIC_HARDIRQS
+	select IRQ_DOMAIN
 	help
 	  Say yes here if you have TWL4030 / TWL6030 family chip on your board.
 	  This core driver provides register access and IRQ handling
-- 
1.7.9

