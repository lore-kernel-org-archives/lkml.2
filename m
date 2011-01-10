Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1AJSFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:05:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab1AJSFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:05:05 -0500
Date: Mon, 10 Jan 2011 19:04:25 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH -mm] fix powerpc/sparc build
Message-ID: <20110110180425.GK9506@random.random>
References: <201101070014.p070Egpo023959@imap1.linux-foundation.org>
 <20110108104208.ca085298.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110108104208.ca085298.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This would become
thp-add-pmd-mangling-generic-functions-fix-pgtableh-build-for-um-2.patch

=====
Subject: thp: build fix for pmdp_get_and_clear

From: Andrea Arcangeli <aarcange@redhat.com>

__pmd should return a valid pmd_t for every arch.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---


diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -93,7 +93,7 @@ static inline pmd_t pmdp_get_and_clear(s
 				       pmd_t *pmdp)
 {
 	BUG();
-	return (pmd_t){ 0 };
+	return __pmd(0);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif

