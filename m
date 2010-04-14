Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab0DNFHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 01:07:31 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42030 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab0DNFH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 01:07:29 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: benh@kernel.crashing.org, Masami Hiramatsu <mhiramat@redhat.com>
Subject: perf: Split out arch specific code & improve PowerPC perf probe support
Date: Wed, 14 Apr 2010 15:06:37 +1000
Message-Id: <1271221600-25533-1-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add the required mappings to use perf probe on PowerPC.

Functionality wise it requires the patch titled "powerpc: Add kprobe-based
event tracer" from the powerpc-next tree to provide the
HAVE_REGS_AND_STACK_ACCESS_API required for CONFIG_KPROBE_EVENT. The code will
still compile cleanly without it and will fail gracefully at runtime on the
missing CONFIG_KPROBE_EVENT support as before.

Part 1 of the patch series moves the arch dependent x86 32 and 64 bit DWARF
register number mappings out into a separate arch directory and adds the
necessary Makefile foo to use it.

Part 2 of the patch series adds the PowerPC mappings.


Changes since v1: From Masami Hiramatsu's suggestion, I added a check in the
Makefile for if the arch specific Makefile defines PERF_HAVE_DWARF_REGS,
printing a message during build if it has not. This simplifies the code
removing the odd macro from the previous version and the need for an arch
specific arch_dwarf-regs.h. I have not entirely disabled DWARF support for
architectures that don't implement the register mappings, so that they can
still add a probe based on a line number (they will be missing the ability to
capture the value of a variable from a register).


Thanks,
-Ian


