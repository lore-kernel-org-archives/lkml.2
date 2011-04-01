Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab1DAKZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 06:25:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35066 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab1DAKZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 06:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=CoHbe7m1nfmct0f5Fa0ufKu5+WJvIHwI09BgBdXXaHfOCJH5UuKvmmBQJXfNlOlf/h
         ZyE1mrjZ0TExmC1rG6cvvCaOYrVpXYXvXd8jphnHbDyaqvC8eJMEO7oZc0ndhzYdnSJ0
         wP7/CsUaE2oF/y7GBW0gph0tv67xkiCSpcUNo=
Subject: [PATCH] regulator: Fix the argument of calling
 regulator_mode_constrain
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 18:25:25 +0800
Message-ID: <1301653525.22820.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second parameter of regulator_mode_constrain takes a pointer.

This patch fixes below warning:
drivers/regulator/core.c: In function 'regulator_set_mode':
drivers/regulator/core.c:2014: warning: passing argument 2 of 'regulator_mode_constrain' makes pointer from integer without a cast
drivers/regulator/core.c:200: note: expected 'int *' but argument is of type 'unsigned int'

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a634946..fff95c3 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2011,7 +2011,7 @@ int regulator_set_mode(struct regulator *regulator, unsigned int mode)
 	}
 
 	/* constraints check */
-	ret = regulator_mode_constrain(rdev, mode);
+	ret = regulator_mode_constrain(rdev, &mode);
 	if (ret < 0)
 		goto out;
 
-- 
1.7.1



