Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab2FJToo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 15:44:44 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:1709 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754901Ab2FJTom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 15:44:42 -0400
Message-ID: <1339357475.30984.49.camel@x61.thuisdomein>
Subject: [PATCH] tile: remove unused header
From: Paul Bolle <pebolle@tiscali.nl>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 10 Jun 2012 21:44:35 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 10 Jun 2012 19:44:35.0421 (UTC) FILETIME=[76BDD0D0:01CD4741]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing includes memprof.h. Nothing uses the macros it defines. It seems
it is just a remnant of the proposed memprof functionality, which got
dropped before the Tilera architecture got added to the tree. This
header can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Dropping the memprof functionality was briefly discussed in
https://lkml.org/lkml/2010/5/26/606 .

1) Tested only by using various git commands on the (history of the)
tree.

 arch/tile/include/asm/memprof.h |   33 ---------------------------------
 1 files changed, 0 insertions(+), 33 deletions(-)
 delete mode 100644 arch/tile/include/asm/memprof.h

diff --git a/arch/tile/include/asm/memprof.h b/arch/tile/include/asm/memprof.h
deleted file mode 100644
index 359949b..0000000
--- a/arch/tile/include/asm/memprof.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License
- *   as published by the Free Software Foundation, version 2.
- *
- *   This program is distributed in the hope that it will be useful, but
- *   WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *   NON INFRINGEMENT.  See the GNU General Public License for
- *   more details.
- *
- * The hypervisor's memory controller profiling infrastructure allows
- * the programmer to find out what fraction of the available memory
- * bandwidth is being consumed at each memory controller.  The
- * profiler provides start, stop, and clear operations to allows
- * profiling over a specific time window, as well as an interface for
- * reading the most recent profile values.
- *
- * This header declares IOCTL codes necessary to control memprof.
- */
-#ifndef _ASM_TILE_MEMPROF_H
-#define _ASM_TILE_MEMPROF_H
-
-#include <linux/ioctl.h>
-
-#define MEMPROF_IOCTL_TYPE 0xB4
-#define MEMPROF_IOCTL_START _IO(MEMPROF_IOCTL_TYPE, 0)
-#define MEMPROF_IOCTL_STOP _IO(MEMPROF_IOCTL_TYPE, 1)
-#define MEMPROF_IOCTL_CLEAR _IO(MEMPROF_IOCTL_TYPE, 2)
-
-#endif /* _ASM_TILE_MEMPROF_H */
-- 
1.7.7.6

