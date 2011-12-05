Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab1LEMGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:06:12 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56913 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab1LEMGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:06:09 -0500
X-AuditID: b753bd60-9645cba00000359c-b6-4edcb3af1827
X-AuditID: b753bd60-9645cba00000359c-b6-4edcb3af1827
Subject: [PATCH 4/6] [RESEND][BUGFIX] x86/tools: Fix insn_sanity message
 outputs
To: Ingo Molnar <mingo@elte.hu>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Mon, 05 Dec 2011 21:05:50 +0900
Message-ID: <20111205120550.15475.70149.stgit@cloud>
In-Reply-To: <20111205120520.15475.82983.stgit@cloud>
References: <20111205120520.15475.82983.stgit@cloud>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix x86 instruction decoder test to dump all error messages
to stderr and others to stdout.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/tools/insn_sanity.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/tools/insn_sanity.c b/arch/x86/tools/insn_sanity.c
index 2025603..b6720d6 100644
--- a/arch/x86/tools/insn_sanity.c
+++ b/arch/x86/tools/insn_sanity.c
@@ -102,7 +102,7 @@ static void dump_stream(FILE *fp, const char *msg, unsigned long nr_iter,
 
 	fprintf(fp, "%s:\n", msg);
 
-	dump_insn(stderr, insn);
+	dump_insn(fp, insn);
 
 	fprintf(fp, "You can reproduce this with below command(s);\n");
 
@@ -260,7 +260,7 @@ int main(int argc, char **argv)
 		if (insn.next_byte <= insn.kaddr ||
 		    insn.kaddr + MAX_INSN_SIZE < insn.next_byte) {
 			/* Access out-of-range memory */
-			dump_stream(stdout, "Error: Found an access violation", i, insn_buf, &insn);
+			dump_stream(stderr, "Error: Found an access violation", i, insn_buf, &insn);
 			errors++;
 		} else if (verbose && !insn_complete(&insn))
 			dump_stream(stdout, "Info: Found an undecodable input", i, insn_buf, &insn);

