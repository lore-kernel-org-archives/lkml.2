Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab2E1Dww (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:52:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51906 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753513Ab2E1D3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:11 -0400
Message-Id: <20120528031206.485575402@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:28 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [ 026/117] regulator: core: Release regulator-regulator supplies on error
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit e81dba85c6388dfabcb76cbc2b8bd02836a53ae5 upstream.

If we fail while registering a regulator make sure we release the supply
for the regulator if there is one.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/regulator/core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 8918271..5a33282 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3193,6 +3193,8 @@ unset_supplies:
 	unset_regulator_supplies(rdev);
 
 scrub:
+	if (rdev->supply)
+		regulator_put(rdev->supply);
 	kfree(rdev->constraints);
 	device_unregister(&rdev->dev);
 	/* device core frees rdev */


