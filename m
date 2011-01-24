Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab1AXM1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 07:27:06 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40898 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1AXM1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 07:27:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=cAT2nckWjjg0HmXcp4Gp4RYegQiyzz9XDvIaJCQO+GrEfQ7CsMqaLBoQtGngd21daJ
         SvoRWfOjicUJpfmeadAdWWalNfGN0VRCUC3QCqm4xJZx+FdL7uPonSdCbezaZ9M9Zl9r
         ReeNPmlLxrDrWq8hcwiuMpz7HdRmX6GlNJZm4=
Date: Mon, 24 Jan 2011 21:08:13 +0900
From: Yoichi Yuasa <yuasa@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: yuasa@linux-mips.org, linux-mips <linux-mips@linux-mips.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fix build error when CONFIG_SWAP is not set
Message-Id: <20110124210813.ba743fc5.yuasa@linux-mips.org>
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In file included from
linux-2.6/arch/mips/include/asm/tlb.h:21,
                 from mm/pgtable-generic.c:9:
include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
include/asm-generic/tlb.h:76: error: implicit declaration of function
'release_pages'
include/asm-generic/tlb.h: In function 'tlb_remove_page':
include/asm-generic/tlb.h:105: error: implicit declaration of function
'page_cache_release'
make[1]: *** [mm/pgtable-generic.o] Error 1

Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
---
 include/linux/swap.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4d55932..92c1be6 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -8,6 +8,7 @@
 #include <linux/memcontrol.h>
 #include <linux/sched.h>
 #include <linux/node.h>
+#include <linux/pagemap.h>
 
 #include <asm/atomic.h>
 #include <asm/page.h>
-- 
1.7.3.5

