Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab2LTTRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:17:23 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21719 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab2LTTOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:14:16 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Cliff Wickman <cpw@sgi.com>, Alex Shi <alex.shi@intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch/x86/platform/uv: use ARRAY_SIZE where possible
Date: Thu, 20 Dec 2012 14:11:34 -0500
Message-Id: <1356030701-16284-26-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 arch/x86/platform/uv/tlb_uv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index dbbdca5..0f92173 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1467,7 +1467,7 @@ static ssize_t ptc_proc_write(struct file *file, const char __user *user,
 	}
 
 	if (input_arg == 0) {
-		elements = sizeof(stat_description)/sizeof(*stat_description);
+		elements = ARRAY_SIZE(stat_description);
 		printk(KERN_DEBUG "# cpu:      cpu number\n");
 		printk(KERN_DEBUG "Sender statistics:\n");
 		for (i = 0; i < elements; i++)
@@ -1508,7 +1508,7 @@ static int parse_tunables_write(struct bau_control *bcp, char *instr,
 	char *q;
 	int cnt = 0;
 	int val;
-	int e = sizeof(tunables) / sizeof(*tunables);
+	int e = ARRAY_SIZE(tunables);
 
 	p = instr + strspn(instr, WHITESPACE);
 	q = p;
-- 
1.8.0

