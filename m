Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab2JBIen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:34:43 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42824 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab2JBIek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:34:40 -0400
Date: Tue, 2 Oct 2012 11:34:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Shai Fultheim <shai@scalemp.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] x86/cache_info: use ARRAY_SIZE() in amd_l3_attrs()
Message-ID: <20121002083409.GM12398@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using ARRAY_SIZE() is more readable.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 9a7c90d..93c5451 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -991,7 +991,7 @@ static struct attribute ** __cpuinit amd_l3_attrs(void)
 	if (attrs)
 		return attrs;
 
-	n = sizeof (default_attrs) / sizeof (struct attribute *);
+	n = ARRAY_SIZE(default_attrs);
 
 	if (amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
 		n += 2;
