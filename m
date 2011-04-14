Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab1DNPji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:39:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32639 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab1DNPjh (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 14 Apr 2011 11:39:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/2] xen/setup: Ignore E820_UNUSABLE when setting 1-1 mappings.
Date: Thu, 14 Apr 2011 11:37:26 -0400
Message-Id: <1302795447-12685-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302795447-12685-1-git-send-email-konrad.wilk@oracle.com>
References: <1302795447-12685-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DA71534.006F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we parse the raw E820, the Xen hypervisor can set "E820_RAM"
to "E820_UNUSABLE" if the mem=X argument is used. As such we
should _not_ consider the E820_UNUSABLE as an 1-1 identity
mapping, but instead use the same case as for E820_RAM.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index fa0269a..5840af1 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -166,7 +166,7 @@ static unsigned long __init xen_set_identity(const struct e820entry *list,
 		if (last > end)
 			continue;
 
-		if (entry->type == E820_RAM) {
+		if ((entry->type == E820_RAM) || (entry->type == E820_UNUSABLE)) {
 			if (start > start_pci)
 				identity += set_phys_range_identity(
 						PFN_UP(start_pci), PFN_DOWN(start));
-- 
1.7.1

