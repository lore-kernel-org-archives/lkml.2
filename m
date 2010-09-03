Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab0ICNne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:43:34 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:32894 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab0ICNnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:43:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YEpmYw/n6txWQZSTUAgqMoUJ2u+uFGbV+xBgs00bgJhfq4PBvDUBZXXzVYEd0ma8Y1
         YFIKRRKaVFvNrHtH7EjxITXFZSddvBSNqP6YWq6N1XKq4egoB0BDf7HvXdItddfL41qm
         rbSc7GgWiryXdIU+q67S5iWKKkOGfWBBI8Hdo=
From: Jarkko Nikula <jhnikula@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jarkko Nikula <jhnikula@gmail.com>
Subject: [PATCH] regulator: Fix machine constraints apply for min_uV != max_uV
Date: Fri,  3 Sep 2010 16:43:49 +0300
Message-Id: <1283521429-32499-1-git-send-email-jhnikula@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Constraints are not applied until both min_uV and max_uV are the same. This
looks like a typo in the test.

Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
---
 drivers/regulator/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 422a709..b092070 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -724,7 +724,7 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 
 	/* do we need to apply the constraint voltage */
 	if (rdev->constraints->apply_uV &&
-		rdev->constraints->min_uV == rdev->constraints->max_uV &&
+		rdev->constraints->min_uV && rdev->constraints->max_uV &&
 		ops->set_voltage) {
 		ret = ops->set_voltage(rdev,
 			rdev->constraints->min_uV, rdev->constraints->max_uV);
-- 
1.7.1

