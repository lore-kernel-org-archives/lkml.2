Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab0I1QzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:55:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56586 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849Ab0I1QzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:55:20 -0400
Date: Tue, 28 Sep 2010 09:53:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org
Subject: [PATCH -next] ceph: fix debugfs warnings
Message-Id: <20100928095310.2983a888.randy.dunlap@oracle.com>
In-Reply-To: <20100928141823.8c61000e.sfr@canb.auug.org.au>
References: <20100928141823.8c61000e.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Include "super.h" outside of CONFIG_DEBUG_FS to eliminate a compiler warning:

fs/ceph/debugfs.c:266: warning: 'struct ceph_fs_client' declared inside parameter list
fs/ceph/debugfs.c:266: warning: its scope is only this definition or declaration, which is probably not what you want
fs/ceph/debugfs.c:271: warning: 'struct ceph_fs_client' declared inside parameter list

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/ceph/debugfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20100927.orig/fs/ceph/debugfs.c
+++ linux-next-20100927/fs/ceph/debugfs.c
@@ -12,9 +12,10 @@
 #include <linux/ceph/auth.h>
 #include <linux/ceph/debugfs.h>
 
+#include "super.h"
+
 #ifdef CONFIG_DEBUG_FS
 
-#include "super.h"
 #include "mds_client.h"
 
 static int mdsmap_show(struct seq_file *s, void *p)
