Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab2E2EXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 00:23:16 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:51251 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2E2EXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 00:23:14 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND 1/7] perf ui: Make --stdio default when TUI is not supported
Date: Tue, 29 May 2012 13:22:56 +0900
Message-Id: <1338265382-6872-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1338265382-6872-1-git-send-email-namhyung@gmail.com>
References: <1338265382-6872-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit dc41b9b8f02db ("perf ui: Change fallback policy of
setup_browser") changed default behavior of the function but
missed setting the use_browser variable to 0 accidently. So
perf report ends up doing nothing in such cases. Fix it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/ui/setup.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index 9f5f888f73e3..791fb15ce350 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -22,6 +22,7 @@ void setup_browser(bool fallback_to_pager)
 			break;
 		/* fall through */
 	default:
+		use_browser = 0;
 		if (fallback_to_pager)
 			setup_pager();
 		break;
-- 
1.7.9.2

