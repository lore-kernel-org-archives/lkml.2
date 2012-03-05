Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab2CENcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:32:09 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51224 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab2CENcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:32:08 -0500
X-AuditID: b753bd60-97991ba000007b1b-77-4f54c055bd18
X-AuditID: b753bd60-97991ba000007b1b-77-4f54c055bd18
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH v4 -tip 0/3] x86/kprobes: bugfixes and split optprobes
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        yrl.pp-manager.tt@hitachi.com, systemtap@sourceware.org,
        anderson@redhat.com
Date: Mon, 05 Mar 2012 22:32:01 +0900
Message-ID: <20120305133200.5982.45827.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are the patches for fixing bugs in kprobes on x86.

- Both bugs are related to the optprobe.
- First bugfix is optprobe to recover instructions when
  thoes are modified with jump.
- Second bugfix is kprobes to recover it too.

This series also includes a patch which split optprobes
parts out from kprobes x86 implementation.

Ingo, I've added the splitting patch according your
advice :)

Thank you,

---

Masami Hiramatsu (3):
      x86/kprobes: Split out optprobe related code to kprobes-opt.c
      [BUGFIX] x86/kprobes: Fix a bug which can modify kernel code
      [BUGFIX] x86/kprobes: Fix to recover instructions on optimized path


 arch/x86/kernel/Makefile         |    1 
 arch/x86/kernel/kprobes-common.h |  106 ++++++
 arch/x86/kernel/kprobes-opt.c    |  516 +++++++++++++++++++++++++++++++
 arch/x86/kernel/kprobes.c        |  633 ++++----------------------------------
 4 files changed, 684 insertions(+), 572 deletions(-)
 create mode 100644 arch/x86/kernel/kprobes-common.h
 create mode 100644 arch/x86/kernel/kprobes-opt.c

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

