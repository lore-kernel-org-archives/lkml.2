Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030700Ab2ERDLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:11:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40391 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762532Ab2ERCw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:26 -0400
Message-Id: <20120518023254.521494545@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:32:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 01/53] regulator: Fix the logic to ensure new voltage setting in valid range
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit f55205f4d4a8823a11bb8b37ef2ecbd78fb09463 upstream.

I think this is a typo.
To ensure new voltage setting won't greater than desc->max,
the equation should be desc->min + desc->step * new_val <= desc->max.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/regulator/max8997.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 9657929..17a58c5 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -684,7 +684,7 @@ static int max8997_set_voltage_buck(struct regulator_dev *rdev,
 		}
 
 		new_val++;
-	} while (desc->min + desc->step + new_val <= desc->max);
+	} while (desc->min + desc->step * new_val <= desc->max);
 
 	new_idx = tmp_idx;
 	new_val = tmp_val;
-- 
1.7.10



