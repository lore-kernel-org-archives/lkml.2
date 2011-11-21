Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab1KUJI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 04:08:27 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41435 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab1KUJIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 04:08:24 -0500
X-AuditID: b753bd60-9a3c6ba000003356-43-4eca14fe2117
X-AuditID: b753bd60-9a3c6ba000003356-43-4eca14fe2117
Subject: [PATCH 4/4] [BUGFIX] x86/tools: Fix insn_sanity message outputs
To: Ingo Molnar <mingo@elte.hu>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Tue, 22 Nov 2011 03:11:25 +0900
Message-ID: <20111121181125.27410.67397.stgit@cloud>
In-Reply-To: <20111121181044.27410.263.stgit@cloud>
References: <20111121181044.27410.263.stgit@cloud>
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

