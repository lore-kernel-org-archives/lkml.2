Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab0LYI7F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 03:59:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:51263 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab0LYI7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 03:59:01 -0500
Date: Sat, 25 Dec 2010 08:58:34 GMT
From: tip-bot for Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, fbuihuu@gmail.com, vagabon.xyz@gmail.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, masami.hiramatsu.pt@hitachi.com, fbuihuu@gmail.com,
        tglx@linutronix.de, vagabon.xyz@gmail.com, mingo@elte.hu
In-Reply-To: <m3y67hsr0m.fsf@gmail.com>
References: <m3y67hsr0m.fsf@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix wrong warning in __show_one_line() if read(1) errors happen
Message-ID: <tip-32b2b6ec57a3adb3ab7215fbf36ec61c15de06ee@git.kernel.org>
Git-Commit-ID: 32b2b6ec57a3adb3ab7215fbf36ec61c15de06ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 25 Dec 2010 08:58:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  32b2b6ec57a3adb3ab7215fbf36ec61c15de06ee
Gitweb:     http://git.kernel.org/tip/32b2b6ec57a3adb3ab7215fbf36ec61c15de06ee
Author:     Franck Bui-Huu <vagabon.xyz@gmail.com>
AuthorDate: Wed, 22 Dec 2010 17:37:13 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 22 Dec 2010 20:32:08 -0200

perf probe: Fix wrong warning in __show_one_line() if read(1) errors happen

This was introduced by commit fde52dbd7f71934aba4e150f3d1d51e826a08850.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <m3y67hsr0m.fsf@gmail.com>
Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 099336e..4bde988 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -309,7 +309,7 @@ static int __show_one_line(FILE *fp, int l, bool skip, bool show_num)
 	return 1;
 error:
 	if (ferror(fp)) {
-		pr_warning("Source file is shorter than expected.\n");
+		pr_warning("File read error: %s\n", strerror(errno));
 		return -1;
 	}
 	return 0;
