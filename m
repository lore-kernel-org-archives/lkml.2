Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab1DZMdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:33:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37549 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1DZMdd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:33:33 -0400
Subject: Re: [BUG] perf and kmemcheck : fatal combination
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Vegard Nossum <vegardno@ifi.uio.no>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <1303820855.3358.49.camel@edumazet-laptop>
References: <1303747731.2747.182.camel@edumazet-laptop>
	 <1303803525.20212.20.camel@twins> <20110426080443.GA806@elte.hu>
	 <1303808257.3012.3.camel@edumazet-laptop>
	 <1303811635.3358.21.camel@edumazet-laptop>
	 <BANLkTinOUFrJuauoxnRTkvrhZRxdYd05Mw@mail.gmail.com>
	 <1303813668.3358.22.camel@edumazet-laptop>
	 <1303820855.3358.49.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Apr 2011 14:33:08 +0200
Message-ID: <1303821188.20212.264.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 14:27 +0200, Eric Dumazet wrote:
> Thats far from trivial, maybe because we dont have NOTRACK api for
> percpu allocations ? 

We can't use per-cpu allocations from NMI context because of the same
problem, per-cpu uses vmalloc and vmalloc needs faults. Hence that
shouldn't be a problem.

It looks like you covered most of it though, the buffer and the
callchain stuff, aside from that it should only use some static data.

Pekka, what does kmemcheck do for .data and .bss things?
