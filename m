Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab0LLXqM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:46:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35881 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab0LLXqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:09 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: khali@linux-fr.org, djwong@us.ibm.com, guenter.roeck@ericsson.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [69/223] hwmon: (lm85) Fix ADT7468 frequency table
Message-Id: <20101212234607.A15CCB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jean Delvare <khali@linux-fr.org>

commit fa7a5797e57d2ed71f9a6fb44f0ae42c2d7b74b7 upstream.

The ADT7468 uses the same frequency table as the ADT7463.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Darrick J. Wong <djwong@us.ibm.com>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/hwmon/lm85.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/hwmon/lm85.c
===================================================================
--- linux.orig/drivers/hwmon/lm85.c
+++ linux/drivers/hwmon/lm85.c
@@ -1259,6 +1259,7 @@ static int lm85_probe(struct i2c_client
 	switch (data->type) {
 	case adm1027:
 	case adt7463:
+	case adt7468:
 	case emc6d100:
 	case emc6d102:
 		data->freq_map = adm1027_freq_map;
