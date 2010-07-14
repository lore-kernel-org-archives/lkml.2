Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab0GNOEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 10:04:33 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:47012 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753729Ab0GNOEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 10:04:32 -0400
Date: Wed, 14 Jul 2010 16:04:28 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>,
        Rajendra Nayak <rnayak@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 1/5] drivers/regulator: Remove dead
 CONFIG_TWL4030_ALLOW_UNSUPPORTED
Message-ID: <c3c850bed3f5714f1efcfad24ad4f8bfcb6b5b54.1279116162.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_TWL4030_ALLOW_UNSUPPORTED doesn't exist in Kconfig and is never
defined anywhere else, therefore removing all references for it from
the source code.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/regulator/twl-regulator.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 7e5892e..8843927 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -244,11 +244,7 @@ static int twlreg_set_mode(struct regulator_dev *rdev, unsigned mode)
  * VAUX3 at 3V is incorrectly listed in some TI manuals as unsupported.
  * TI are revising the twl5030/tps659x0 specs to support that 3.0V setting.
  */
-#ifdef CONFIG_TWL4030_ALLOW_UNSUPPORTED
-#define UNSUP_MASK	0x0000
-#else
 #define UNSUP_MASK	0x8000
-#endif
 
 #define UNSUP(x)	(UNSUP_MASK | (x))
 #define IS_UNSUP(x)	(UNSUP_MASK & (x))
-- 
1.7.0.4

