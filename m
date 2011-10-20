Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1JTHne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 03:43:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41495 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab1JTHnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 03:43:33 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, anton@samba.org, penberg@kernel.org,
        daahern@cisco.com, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] tools/perf: Increase symbol KSYM_NAME_LEN size
Date: Thu, 20 Oct 2011 09:43:26 +0200
Message-Id: <1319096606-11568-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fglrx propietary driver has symbol names over 128 chars (:S). This
breaks the function kallsyms__parse.

This fix increases the size of KSYM_NAME_LEN, so kallsyms__parse can
work on such kernels.

The only counterparty, is that such function requires 128 more bytes to
work.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 tools/perf/util/symbol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 40eeaf0..d4f8750 100644
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
1.7.7

