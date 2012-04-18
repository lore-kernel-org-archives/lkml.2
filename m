Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab2DRL2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 07:28:32 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20170 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2DRL2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 07:28:30 -0400
Date: Wed, 18 Apr 2012 14:28:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] debugobjects: fill_pool() returns void now
Message-ID: <20120418112810.GA2669@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F8EA552.005D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a return missed in 1fda107d44 "debugobjects: Remove unused
return value from fill_pool()".  It makes gcc complain:

	lib/debugobjects.c: In function ‘fill_pool’:
	lib/debugobjects.c:98:4: warning: ‘return’ with a value, in
		function returning void [enabled by default]

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 1b6c00a..d11808c 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -95,7 +95,7 @@ static void fill_pool(void)
 
 		new = kmem_cache_zalloc(obj_cache, gfp);
 		if (!new)
-			return obj_pool_free;
+			return;
 
 		raw_spin_lock_irqsave(&pool_lock, flags);
 		hlist_add_head(&new->node, &obj_pool);
