Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab2JZEaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 00:30:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10145 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab2JZEaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 00:30:09 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-79-508a11cf7376
From: Jingoo Han <jg1.han@samsung.com>
To: "'Rafael J. Wysocki'" <rafael.j.wysocki@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Daniel Lezcano'" <daniel.lezcano@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] cpuidle: add missing header include
Date: Fri, 26 Oct 2012 13:30:07 +0900
Message-id: <001401cdb332$93ffe450$bbffacf0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2zMpPiNhRK9FVBTSyL2exRwpsmxA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsVy+t9jAd3zgl0BBtPfm1pc3jWHzeJz7xFG
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKOH5vBXrCTp2Lda+kGxstcXYwcHBICJhJf/rJ1MXIC
	mWISF+6tB7OFBBYxSuxeJ9fFyAVk/2KU2PTiFjtIgk1ATeLLl8NgtoiAmcSHzqXMIEXMAhMY
	Je4dmA2WEAYaunzfU1aQBSwCqhI/v3iAhHkFbCXa3rUxQ9iCEj8m32MBsZkFtCTW7zzOBGHL
	S2xe85YZ4jZ1iUd/dSFW6UkcObuJGaJERGLfi3eMExgFZiGZNAvJpFlIJs1C0rKAkWUVo2hq
	QXJBcVJ6rqFecWJucWleul5yfu4mRnBwPpPawbiyweIQowAHoxIPb0RKZ4AQa2JZcWXuIUYJ
	DmYlEd7dU4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZs9UgKEBNITS1KzU1MLUotgskwcnFIN
	jFFzhPzXzf36et4Ku1lqv+ZzXM38ZWYko9CXe+fLRYmzQdc3lG/dJhqw692KT6Va+eHXlGR4
	D+dVX4stOx7K+6Vt+YmKkEMv/z8oCVDedDdw973XF84s0FwvIF+qcezHsslZ3QpJoTtkLs6Z
	2DnnpbdMyvKDTl8myq2yfv1lkW17+iNGlUWTf+sqsRRnJBpqMRcVJwIAQxdRlEoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing device.h header to fix build warnings as below:

drivers/cpuidle/cpuidle.h:26:41: warning: 'struct device' declared inside parameter list [enabled by default]
drivers/cpuidle/cpuidle.h:26:41: warning: its scope is only this definition or declaration, which is probably not what you want
[enabled by default]
drivers/cpuidle/cpuidle.h:27:45: warning: 'struct device' declared inside parameter list [enabled by default]
In file included from drivers/cpuidle/driver.c:15:0:
drivers/cpuidle/cpuidle.h:26:41: warning: 'struct device' declared inside parameter list [enabled by default]
drivers/cpuidle/cpuidle.h:26:41: warning: its scope is only this definition or declaration, which is probably not what you want
[enabled by default]
drivers/cpuidle/cpuidle.h:27:45: warning: 'struct device' declared inside parameter list [enabled by default]

This build warning is introduced by commit efeca1b
"cpuidle / sysfs: change function parameter".

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/cpuidle/cpuidle.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
index a5bbd1c..2120d9e 100644
--- a/drivers/cpuidle/cpuidle.h
+++ b/drivers/cpuidle/cpuidle.h
@@ -5,6 +5,8 @@
 #ifndef __DRIVER_CPUIDLE_H
 #define __DRIVER_CPUIDLE_H
 
+#include <linux/device.h>
+
 /* For internal use only */
 extern struct cpuidle_governor *cpuidle_curr_governor;
 extern struct list_head cpuidle_governors;
-- 
1.7.1


