Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab1DZTNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:13:18 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:49704 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab1DZTNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:13:17 -0400
Subject: Re: [BUG] perf and kmemcheck : fatal combination
From: Pekka Enberg <penberg@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Vegard Nossum <vegardno@ifi.uio.no>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <1303821188.20212.264.camel@twins>
References: <1303747731.2747.182.camel@edumazet-laptop>
	 <1303803525.20212.20.camel@twins> <20110426080443.GA806@elte.hu>
	 <1303808257.3012.3.camel@edumazet-laptop>
	 <1303811635.3358.21.camel@edumazet-laptop>
	 <BANLkTinOUFrJuauoxnRTkvrhZRxdYd05Mw@mail.gmail.com>
	 <1303813668.3358.22.camel@edumazet-laptop>
	 <1303820855.3358.49.camel@edumazet-laptop>
	 <1303821188.20212.264.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 26 Apr 2011 22:13:12 +0300
Message-ID: <1303845192.15231.113.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 14:33 +0200, Peter Zijlstra wrote:
> On Tue, 2011-04-26 at 14:27 +0200, Eric Dumazet wrote:
> > Thats far from trivial, maybe because we dont have NOTRACK api for
> > percpu allocations ? 
> 
> We can't use per-cpu allocations from NMI context because of the same
> problem, per-cpu uses vmalloc and vmalloc needs faults. Hence that
> shouldn't be a problem.
> 
> It looks like you covered most of it though, the buffer and the
> callchain stuff, aside from that it should only use some static data.
> 
> Pekka, what does kmemcheck do for .data and .bss things?

No, kmemcheck is only active for memory allocated with slab and the page
allocator .

