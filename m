Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab2EGOsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:48:39 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:57644
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757106Ab2EGOsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:48:31 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz98dKzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3NQGK-01-0LO-02
X-M-MSG: 
Date: Mon, 7 May 2012 16:47:56 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] perf/x86-ibs: Add support for IBS pseudo events
Message-ID: <20120507144756.GG18810@erda.amd.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
 <1335983192-23731-5-git-send-email-robert.richter@amd.com>
 <1336388454.27020.2.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1336388454.27020.2.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.05.12 13:00:54, Peter Zijlstra wrote:
> Who again wasn't decoding anything in perf_event_attr:config* ?

attr:config is one of the ibs control msrs comparable with perfctr's
evntsel msr:

 MSRC001_1030 IBS Fetch Control Register (IbsFetchCtl)
 MSRC001_1033 IBS Execution Control Register (IbsOpCtl)

There are some options (randomisation, cycle/micro-op counting) but
usually it is null since the period is encoded in attr:period. But ibs
could be setup by an application using attr:config only which then
passes the value directly to the ctl msr.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

