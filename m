Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab0GXJO2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 05:14:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:36763 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577Ab0GXJO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 05:14:26 -0400
Message-ID: <4C4AAEE9.8050903@kernel.org>
Date: Sat, 24 Jul 2010 11:14:17 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH wq#for-next] fscache: fix build on !CONFIG_SYSCTL
References: <20100723164931.7bf2160f.sfr@canb.auug.org.au> <20100723090831.6af4a288.randy.dunlap@oracle.com>
In-Reply-To: <20100723090831.6af4a288.randy.dunlap@oracle.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 24 Jul 2010 09:14:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8b8edefa (fscache: convert object to use workqueue instead of
slow-work) made fscache_exit() call unregister_sysctl_table()
unconditionally breaking build when sysctl is disabled.  Fix it by
putting it inside CONFIG_SYSCTL.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Howells <dhowells@redhat.com>
---
This should fix it.  Thanks.

 fs/fscache/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index 500936d..f9d8567 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -186,7 +186,9 @@ static void __exit fscache_exit(void)

 	kobject_put(fscache_root);
 	kmem_cache_destroy(fscache_cookie_jar);
+#ifdef CONFIG_SYSCTL
 	unregister_sysctl_table(fscache_sysctl_header);
+#endif
 	fscache_proc_cleanup();
 	destroy_workqueue(fscache_op_wq);
 	destroy_workqueue(fscache_object_wq);
-- 
1.7.1

