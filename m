Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab2DRLuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 07:50:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38065 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab2DRLuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 07:50:06 -0400
Date: Wed, 18 Apr 2012 04:49:34 -0700
From: tip-bot for Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <tip-3340808cf04faad7b87d6c6e13800825e5552b51@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, dan.carpenter@oracle.com
In-Reply-To: <20120418112810.GA2669@elgon.mountain>
References: <20120418112810.GA2669@elgon.mountain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/debugobjects] debugobjects: Fill_pool() returns void now
Git-Commit-ID: 3340808cf04faad7b87d6c6e13800825e5552b51
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 18 Apr 2012 04:49:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3340808cf04faad7b87d6c6e13800825e5552b51
Gitweb:     http://git.kernel.org/tip/3340808cf04faad7b87d6c6e13800825e5552b51
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Wed, 18 Apr 2012 14:28:10 +0300
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 18 Apr 2012 13:38:48 +0200

debugobjects: Fill_pool() returns void now

There was a return missed in 1fda107d44 "debugobjects: Remove unused
return value from fill_pool()".  It makes gcc complain:

	lib/debugobjects.c: In function ‘fill_pool’:
	lib/debugobjects.c:98:4: warning: ‘return’ with a value, in
		function returning void [enabled by default]

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: http://lkml.kernel.org/r/20120418112810.GA2669@elgon.mountain
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 lib/debugobjects.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
