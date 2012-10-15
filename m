Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab2JOOPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:15:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41463 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab2JOOPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:15:22 -0400
From: Nishanth Menon <nm@ti.com>
To: <linux-pm@vger.kernel.org>
CC: Nishanth Menon <nm@ti.com>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] PM / devfreq: make devfreq_class static
Date: Mon, 15 Oct 2012 09:15:13 -0500
Message-ID: <1350310513-27682-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devfreq_class is used internally by devfreq and has no
need to be globally available.

This also fixes the following sparse warning:
drivers/devfreq/devfreq.c:30:14: warning: symbol 'devfreq_class' was not declared. Should it be static?

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@ti.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/devfreq/devfreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 9f562ae..964e08d 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -27,7 +27,7 @@
 #include <linux/hrtimer.h>
 #include "governor.h"
 
-struct class *devfreq_class;
+static struct class *devfreq_class;
 
 /*
  * devfreq_work periodically monitors every registered device.
-- 
1.7.9.5

