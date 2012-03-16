Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761430Ab2CPMRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 08:17:31 -0400
Received: from goliath.siemens.de ([192.35.17.28]:18773 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab2CPMRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 08:17:30 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 3/4] kgdb: Respect that flush op is optional
Date: Fri, 16 Mar 2012 13:17:13 +0100
Message-Id: <08ddbfb8fbca5fef8adfce3449b5744b0db7b45f.1331900215.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1331900215.git.jan.kiszka@siemens.com>
References: <cover.1331900215.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1331900215.git.jan.kiszka@siemens.com>
References: <cover.1331900215.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all kgdb I/O drivers implement a flush operation. Adjust
gdbstub_exit accordingly.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 kernel/debug/gdbstub.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index 5d7ed0a..c174ea3 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -1132,5 +1132,6 @@ void gdbstub_exit(int status)
 	dbg_io_ops->write_char(hex_asc_lo(checksum));
 
 	/* make sure the output is flushed, lest the bootloader clobber it */
-	dbg_io_ops->flush();
+	if (dbg_io_ops->flush)
+		dbg_io_ops->flush();
 }
-- 
1.7.3.4

