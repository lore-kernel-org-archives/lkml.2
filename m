Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab2IGRHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 13:07:16 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:9616
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868Ab2IGRHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 13:07:14 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1202hzzz2dh668h839h944hd25hf0ah11b5h121eh1220h1288h1155h)
X-WSS-ID: 0M9ZOVT-01-KOW-02
X-M-MSG: 
Date: Fri, 7 Sep 2012 19:07:00 +0200
From: Robert Richter <robert.richter@amd.com>
To: David Ahern <dsahern@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf, ibs: Check syscall attribute flags
Message-ID: <20120907170700.GK8285@erda.amd.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-9-git-send-email-dsahern@gmail.com>
 <20120906190238.GA29278@erda.amd.com>
 <5048F6BF.70106@gmail.com>
 <20120906195645.GD8285@erda.amd.com>
 <20120907164114.GJ8285@erda.amd.com>
 <504A25DB.2030100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <504A25DB.2030100@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.09.12 10:50:35, David Ahern wrote:
> On 9/7/12 10:41 AM, Robert Richter wrote:
> > +	struct perf_event_attr notsupp = {
> > +		.exclude_user	= 1,
> > +		.exclude_kernel	= 1,
> > +		.exclude_hv	= 1,
> > +		.exclude_idle	= 1,
> > +		.exclude_host	= 1,
> > +		.exclude_guest	= 1,
> > +	};
> >
> >   	perf_ibs = get_ibs_pmu(event->attr.type);
> >   	if (perf_ibs) {
> > @@ -229,6 +237,9 @@ static int perf_ibs_init(struct perf_event *event)
> >   	if (event->pmu != &perf_ibs->pmu)
> >   		return -ENOENT;
> >
> > +	if (perf_flags(&event->attr) & perf_flags(&notsupp))
> > +		return -EINVAL;
> > +
> 
> Am I reading this right - if exclude_guest is set then perf_ibs_init 
> returns -EINVAL?

Yes, the hardware does not support this. I will look for a solution
which emulates this is software.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

