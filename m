Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab0KLLhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 06:37:07 -0500
Received: from canuck.infradead.org ([134.117.69.58]:43558 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab0KLLhF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:37:05 -0500
Subject: Re: [PATCH 2/3] perf: Add support for extra parameters for raw
 events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com,
        paulus <paulus@samba.org>
In-Reply-To: <AANLkTi=idvNVyccD53Xwjp5mWfJb=S8UXekhXNqhzRPC@mail.gmail.com>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
	 <1289492117-18066-2-git-send-email-andi@firstfloor.org>
	 <4CDC2DDD.50508@linux.vnet.ibm.com> <4CDC3845.4030104@linux.intel.com>
	 <4CDC4628.8020109@linux.vnet.ibm.com>
	 <20101111194936.GJ18718@basil.fritz.box> <1289505587.2084.193.camel@laptop>
	 <20101111201259.GL18718@basil.fritz.box> <1289507858.2084.195.camel@laptop>
	 <20101112102748.GA8020@basil.fritz.box>
	 <AANLkTi=idvNVyccD53Xwjp5mWfJb=S8UXekhXNqhzRPC@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 12 Nov 2010 12:36:57 +0100
Message-ID: <1289561817.2084.240.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 11:49 +0100, Stephane Eranian wrote:
> The difficulty with PEBS-LL (load latency) is not so much the encoding of the
> latency. It is more how to expose the data back to user. You get a full PEBS
> record for each miss. So you get the PEBS machine state + data addr, miss
> latency, and data source (where did the line come from). We have already
> discussed how to expose machine state in general. I'll work on a patch for this.

Frederic was working on this PERF_SAMPLE_REGS stuff as well for his copy
the stack top and let dwarfs go wild at it patches.

> So we can get the general PEBS machine state out. However, the question is
> how do we expose data addr, latency, data source? We can reuse the
> SAMPLE_ADDR for the data address. Sample IP would point to the load
> instruction (with help from LBR to correct the off by one issue). For
> the latency

Right, PERF_SAMPLE_IP and PERF_SAMPLE_ADDR 

> and data source, I proposed using pseudo regs and leveraging the sampled machine
> state mechanism. An alternative may be to define a new record type that would b
> generic enough to be reusable, for instance { instr_addr, data_addr,
> latency, data_src, flags; }. 

I'm not sure I like the idea of pseudo regs.. I'm afraid it'll get messy
quite quickly. Load-latency is a bit like IBS that way, terribly messy.


