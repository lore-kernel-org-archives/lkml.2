Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab2C3Xnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:43:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab2C3Xne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 19:43:34 -0400
Date: Fri, 30 Mar 2012 19:43:17 -0400
From: Phillip Lougher <plougher@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, Eugene Teo <eteo@redhat.com>,
        Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH] sysctl: fix restrict write access to dmesg_restrict
Message-ID: <20120330234317.GC411@lenovo-rd230-04.lab.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit bfdc0b4 adds code to restrict access to dmesg_restrict,
however, it incorrectly alters kptr_restrict rather than
dmesg_restrict.

The original patch from Richard Weinberger
(https://lkml.org/lkml/2011/3/14/362) alters dmesg_restrict as
expected, and so the patch seems to have been misapplied.

Signed-off-by: Phillip Lougher <plougher@redhat.com>
---
 kernel/sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f487f25..72a5302 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -713,7 +713,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &dmesg_restrict,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dmesg_restrict,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
@@ -722,7 +722,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &kptr_restrict,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dmesg_restrict,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
-- 
1.7.9.5

