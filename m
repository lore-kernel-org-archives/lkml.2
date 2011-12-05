Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab1LERnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:43:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58767 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab1LERnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:43:15 -0500
Date: Mon, 5 Dec 2011 09:42:47 -0800
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-bfbe9015de5c78d1808cd09526b9166b2e6aa440@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111205120545.15475.7928.stgit@cloud>
References: <20111205120545.15475.7928.stgit@cloud>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86/tools: Fix instruction decoder message output
Git-Commit-ID: bfbe9015de5c78d1808cd09526b9166b2e6aa440
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 09:42:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bfbe9015de5c78d1808cd09526b9166b2e6aa440
Gitweb:     http://git.kernel.org/tip/bfbe9015de5c78d1808cd09526b9166b2e6aa440
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 5 Dec 2011 21:05:45 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 14:53:17 +0100

x86/tools: Fix instruction decoder message output

Fix instruction decoder test (insn_sanity), so that
it doesn't show both info and error messages twice on
same instruction. (In that case, show only error message)

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20111205120545.15475.7928.stgit@cloud
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/tools/insn_sanity.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/tools/insn_sanity.c b/arch/x86/tools/insn_sanity.c
index 334d9de..2025603 100644
--- a/arch/x86/tools/insn_sanity.c
+++ b/arch/x86/tools/insn_sanity.c
@@ -257,15 +257,14 @@ int main(int argc, char **argv)
 		insn_init(&insn, insn_buf, x86_64);
 		insn_get_length(&insn);
 
-		if (verbose && !insn_complete(&insn))
-			dump_stream(stdout, "Info: Found an undecodable input", i, insn_buf, &insn);
-
 		if (insn.next_byte <= insn.kaddr ||
 		    insn.kaddr + MAX_INSN_SIZE < insn.next_byte) {
 			/* Access out-of-range memory */
 			dump_stream(stdout, "Error: Found an access violation", i, insn_buf, &insn);
 			errors++;
-		}
+		} else if (verbose && !insn_complete(&insn))
+			dump_stream(stdout, "Info: Found an undecodable input", i, insn_buf, &insn);
+
 		insns++;
 	}
 
