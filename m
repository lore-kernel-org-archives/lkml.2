Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab0LXRyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 12:54:20 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:34300 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab0LXRyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 12:54:19 -0500
Date: Fri, 24 Dec 2010 09:52:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org, Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH -mmotm] kptr_restrict: fix build when PRINTK not enabled
Message-Id: <20101224095226.2129fa9c.randy.dunlap@oracle.com>
In-Reply-To: <201012240132.oBO1W8Ub022207@imap1.linux-foundation.org>
References: <201012240132.oBO1W8Ub022207@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

#include <linux/printk.h> since that is where kptr_restrict is externed.

Put kptr_restrict inside #ifdef CONFIG_PRINTK block to fix build error
when CONFIG_PRINTK is not enabled:

kernel/sysctl.c:712: error: 'kptr_restrict' undeclared here (not in a function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>
---
 kernel/sysctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- mmotm-2010-1223-1658.orig/kernel/sysctl.c
+++ mmotm-2010-1223-1658/kernel/sysctl.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/sysctl.h>
 #include <linux/signal.h>
+#include <linux/printk.h>
 #include <linux/proc_fs.h>
 #include <linux/security.h>
 #include <linux/ctype.h>
@@ -706,7 +707,6 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
-#endif
 	{
 		.procname	= "kptr_restrict",
 		.data		= &kptr_restrict,
@@ -716,6 +716,7 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
+#endif
 	{
 		.procname	= "ngroups_max",
 		.data		= &ngroups_max,



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
