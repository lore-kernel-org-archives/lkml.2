Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab2DSHBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 03:01:31 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:32966 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab2DSHBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 03:01:25 -0400
Date: Thu, 19 Apr 2012 10:00:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Frank Arnold <frank.arnold@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] cpu: remove some dead code in store_cache_disable()
Message-ID: <20120419070053.GB16645@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090204.4F8FB82F.0039,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amd_set_l3_disable_slot() never returns -EEXIST, it only returns -EINVAL
or zero.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 73d08ed..7b4e294 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -466,12 +466,9 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 		return -EINVAL;
 
 	err = amd_set_l3_disable_slot(this_leaf->base.nb, cpu, slot, val);
-	if (err) {
-		if (err == -EEXIST)
-			printk(KERN_WARNING "L3 disable slot %d in use!\n",
-					    slot);
+	if (err)
 		return err;
-	}
+
 	return count;
 }
 
