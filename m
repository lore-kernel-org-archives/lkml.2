Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab2EGQD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:03:58 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:27381
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756724Ab2EGQD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:03:56 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3NTY5-02-6TL-02
X-M-MSG: 
Date: Mon, 7 May 2012 18:03:39 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] perf/x86-ibs: Add support for IBS pseudo events
Message-ID: <20120507160339.GK18810@erda.amd.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
 <1335983192-23731-5-git-send-email-robert.richter@amd.com>
 <1336388454.27020.2.camel@laptop>
 <20120507144756.GG18810@erda.amd.com>
 <1336403718.27020.64.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1336403718.27020.64.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.05.12 17:15:18, Peter Zijlstra wrote:
> On Mon, 2012-05-07 at 16:47 +0200, Robert Richter wrote:
> > > Who again wasn't decoding anything in perf_event_attr:config* ?
> > 
> > attr:config is one of the ibs control msrs comparable with perfctr's
> > evntsel msr:
> > 
> >  MSRC001_1030 IBS Fetch Control Register (IbsFetchCtl)
> >  MSRC001_1033 IBS Execution Control Register (IbsOpCtl)
> 
> You missed reading a '*', even so:
> 
> > There are some options (randomisation, cycle/micro-op counting) but
> > usually it is null since the period is encoded in attr:period. But ibs
> > could be setup by an application using attr:config only which then
> > passes the value directly to the ctl msr. 
> 
> PMU_FORMAT_ATTR(IbsFetchMaxCnt, "config:0-15"   );
> PMU_FORMAT_ATTR(IbsFetchCnt,	"config:16-31"	);
> PMU_FORMAT_ATTR(IbsFetchVal,	"config:49"	);
> PMU_FORMAT_ATTR(IbsRandEn,	"config:57"	);
> 
> and
> 
> PMU_FORMAT_ATTR(IbsOpMaxCnt,	"config:0-15"	);
> PMU_FORMAT_ATTR(IbsOpVal,	"config:18"	);
> PMU_FORMAT_ATTR(IbsOpCntCtl,	"config:19"	); /* subject to ibs_caps */
> 
> Are the writable bitfields of those two MSRs resp.
> 
> This patch adds:
> 
> PMU_FORMAT_ATTR(IbsFilter0Idx,	"config1:0-7"	);
> PMU_FORMAT_ATTR(IbsFilter0Type,	"config1:12-15"	);
> PMU_FORMAT_ATTR(IbsFilter0Mask,	"config1:16-23"	);
> PMU_FORMAT_ATTR(IbsFilter0Match,"config1:24-31"	);
> PMU_FORMAT_ATTR(IbsFilter0Any,	"config1:16-31"	);
> 

Yes, let's take this format specification for config and drop kernel
side filtering in config[12].

Passing options like IbsRandEn was another open item. This is a nice
solution for this.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

