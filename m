Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab0DTG7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 02:59:10 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:58453 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab0DTG7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 02:59:09 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: benh@kernel.crashing.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH v4] perf: Split out arch specific code & improve PowerPC perf probe support
Date: Tue, 20 Apr 2010 16:58:31 +1000
Message-Id: <1271746713-8347-1-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the 4th version of the perf probe PowerPC support and perf arch specific
infrastructure patches rebased on top of tip/perf/core.


Changelog V4:
* Rebased on top of tip/perf/core (with powerpc/next merged) and resolved merge
  conflicts.
* Move the check for DWARF support prior to the inclusion of the arch
  specific Makefile so that the arch specific Makefile can include the relevant
  files in the build only if DWARF support is available.
* Fix NO_DWARF build on x86 and PowerPC

Changelog V3:
  From Masami Hiramatsu's feedback DWARF support is disabled altogether if the
  architecture specific Makefile does not define PERF_HAVE_DWARF_REGS - ie,
  DWARF register mappings are missing for the architecture. A message
  indicating this is printed out during compilation.

Changelog V2:
  From Masami Hiramatsu's suggestion, I added a check in the Makefile for if
  the arch specific Makefile defines PERF_HAVE_DWARF_REGS, printing a message
  during build if it has not. This simplifies the code removing the odd macro
  from the previous version and the need for an arch specific
  arch_dwarf-regs.h.  I have not entirely disabled DWARF support for
  architectures that don't implement the register mappings, so that they can
  still add a probe based on a line number (they will be missing the ability to
  capture the value of a variable from a register).

These patches add the required mappings to use perf probe on PowerPC.

Part 1 of the patch series moves the arch dependent x86 32 and 64 bit DWARF
register number mappings out into a separate arch directory and adds the
necessary Makefile foo to use it.

Part 2 of the patch series adds the PowerPC mappings -
Functionality wise it requires the patch titled "powerpc: Add kprobe-based
event tracer" from the powerpc-next tree to provide the
HAVE_REGS_AND_STACK_ACCESS_API required for CONFIG_KPROBE_EVENT. The code will
still compile cleanly without it and will fail gracefully at runtime on the
missing CONFIG_KPROBE_EVENT support as before as well as printing a warning
message during compilation.


