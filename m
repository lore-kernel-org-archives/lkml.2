Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab1KUJIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 04:08:12 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:50880 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab1KUJIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 04:08:09 -0500
X-AuditID: b753bd60-a3089ba000000655-9e-4eca14f7d98a
X-AuditID: b753bd60-a3089ba000000655-9e-4eca14f7d98a
Subject: [PATCH 3/4] [BUGFIX] x86/tools: Fix instruction decoder message output
To: Ingo Molnar <mingo@elte.hu>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Tue, 22 Nov 2011 03:11:19 +0900
Message-ID: <20111121181119.27410.25790.stgit@cloud>
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

Fix instruction decoder test (insn_sanity), so that
it doesn't show both info and error messages twice on
same instruction. (In that case, show only error message)

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
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
 

