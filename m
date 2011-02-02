Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab1BBHMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 02:12:23 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:56356 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab1BBHMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 02:12:22 -0500
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
Subject: PowerPC, ftrace: Add PPC raw syscall tracepoints & ftrace fixes (mimimal subset only) v3
Date: Wed,  2 Feb 2011 18:11:52 +1100
Message-Id: <1296630718-17537-1-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git send-email just failed to save or send this message, so retyping...


Hi All,

This is a partial version of my 'ftrace syscalls, PowerPC: Various fixes,
Compat Syscall support and PowerPC implementation'.

I finally found some time this week to go back and work on this patchset, but
now I've been hit with another more pressing work item, so this will once again
have to go on the backburner :-(. Even though I haven't finished fixing up the
complete 40 patch series I would still like to get this smaller minimal subset
in. I've had a request for the raw syscall tracepoints on PowerPC that this
subset implements, and these patches have proven to be pretty stable.

This subset also fixes ftrace syscalls to ensure that events will only be
created for syscalls that successfully map their metadata to a syscall number,
so that non-working phantom events are not created. Patches #2 and #6 in this
series are not strictly necessary for this, they just optimise ftrace syscalls
a bit.

What's missing from this series that was in the v2 is the conversion of
all the syscalls implemented under /arch/powerpc, Jason Baron's compat
syscall support and the conversion of the remaining native and compat
syscalls to this infrastructure.


This is based on tip/master. The PowerPC specific patch will need Ben's ACK
before it goes in.

Changes from the last subset I posted:
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

