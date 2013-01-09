Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab3AIUgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:36:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:41097 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932778Ab3AIUgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:36:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [ 009/123] arm64: Make !dirty ptes read-only
Date: Wed,  9 Jan 2013 12:34:08 -0800
Message-Id: <20130109201459.702213124@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 33eaa58f854770dc9c98411a356c98e3a53edfda upstream.

The AArch64 Linux port relies on the mm code to wrprotect clean ptes.
This however is not the case with newly created ptes and
PAGE_SHARED(_EXEC) is writable but !dirty.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/pgtable.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -159,6 +159,8 @@ static inline void set_pte_at(struct mm_
 {
 	if (pte_present_exec_user(pte))
 		__sync_icache_dcache(pte, addr);
+	if (!pte_dirty(pte))
+		pte = pte_wrprotect(pte);
 	set_pte(ptep, pte);
 }
 


