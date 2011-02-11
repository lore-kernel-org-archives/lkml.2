Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab1BKVpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 16:45:09 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12174 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154Ab1BKVpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 16:45:06 -0500
Date: Fri, 11 Feb 2011 22:43:57 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-rdma@vger.kernel.org, Eli Cohen <eli@mellanox.co.il>,
        Julia Lawall <julia@diku.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Sean Hefty <sean.hefty@intel.com>, Roland Dreier <roland@kernel.org>
Subject: [PATCH][RFC] infiniband: Fix allocation size in
 register_snoop_agent()
Message-ID: <alpine.LNX.2.00.1102112237490.16994@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, someone needs to double check me on this before merging anything, but 
don't we want to allocate sizeof(struct ib_mad_snoop_private) here, rather 
than just the size of a pointer to the struct?

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 mad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

 compile tested only. no hardware available for proper test.

diff --git 
a/drivers/infiniband/core/mad.c 
b/drivers/infiniband/core/mad.c
index 822cfdc..2c74b85 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -413,7 +413,7 @@ static int register_snoop_agent(struct ib_mad_qp_info *qp_info,
 	if (i == qp_info->snoop_table_size) {
 		/* Grow table. */
 		new_snoop_table = krealloc(qp_info->snoop_table,
-					   sizeof mad_snoop_priv *
+					   sizeof(struct ib_mad_snoop_private) *
 					   (qp_info->snoop_table_size + 1),
 					   GFP_ATOMIC);
 		if (!new_snoop_table) {


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

