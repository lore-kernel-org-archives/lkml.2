Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab0EMGEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 02:04:45 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:34299 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab0EMGEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 02:04:43 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: perf trace: Fix array handling & value truncation
Date: Thu, 13 May 2010 16:03:45 +1000
Message-Id: <1273730632-21008-1-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes several issues with perf trace relating to the size of a long.

The first issue fixed by patch #2 is an assumption that tracepoints with arrays
as part of their output (for instance, raw_syscalls:sys_enter) that the size of
each element within the array is a long size. Due to further problems fixed by
patches #3 through #5, the long_size was not even being set in the
trace-event-parse.c file, and as a result the code was previously treating the
array elements as 0 size.

Patch #6 fixes issues where printing the values of pointers and longs from
64bit kernels were being truncated if perf was compiled as 32bit. This
obviously effects tracepoints with a "%p" or "%ld" in their output format, but
also affects the printout of the location of kprobes.

Patches #1 and #7 apply good software engineering practice to help spot future
regressions of these issues.

Thanks,
-Ian

