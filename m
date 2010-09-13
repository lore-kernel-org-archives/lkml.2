Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0IMTnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:43:01 -0400
Received: from mail.openrapids.net ([64.15.138.104]:51416 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752833Ab0IMTnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:43:00 -0400
Date: Mon, 13 Sep 2010 15:42:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        "markus.t.metzger" <markus.t.metzger@intel.com>
Subject: Re: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
Message-ID: <20100913194258.GB28294@Krystal>
References: <1284391000.2275.338.camel@laptop> <AANLkTin35TXPcs9u3pLfo8QRUmGnftT1DPfswRUVEvJW@mail.gmail.com> <1284391480.2275.350.camel@laptop> <AANLkTik8r4moPy5muNyT2oKGH5aEaMOLL0Zqn=-hkpos@mail.gmail.com> <1284392476.2275.369.camel@laptop> <AANLkTimZTzCjea3KFxGcaQ7kscod7sOrz13LkNF_u38w@mail.gmail.com> <1284399329.2275.387.camel@laptop> <AANLkTi=DGnP-r++PhzWFMdwdu_ReUKAmGLCA2zPNBG5J@mail.gmail.com> <20100913193120.GA28294@Krystal> <1284406463.2275.423.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284406463.2275.423.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:42:44 up 233 days, 22:19,  5 users,  load average: 0.03, 0.05,
	0.05
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Mon, 2010-09-13 at 15:31 -0400, Mathieu Desnoyers wrote:
> > > Ok, so can we play the same trick you're playing with the sampling
> > > buffer, i.e., you use alloc_pages_node() for one page at a time, and
> > > then you stitch them on demand via SW?
> > 
> > Well, a thought is striking me: it sounds like you are re-doing YAORB (short
> > for Yet Another Ring Buffer, 
> 
> He's not.. the hardware needs a large (virtually) contiguous region to
> poke data into, we need to read it out from NMI context.

Ah ok, it's different then.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
