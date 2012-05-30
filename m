Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab2E3HtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:49:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35349 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2E3HtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:49:14 -0400
Date: Wed, 30 May 2012 00:48:59 -0700
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-21f0d423b989284f82004d0f80c75581fec91fb2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, namhyung@gmail.com
In-Reply-To: <1338216802-5675-1-git-send-email-namhyung@gmail.com>
References: <1338216802-5675-1-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf ui:
  Make --stdio default when TUI is not supported
Git-Commit-ID: 21f0d423b989284f82004d0f80c75581fec91fb2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 00:49:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  21f0d423b989284f82004d0f80c75581fec91fb2
Gitweb:     http://git.kernel.org/tip/21f0d423b989284f82004d0f80c75581fec91fb2
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Mon, 28 May 2012 23:53:22 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 May 2012 13:29:54 -0300

perf ui: Make --stdio default when TUI is not supported

The commit dc41b9b8f02db ("perf ui: Change fallback policy of
setup_browser") changed default behavior of the function but missed
setting the use_browser variable to 0 accidently. So perf report ends up
doing nothing in such cases. Fix it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1338216802-5675-1-git-send-email-namhyung@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/setup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index 9f5f888..791fb15 100644
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
