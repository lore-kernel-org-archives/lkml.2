Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab1BUOZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:25:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421Ab1BUOZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:25:38 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu
Cc: masami.hiramatsu.pt@hitachi.com, acme@redhat.com, fweisbec@gmail.com,
        hpa@zytor.com, ananth@in.ibm.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        a.p.zijlstra@chello.nl, eric.dumazet@gmail.com,
        2nddept-manager@sdl.hitachi.co.jp
Subject: [PATCH 0/2] x86: separating entry text section + kprobes fix
Date: Mon, 21 Feb 2011 15:25:11 +0100
Message-Id: <1298298313-5980-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <20110220125948.GC25700@elte.hu>
References: <20110220125948.GC25700@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

while fixing the optimized kprobes issue, we found out that separating
the entry text section might have performance benefits with regards to
the instruction cache usage.

attached patches:
1/2 - x86: separating entry text section
2/2 - kprobes: disabling optimized kprobes for entry text section

wbr,
jirka
---
 arch/x86/ia32/ia32entry.S         |    2 ++
 arch/x86/kernel/entry_32.S        |    6 ++++--
 arch/x86/kernel/entry_64.S        |    6 ++++--
 arch/x86/kernel/kprobes.c         |    8 ++++++++
 arch/x86/kernel/vmlinux.lds.S     |    1 +
 include/asm-generic/sections.h    |    1 +
 include/asm-generic/vmlinux.lds.h |    6 ++++++
 7 files changed, 26 insertions(+), 4 deletions(-)
