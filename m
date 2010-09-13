Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab0IMRfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:35:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:50804 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab0IMRfr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:35:47 -0400
Subject: Re: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com,
        "markus.t.metzger" <markus.t.metzger@intel.com>
In-Reply-To: <AANLkTimZTzCjea3KFxGcaQ7kscod7sOrz13LkNF_u38w@mail.gmail.com>
References: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com>
	 <20100913150914.GA6155@nowhere>
	 <AANLkTi=OR69sDbUMkSnx_-bpF=yHF_xNY1v=-BJgLpp5@mail.gmail.com>
	 <1284391000.2275.338.camel@laptop>
	 <AANLkTin35TXPcs9u3pLfo8QRUmGnftT1DPfswRUVEvJW@mail.gmail.com>
	 <1284391480.2275.350.camel@laptop>
	 <AANLkTik8r4moPy5muNyT2oKGH5aEaMOLL0Zqn=-hkpos@mail.gmail.com>
	 <1284392476.2275.369.camel@laptop>
	 <AANLkTimZTzCjea3KFxGcaQ7kscod7sOrz13LkNF_u38w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 19:35:29 +0200
Message-ID: <1284399329.2275.387.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 17:55 +0200, Stephane Eranian wrote:
> 
> Ok, so you're saying there is no allocator that will give non-contiguous
> physical memory WITHOUT requiring a page fault to populate the pte.
> 
> On the other hand, with vmalloc_node() the pte are populated when
> you first touch the memory. That happens as part of memset() right after
> the allocation and thus outside of NMI interrupt handler.
> 
> Does this sound right? 

Nope, in particular read: http://lkml.org/lkml/2010/7/14/465

The issue is that the vmalloc space can be mapped in different
processes, and that memset() will only ensure its mapped in the current
process, but the next one might need that fault to populate.


