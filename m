Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab0IJIQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 04:16:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40451 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab0IJIQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 04:16:25 -0400
Subject: Re: [RFC PATCH 1/2] perf_events: add support for per-cpu
 per-cgroup monitoring (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com, acme@redhat.com, Tejun Heo <tj@kernel.org>
In-Reply-To: <AANLkTimHwiXa62GhHA0hQ0AOcDaxgqRcV+O63G_qoZW8@mail.gmail.com>
References: <4c88dca1.44e7d80a.577e.3592@mx.google.com>
	 <1284040322.2589.174.camel@edumazet-laptop>
	 <AANLkTimHwiXa62GhHA0hQ0AOcDaxgqRcV+O63G_qoZW8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Sep 2010 10:16:06 +0200
Message-ID: <1284106566.402.26.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-09 at 23:41 +0200, Stephane Eranian wrote:
> > alloc_percpu() is zalloc_percpu() in fact, memory is already cleared.
> >
> I remember thinking about this and trying to trace to the code down
> to figure this out. But it is rather complicated. If alloc_percpu() always
> clears the memory, then I think that calling is zalloc_percpu()
> would be more helpful.... 

pcpu_populate_chunk() in mm/percpu-vm.c does indeed do that memset, the
one in mm/percpu-km.c does not.

It is not obviously clear to me the -km allocator does indeed result in
zero filled memory.

Tejun?
