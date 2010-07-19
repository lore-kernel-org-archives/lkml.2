Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936261Ab0GSPbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 11:31:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936185Ab0GSPbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 11:31:38 -0400
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: [PATCH v5 05/12] Export __get_user_pages_fast.
Date: Mon, 19 Jul 2010 18:30:55 +0300
Message-Id: <1279553462-7036-6-git-send-email-gleb@redhat.com>
In-Reply-To: <1279553462-7036-1-git-send-email-gleb@redhat.com>
References: <1279553462-7036-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM will use it to try and find a page without falling back to slow
gup. That is why get_user_pages_fast() is not enough.

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/mm/gup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 738e659..a4ce19f 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -8,6 +8,7 @@
 #include <linux/mm.h>
 #include <linux/vmstat.h>
 #include <linux/highmem.h>
+#include <linux/module.h>
 
 #include <asm/pgtable.h>
 
@@ -274,6 +275,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 
 	return nr;
 }
+EXPORT_SYMBOL_GPL(__get_user_pages_fast);
 
 /**
  * get_user_pages_fast() - pin user pages in memory
-- 
1.7.1

