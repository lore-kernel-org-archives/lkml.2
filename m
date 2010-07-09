Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab0GISby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 14:31:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:52329 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab0GISbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 14:31:52 -0400
Date: Fri, 9 Jul 2010 18:31:29 GMT
From: tip-bot for Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       kaneshige.kenji@jp.fujitsu.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, kaneshige.kenji@jp.fujitsu.com, hpa@linux.intel.com
In-Reply-To: <4C197ADF.90509@jp.fujitsu.com>
References: <4C197ADF.90509@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, ioremap: Fix normal ram range check
Message-ID: <tip-2233576bf7b5d246593c3e06cab74d879b32b949@git.kernel.org>
Git-Commit-ID: 2233576bf7b5d246593c3e06cab74d879b32b949
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 09 Jul 2010 18:31:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2233576bf7b5d246593c3e06cab74d879b32b949
Gitweb:     http://git.kernel.org/tip/2233576bf7b5d246593c3e06cab74d879b32b949
Author:     Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
AuthorDate: Thu, 17 Jun 2010 10:31:11 +0900
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 Jul 2010 10:51:56 -0700

x86, ioremap: Fix normal ram range check

Check for normal RAM in x86 ioremap() code seems to not work for the
last page frame in the specified physical address range.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
LKML-Reference: <4C197ADF.90509@jp.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/ioremap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 9c8e3a7..299e4eb 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -101,7 +101,7 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
 	last_pfn = last_addr >> PAGE_SHIFT;
-	for (pfn = phys_addr >> PAGE_SHIFT; pfn < last_pfn; pfn++) {
+	for (pfn = phys_addr >> PAGE_SHIFT; pfn <= last_pfn; pfn++) {
 		int is_ram = page_is_ram(pfn);
 
 		if (is_ram && pfn_valid(pfn) && !PageReserved(pfn_to_page(pfn)))
