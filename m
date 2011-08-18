Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab1HRLhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 07:37:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521Ab1HRLhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 07:37:45 -0400
Date: Thu, 18 Aug 2011 07:37:21 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix perf build against newer glibc
Message-ID: <20110818113720.GL2227@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upstream glibc commit 295e904 added a definition for __attribute_const__ to
cdefs.h.  This causes the following error when building perf:

util/include/linux/compiler.h:8:0: error: "__attribute_const__" redefined [-Werror]
/usr/include/sys/cdefs.h:226:0: note: this is the location of the previous definition

Wrap __attribute_const__ in #ifndef as we do for __always_inline.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 tools/perf/util/include/linux/compiler.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/include/linux/compiler.h b/tools/perf/util/include/linux/compiler.h
index 791f9dd..547628e 100644
--- a/tools/perf/util/include/linux/compiler.h
+++ b/tools/perf/util/include/linux/compiler.h
@@ -5,7 +5,9 @@
 #define __always_inline	inline
 #endif
 #define __user
+#ifndef __attribute_const__
 #define __attribute_const__
+#endif
 
 #define __used		__attribute__((__unused__))
 
-- 
1.7.6

