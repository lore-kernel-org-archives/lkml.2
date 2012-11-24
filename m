Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab2KXQ6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 11:58:54 -0500
Received: from mail.ddl.dyc.edu ([67.151.215.230]:54983 "EHLO ddl.dyc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab2KXQ6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 11:58:52 -0500
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Nov 2012 11:58:52 EST
From: "Anthony G. Basile" <basile@opensource.dyc.edu>
To: linux-kernel@vger.kernel.org
Cc: rob@landley.net, jj@chaosbits.net, jkosina@suse.cz,
        linux-doc@vger.kernel.org, embedded@gentoo.org, kernel@gentoo.org,
        "Anthony G. Basile" <basile@opensource.dyc.edu>
Subject: [PATCH] Remove unnecessary declarations from Documentation/accounting/getdelays.c
Date: Sat, 24 Nov 2012 11:54:24 -0500
Message-Id: <1353776064-25815-1-git-send-email-basile@opensource.dyc.edu>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Anthony G. Basile" <basile@opensource.dyc.edu>

stime and utime are declared __u64 but are never used.  On a glibc system
this is harmless lint, but on a uClibc system, because of the difference
in they way header files stack, including stdio.h brings in time.h and
this causes a name collision with stime.  Since these are useless anyhow,
we remove them.

Signed-off-by: Anthony G. Basile <basile@opensource.dyc.edu>
---
 Documentation/accounting/getdelays.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index 6f706ac..f8ebcde 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -51,7 +51,6 @@ int dbg;
 int print_delays;
 int print_io_accounting;
 int print_task_context_switch_counts;
-__u64 stime, utime;
 
 #define PRINTF(fmt, arg...) {			\
 	    if (dbg) {				\
-- 
1.7.6.1

