Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab1G1Xod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:44:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:12959 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110Ab1G1XoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="33351999"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: anton@samba.org, benh@kernel.crashing.org, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [14/50] powerpc/pseries/hvconsole: Fix dropped console output
Message-Id: <20110728234418.8B7182403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Anton Blanchard <anton@samba.org>

[ upstream commit 51d33021425e1f905beb4208823146f2fb6517da ]

Return -EAGAIN when we get H_BUSY back from the hypervisor. This
makes the hvc console driver retry, avoiding dropped printks.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: <stable@kernel.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/arch/powerpc/platforms/pseries/hvconsole.c
===================================================================
--- linux-2.6.35.y.orig/arch/powerpc/platforms/pseries/hvconsole.c
+++ linux-2.6.35.y/arch/powerpc/platforms/pseries/hvconsole.c
@@ -73,7 +73,7 @@ int hvc_put_chars(uint32_t vtermno, cons
 	if (ret == H_SUCCESS)
 		return count;
 	if (ret == H_BUSY)
-		return 0;
+		return -EAGAIN;
 	return -EIO;
 }
 
