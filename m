Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab0IRTUv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:20:51 -0400
Received: from kroah.org ([198.145.64.141]:43857 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177Ab0IRTQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:17 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:06 2010
Message-Id: <20100918191306.492758285@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guillem Jover <guillem@hadrons.org>, Riku Voipio <riku.voipio@iki.fi>,
        Jean Delvare <khali@linux-fr.org>
Subject: [107/129] hwmon: (f75375s) Shift control mode to the correct bit position
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guillem Jover <guillem@hadrons.org>

commit 96f3640894012be7dd15a384566bfdc18297bc6c upstream.

The spec notes that fan0 and fan1 control mode bits are located in bits
7-6 and 5-4 respectively, but the FAN_CTRL_MODE macro was making the
bits shift by 5 instead of by 4.

Signed-off-by: Guillem Jover <guillem@hadrons.org>
Cc: Riku Voipio <riku.voipio@iki.fi>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/f75375s.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -79,7 +79,7 @@ enum chips { f75373, f75375 };
 #define F75375_REG_PWM2_DROP_DUTY	0x6C
 
 #define FAN_CTRL_LINEAR(nr)		(4 + nr)
-#define FAN_CTRL_MODE(nr)		(5 + ((nr) * 2))
+#define FAN_CTRL_MODE(nr)		(4 + ((nr) * 2))
 
 /*
  * Data structures and manipulation thereof


