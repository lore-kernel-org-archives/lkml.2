Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab1BBBKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:10:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:10973 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab1BBAnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028255"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: gorlik@penguintown.net, khali@linux-fr.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [16/139] hwmon: (adm1026) Allow 1 as a valid divider value
Message-Id: <20110202004330.8F3E13E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Gabriele Gorla <gorlik@penguintown.net>

commit 8b0f1840a46449e1946fc88860ef3ec8d6b1c2c7 upstream.

Allow 1 as a valid div value as specified in the ADM1026 datasheet.

Signed-off-by: Gabriele Gorla <gorlik@penguintown.net>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/hwmon/adm1026.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6.35.y/drivers/hwmon/adm1026.c
===================================================================
--- linux-2.6.35.y.orig/drivers/hwmon/adm1026.c
+++ linux-2.6.35.y/drivers/hwmon/adm1026.c
@@ -920,9 +920,7 @@ static ssize_t set_fan_div(struct device
 
 	val = simple_strtol(buf, NULL, 10);
 	new_div = DIV_TO_REG(val);
-	if (new_div == 0) {
-		return -EINVAL;
-	}
+
 	mutex_lock(&data->update_lock);
 	orig_div = data->fan_div[nr];
 	data->fan_div[nr] = DIV_FROM_REG(new_div);
