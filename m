Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2HVInV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:43:21 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40289 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab2HVInP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:43:15 -0400
X-AuditID: b753bd60-95762ba000007c38-75-50349ba1e61d
X-AuditID: b753bd60-95762ba000007c38-75-50349ba1e61d
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PATCH 1/5] trace-cmd: Use TRACE_DIR envrionment variable if defined
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Amit Shah <amit.shah@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@amd64.org>,
        "Franch Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Date: Wed, 22 Aug 2012 17:43:02 +0900
Message-ID: <20120822084301.17293.90649.stgit@ltc189.sdl.hitachi.co.jp>
In-Reply-To: <20120822084251.17293.69086.stgit@ltc189.sdl.hitachi.co.jp>
References: <20120822084251.17293.69086.stgit@ltc189.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Use TRACE_DIR environment variable for setting
debugfs/tracing directory if defined. This is
for controlling guest(or remote) ftrace.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---

 trace-util.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/trace-util.c b/trace-util.c
index e128188..d5a3eb4 100644
--- a/trace-util.c
+++ b/trace-util.c
@@ -311,6 +311,15 @@ char *tracecmd_find_tracing_dir(void)
 	char type[100];
 	FILE *fp;
 	
+	tracing_dir = getenv("TRACE_DIR");
+	if (tracing_dir) {
+		tracing_dir = strdup(tracing_dir);
+		if (!tracing_dir)
+			die("malloc");
+		warning("Use environmental tracing directory: %s\n", tracing_dir);
+		return tracing_dir;
+	}
+
 	if ((fp = fopen("/proc/mounts","r")) == NULL) {
 		warning("Can't open /proc/mounts for read");
 		return NULL;


