Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604Ab2JYONF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:13:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58791 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758584Ab2JYOMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:12:45 -0400
Date: Thu, 25 Oct 2012 15:12:44 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mfd: arizona: Use correct array for ARRAY_SIZE in
	mfd_add_devices call
Message-ID: <20121025141244.GA31078@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wm5102_devs array was used for ARRAY_SIZE whilst adding the wm5110
devices. This change corrects this to get the size from the wm5110_devs
array. As both arrays are the same size no issues should have been
caused by this bug.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 1b48f20..166254b 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -520,7 +520,7 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 		break;
 	case WM5110:
 		ret = mfd_add_devices(arizona->dev, -1, wm5110_devs,
-				      ARRAY_SIZE(wm5102_devs), NULL, 0, NULL);
+				      ARRAY_SIZE(wm5110_devs), NULL, 0, NULL);
 		break;
 	}
 
-- 
1.7.2.5

