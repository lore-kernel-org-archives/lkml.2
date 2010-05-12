Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab0ELRAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:00:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52067 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab0ELRA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:00:28 -0400
Subject: Re: Perf and ftrace [was Re: PyTimechart]
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Pierre Tardy <tardyp@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
       arjan@infradead.org, ziga.mahkovec@gmail.com,
       davem <davem@davemloft.net>
In-Reply-To: <20100512164650.GH5405@nowhere>
References: <AANLkTilJLcdfK-vgqGdXyaZ_bQ1BDFmQl619egtGAA4i@mail.gmail.com>
	 <20100511213625.GD5422@nowhere>
	 <AANLkTikumkBKwYTYIK63mT2i_hI4SAo-Eua0cx9OCHnD@mail.gmail.com>
	 <20100512144811.GA5405@nowhere>
	 <1273678596.27703.30.camel@gandalf.stny.rr.com>
	 <20100512164650.GH5405@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 19:00:24 +0200
Message-ID: <1273683624.1626.127.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 18:46 +0200, Frederic Weisbecker wrote:
> But there is no strong reason for perf record not to use splice,
> a part the fact that perf doesn't support splice.
> 
Its mostly an interface/api question. You cannot easily splice() a
mmap()'ed buffer on machines that have address constraints like sparc.

The thing I was thinking about is adding a new syscall that creates a
single buffer of specified size and provides a fd. Then use
PERF_EVENT_IOC_SET_OUTPUT, to connect an event to that fd/buffer and use
splice() on that fd.

It could reuse most of the perf buffer code, but simply not map it into
userspace and therefore not have the restriction on the vaddr.

Once you have that, a .splice_read implementation shouldn't be too hard.

