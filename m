Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab1KUJHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 04:07:49 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:50790 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab1KUJHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 04:07:46 -0500
X-AuditID: b753bd60-a1286ba000000655-6a-4eca14dfd68e
X-AuditID: b753bd60-a1286ba000000655-6a-4eca14dfd68e
Subject: [PATCH 0/4]x86: decoder bugfixes
To: Ingo Molnar <mingo@elte.hu>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Tue, 22 Nov 2011 03:10:44 +0900
Message-ID: <20111121181044.27410.263.stgit@cloud>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here, I fixed bugs in x86 instruction decoder which fixes
instruction decoder warnings. This series also fixes below
bugs;

<Important>
 - Doesn't build decoder selftest tool (test_get_len).
 - Fails to decode some grouped AVX instructions.

<Minor>
 - insn_sanity may dump message twice on same instruction
 - insn_sanity outputs information message on stderr.

Now I'm also trying to update x86 opcode map according to
Intel SDM, which allow us to decode AVX2 instructions.

Thank you,

---

Masami Hiramatsu (4):
      [BUGFIX] x86/tools: Fix Makefile to build all test tools
      [BUGFIX] x86: Fix instruction decoder to handle grouped AVX instructions
      [BUGFIX] x86/tools: Fix instruction decoder message output
      [BUGFIX] x86/tools: Fix insn_sanity message outputs


 arch/x86/lib/inat.c          |    9 ++++++++-
 arch/x86/lib/insn.c          |    4 +++-
 arch/x86/tools/Makefile      |    3 +--
 arch/x86/tools/insn_sanity.c |   11 +++++------
 4 files changed, 17 insertions(+), 10 deletions(-)

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

