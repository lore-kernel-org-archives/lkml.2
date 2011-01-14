Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab1ANQCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 11:02:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757897Ab1ANQBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 11:01:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FS-Cache: Fix operation handling
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-cachefs@redhat.com, linux-kernel@vger.kernel.org,
        Akshat Aranya <aranya@nec-labs.com>,
        David Howells <dhowells@redhat.com>
Date: Fri, 14 Jan 2011 16:00:47 +0000
Message-ID: <20110114160047.26151.2075.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akshat Aranya <aranya@nec-labs.com>

fscache_submit_exclusive_op() adds an operation to the pending list if
other operations are pending.  Fix the check for pending ops as n_ops must be
greater than 0 at the point it is checked as it is incremented immediately
before under lock.

Signed-off-by: Akshat Aranya <aranya@nec-labs.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/operation.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
index b9f34ea..48a18f1 100644
--- a/fs/fscache/operation.c
+++ b/fs/fscache/operation.c
@@ -101,7 +101,7 @@ int fscache_submit_exclusive_op(struct fscache_object *object,
 		object->n_ops++;
 		object->n_exclusive++;	/* reads and writes must wait */
 
-		if (object->n_ops > 0) {
+		if (object->n_ops > 1) {
 			atomic_inc(&op->usage);
 			list_add_tail(&op->pend_link, &object->pending_ops);
 			fscache_stat(&fscache_n_op_pend);

