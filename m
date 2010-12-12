Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab0LLPRJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 10:17:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:40495 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab0LLPRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 10:17:02 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Franck Bui-Huu <fbuihuu@gmail.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Francis Moreau <francis.moro@gmail.com>,
        Franck Bui-Huu <vagabon.xyz@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf symbols: Stop using vmlinux files with no symbols
Date: Sun, 12 Dec 2010 13:16:54 -0200
Message-Id: <1292167014-20936-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1292167014-20936-1-git-send-email-acme@infradead.org>
References: <1292167014-20936-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

Fail if the kernel image contains no symbol, allowing using other images
in the vmlinux search path that may have a usable symtab.

Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Francis Moreau <francis.moro@gmail.com>
Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
LPU-Reference: <m3d3p9ydx9.fsf_-_@gmail.com>
Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index b71acd6..61191c6 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -135,7 +135,7 @@ const char *kernel_get_module_path(const char *module)
 		if (dso__load_vmlinux(dso, map, vmlinux_name, NULL) <= 0)
 			return NULL;
 	} else {
-		if (dso__load_vmlinux_path(dso, map, NULL) < 0) {
+		if (dso__load_vmlinux_path(dso, map, NULL) <= 0) {
 			pr_debug("Failed to load kernel map.\n");
 			return NULL;
 		}
-- 
1.6.2.5

