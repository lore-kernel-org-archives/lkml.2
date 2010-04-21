Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab0DUOAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 10:00:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab0DUOAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 10:00:40 -0400
Date: Wed, 21 Apr 2010 10:00:33 -0400
From: Kyle McMartin <kmcmartin@redhat.com>
To: eparis@redhat.com
Cc: kees@canonical.com, cebbert@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] trivial: make mmap_min_addr perms 600
Message-ID: <20100421140033.GA8389@ihatethathostname.lab.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck points out that mmap_min_addr is 644...

CAP_SYS_RAWIO will deny users read/write to the file, let's let them see
that this is intended.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8686b0f..5868481 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1209,7 +1209,7 @@ static struct ctl_table vm_table[] = {
 		.procname	= "mmap_min_addr",
 		.data		= &dac_mmap_min_addr,
 		.maxlen		= sizeof(unsigned long),
-		.mode		= 0644,
+		.mode		= 0600,
 		.proc_handler	= mmap_min_addr_handler,
 	},
 #endif
