Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab2KLVWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:22:06 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36287 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab2KLVTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:19:40 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 32/46] x86, mm: change low/hignmem_pfn_init to static on 32bit
Date: Mon, 12 Nov 2012 13:18:28 -0800
Message-Id: <1352755122-25660-33-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1352755122-25660-1-git-send-email-yinghai@kernel.org>
References: <20121112193044.GA11615@phenom.dumpdata.com>
 <1352755122-25660-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 0ae1ba8..322ee56 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -575,7 +575,7 @@ early_param("highmem", parse_highmem);
  * artificially via the highmem=x boot parameter then create
  * it:
  */
-void __init lowmem_pfn_init(void)
+static void __init lowmem_pfn_init(void)
 {
 	/* max_low_pfn is 0, we already have early_res support */
 	max_low_pfn = max_pfn;
@@ -611,7 +611,7 @@ void __init lowmem_pfn_init(void)
  * We have more RAM than fits into lowmem - we try to put it into
  * highmem, also taking the highmem=x boot parameter into account:
  */
-void __init highmem_pfn_init(void)
+static void __init highmem_pfn_init(void)
 {
 	max_low_pfn = MAXMEM_PFN;
 
-- 
1.7.7

