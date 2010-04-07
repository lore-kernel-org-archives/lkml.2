Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab0DGOBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 10:01:08 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:44326 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab0DGOBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:01:07 -0400
Date: Wed, 7 Apr 2010 09:59:10 -0400
From: Jeff Dike <jdike@addtoit.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Xin, Xiaohui" <xiaohui.xin@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix vq_memory_access_ok error checking
Message-ID: <20100407135910.GA18268@c-98-229-117-200.hsd1.ma.comcast.net>
References: <20100406201414.GA6528@c-98-229-117-200.hsd1.ma.comcast.net> <20100407074907.GA7084@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100407074907.GA7084@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 10:49:07AM +0300, Michael S. Tsirkin wrote:
> Thanks!
> Can you add a Signed-off-by line?

Oops, I was in a hurry...

commit 7938779d9f357ede8bc3c122fd0dc9d5ec4fcf1d
Author: Jeff Dike <jdike@addtoit.com>
Date:   Wed Mar 31 15:05:08 2010 -0400

    vq_memory_access_ok needs to check whether mem == NULL

    Signed-off-by: Jeff Dike <jdike@linux.intel.com>

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
