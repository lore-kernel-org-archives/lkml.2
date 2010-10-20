Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab0JTT7C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 15:59:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:52892 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755425Ab0JTT7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 15:59:00 -0400
Date: Wed, 20 Oct 2010 19:58:41 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
In-Reply-To: <20101020103642.GA3135@kryptos.osrc.amd.com>
References: <20101020103642.GA3135@kryptos.osrc.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Fix incorrect data type in vmalloc_sync_all()
Message-ID: <tip-f01f7c56a1425b9749a99af821e1de334fb64d7e@git.kernel.org>
Git-Commit-ID: f01f7c56a1425b9749a99af821e1de334fb64d7e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Oct 2010 19:58:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f01f7c56a1425b9749a99af821e1de334fb64d7e
Gitweb:     http://git.kernel.org/tip/f01f7c56a1425b9749a99af821e1de334fb64d7e
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Tue, 19 Oct 2010 22:17:37 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 20 Oct 2010 12:54:04 -0700

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
 
