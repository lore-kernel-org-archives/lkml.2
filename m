Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030610Ab2ERDLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:11:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40394 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762540Ab2ERCw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:26 -0400
Message-Id: <20120518023254.918912892@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:32:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Henry von Tresckow <hvontres@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [ 04/53] ARM: orion5x: Fix GPIO enable bits for MPP9
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 48d99f47a81a66bdd61a348c7fe8df5a7afdf5f3 upstream.

Commit 554cdaefd1cf7bb54b209c4e68c7cec87ce442a9 ('ARM: orion5x: Refactor
mpp code to use common orion platform mpp.') seems to have accidentally
inverted the GPIO valid bits for MPP9 (only).  For the mv2120 platform
which uses MPP9 as a GPIO LED device, this results in the error:

[   12.711476] leds-gpio: probe of leds-gpio failed with error -22

Reported-by: Henry von Tresckow <hvontres@gmail.com>
References: http://bugs.debian.org/667446
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Tested-by: Hans Henry von Tresckow <hvontres@gmail.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 arch/arm/mach-orion5x/mpp.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-orion5x/mpp.h b/arch/arm/mach-orion5x/mpp.h
index eac6897..db70e79 100644
--- a/arch/arm/mach-orion5x/mpp.h
+++ b/arch/arm/mach-orion5x/mpp.h
@@ -65,8 +65,8 @@
 #define MPP8_GIGE               MPP(8,  0x1, 0, 0, 1,   1,   1)
 
 #define MPP9_UNUSED		MPP(9,  0x0, 0, 0, 1,   1,   1)
-#define MPP9_GPIO		MPP(9,  0x0, 0, 0, 1,   1,   1)
-#define MPP9_GIGE               MPP(9,  0x1, 1, 1, 1,   1,   1)
+#define MPP9_GPIO		MPP(9,  0x0, 1, 1, 1,   1,   1)
+#define MPP9_GIGE               MPP(9,  0x1, 0, 0, 1,   1,   1)
 
 #define MPP10_UNUSED		MPP(10, 0x0, 0, 0, 1,   1,   1)
 #define MPP10_GPIO		MPP(10, 0x0, 1, 1, 1,   1,   1)
-- 
1.7.10



