Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab0JNDIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 23:08:01 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36769 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab0JNDIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 23:08:00 -0400
X-AuditID: b753bd60-a6b32ba000000226-08-4cb6740d92a0
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip  0/5] Kprobes updates
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Date: Thu, 14 Oct 2010 12:10:11 +0900
Message-ID: <20101014031011.4100.32343.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of patches fixes some code/docs which are related to
kprobes (especially optprobe).
First 2 resend patches update document and selftest since
optprobe changes kprobes behavior.
Next 2 patches fix double get_cpu() by using __stop_machine().
And the last patch makes text_poke_smp() depending on
stop_machine() on smp, because without stop_machine(),
it can't ensure safety on smp.

Thank you,

---

Masami Hiramatsu (5):
      [BUGFIX] kconfig/x86: Add HAVE_TEXT_POKE_SMP config for stop_machine dependency
      [BUGFIX] x86: Use __stop_machine() in text_poke_smp()
      Define __stop_machine when CONFIG_STOP_MACHINE=n
      [RESEND][BUGFIX] kprobes: Fix selftest to clear flags field for reusing probes
      [RESEND] kprobes: Update document about irq disabled state in kprobe handler


 Documentation/kprobes.txt     |    8 +++++---
 arch/x86/Kconfig              |    5 +++++
 arch/x86/kernel/alternative.c |    3 ++-
 include/linux/stop_machine.h  |   10 ++++++++--
 kernel/test_kprobes.c         |   12 +++++++++---
 5 files changed, 29 insertions(+), 9 deletions(-)

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

