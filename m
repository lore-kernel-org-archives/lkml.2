Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750839Ab0LGFAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 00:00:38 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:41830 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab0LGFAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 00:00:37 -0500
Content-Type: text/plain; charset=UTF-8
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
        Jason Baron <jbaron@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Nathan Lynch <ntl@pobox.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andreas Dilger <adilger@dilger.ca>, Jiri Kosina <jkosina@suse.cz>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Alexander Graf <agraf@suse.de>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Gibson <dwg@au1.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: PowerPC, ftrace: Add PPC raw syscall tracepoints & ftrace fixes (subset from v2)
From: Ian Munsie <imunsie@au1.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
In-reply-to: <1291696151-4336-1-git-send-email-imunsie@au1.ibm.com>
References: <1291696151-4336-1-git-send-email-imunsie@au1.ibm.com>
Date: Tue, 07 Dec 2010 16:00:31 +1100
Message-Id: <1291698004-sup-2452@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, It seems that I missed LKML in the to address of the cover email
for this set. Guess I shouldn't send a patch set just as the fire alarm
goes off.  Resending:


Hi all,

This is a partial version of my 'ftrace syscalls, PowerPC: Various fixes,
Compat Syscall support and PowerPC implementation'.

I've been tied up with other work and haven't had time to complete the
work on the v3 of the full set, but the patches I'm including here are
pretty stable and there has been a request for the raw syscall
tracepoints in PowerPC.

The actual patches included here have not been changed from the v2 other than
rebasing them on tip/master. They add support for *raw* syscall tracepoints on
PowerPC, while fixing ftrace syscalls to ensure that events will only be created
for syscalls that successfully map their metadata to a syscall number,
so that non-working phantom events are not created.

Patch #2 and #6 in this series are not strictly necessary for this, they just
optimise ftrace syscalls a bit.


What's missing from this series that was in the v2 is the conversion of
all the syscalls implemented under /arch/powerpc, Jason Baron's compat
syscall support and the conversion of the remaining native and compat
syscalls to this infrastructure.

Cheers,
-Ian

GIT: [PATCH 1/6] ftrace syscalls: don't add events for unmapped syscalls
GIT: [PATCH 2/6] trace syscalls: Remove redundant syscall_nr checks
GIT: [PATCH 3/6] ftrace syscalls: Make arch_syscall_addr weak
GIT: [PATCH 4/6] ftrace syscalls: Allow arch specific syscall symbol matching
GIT: [PATCH 5/6] trace, powerpc: Implement raw syscall tracepoints on PowerPC
GIT: [PATCH 6/6] trace syscalls: Early terminate search for sys_ni_syscall
