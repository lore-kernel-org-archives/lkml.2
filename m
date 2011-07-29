Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab1G2Pq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 11:46:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab1G2Pq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 11:46:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] frv: remove unnecessary code
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Greg Dietsche <Gregory.Dietsche@cuw.edu>,
        David Howells <dhowells@redhat.com>
Date: Fri, 29 Jul 2011 16:46:16 +0100
Message-ID: <20110729154616.24424.8362.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Dietsche <Gregory.Dietsche@cuw.edu>

remove unnecessary code that matches this coccinelle pattern
	if (...)
		return ret;
	return ret;

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/mm/pgalloc.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)


diff --git a/arch/frv/mm/pgalloc.c b/arch/frv/mm/pgalloc.c
index c42c83d..4fb63a3 100644
--- a/arch/frv/mm/pgalloc.c
+++ b/arch/frv/mm/pgalloc.c
@@ -133,13 +133,7 @@ void pgd_dtor(void *pgd)
 
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	pgd_t *pgd;
-
-	pgd = quicklist_alloc(0, GFP_KERNEL, pgd_ctor);
-	if (!pgd)
-		return pgd;
-
-	return pgd;
+	return quicklist_alloc(0, GFP_KERNEL, pgd_ctor);
 }
 
 void pgd_free(struct mm_struct *mm, pgd_t *pgd)

