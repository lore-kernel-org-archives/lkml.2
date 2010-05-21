Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab0EUOUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:20:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54474 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab0EUOUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:20:43 -0400
Message-Id: <20100521134205.781916350@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 21 May 2010 15:42:05 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>,
       Will Deacon <will.deacon@arm.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] convert perf to local64_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches introduce local64_t.

Since perf_event:count is only modified cross-cpu when child-counters
feed back their changes on exit, and we can use a secondary variable
for that, we can convert perf to use local64_t instead of atomic64_t
and use instructions without buslock semantics.

The local64_t implementation uses local_t for 64 bits, since local_t is
of type long, for 32 bit it falls back to atomic64_t. Architectures can
provide their own implementation as usual.



