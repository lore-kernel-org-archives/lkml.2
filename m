Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821Ab2KVWVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:21:01 -0500
Received: from mail.kernel.org ([198.145.19.201]:49356 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539Ab2KVSi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alexander Lyakas <alex.bolshoy@gmail.com>,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 060/171] crush: fix memory leak when destroying tree buckets
Date: Wed, 21 Nov 2012 16:40:06 -0800
Message-Id: <20121122004039.391768141@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

(cherry picked from commit 6eb43f4b5a2a74599b4ff17a97c03a342327ca65)

Reflects ceph.git commit 46d63d98434b3bc9dad2fc9ab23cbaedc3bcb0e4.

Reported-by: Alexander Lyakas <alex.bolshoy@gmail.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/crush/crush.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ceph/crush/crush.c
+++ b/net/ceph/crush/crush.c
@@ -85,6 +85,8 @@ void crush_destroy_bucket_list(struct cr
 
 void crush_destroy_bucket_tree(struct crush_bucket_tree *b)
 {
+	kfree(b->h.perm);
+	kfree(b->h.items);
 	kfree(b->node_weights);
 	kfree(b);
 }


