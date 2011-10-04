Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab1JDO0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 10:26:54 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:2008
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757065Ab1JDO0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 10:26:53 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz179dN1432N98dKzz1202hzzz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LSJPGG-02-UR5-02
X-M-MSG: 
Date: Tue, 4 Oct 2011 16:26:41 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        acme <acme@ghostprotocols.net>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [V3][PATCH 0/7] perf, x86: Implement AMD IBS
Message-ID: <20111004142641.GF21506@erda.amd.com>
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
 <1316778523.9084.17.camel@twins>
 <20110923122014.GP6063@erda.amd.com>
 <1317716839.25926.12.camel@twins>
 <20111004085409.GA18566@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111004085409.GA18566@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.10.11 04:54:09, Ingo Molnar wrote:
> So the whole IBS thing looks quite unintegrated to me - and that's 
> partly because the hw is admittedly weird. The way we could perhaps 
> live with it upstream is two conditions:
> 
>  - Testable IBS user-space code a bit more prominently integrated
>    than having to go down into a cellar with no working lights and 
>    finding the code on display in tools/perf/Documentation/examples/ 
>    on the bottom of a locked filing cabinet stuck in a disused
>    lavatory with a sign on the door saying 'Beware of the Leopard.'

With Lin Ming's patch

 [PATCH v2 6/6] perf tool: Parse general/raw events from sysfs

you can use perf record to collect IBS samples, e.g.:

 # perf record -e ibs_fetch:r0 -c 100000 -a bash -c someload
 [ perf record: Woken up 3 times to write data ]
 [ perf record: Captured and wrote 2.004 MB perf.data (~87572 samples) ]

With Stephane's patch

 [PATCH] perf: make perf.data more self-descriptive (v8)

I could extend perf report to add an IBS parser (I need to know the
pmu name/type value mapping).

Do you have something like that in mind?

As all these patches are still off-tree I would rather prefer to
decouple the IBS patches from a parser implementation and add it later
as a single patch series. Hmm?

>  - Only root/privileged users should be able to access it. Right now
>    i think it's root-only due to percpu restrictions, but wanted to 
>    mention it that this is an explicit requirement.

Yes, IBS is restricted to percpu. And percpu requires root privileges
like all other pmu events. What is your point here?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

