Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab0LWKSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 05:18:20 -0500
Received: from canuck.infradead.org ([134.117.69.58]:56503 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab0LWKST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 05:18:19 -0500
Subject: Re: [RFC PATCH] perf: Add load latency monitoring on Intel
 Nehalem/Westmere
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, paulus <paulus@samba.org>
In-Reply-To: <1293094781.2565.197.camel@minggr.sh.intel.com>
References: <1293005543.2565.156.camel@minggr.sh.intel.com>
	 <1293008431.2170.63.camel@laptop>
	 <AANLkTintfpyvx=Pj1+uu8kCkFn3zT6b36h27Hb7pm=ZF@mail.gmail.com>
	 <1293014701.2170.111.camel@laptop>  <1293014967.2170.114.camel@laptop>
	 <1293094781.2565.197.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 23 Dec 2010 11:18:18 +0100
Message-ID: <1293099498.2170.452.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-23 at 16:59 +0800, Lin Ming wrote:
> > {L1, L2, L3, RAM}x{snoop, local, remote}x{shared, exclusive} + {unknown,
> > uncached, IO}
> > 
> > Which takes all of 5 bits to encode.
> 
> Do you mean below encoding?
> 
> bits4 3 2 1 0
>     + + + + +
>     | | | | |
>     | | | {L1, L2, L3, RAM} or {unknown, uncached, IO}
>     | | |
>     | {snoop, local, remote, OTHER}
>     |
>     {shared, exclusive}
> 
> If bits(2-3) is OTHER, then bits(0-1) is the encoding of {unknown,
> uncached, IO}. 

That is most certainly a very valid encoding, and a rather nice one at
that. I hadn't really gone further than: 4*3*2 + 3 < 2^5 :-)

If you also make OTHER=0, then a valid encoding for unknown is also 0,
which is a nice meaning for 0...
