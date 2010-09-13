Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab0IMPvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:51:25 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:37549 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab0IMPvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:51:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W+3OP7UQwzvr6v1y9HwfH+OU3QpSO9O/ogm8+z5q17NpPkW4WyqHA2tVW+KSwYuCKr
         NOqa6J07xWSmOJW4/XVe1sLKYakyJY24SMXFkshFZZ8e0KqErWnn9ULTY2b/pYDAw5Lk
         P9fdnuLVOLuXYtULvtGsLsEynxX6XWPJh97Rw=
Date: Mon, 13 Sep 2010 17:51:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com,
        "markus.t.metzger" <markus.t.metzger@intel.com>
Subject: Re: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
Message-ID: <20100913155117.GB6155@nowhere>
References: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com> <20100913150914.GA6155@nowhere> <AANLkTi=OR69sDbUMkSnx_-bpF=yHF_xNY1v=-BJgLpp5@mail.gmail.com> <1284391000.2275.338.camel@laptop> <AANLkTin35TXPcs9u3pLfo8QRUmGnftT1DPfswRUVEvJW@mail.gmail.com> <1284391480.2275.350.camel@laptop> <AANLkTik8r4moPy5muNyT2oKGH5aEaMOLL0Zqn=-hkpos@mail.gmail.com> <1284392476.2275.369.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284392476.2275.369.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 05:41:16PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-09-13 at 17:31 +0200, Stephane Eranian wrote:
> > On Mon, Sep 13, 2010 at 5:24 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Mon, 2010-09-13 at 17:20 +0200, Stephane Eranian wrote:
> > >
> > >> That is the case we the sizes you have chosen today. For DS, we
> > >> could round up to one page for now.
> > >
> > > Markus chose the BTS size, for PEBS a single page was plenty since we do
> > > single event things (although we could do multiple for attr.precise_ip <
> > > 2).
> > >
> > > For DS there's:
> > >  kmalloc_node(sizeof(struct ds), GFP_KERNEL | __GFP_ZERO, cpu_node(cpu));
> > >
> > Ok, let try again with alloc_pages_node() + kmalloc_node().
> > I think we can stick with kmalloc() for DS because we are far from
> > consuming a page.
> 
> Thing is, if you're really seeing allocation failures,
> alloc_pages_node() isn't going to help. And the problem is, these
> allocations aren't movable, so memory compaction and all the other fancy
> stuff aren't really going to help much :/
> 
> There was some talk about a function that should sync all of vmalloc
> space, but iirc it was broken for some configs.


Mathieu has posted a set of patches to support traps/faults in NMIs,
this has been followed by a discussion with Linus.

http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-07/msg05222.html

I think they came with some patches to solve the problem, pushing all the
fixup code in the NMI area, but the discussion was preempted by holidays
and I suspect Mathieu is focusing on some other scheduler patches right now :)

