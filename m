Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933394Ab0KQBCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:02:34 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26660 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932835Ab0KQBCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:02:33 -0500
Date: Tue, 16 Nov 2010 17:00:05 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, axboe@kernel.dk
Subject: [PATCH] cciss: fix build for PROC_FS disabled
Message-Id: <20101116170005.2646f4fb.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTimYevUOSxDm+nGq_ctPEFp_E2zJR7rNGvUi2fWY@mail.gmail.com>
References: <AANLkTimYevUOSxDm+nGq_ctPEFp_E2zJR7rNGvUi2fWY@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix cciss driver for CONFIG_PROC_FS not enabled:

drivers/block/cciss.c:4929: error: 'proc_cciss' undeclared (first use in this function)

The recent patch (which I acked) did not handle this configuration.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/block/cciss.c |    2 ++
 1 file changed, 2 insertions(+)

--- lnx-2637-rc2.orig/drivers/block/cciss.c
+++ lnx-2637-rc2/drivers/block/cciss.c
@@ -4926,8 +4926,10 @@ static void __exit cciss_cleanup(void)
 		}
 	}
 	kthread_stop(cciss_scan_thread);
+#ifdef CONFIG_PROC_FS
 	if (proc_cciss)
 		remove_proc_entry("driver/cciss", NULL);
+#endif
 	bus_unregister(&cciss_bus_type);
 }
 
