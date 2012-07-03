Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab2GCPsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 11:48:51 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48584 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab2GCPsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 11:48:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/4] xen/p2m: Optimize the get_phys_to_machine function a bit.
Date: Tue,  3 Jul 2012 11:40:35 -0400
Message-Id: <1341330038-21686-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1341330038-21686-1-git-send-email-konrad.wilk@oracle.com>
References: <1341330038-21686-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running perf tells me that the check for p2m_identity
is done a lot - more than it should.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/p2m.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 64effdc..161bcdc 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -406,7 +406,7 @@ unsigned long get_phys_to_machine(unsigned long pfn)
 	 * and in p2m_*missing, so returning the INVALID_P2M_ENTRY
 	 * would be wrong.
 	 */
-	if (p2m_top[topidx][mididx] == p2m_identity)
+	if (unlikely(p2m_top[topidx][mididx] == p2m_identity))
 		return IDENTITY_FRAME(pfn);
 
 	return p2m_top[topidx][mididx][idx];
-- 
1.7.7.6

