Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab1DGRdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 13:33:23 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:55295 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab1DGRdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 13:33:20 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-watchdog@vger.kernel.org
Subject: [PATCH] watchdog: mpc8xxx: fix build failure
Date: Thu,  7 Apr 2011 10:33:13 -0700
Message-Id: <1302197593-31815-1-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.3.4
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Thu, 07 Apr 2011 10:33:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1c48a5c93da63132b92c4bbcd18e690c51539df6 caused a build failure
for the mpc8xxx watchdog driver. Fix it.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-watchdog@vger.kernel.org
---
 drivers/watchdog/mpc8xxx_wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index 6709d72..528bceb 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -195,7 +195,7 @@ static int __devinit mpc8xxx_wdt_probe(struct platform_device *ofdev)
 
 	if (!ofdev->dev.of_match)
 		return -EINVAL;
-	wdt_type = match->data;
+	wdt_type = ofdev->dev.of_match->data;
 
 	if (!freq || freq == -1)
 		return -EINVAL;
-- 
1.7.3.4

