Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab2LMCFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:05:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:59521 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486Ab2LMCFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:05:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,269,1355126400"; 
   d="scan'208";a="261429964"
From: Feng Tang <feng.tang@intel.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
Cc: alek.du@intel.com, Feng Tang <feng.tang@intel.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH 3/3] rtc: Skip setting xtime if persisent clock exist
Date: Thu, 13 Dec 2012 10:05:28 +0800
Message-Id: <1355364328-19550-3-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355364328-19550-1-git-send-email-feng.tang@intel.com>
References: <1355364328-19550-1-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the timekeeping_init() already initialize the xtime with
read_persistent_clock().

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 drivers/rtc/hctosys.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/rtc/hctosys.c b/drivers/rtc/hctosys.c
index 4aa60d7..2b539cd 100644
--- a/drivers/rtc/hctosys.c
+++ b/drivers/rtc/hctosys.c
@@ -52,6 +52,10 @@ static int __init rtc_hctosys(void)
 		goto err_invalid;
 	}
 
+	/* Skip setting xtime again if persistent clock exist */
+	if (persistent_clock_exist)
+		goto skip_timeset;
+
 	rtc_tm_to_time(&tm, &tv.tv_sec);
 
 	err = do_settimeofday(&tv);
@@ -65,6 +69,7 @@ static int __init rtc_hctosys(void)
 
 err_invalid:
 err_read:
+skip_timeset:
 	rtc_class_close(rtc);
 
 err_open:
-- 
1.7.9.5

