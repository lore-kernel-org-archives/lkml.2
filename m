Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964962Ab1LPWgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 17:36:44 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:17199 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab1LPWgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 17:36:38 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.36.179.132;KIP:(null);UIP:(null);IPV:NLI;H:kedge1.utk.tennessee.edu;RD:kedge1.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 16 Dec 2011 17:36:35 -0500
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <mingo@elte.hu>, William Cohen <wcohen@redhat.com>,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        Vince Weaver <vince@deater.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/6] perf: x86 RDPMC and RDTSC support
In-Reply-To: <20111121145114.049265181@chello.nl>
Message-ID: <alpine.DEB.2.00.1112161731570.6060@cl320.eecs.utk.edu>
References: <20111121145114.049265181@chello.nl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011, Peter Zijlstra wrote:

> These few patches implement x86 RDPMC support and add an extention to the self
> monitoring data to also allow additional time updates using userspace TSC reads.
> 
> There's a few loose ends, but it mostly seems to work.

I've finally had time to apply and test these patches.

Firstly, the documentation was a bit sparse (though I guess that's OK for 
an RFC patch).  Is it possible to read multiple counters at once with this 
interface, i.e. using FORMAT_GROUP?

Also, am I correct that the counters are set to always counting, so you 
always have to do a rdpmc() before and a rdpmc() after?

I ran some benchmarks, the results can be found here:
   http://web.eecs.utk.edu/~vweaver1/projects/perf-events/benchmarks/rdtsc_overhead/

I used the mmap_read_self() routine from your example as the "read" 
performance that I measured.

If start/stop are truly unnecessary when run with your patch then the 
"total" results shift in your favor.  Otherwise perfmon2 and perfctr still 
win the self-monitoring overhead race by a lot.

Vince

