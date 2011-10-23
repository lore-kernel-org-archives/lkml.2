Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab1JWTMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 15:12:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53967 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab1JWTMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 15:12:38 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Anton Blanchard <anton@samba.org>, David Ahern <daahern@cisco.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/4] perf symbols: Increase symbol KSYM_NAME_LEN size
Date: Sun, 23 Oct 2011 17:12:23 -0200
Message-Id: <1319397143-20301-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319397143-20301-1-git-send-email-acme@infradead.org>
References: <1319397143-20301-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Fglrx propietary driver has symbol names over 128 chars (:S). This
breaks the function kallsyms__parse.

This fix increases the size of KSYM_NAME_LEN, so kallsyms__parse can
work on such kernels.

The only counterparty, is that such function requires 128 more bytes to
work.

Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: David Ahern <daahern@cisco.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1319096606-11568-1-git-send-email-ricardo.ribalda@gmail.com
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 3f09a23..632b50c 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -24,7 +24,7 @@
 #include <sys/utsname.h>
 
 #ifndef KSYM_NAME_LEN
-#define KSYM_NAME_LEN 128
+#define KSYM_NAME_LEN 256
 #endif
 
 #ifndef NT_GNU_BUILD_ID
-- 
1.6.2.5

