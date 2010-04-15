Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab0DOD5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 23:57:47 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:44526 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab0DOD5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 23:57:46 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: benh@kernel.crashing.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v3] perf: Split out arch specific code & improve PowerPC perf probe support
Date: Thu, 15 Apr 2010 13:57:00 +1000
Message-Id: <1271303822-11542-1-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


Changes since v2: From Masami Hiramatsu's feedback DWARF support is disabled
altogether if the architecture specific Makefile does not define
PERF_HAVE_DWARF_REGS - ie, DWARF register mappings are missing for the
architecture. A message indicating this is printed out during compilation.


