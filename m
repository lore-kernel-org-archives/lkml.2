Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965031Ab1C3VIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:08:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:49299 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965017Ab1C3VIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411278444"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: hdegoede@redhat.com, khali@linux-fr.org, guenter.roeck@ericsson.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [184/275] hwmon/f71882fg: Set platform drvdata to NULL later
Message-Id: <20110330210707.6E9B23E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Hans de Goede <hdegoede@redhat.com>

commit d9ebaa45472c92704f4814682eec21455edcfa1f upstream.

This avoids a possible race leading to trying to dereference NULL.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/hwmon/f71882fg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/hwmon/f71882fg.c
===================================================================
--- linux-2.6.35.y.orig/drivers/hwmon/f71882fg.c	2011-03-29 22:50:48.657013408 -0700
+++ linux-2.6.35.y/drivers/hwmon/f71882fg.c	2011-03-29 23:03:02.087246763 -0700
@@ -2100,7 +2100,6 @@
 	int nr_fans = (data->type == f71882fg) ? 4 : 3;
 	u8 start_reg = f71882fg_read8(data, F71882FG_REG_START);
 
-	platform_set_drvdata(pdev, NULL);
 	if (data->hwmon_dev)
 		hwmon_device_unregister(data->hwmon_dev);
 
@@ -2167,6 +2166,7 @@
 		}
 	}
 
+	platform_set_drvdata(pdev, NULL);
 	kfree(data);
 
 	return 0;
