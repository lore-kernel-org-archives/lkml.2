Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab0JLMue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 08:50:34 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:41139 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932261Ab0JLMud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 08:50:33 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: _MG1zh0VM1nWzwHHj7o8GZk5yyOrq6hFKsIJS5gCa_JVEmI
 SWEvyFkK2.xuXa8SMHykbM6HGXdnhixA1Qif.g0eXk9rwC18mbsRA.oXwmMJ
 I7Tfq.MLM98UDwnYnuxwSYpYEML4cwy2u8PJefrSQSyCTa8UB1l2YicU1DOn
 3hG4iJh5l6B9TwkealXY8inXyiL2hrm.EVYRp8O0QZ8sEioyBTc_1yV34MRd
 S
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 12 Oct 2010 07:50:27 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        Eilon Greenstein <eilong@broadcom.com>, Christoph Hellwig <hch@lst.de>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH net-next] net:  allocate skbs on local node
In-Reply-To: <4CB441CB.2000708@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.1010120745360.31832@router.home>
References: <1286838210.30423.128.camel@edumazet-laptop> <1286839363.30423.130.camel@edumazet-laptop> <1286859925.30423.184.camel@edumazet-laptop> <20101011230322.f0f6dd47.akpm@linux-foundation.org> <1286866699.30423.234.camel@edumazet-laptop>
 <20101012002435.f51f2c0e.akpm@linux-foundation.org> <1286869793.2732.24.camel@edumazet-laptop> <20101012005856.994bea6d.akpm@linux-foundation.org> <4CB441CB.2000708@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010, Pekka Enberg wrote:

> There's little point in discussing the removal of SLAB as long as there are
> performance regressions for real workloads from people who are willing to
> share results and test patches. I'm optimistic that we'll be able to try
> removing SLAB some time next year unless something interesting pops up...

Hmmm. Given these effects I think we should be more cautious regarding the
unification work. May be the "unified allocator" should replace SLAB
instead and SLUB can stay unchanged? The unification patches go back to
the one lock per node SLAB thing because the queue maintenance overhead is
otherwise causing large regressions in hackbench because of lots of atomic
ops. The per node lock seem to be causing problems here in the network
stack,. Take the unified as a SLAB cleanup instead? Then at least we have
a large common code base and just differentiate through the locking
mechanism?

