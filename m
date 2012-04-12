Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762333Ab2DLJaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 05:30:20 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40522 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab2DLJaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 05:30:18 -0400
Message-ID: <4F86A060.1010604@linux.vnet.ibm.com>
Date: Thu, 12 Apr 2012 14:59:04 +0530
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
Subject: [PATCH 1/2] perf/probe: verify instruction/offset in perf before
 adding a uprobe
References: <20120412085748.23484.53789.stgit@nprashan.in.ibm.com>
In-Reply-To: <20120412085748.23484.53789.stgit@nprashan.in.ibm.com>
X-Forwarded-Message-Id: <20120412085748.23484.53789.stgit@nprashan.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041209-7282-0000-0000-0000081FBD7F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To verify instruction/offset in perf, before adding a uprobe we
need to use arc/x86/lib/insn.c from perf code. Since perf Makefile
enables -Wswitch-default flag it causes build warnings/failures. This
patch is to address the build warnings in insn.c.


Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
---

 arch/x86/lib/insn.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 25feb1a..b9e42f1 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -397,6 +397,8 @@ static void __get_moffset(struct insn *insn)
 		insn->moffset2.value = get_next(int, insn);
 		insn->moffset2.nbytes = 4;
 		break;
+	default:
+		break;
 	}
 	insn->moffset1.got = insn->moffset2.got = 1;

@@ -417,6 +419,8 @@ static void __get_immv32(struct insn *insn)
 		insn->immediate.value = get_next(int, insn);
 		insn->immediate.nbytes = 4;
 		break;
+	default:
+		break;
 	}

 err_out:
@@ -441,6 +445,8 @@ static void __get_immv(struct insn *insn)
 		insn->immediate2.value = get_next(int, insn);
 		insn->immediate2.nbytes = 4;
 		break;
+	default:
+		break;
 	}
 	insn->immediate1.got = insn->immediate2.got = 1;

@@ -463,6 +469,8 @@ static void __get_immptr(struct insn *insn)
 	case 8:
 		/* ptr16:64 is not exist (no segment) */
 		return;
+	default:
+		break;
 	}
 	insn->immediate2.value = get_next(unsigned short, insn);
 	insn->immediate2.nbytes = 2;

