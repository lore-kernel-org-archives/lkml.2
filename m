Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab1FATdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:33:51 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:38883 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab1FATdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:33:50 -0400
Subject: [PATCH] Use hlist_entry() for io_context.cic_list.first
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 01 Jun 2011 21:33:44 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306956828.9926.2.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

list_entry() and hlist_entry() are both simply aliases for
container_of(), but since io_context.cic_list.first is an hlist_node one
should at least use the correct alias.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 block/blk-ioc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index c898049..342eae9 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -21,7 +21,7 @@ static void cfq_dtor(struct io_context *ioc)
 	if (!hlist_empty(&ioc->cic_list)) {
 		struct cfq_io_context *cic;
 
-		cic = list_entry(ioc->cic_list.first, struct cfq_io_context,
+		cic = hlist_entry(ioc->cic_list.first, struct cfq_io_context,
 								cic_list);
 		cic->dtor(ioc);
 	}
@@ -57,7 +57,7 @@ static void cfq_exit(struct io_context *ioc)
 	if (!hlist_empty(&ioc->cic_list)) {
 		struct cfq_io_context *cic;
 
-		cic = list_entry(ioc->cic_list.first, struct cfq_io_context,
+		cic = hlist_entry(ioc->cic_list.first, struct cfq_io_context,
 								cic_list);
 		cic->exit(ioc);
 	}
-- 
1.7.5.2



