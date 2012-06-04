Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab2FDDJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 23:09:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:49323 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab2FDDJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 23:09:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="152162707"
Message-ID: <4FCC265F.5@intel.com>
Date: Mon, 04 Jun 2012 11:07:11 +0800
From: ShuoX Liu <shuox.liu@intel.com>
Reply-To: shuox.liu@intel.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Borislav Petkov <bp@alien8.de>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, andi@firstfloor.org,
        Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v4 2/2] x86 mce: use new printk recursion disabling interface
References: <4FBC444A.6060500@intel.com> <20120523100138.GA13506@x1.osrc.amd.com> <4FBDCE4A.7050900@intel.com> <20120524061145.GA18284@liondog.tnic> <20120524155611.b7aeff4d.akpm@linux-foundation.org> <1337905811.14538.206.camel@ymzhang.sh.intel.com> <4FBF3295.7090608@intel.com> <4FBF32E8.90101@intel.com> <20120525074114.GA5417@liondog.tnic> <4FC2DDFF.3020600@intel.com> <20120530090844.GA23663@liondog.tnic> <4FCC25D3.7070308@intel.com>
In-Reply-To: <4FCC25D3.7070308@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ShuoX Liu <shuox.liu@intel.com>

Disable printk recursion to make sure MCE logs printed out.

Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
---
We hit it when running a MTBF testing on a Android atom mobile.
---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 2afcbd2..906e838 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -306,6 +306,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 {
 	int i, apei_err = 0;
 
+	printk_recursion_check_disable();
 	if (!fake_panic) {
 		/*
 		 * Make sure only one CPU runs in machine check panic
@@ -360,6 +361,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 		panic(msg);
 	} else
 		pr_emerg(HW_ERR "Fake kernel panic: %s\n", msg);
+	printk_recursion_check_enable();
 }
 
 /* Support code for software error injection */
-- 
1.7.1

