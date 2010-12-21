Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab0LUViI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:38:08 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25133 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab0LUViG (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 21 Dec 2010 16:38:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 09/10] xen/mmu: Be aware of p2m_[mid_|]missing when saving/restore.
Date: Tue, 21 Dec 2010 16:37:39 -0500
Message-Id: <1292967460-15709-10-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We did not consider the 1-1 mapping and during restore would
not properly deal with them.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index a917439..b2b8733 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -329,14 +329,13 @@ void xen_build_mfn_list_list(void)
 		 * they're just missing, just update the stored mfn,
 		 * since all could have changed over a migrate.
 		 */
-		if (mid == p2m_mid_identity) {
+		if (mid == p2m_mid_identity || mid == p2m_mid_missing) {
 			BUG_ON(mididx);
 			BUG_ON(mid_mfn_p != p2m_mid_identity_mfn);
 			p2m_top_mfn[topidx] = virt_to_mfn(p2m_mid_identity_mfn);
 			pfn += (P2M_MID_PER_PAGE - 1) * P2M_PER_PAGE;
 			continue;
 		}
-
 		if (mid_mfn_p == p2m_mid_identity_mfn) {
 			/*
 			 * XXX boot-time only!  We should never find
-- 
1.7.1

