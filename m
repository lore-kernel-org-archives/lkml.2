Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab0FRDYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 23:24:49 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35430 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183Ab0FRDYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 23:24:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C1AE6CD.1080704@jp.fujitsu.com>
Date: Fri, 18 Jun 2010 12:23:57 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
CC: matthew@wil.cx, macro@linux-mips.org, kamezawa.hiroyu@jp.fujitsu.com,
       eike-kernel@sf-tec.de, jeremy@goop.org, linux-pci@vger.kernel.org
Subject: [PATCH 2/2] x86: ioremap: fix normal ram range check
References: <4C1AE64C.6040609@jp.fujitsu.com>
In-Reply-To: <4C1AE64C.6040609@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for norma RAM in x86 ioremap() code seems to not work for the
last page frame in the specified physical address range.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 arch/x86/mm/ioremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.34/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6.34.orig/arch/x86/mm/ioremap.c
+++ linux-2.6.34/arch/x86/mm/ioremap.c
@@ -101,7 +101,7 @@ static void __iomem *__ioremap_caller(re
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
 	last_pfn = last_addr >> PAGE_SHIFT;
-	for (pfn = phys_addr >> PAGE_SHIFT; pfn < last_pfn; pfn++) {
+	for (pfn = phys_addr >> PAGE_SHIFT; pfn <= last_pfn; pfn++) {
 		int is_ram = page_is_ram(pfn);
 
 		if (is_ram && pfn_valid(pfn) && !PageReserved(pfn_to_page(pfn)))

