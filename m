Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018Ab2FUTUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 15:20:10 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:2121 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759830Ab2FUTUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 15:20:08 -0400
Message-ID: <1340306406.1773.59.camel@x61.thuisdomein>
Subject: [PATCH 1/3] Remove useless wrappers of asm-generic/cpumask.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org,
        Jonas Bonn <jonas@southpole.se>, linux@openrisc.net,
        Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org
Date: Thu, 21 Jun 2012 21:20:06 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 21 Jun 2012 19:20:06.0987 (UTC) FILETIME=[DE07D1B0:01CD4FE2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

frv and xtensa both have a header (in their include/asm directories)
that are thin wrappers around asm-generic/cpumask.h. These wrappers are
useless, since that header doesn't exist. They are also unused (all
files including asm/cpumask.h are x86 specific).

hexagon and openrisc generate similar headers at build time (using a
generic-y entry in include/asm/Kbuild). These generated headers are
useless and unused too.

Remove these headers and generic-y entries.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/frv/include/asm/cpumask.h    |    6 ------
 arch/hexagon/include/asm/Kbuild   |    1 -
 arch/openrisc/include/asm/Kbuild  |    1 -
 arch/xtensa/include/asm/cpumask.h |   16 ----------------
 4 files changed, 0 insertions(+), 24 deletions(-)
 delete mode 100644 arch/frv/include/asm/cpumask.h
 delete mode 100644 arch/xtensa/include/asm/cpumask.h

diff --git a/arch/frv/include/asm/cpumask.h b/arch/frv/include/asm/cpumask.h
deleted file mode 100644
index d999c20..0000000
--- a/arch/frv/include/asm/cpumask.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_CPUMASK_H
-#define _ASM_CPUMASK_H
-
-#include <asm-generic/cpumask.h>
-
-#endif /* _ASM_CPUMASK_H */
diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
index 9aa17f1..8ecd202 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -7,7 +7,6 @@ header-y += user.h
 generic-y += auxvec.h
 generic-y += bug.h
 generic-y += bugs.h
-generic-y += cpumask.h
 generic-y += cputime.h
 generic-y += current.h
 generic-y += device.h
diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index 3f35c38..08484f7 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -13,7 +13,6 @@ generic-y += cacheflush.h
 generic-y += checksum.h
 generic-y += cmpxchg.h
 generic-y += cmpxchg-local.h
-generic-y += cpumask.h
 generic-y += cputime.h
 generic-y += current.h
 generic-y += device.h
diff --git a/arch/xtensa/include/asm/cpumask.h b/arch/xtensa/include/asm/cpumask.h
deleted file mode 100644
index ebeede3..0000000
--- a/arch/xtensa/include/asm/cpumask.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * include/asm-xtensa/cpumask.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_CPUMASK_H
-#define _XTENSA_CPUMASK_H
-
-#include <asm-generic/cpumask.h>
-
-#endif /* _XTENSA_CPUMASK_H */
-- 
1.7.7.6

