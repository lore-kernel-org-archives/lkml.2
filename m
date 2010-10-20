Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab0JTTbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 15:31:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:37282 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab0JTTbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 15:31:36 -0400
Date: Wed, 20 Oct 2010 19:31:14 GMT
From: tip-bot for tip-bot for Jeremy Fitzhardinge 
	<jeremy.fitzhardinge@citrix.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com,
        jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com, borislav.petkov@amd.com
In-Reply-To: <20101020103642.GA3135@kryptos.osrc.amd.com>
References: <20101020103642.GA3135@kryptos.osrc.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Fix incorrect data type in vmalloc_sync_all()
Message-ID: <tip-bfac67208d6d2a84fe7980187d3d2f21424dde59@git.kernel.org>
Git-Commit-ID: bfac67208d6d2a84fe7980187d3d2f21424dde59
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Oct 2010 19:31:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bfac67208d6d2a84fe7980187d3d2f21424dde59
Gitweb:     http://git.kernel.org/tip/bfac67208d6d2a84fe7980187d3d2f21424dde59
Author:     tip-bot for Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
AuthorDate: Tue, 19 Oct 2010 22:17:37 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 20 Oct 2010 11:53:10 -0700

x86, mm: Fix incorrect data type in vmalloc_sync_all()

arch/x86/mm/fault.c: In function 'vmalloc_sync_all':
arch/x86/mm/fault.c:238: warning: assignment makes integer from pointer without a cast

introduced by 617d34d9e5d8326ec8f188c616aa06ac59d083fe.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20101020103642.GA3135@kryptos.osrc.amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/fault.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 6c27c39..0cdb8d4 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -230,7 +230,7 @@ void vmalloc_sync_all(void)
 		spin_lock_irqsave(&pgd_lock, flags);
 		list_for_each_entry(page, &pgd_list, lru) {
 			spinlock_t *pgt_lock;
-			int ret;
+			pmd_t *ret;
 
 			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
 
