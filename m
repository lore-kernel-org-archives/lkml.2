Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934245Ab2FHKWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 06:22:49 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:2472 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276Ab2FHKWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 06:22:48 -0400
Message-ID: <1339150966.25798.34.camel@x61.thuisdomein>
Subject: [PATCH] Delete if_strip.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org
Date: Fri, 08 Jun 2012 12:22:46 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 08 Jun 2012 10:22:47.0105 (UTC) FILETIME=[A6317B10:01CD4560]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f80a3f62383bf673c310926d55142d51f118926d ("Staging: strip: delete
the driver") left if_strip.h unused: nothing in the tree includes it
anymore. It is still exported, but since nothing in the kernel uses
struct MetricomAddress, that seems pointless. Delete this header too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Again, this is tested only with git grep (now both on file name and on
"MetricomAddress"). Looks obviously correct, though.

 include/linux/Kbuild     |    1 -
 include/linux/if_strip.h |   27 ---------------------------
 2 files changed, 0 insertions(+), 28 deletions(-)
 delete mode 100644 include/linux/if_strip.h

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 8760be3..9366142 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -183,7 +183,6 @@ header-y += if_ppp.h
 header-y += if_pppol2tp.h
 header-y += if_pppox.h
 header-y += if_slip.h
-header-y += if_strip.h
 header-y += if_team.h
 header-y += if_tun.h
 header-y += if_tunnel.h
diff --git a/include/linux/if_strip.h b/include/linux/if_strip.h
deleted file mode 100644
index 6526a62..0000000
--- a/include/linux/if_strip.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * if_strip.h --
- *
- *      Definitions for the STRIP interface
- *
- * Copyright 1996 The Board of Trustees of The Leland Stanford
- * Junior University. All Rights Reserved.
- *
- * Permission to use, copy, modify, and distribute this
- * software and its documentation for any purpose and without
- * fee is hereby granted, provided that the above copyright
- * notice appear in all copies.  Stanford University
- * makes no representations about the suitability of this
- * software for any purpose.  It is provided "as is" without
- * express or implied warranty.
- */
-
-#ifndef __LINUX_STRIP_H
-#define __LINUX_STRIP_H
-
-#include <linux/types.h>
-
-typedef struct {
-    __u8 c[6];
-} MetricomAddress;
-
-#endif
-- 
1.7.7.6

