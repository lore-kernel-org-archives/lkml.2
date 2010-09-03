Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0ICDBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 23:01:32 -0400
Received: from smtp13.ono.com ([62.42.230.16]:39467 "EHLO resmaa13.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752340Ab0ICDBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 23:01:31 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Sep 2010 23:01:31 EDT
Date: Fri, 3 Sep 2010 04:54:59 +0200
From: Guillem Jover <guillem@hadrons.org>
To: Riku Voipio <riku.voipio@iki.fi>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] hwmon: (f75375s) Shift control mode to the correct bit
 position
Message-ID: <20100903025459.GA15996@gaara.hadrons.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spec notes that fan0 and fan1 control mode bits are located in bits
7-6 and 5-4 respectively, but the FAN_CTRL_MODE macro was making the
bits shift by 5 instead of by 4.

Signed-off-by: Guillem Jover <guillem@hadrons.org>
---
 drivers/hwmon/f75375s.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
index 0f58ecc..e5828c0 100644
--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -79,7 +79,7 @@ enum chips { f75373, f75375 };
 #define F75375_REG_PWM2_DROP_DUTY	0x6C
 
 #define FAN_CTRL_LINEAR(nr)		(4 + nr)
-#define FAN_CTRL_MODE(nr)		(5 + ((nr) * 2))
+#define FAN_CTRL_MODE(nr)		(4 + ((nr) * 2))
 
 /*
  * Data structures and manipulation thereof
-- 
1.7.1

