Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834Ab0JZCx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:53:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758813Ab0JZCx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:53:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 01/43] Partially revert patch that encloses asm-offset.h
 numbers in brackets
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Jan Beulich <jbeulich@novell.com>
Date: Tue, 26 Oct 2010 03:53:07 +0100
Message-ID: <20101026025307.23512.30968.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Partially revert patch:

	commit 3234282f33b29d349bcada40204fc7c8fda7fe72
	Author: Jan Beulich <JBeulich@novell.com>
	Date:   Tue Oct 19 14:52:26 2010 +0100
	x86, asm: Fix CFI macro invocations to deal with shortcomings in gas

This breaks MN10300 arch as this changes many instances of instructions
similar to the following:

	MOV	number,D0

which represents an immediate value load into:

	MOV	(number),D0

which the assembler then interprets as a load from absolute address.

arch/mn10300/kernel/entry.S:64: Error: Invalid opcode/operands
arch/mn10300/kernel/entry.S:65: Error: junk at end of line, first unrecognized character is `0'
arch/mn10300/kernel/entry.S:74: Error: Invalid opcode/operands
arch/mn10300/kernel/entry.S:74: Error: junk at end of line, first unrecognized character is `1'
arch/mn10300/kernel/entry.S:75: Error: Invalid opcode/operands
arch/mn10300/kernel/entry.S:76: Error: junk at end of line, first unrecognized character is `0'

cc: Jan Beulich <jbeulich@novell.com>
cc: Alexander van Heukelum <heukelum@fastmail.fm>
cc: H. Peter Anvin <hpa@linux.intel.com>
cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 Kbuild |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/Kbuild b/Kbuild
index 431f7ca..b00037a 100644
--- a/Kbuild
+++ b/Kbuild
@@ -53,7 +53,7 @@ targets += arch/$(SRCARCH)/kernel/asm-offsets.s
 # Default sed regexp - multiline due to syntax constraints
 define sed-y
 	"/^->/{s:->#\(.*\):/* \1 */:; \
-	s:^->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 (\2) /* \3 */:; \
+	s:^->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 \2 /* \3 */:; \
 	s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; \
 	s:->::; p;}"
 endef

