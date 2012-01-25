Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab2AYJ64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 04:58:56 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43608 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755070Ab2AYJ6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 04:58:55 -0500
MIME-Version: 1.0
X-Originating-IP: [46.30.80.210]
From: Stefan Seidel <stefans@android-x86.org>
Date: Wed, 25 Jan 2012 10:58:32 +0100
X-Google-Sender-Auth: CMK7R3g4n1gPRYfIqRINLWUYJg4
Message-ID: <CACcUPpa5FydvemAX7idTOi9dU3+UYs_cra_YNq1bbQc47jr0Yw@mail.gmail.com>
Subject: Emulating unsupported x86 opcodes in software
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm looking for advice regarding the emulation of CPU instructions
which the current processor doesn't support. Specifically, I want to
emulate SSE3 instructions on non-SSE3-capable CPUs. The OSx86
project[1] has developed an SSE3 emulation based on SSE2 instructions.

The general idea is:
 - install a "stage 1" trap handler for INT 6h (invalid opcode)
 - "stage 1" handler returns the address of the "stage 2" handler, the
actual emulation routine
 - "stage 2" handler runs in user-mode, reads the invalid (SSE3)
instruction and operands and emulates it
 - "stage 2" handler stores the result in the correct destination
(register or memory) and restores all dirty registers to their
original state
More in-depth description is available as PDF[2].

Now it is not a problem to replace the INT 6h handler, but these are
my open questions:
1. How can I have the stage 2 handler run in user-mode (ring 3)
2. How do I allocate/obtain the address of the code segment containing
the stage 2 handler OR
3. Is it even possible to for code which is implemented in the kernel
to be called and executed in user-mode, and if not, what is the
alternative.

Both stage 1 and 2 handlers are available as binary (currently, I'm
trying to contact the original author for the source code).

Thank you very much for any help.

Stefan Seidel
P.S.: CC'ing me in your answer would be appreciated.

[1] http://code.google.com/p/xnu-dev/
[2] http://code.google.com/p/xnu-dev/downloads/detail?name=SSE3%20Emulator.pdf
