Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab0DFUOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 16:14:41 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:37694 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab0DFUOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 16:14:35 -0400
Date: Tue, 6 Apr 2010 16:14:14 -0400
From: Jeff Dike <jdike@addtoit.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Xin, Xiaohui" <xiaohui.xin@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix vq_memory_access_ok error checking
Message-ID: <20100406201414.GA6528@c-98-229-117-200.hsd1.ma.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's another small patch fixing an error path...

			Jeff

-- 
Work email - jdike at linux dot intel dot com


commit 7938779d9f357ede8bc3c122fd0dc9d5ec4fcf1d
Author: Jeff Dike <jdike@addtoit.com>
Date:   Wed Mar 31 15:05:08 2010 -0400

    vq_memory_access_ok needs to check whether mem == NULL

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 7bd7a1e..b8e1127 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -235,6 +235,10 @@ static int vq_memory_access_ok(void __user *log_base, struct vhost_memory *mem,
 			       int log_all)
 {
 	int i;
+
+        if (!mem)
+                return 0;
+
 	for (i = 0; i < mem->nregions; ++i) {
 		struct vhost_memory_region *m = mem->regions + i;
 		unsigned long a = m->userspace_addr;
