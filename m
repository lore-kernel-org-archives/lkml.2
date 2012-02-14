Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816Ab2BNBx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 20:53:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:45735 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab2BNBxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 20:53:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        David Ahern <dsahern@gmail.com>, Jason Wang <jasowang@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/16] perf tools: Change perf_guest default back to false
Date: Mon, 13 Feb 2012 23:52:46 -0200
Message-Id: <1329184375-27911-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1329184375-27911-1-git-send-email-acme@infradead.org>
References: <1329184375-27911-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

Setting perf_guest to true by default makes no sense because the perf
subcommands can not setup guest symbol information and thus not process
and guest samples. The only exception is perf-kvm which changes the
perf_guest value on its own.  So change the default for perf_guest back
to false.

Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1328893505-4115-3-git-send-email-joerg.roedel@amd.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 8131410..fb25d13 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -6,7 +6,7 @@
  * XXX We need to find a better place for these things...
  */
 bool perf_host  = true;
-bool perf_guest = true;
+bool perf_guest = false;
 
 void event_attr_init(struct perf_event_attr *attr)
 {
-- 
1.7.9.123.g65da0

