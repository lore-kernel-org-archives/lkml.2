Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab1JKTPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 15:15:25 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:53716 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754948Ab1JKTPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 15:15:23 -0400
Message-ID: <4E9495C8.1030200@xenotime.net>
Date: Tue, 11 Oct 2011 12:15:20 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH -next] jbd2: fix build when CONFIG_BUG is not enabled
References: <20111011201127.455df266dcbffb1d621f8576@canb.auug.org.au>
In-Reply-To: <20111011201127.455df266dcbffb1d621f8576@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build error when CONFIG_BUG is not enabled:

fs/jbd2/transaction.c:1175:3: error: implicit declaration of function '__WARN'

by changing __WARN() to WARN_ON(), as suggested by
Arnaud Lacombe <lacombar@gmail.com>.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Arnaud Lacombe <lacombar@gmail.com>
---

Same build error as reported on 31-AUG-2011 for
linux-next 20110830.

 fs/jbd2/transaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- next-2011-1011.orig/fs/jbd2/transaction.c
+++ next-2011-1011/fs/jbd2/transaction.c
@@ -27,6 +27,7 @@
 #include <linux/highmem.h>
 #include <linux/hrtimer.h>
 #include <linux/backing-dev.h>
+#include <linux/bug.h>
 #include <linux/module.h>
 
 static void __jbd2_journal_temp_unlink_buffer(struct journal_head *jh);
@@ -1171,8 +1172,7 @@ out_unlock_bh:
 	jbd_unlock_bh_state(bh);
 out:
 	JBUFFER_TRACE(jh, "exit");
-	if (ret)
-		__WARN();	/* All errors are bugs, so dump the stack */
+	WARN_ON(ret);	/* All errors are bugs, so dump the stack */
 	return ret;
 }
 
