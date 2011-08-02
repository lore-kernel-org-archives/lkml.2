Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab1HBJqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 05:46:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab1HBJph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 05:45:37 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] xen: off by one error in xen/setup.c
Date: Tue,  2 Aug 2011 11:45:23 +0200
Message-Id: <1312278325-4246-2-git-send-email-imammedo@redhat.com>
In-Reply-To: <1312278325-4246-1-git-send-email-imammedo@redhat.com>
References: <1312278325-4246-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not try to initialize pfn beyond of available address space.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/xen/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 60aeeb5..2221b05 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -69,7 +69,7 @@ static void __init xen_add_extra_mem(unsigned long pages)
 
 	xen_max_p2m_pfn = PFN_DOWN(extra_start + size);
 
-	for (pfn = PFN_DOWN(extra_start); pfn <= xen_max_p2m_pfn; pfn++)
+	for (pfn = PFN_DOWN(extra_start); pfn < xen_max_p2m_pfn; ++pfn)
 		__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
 }
 
-- 
1.7.5

