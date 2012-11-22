Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab2KVWSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:18:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:49364 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566Ab2KVSid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Zheng Yan <zheng.z.yan@intel.com>, Alex Elder <elder@inktank.com>
Subject: [ 085/171] rbd: Clear ceph_msg->bio_iter for retransmitted message
Date: Wed, 21 Nov 2012 16:40:31 -0800
Message-Id: <20121122004041.901216074@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Yan, Zheng" <zheng.z.yan@intel.com>

(cherry picked from commit 43643528cce60ca184fe8197efa8e8da7c89a037)
(cherry picked from commit b132cf4c733f91bb4dd2277ea049243cf16e8b66)

The bug can cause NULL pointer dereference in write_partial_msg_pages

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -563,6 +563,10 @@ static void prepare_write_message(struct
 		m->hdr.seq = cpu_to_le64(++con->out_seq);
 		m->needs_out_seq = false;
 	}
+#ifdef CONFIG_BLOCK
+	else
+		m->bio_iter = NULL;
+#endif
 
 	dout("prepare_write_message %p seq %lld type %d len %d+%d+%d %d pgs\n",
 	     m, con->out_seq, le16_to_cpu(m->hdr.type),


