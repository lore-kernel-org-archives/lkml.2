Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab1HAF1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 01:27:24 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:16932
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642Ab1HAF1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 01:27:18 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LP8HTA-01-2DE-02
X-M-MSG: 
Date: Mon, 1 Aug 2011 07:27:12 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] perf, x86: Implement IBS initialization
Message-ID: <20110801052712.GX4590@erda.amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
 <1311860812-28748-3-git-send-email-robert.richter@amd.com>
 <1311958725.5890.410.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1311958725.5890.410.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.07.11 12:58:45, Peter Zijlstra wrote:
> On Thu, 2011-07-28 at 15:46 +0200, Robert Richter wrote:
> > +static int perf_ibs_add(struct perf_event *event, int flags)
> > +{
> > +       pr_info("Adding event %p (config=%016llx) to pmu %s (type=%d) on cpu %d\n",
> > +               event, event->attr.config, perf_ibs.name, event->attr.type, event->oncpu);
> > +       return 0;
> > +}
> > +
> > +static void perf_ibs_del(struct perf_event *event, int flags)
> > +{
> > +       pr_info("Removing event %p (config=%016llx) to pmu %s (type=%d) on cpu %d\n",
> > +               event, event->attr.config, perf_ibs.name, event->attr.type, event->oncpu);
> > +} 
> 
> While I see you remove them later on, I do find it somewhat strange to
> have them here. This is user triggerable code in the context switch
> path, lots of nasty can come from this.

I will remove it and simply replace it with function stubs.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

