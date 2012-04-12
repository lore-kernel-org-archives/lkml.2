Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762327Ab2DLJ3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 05:29:09 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44717 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab2DLJ3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 05:29:06 -0400
Message-ID: <4F86A03A.1080203@linux.vnet.ibm.com>
Date: Thu, 12 Apr 2012 14:58:26 +0530
From: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH 0/2] perf/probe: verify instruction/offset in perf before
 adding a uprobe
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041209-1780-0000-0000-000004B2DDDE
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000266; HX=3.00000187; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00130189; UDB=6.00030744; UTC=2012-04-12
 09:29:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is to augment Srikar's perf support for uprobes patch
(https://lkml.org/lkml/2012/4/11/191) with the following features:

a. Instruction verification for user space tracing
b. Function boundary validation support to uprobes as its kernel
counterpart (Commit-ID: 1c1bc922).

This will help in ensuring uprobe is placed at right location inside
the intended function.


--
 Prashanth Nageshappa (1):
      address build warnings/errors in insn.c
      changes to perf code to verify instruction/offset before adding uprobe


 arch/x86/lib/insn.c                    |    8 +++
 tools/perf/arch/x86/Makefile           |    4 ++
 tools/perf/arch/x86/util/probe-event.c |   83 ++++++++++++++++++++++++++++++++
 tools/perf/util/include/linux/string.h |    1 
 tools/perf/util/probe-event.c          |   22 ++++++++
 tools/perf/util/probe-event.h          |    2 +
 tools/perf/util/symbol.c               |    2 +
 tools/perf/util/symbol.h               |    1 
 8 files changed, 122 insertions(+), 1 deletions(-)
 create mode 100644 tools/perf/arch/x86/util/probe-event.c

