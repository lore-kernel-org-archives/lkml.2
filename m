Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab1HBJqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 05:46:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab1HBJpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 05:45:38 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] xen: Fix printk() format in xen/setup.c
Date: Tue,  2 Aug 2011 11:45:24 +0200
Message-Id: <1312278325-4246-3-git-send-email-imammedo@redhat.com>
In-Reply-To: <1312278325-4246-1-git-send-email-imammedo@redhat.com>
References: <1312278325-4246-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use correct format specifier for unsigned long.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/xen/setup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 2221b05..d9eef1e 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -113,7 +113,7 @@ static unsigned long __init xen_release_chunk(phys_addr_t start_addr,
 			len++;
 		}
 	}
-	printk(KERN_CONT "%ld pages freed\n", len);
+	printk(KERN_CONT "%lu pages freed\n", len);
 
 	return len;
 }
@@ -139,7 +139,7 @@ static unsigned long __init xen_return_unused_memory(unsigned long max_pfn,
 	if (last_end < max_addr)
 		released += xen_release_chunk(last_end, max_addr);
 
-	printk(KERN_INFO "released %ld pages of unused memory\n", released);
+	printk(KERN_INFO "released %lu pages of unused memory\n", released);
 	return released;
 }
 
-- 
1.7.5

