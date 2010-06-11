Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385Ab0FKJVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 05:21:32 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39322 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab0FKJVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 05:21:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C11FFF6.8040406@jp.fujitsu.com>
Date: Fri, 11 Jun 2010 18:20:54 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
CC: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: [PATCH 3/4] x86: ioremap: remove physical address warning message
References: <4C11FF10.4060203@jp.fujitsu.com>
In-Reply-To: <4C11FF10.4060203@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current ioremap() code for x86 displays warning message if too high
address to handle is passed. But this can happen as usual cases. For
example, if 64-bit BAR is assigned to a PCI device and its device
driver calls pci_iomap(). So this patch changes the warning messages
as follows.

- Change printk message from KERN_WARNING to KERN_DEBUG
- Remove WARN_ON_ONCE()

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 arch/x86/mm/ioremap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.34/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6.34.orig/arch/x86/mm/ioremap.c	2010-06-10 07:28:31.966187993 +0900
+++ linux-2.6.34/arch/x86/mm/ioremap.c	2010-06-10 07:28:33.146375380 +0900
@@ -78,9 +78,8 @@
 		return NULL;
 
 	if (!phys_addr_valid(phys_addr)) {
-		printk(KERN_WARNING "ioremap: invalid physical address %llx\n",
+		printk(KERN_DEBUG "ioremap: can't map physical address %llx\n",
 		       (unsigned long long)phys_addr);
-		WARN_ON_ONCE(1);
 		return NULL;
 	}
 


