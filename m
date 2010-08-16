Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab0HPHhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 03:37:13 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:10306 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab0HPHhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 03:37:11 -0400
X-SpamScore: 6
X-BigFish: VPS6(z3cfcs329eqz1432N98dN936eKzz1202hzzz32i2a8h64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0L78IHO-02-2XC-02
X-M-MSG: 
Date: Mon, 16 Aug 2010 09:37:01 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100816073701.GF26154@erda.amd.com>
References: <20100804162026.GU3353@redhat.com>
 <20100804163930.GE5130@lenovo>
 <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100811220058.GT26154@erda.amd.com>
 <20100812131007.GW26154@erda.amd.com>
 <20100812182126.GM4879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100812182126.GM4879@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.08.10 14:21:26, Don Zickus wrote:

> > I was testing the patch further, it properly filters perfctr
> > back-to-back nmis. I was able to reliable detect unknown nmis
> > triggered by the nmi button during high load perf sessions with
> > multiple counters, no false positives.
> 
> For my own curiousity, what type of high load perf sessions are you using
> to test this.  I don't know perf well enough to have it generate events
> across multiple perfctrs.

You put load on all cpus and then start something like the following:

 perf record -e cycles -e instructions -e cache-references \
 	-e cache-misses -e branch-misses -a -- sleep 10

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

