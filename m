Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761960Ab0GUAlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 20:41:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:37940 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761940Ab0GUAlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 20:41:35 -0400
Date: Wed, 21 Jul 2010 00:41:00 GMT
From: tip-bot for Florian Zumbiehl <florz@florz.de>
Cc: linux-kernel@vger.kernel.org, florz@florz.de, hpa@zytor.com,
        mingo@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, florz@florz.de,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <201007202219.o6KMJlES021058@imap1.linux-foundation.org>
References: <201007202219.o6KMJlES021058@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, iomap: Fix wrong page aligned size calculation in ioremapping code
Message-ID: <tip-468c30f2bbdf1ba0fbf16667eade23a46eaa8f06@git.kernel.org>
Git-Commit-ID: 468c30f2bbdf1ba0fbf16667eade23a46eaa8f06
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 00:41:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  468c30f2bbdf1ba0fbf16667eade23a46eaa8f06
Gitweb:     http://git.kernel.org/tip/468c30f2bbdf1ba0fbf16667eade23a46eaa8f06
Author:     Florian Zumbiehl <florz@florz.de>
AuthorDate: Tue, 20 Jul 2010 15:19:47 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 20 Jul 2010 16:56:35 -0700

x86, iomap: Fix wrong page aligned size calculation in ioremapping code

x86 early_iounmap(): fix off-by-one error in page alignment of allocation
size for sizes where size%PAGE_SIZE==1.

Signed-off-by: Florian Zumbiehl <florz@florz.de>
LKML-Reference: <201007202219.o6KMJlES021058@imap1.linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/ioremap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index d41d3a9..3ba6e06 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -611,7 +611,7 @@ void __init early_iounmap(void __iomem *addr, unsigned long size)
 		return;
 	}
 	offset = virt_addr & ~PAGE_MASK;
-	nrpages = PAGE_ALIGN(offset + size - 1) >> PAGE_SHIFT;
+	nrpages = PAGE_ALIGN(offset + size) >> PAGE_SHIFT;
 
 	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
 	while (nrpages > 0) {
