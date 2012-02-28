Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030235Ab2B1SvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 13:51:06 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:34829 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030223Ab2B1SvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 13:51:02 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH trivial next 8/9] staging: ramster: Use vsprintf extention %pf with builtin_return_address
Date: Tue, 28 Feb 2012 10:49:37 -0800
Message-Id: <f92c6a1e643f30ad8d92ba95a0017a1865fae8c8.1330454853.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1330454853.git.joe@perches.com>
References: <cover.1330454853.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emit the function name not the address when possible.

builtin_return_address() gives an address.  When building
a kernel with CONFIG_KALLSYMS, emit the actual function
name not the address.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/ramster/cluster/heartbeat.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ramster/cluster/heartbeat.c b/drivers/staging/ramster/cluster/heartbeat.c
index 0020949..fe1db52 100644
--- a/drivers/staging/ramster/cluster/heartbeat.c
+++ b/drivers/staging/ramster/cluster/heartbeat.c
@@ -398,7 +398,7 @@ int r2hb_register_callback(const char *region_uuid,
 	up_write(&r2hb_callback_sem);
 	ret = 0;
 out:
-	mlog(ML_CLUSTER, "returning %d on behalf of %p for funcs %p\n",
+	mlog(ML_CLUSTER, "returning %d on behalf of %pf for funcs %pf\n",
 	     ret, __builtin_return_address(0), hc);
 	return ret;
 }
@@ -409,7 +409,7 @@ void r2hb_unregister_callback(const char *region_uuid,
 {
 	BUG_ON(hc->hc_magic != R2HB_CB_MAGIC);
 
-	mlog(ML_CLUSTER, "on behalf of %p for funcs %p\n",
+	mlog(ML_CLUSTER, "on behalf of %pf for funcs %pf\n",
 	     __builtin_return_address(0), hc);
 
 	/* XXX Can this happen _with_ a region reference? */
-- 
1.7.8.111.gad25c.dirty

