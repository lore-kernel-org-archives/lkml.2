Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab0IJXxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 19:53:09 -0400
Received: from ns2.cypress.com ([157.95.67.5]:33866 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038Ab0IJXxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 19:53:08 -0400
Subject: [PATCH] west bridge block fix
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Cypress
Date: Fri, 10 Sep 2010 16:52:56 -0700
Message-Id: <1284162776.16135.5.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains an update for cyasblkdev_queue.c which is needed for
the kernel update from 2.6.35 to 2.6.36.

Signed-off-by: David Cross <david.cross@cypress.com>
---
diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c linux-next-incremen/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
--- linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c	2010-09-01 15:56:46.000000000 -0700
+++ linux-next-incremen/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c	2010-09-10 13:58:24.000000000 -0700
@@ -95,7 +95,7 @@ static int cyasblkdev_prep_request(
 	DBGPRN_FUNC_NAME;
 
 	/* we only like normal block requests.*/
-	if (!blk_fs_request(req)) {
+	if (req->cmd_type != REQ_TYPE_FS && !(req->cmd_flags & REQ_DISCARD)) {
 		#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message("%s:%x bad request received\n",
 			__func__, current->pid) ;


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

