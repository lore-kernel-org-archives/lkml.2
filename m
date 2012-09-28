Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab2I1Hjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:39:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:8956 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211Ab2I1Hjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:39:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,499,1344236400"; 
   d="scan'208,223";a="227634387"
Message-ID: <1348818018.10877.324.camel@rui.sh.intel.com>
Subject: [RFC PATCH 4/6] Change i2c_register_board_info from __init to
 __devinit
From: Zhang Rui <rui.zhang@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Len, Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Date: Fri, 28 Sep 2012 15:40:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 34aa38e12c04544d89af2eae46de284dc8a03b8d Mon Sep 17 00:00:00 2001
From: Zhang Rui <rui.zhang@intel.com>
Date: Thu, 27 Sep 2012 15:42:23 +0800
Subject: [RFC PATCH 4/6] Change i2c_register_board_info from __init to
 __devinit.

ACPI 5 supports enumerating I2C adapter and its slaves
via ACPI namespace, and this needs to be done at runtime,
after the ACPI I2C controller driver being loaded.

detailed usage of this API can be found in next patch.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/i2c/i2c-boardinfo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/i2c-boardinfo.c b/drivers/i2c/i2c-boardinfo.c
index f24cc64..1ecbbdc 100644
--- a/drivers/i2c/i2c-boardinfo.c
+++ b/drivers/i2c/i2c-boardinfo.c
@@ -61,7 +61,7 @@ EXPORT_SYMBOL_GPL(__i2c_first_dynamic_bus_num);
  * The board info passed can safely be __initdata, but be careful of embedded
  * pointers (for platform_data, functions, etc) since that won't be copied.
  */
-int __init
+int __devinit
 i2c_register_board_info(int busnum,
 	struct i2c_board_info const *info, unsigned len)
 {
-- 
1.7.7.6



