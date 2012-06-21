Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136Ab2FUTYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 15:24:17 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:3929 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755266Ab2FUTYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 15:24:13 -0400
Message-ID: <1340306497.1773.61.camel@x61.thuisdomein>
Subject: [PATCH 3/3] Remove useless wrappers of asm-generic/rmap.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, Jonas Bonn <jonas@southpole.se>,
        linux@openrisc.net, Chris Zankel <chris@zankel.net>,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Jun 2012 21:21:37 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 21 Jun 2012 19:21:37.0874 (UTC) FILETIME=[14341320:01CD4FE3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xtensa has a header (in its include/asm directory) that is a thin
wrapper around asm-generic/rmap.h. This wrapper is useless, since that
header doesn't exist. It is also unused (no file includes asm/rmap.h).

openrisc generates a similar header at build time (using a generic-y
entry in include/asm/Kbuild). This generated header is useless and
unused too.

Remove this header and this generic-y entry.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/openrisc/include/asm/Kbuild |    1 -
 arch/xtensa/include/asm/rmap.h   |   16 ----------------
 2 files changed, 0 insertions(+), 17 deletions(-)
 delete mode 100644 arch/xtensa/include/asm/rmap.h

diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index 08484f7..0922959 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -42,7 +42,6 @@ generic-y += percpu.h
 generic-y += poll.h
 generic-y += posix_types.h
 generic-y += resource.h
-generic-y += rmap.h
 generic-y += scatterlist.h
 generic-y += sections.h
 generic-y += segment.h
diff --git a/arch/xtensa/include/asm/rmap.h b/arch/xtensa/include/asm/rmap.h
deleted file mode 100644
index 649588b..0000000
--- a/arch/xtensa/include/asm/rmap.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * include/asm-xtensa/rmap.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_RMAP_H
-#define _XTENSA_RMAP_H
-
-#include <asm-generic/rmap.h>
-
-#endif
-- 
1.7.7.6

