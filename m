Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab2IGRZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 13:25:45 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:18457
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530Ab2IGRZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 13:25:17 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1202hzz8275dhz2dh668h839h944hd25hf0ah11b5h121eh1220h1288h1155h)
X-WSS-ID: 0M9ZPPX-01-LY9-02
X-M-MSG: 
Date: Fri, 7 Sep 2012 19:25:05 +0200
From: Robert Richter <robert.richter@amd.com>
To: David Ahern <dsahern@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf, ibs: Check syscall attribute flags
Message-ID: <20120907172505.GM8285@erda.amd.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-9-git-send-email-dsahern@gmail.com>
 <20120906190238.GA29278@erda.amd.com>
 <5048F6BF.70106@gmail.com>
 <20120906195645.GD8285@erda.amd.com>
 <20120907164114.GJ8285@erda.amd.com>
 <504A25DB.2030100@gmail.com>
 <20120907170700.GK8285@erda.amd.com>
 <504A2ADC.4050703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <504A2ADC.4050703@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.09.12 11:11:56, David Ahern wrote:
> On 9/7/12 11:07 AM, Robert Richter wrote:
> >> Am I reading this right - if exclude_guest is set then perf_ibs_init
> >> returns -EINVAL?
> >
> > Yes, the hardware does not support this. I will look for a solution
> > which emulates this is software.
> 
> ugh, that's exactly we need for Intel: if precise is set, exclude_guest 
> must be set.
> 
> In perf I would like to set exclude_guest if precise is set -- what I 
> mentioned yesterday for the patch https://lkml.org/lkml/2012/7/20/437. 
> With my patch -e cycles:p on AMD will then fail EINVAL.

You may set this bit per default. On EINVAL perf falls back and clears
the bit. I tested exactly this for ibs and it works.

So, on Intel, if the guest_exclude bit is not set, the kernel simply
throws an EINVAL too, but since perf sets it per default with the
precise modifier there shouldn't be any problem here.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

