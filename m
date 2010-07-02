Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab0GBIQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 04:16:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:58364 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757668Ab0GBIQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 04:16:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,525,1272870000"; 
   d="scan'208";a="532503485"
From: feng.tang@intel.com
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       hpa@zytor.com, jacob.jun.pan@intel.com, dtor@mail.ru,
       randy.dunlap@oracle.com
Cc: Feng Tang <feng.tang@intel.com>
Subject: [PATCH 5/5] input: i8042 - add runtime check in x86's i8042_platform_init
Date: Fri,  2 Jul 2010 16:35:16 +0800
Message-Id: <1278059716-7147-6-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1278059716-7147-1-git-send-email-feng.tang@intel.com>
References: <1278059716-7147-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Then it will first check x86_platforms's i8042 detection result,
then go on with normal probe.

Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 drivers/input/serio/i8042-x86ia64io.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 6168469..2e14fc5 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -840,6 +840,10 @@ static int __init i8042_platform_init(void)
 {
 	int retval;
 
+	/* Just return if pre-detection shows no i8042 controller exist */
+	if (!x86_platform.i8042_detect())
+		return -ENODEV;
+
 /*
  * On ix86 platforms touching the i8042 data register region can do really
  * bad things. Because of this the region is always reserved on ix86 boxes.
-- 
1.7.0.4

