Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab1EYVim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:38:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48918 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab1EYVil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:38:41 -0400
From: Konrad@dumpdata.com, Rzeszutek@dumpdata.com, Wilk@dumpdata.com
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/2] xen/setup: Ignore E820_UNUSABLE when setting 1-1 mappings.
Date: Wed, 25 May 2011 17:37:35 -0400
Message-Id: <1306359456-3627-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306359456-3627-1-git-send-email-konrad.wilk@oracle.com>
References: <1306359456-3627-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DDD76B5.00D0,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

When we parse the raw E820, the Xen hypervisor can set "E820_RAM"
to "E820_UNUSABLE" if the mem=X argument is used. As such we
should _not_ consider the E820_UNUSABLE as an 1-1 identity
mapping, but instead use the same case as for E820_RAM.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 90bac0a..fba4a6c 100644
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
1.7.4.1

