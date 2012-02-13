Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab2BMO5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 09:57:49 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39410 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab2BMO5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 09:57:48 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com, paulus@samba.org,
        tglx@linutronix.de, David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf tools: fix out of tree compiles
Date: Mon, 13 Feb 2012 07:57:37 -0700
Message-Id: <1329145057-26302-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For latest tip/perf/core tree Compiles are failing on:

GEN common-cmds.h
make: *** No rule to make target `../../arch/x86/lib/memset_64.S', needed by `builtin-annotate.o'.  Stop.

Resolve by adding memset.* to the tar file.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/MANIFEST |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 1078c5f..5476bc0 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -9,6 +9,7 @@ lib/rbtree.c
 include/linux/swab.h
 arch/*/include/asm/unistd*.h
 arch/*/lib/memcpy*.S
+arch/*/lib/memset*.S
 include/linux/poison.h
 include/linux/magic.h
 include/linux/hw_breakpoint.h
-- 
1.7.7.6

