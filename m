Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab0ELRrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:47:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41434 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab0ELRrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:47:09 -0400
Subject: Re: Perf and ftrace [was Re: PyTimechart]
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Pierre Tardy <tardyp@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem <davem@davemloft.net>
In-Reply-To: <20100512170734.GA15953@Krystal>
References: <AANLkTilJLcdfK-vgqGdXyaZ_bQ1BDFmQl619egtGAA4i@mail.gmail.com>
	 <20100511213625.GD5422@nowhere>
	 <AANLkTikumkBKwYTYIK63mT2i_hI4SAo-Eua0cx9OCHnD@mail.gmail.com>
	 <20100512144811.GA5405@nowhere>
	 <1273678596.27703.30.camel@gandalf.stny.rr.com>
	 <20100512164650.GH5405@nowhere> <1273683624.1626.127.camel@laptop>
	 <20100512170734.GA15953@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 19:47:05 +0200
Message-ID: <1273686425.1626.142.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 13:07 -0400, Mathieu Desnoyers wrote:
> > Its mostly an interface/api question. You cannot easily splice() a
> > mmap()'ed buffer on machines that have address constraints like sparc.
> 
> Ah ? Can you explain this issue a bit more ? There is possibly a concern I don't
> quite see here. 

IIRC Sparc has virtually tagged D-caches on the lower 9 bits of the pfn,
so to avoid cache aliasing both mappings (kernel and user) need to be
aligned.

Since splice needs to swap pages it needs to allocate replacement pages
with the exact right alignment, which is rather expensive (in either
time or space).


