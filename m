Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab0LHAsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:48:31 -0500
Received: from kroah.org ([198.145.64.141]:58761 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343Ab0LHAsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:48:25 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:36 2010
Message-Id: <20101208004436.717522477@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:45:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>
Subject: [124/127] UV - XPC: pass nasid instead of nid to gru_create_message_queue
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Robin Holt <holt@sgi.com>

commit 57e6d258b1e41cd7ceb26fa43ce116939d8440b1 upstream.

Currently, the UV xpc code is passing nid to the gru_create_message_queue
instead of nasid as it expects.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/sgi-xp/xpc_uv.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -203,6 +203,7 @@ xpc_create_gru_mq_uv(unsigned int mq_siz
 	enum xp_retval xp_ret;
 	int ret;
 	int nid;
+	int nasid;
 	int pg_order;
 	struct page *page;
 	struct xpc_gru_mq_uv *mq;
@@ -258,9 +259,11 @@ xpc_create_gru_mq_uv(unsigned int mq_siz
 		goto out_5;
 	}
 
+	nasid = UV_PNODE_TO_NASID(uv_cpu_to_pnode(cpu));
+
 	mmr_value = (struct uv_IO_APIC_route_entry *)&mq->mmr_value;
 	ret = gru_create_message_queue(mq->gru_mq_desc, mq->address, mq_size,
-				       nid, mmr_value->vector, mmr_value->dest);
+				     nasid, mmr_value->vector, mmr_value->dest);
 	if (ret != 0) {
 		dev_err(xpc_part, "gru_create_message_queue() returned "
 			"error=%d\n", ret);


