Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab1G1XxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:53:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:27791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090Ab1G1XoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="31552484"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: kronos.it@gmail.com, khali@linux-fr.org, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [19/50] hwmon: (asus_atk0110) Fix memory leak
Message-Id: <20110728234423.A17542403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Luca Tettamanti <kronos.it@gmail.com>

[ upstream commit 0b8e77f12cb6bfe2e5a67f2cdc8c7af23abc4ccf ]

The object returned by atk_gitm is dynamically allocated and must be
freed.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: stable@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/hwmon/asus_atk0110.c
===================================================================
--- linux-2.6.35.y.orig/drivers/hwmon/asus_atk0110.c
+++ linux-2.6.35.y/drivers/hwmon/asus_atk0110.c
@@ -655,6 +655,7 @@ static int atk_debugfs_gitm_get(void *p,
 	else
 		err = -EIO;
 
+	ACPI_FREE(ret);
 	return err;
 }
 
