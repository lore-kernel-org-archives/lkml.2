Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab2LRHQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 02:16:25 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30214 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2LRHQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 02:16:24 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v7 03/27] x86, realmode: set real_mode permissions early
Date: Mon, 17 Dec 2012 23:15:35 -0800
Message-Id: <1355814959-10573-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to set trampoline code to EXEC early before we do smp
AP bootings.

Found the problem after switching to #PF handler set page table.

Change to use  early_initcall instead.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/realmode/init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 8045026..0b7e840 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -111,5 +111,4 @@ static int __init set_real_mode_permissions(void)
 
 	return 0;
 }
-
-arch_initcall(set_real_mode_permissions);
+early_initcall(set_real_mode_permissions);
-- 
1.7.10.4

