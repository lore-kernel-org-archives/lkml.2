Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab1GHE5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 00:57:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:53197 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab1GHE5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 00:57:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,498,1304319600"; 
   d="scan'208,223";a="22941725"
From: "Liu, ShuoX" <shuox.liu@intel.com>
To: "Brown, Len" <len.brown@intel.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "gregkh@suse.de" <gregkh@suse.de>
CC: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 8 Jul 2011 12:57:07 +0800
Subject: [PATCH] runtime-pm: consistent utilization of deferred_resume
Thread-Topic: [PATCH] runtime-pm: consistent utilization of deferred_resume
Thread-Index: Acw9K3zX9Yrx6bTcQ9uiCoo/rZErmg==
Message-ID: <6E3BC7F7C9A4BF4286DD4C043110F30B59E040012A@shsmsx502.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 10bb3c851a0a9c9ca4d552743a371e3cfda81075 Mon Sep 17 00:00:00 2001
From: ShuoX Liu <shuox.liu@intel.com>
Date: Thu, 7 Jul 2011 15:59:06 +0800
Subject: [PATCH] runtime-pm: consistent utilization of deferred_resume

dev->power.deferred_resume is used as a bool typically, so change
one assignment to false from 0, like other places.

Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
---
 drivers/base/power/runtime.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 0d4587b..af3d1a5 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -388,7 +388,7 @@ static int rpm_suspend(struct device *dev, int rpmflags)
 	retval = rpm_callback(callback, dev);
 	if (retval) {
 		__update_runtime_status(dev, RPM_ACTIVE);
-		dev->power.deferred_resume = 0;
+		dev->power.deferred_resume = false;
 		if (retval == -EAGAIN || retval == -EBUSY)
 			dev->power.runtime_error = 0;
 		else
-- 
1.7.1


