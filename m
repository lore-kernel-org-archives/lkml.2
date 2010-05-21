Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab0EUOxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:53:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001Ab0EUOxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:53:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100521135944.884367426@chello.nl>
References: <20100521135944.884367426@chello.nl> <20100521134205.781916350@chello.nl>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: dhowells@redhat.com, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>,
       Will Deacon <will.deacon@arm.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/4] arch: local64_t
Date: Fri, 21 May 2010 15:52:29 +0100
Message-ID: <23895.1274453549@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> + * This is the default implementation, which uses atomic64_t.  Which is
> + * rather pointless.  The whole point behind local64_t is that some processors
> + * can perform atomic adds and subtracts in a manner which is atomic wrt IRQs
> + * running on this CPU.  local64_t allows exploitation of such capabilities.

Interesting...  What FRV does in atomic64-ops.S should probably be rebranded
local64_t, and atomic64_t ops be based on that in non-SMP mode.

What I did on FRV was to emulate LL/ST instructions using some of the
excessive numbers of conditional bits to do so - but it only works on UP
systems.

David
