Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab0IMTep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:34:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46829 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab0IMTeo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:34:44 -0400
Subject: Re: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        "markus.t.metzger" <markus.t.metzger@intel.com>
In-Reply-To: <20100913193120.GA28294@Krystal>
References: <20100913150914.GA6155@nowhere>
	 <AANLkTi=OR69sDbUMkSnx_-bpF=yHF_xNY1v=-BJgLpp5@mail.gmail.com>
	 <1284391000.2275.338.camel@laptop>
	 <AANLkTin35TXPcs9u3pLfo8QRUmGnftT1DPfswRUVEvJW@mail.gmail.com>
	 <1284391480.2275.350.camel@laptop>
	 <AANLkTik8r4moPy5muNyT2oKGH5aEaMOLL0Zqn=-hkpos@mail.gmail.com>
	 <1284392476.2275.369.camel@laptop>
	 <AANLkTimZTzCjea3KFxGcaQ7kscod7sOrz13LkNF_u38w@mail.gmail.com>
	 <1284399329.2275.387.camel@laptop>
	 <AANLkTi=DGnP-r++PhzWFMdwdu_ReUKAmGLCA2zPNBG5J@mail.gmail.com>
	 <20100913193120.GA28294@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 21:34:23 +0200
Message-ID: <1284406463.2275.423.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 15:31 -0400, Mathieu Desnoyers wrote:
> > Ok, so can we play the same trick you're playing with the sampling
> > buffer, i.e., you use alloc_pages_node() for one page at a time, and
> > then you stitch them on demand via SW?
> 
> Well, a thought is striking me: it sounds like you are re-doing YAORB (short
> for Yet Another Ring Buffer, 

He's not.. the hardware needs a large (virtually) contiguous region to
poke data into, we need to read it out from NMI context.
