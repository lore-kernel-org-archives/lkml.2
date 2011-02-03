Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1BCD1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 22:27:43 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:44970 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab1BCD1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 22:27:41 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Andreas Dilger <adilger@dilger.ca>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Jason Baron <jbaron@redhat.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Steven Rostedt <rostedt@goodmis.org>, Alexander Graf <agraf@suse.de>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Scott Wood <scottwood@freescale.com>, Nathan Lynch <ntl@pobox.com>,
        Avantika Mathur <mathur@linux.vnet.ibm.com>,
        David Gibson <dwg@au1.ibm.com>, Andreas Schwab <schwab@linux-m68k.org>,
        Namhyung Kim <namhyung@gmail.com>
Subject: PowerPC, ftrace: Add PPC raw syscall tracepoints & ftrace fixes (mimimal subset only) v4
Date: Thu,  3 Feb 2011 14:27:19 +1100
Message-Id: <1296703645-18718-1-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This is a partial version of my 'ftrace syscalls, PowerPC: Various fixes,
Compat Syscall support and PowerPC implementation'. This is updated from
yesterday with arch_syscall_addr changed to a static inline function from
Steven's suggestion.

This subset implements the raw syscall tracepoints on PowerPC which has been
requested recently.  It also fixes ftrace syscalls to ensure that events will
only be created for syscalls that successfully map their metadata to a syscall
number, so that non-working phantom events are not created. Patches #2 and #6
in this series are not strictly necessary for this, they just optimise ftrace
syscalls a bit.

What's missing from this series that was in the full 40 patch v2 series is the
conversion of all the syscalls implemented under /arch/powerpc, Jason Baron's
compat syscall support and the conversion of the remaining native and compat
syscalls to this infrastructure.

Cheers,
-Ian


Changelog:
Subset v4:
- Changed arch_syscall_addr to a static inline function from Steven's
  suggestion. Archs implementing their own function must now define
  ARCH_HAS_SYSCALL_MATCH_SYM_NAME in their asm/ftrace.h

Subset v3:
- Rather than removing the redundant syscall_nr checks completely, I have
  turned them into WARN_ON_ONCE to catch possible future regressions, from
  Steven Rostedt's suggestion.
- From Mike Frysinger's suggestion, arch_syscall_addr is now a macro rather
  than a weak function to minimise the overhead at boot. Archs with special
  requirements (such as ppc64) can define their own macro in asm/ftrace.h.
  Steven Rostedt suggested this be made a static inline function, but I don't
  see how this would be possible (at least without #defines and #ifndefs) given
  that it has to be weak to allow archs to override it (Unless I misunderstood
  something?  Steven?).

Subset v2:
- Minimal unchanged subset from 'ftrace syscalls, PowerPC: Various fixes,
  Compat Syscall support and PowerPC implementation' v2 patch series.


