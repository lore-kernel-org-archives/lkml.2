Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030207Ab2GEPpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:45:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:59114 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964799Ab2GEPpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:45:32 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 15/20] tools lib traceevent: Add missing break in make_bprint_args
Date: Thu,  5 Jul 2012 12:45:13 -0300
Message-Id: <1341503118-13198-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341503118-13198-1-git-send-email-acme@infradead.org>
References: <1341503118-13198-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

In the current code we assign vsize=8 and then fall through to the
default and assign vsize=1. -> probably the break is missing here,
otherwise we can remove the case.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-3fxjy46h2tr9pl0spv7tems6@git.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 8630160..f880db4 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3594,6 +3594,7 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 					break;
 				case 2:
 					vsize = 8;
+					break;
 				default:
 					vsize = ls; /* ? */
 					break;
-- 
1.7.9.2.358.g22243

