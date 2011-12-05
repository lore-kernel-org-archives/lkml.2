Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab1LEMFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:05:46 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46735 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab1LEMFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:05:44 -0500
X-AuditID: b753bd60-9aa63ba00000359c-66-4edcb3960564
X-AuditID: b753bd60-9aa63ba00000359c-66-4edcb3960564
Subject: [PATCH 0/6]x86: decoder bugfixes/updates
To: Ingo Molnar <mingo@elte.hu>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Mon, 05 Dec 2011 21:05:20 +0900
Message-ID: <20111205120520.15475.82983.stgit@cloud>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here are the patches of bugfixes and updates for x86
instruction decoder. Since it seems that previous
patches are not merged yet, I included thoes and
updated for the latest tip tree.

This series fixes below bugs;

<Important>
 - Doesn't build decoder selftest tool (test_get_len).
 - Fails to decode some grouped AVX instructions.

<Minor>
 - insn_sanity may dump message twice on same instruction
 - insn_sanity outputs information message on stderr.

And updates x86 instruction maps for AVX2 according to
Intel(R) 64 and IA-32 Architectures Software Developer's
Manual Vol.2 (#325383-040US, October 2011) and Intel(R)
Advanced Vector Extensions Programming Reference
(#319433-011,JUNE 2011).

Thank you,

---

Masami Hiramatsu (6):
      [RESEND][BUGFIX] x86/tools: Fix Makefile to build all test tools
      [RESEND][BUGFIX] x86: Fix instruction decoder to handle grouped AVX instructions
      [RESEND][BUGFIX] x86/tools: Fix instruction decoder message output
      [RESEND][BUGFIX] x86/tools: Fix insn_sanity message outputs
      x86: Update instruction decoder to support new AVX formats
      x86/tools: Add decoded instruction dump mode


 arch/x86/lib/inat.c                  |    9 -
 arch/x86/lib/insn.c                  |    4 
 arch/x86/lib/x86-opcode-map.txt      |  606 +++++++++++++++++++---------------
 arch/x86/tools/Makefile              |    3 
 arch/x86/tools/gen-insn-attr-x86.awk |   21 +
 arch/x86/tools/insn_sanity.c         |   16 -
 6 files changed, 365 insertions(+), 294 deletions(-)

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

