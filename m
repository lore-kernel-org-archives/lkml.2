Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2AIMMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 07:12:25 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:57699 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab2AIMMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 07:12:24 -0500
Subject: drivers/regulator/core.c: Fixes mapping inside
 regulator_mode_to_status() and makes it returning -EINVAL on invalid input.
From: Krystian Garbaciak <dd.diasemi@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Jan 2012 12:12:20 +0000
Message-ID: <1326111140.22107.9.camel@sw-eng-lt-dc-vm2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor fix that makes the function working correctly with
REGULATOR_MODE_STANDBY as parameter.
Also, on invalid input (bad mode), it is better to return -EINVAL,
instead of meaningless 0 value (which actually is interpreted as
REGULATOR_STATUS_OFF).

--- 
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 938398f..45aa874 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2484,10 +2484,10 @@ int regulator_mode_to_status(unsigned int mode)
 		return REGULATOR_STATUS_NORMAL;
 	case REGULATOR_MODE_IDLE:
 		return REGULATOR_STATUS_IDLE;
-	case REGULATOR_STATUS_STANDBY:
+	case REGULATOR_MODE_STANDBY:
 		return REGULATOR_STATUS_STANDBY;
 	default:
-		return 0;
+		return -EINVAL;
 	}
 }
 EXPORT_SYMBOL_GPL(regulator_mode_to_status);

