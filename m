Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904Ab1F1QN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:13:58 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:58469 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759295Ab1F1QLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:11:30 -0400
Date: Tue, 28 Jun 2011 20:11:10 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf, x86: Add hw_watchdog_set_attr() in a sake of
 nmi-watchdog on P4
Message-ID: <20110628161110.GJ1159@sun>
References: <20110623124918.GC13050@sun>
 <20110627190358.GQ3765@redhat.com>
 <20110627193201.GB1159@sun>
 <CABPqkBTE_6ma70ZQbbz1NnznCGB7YO74kmL+=fP66qFVvVFLBw@mail.gmail.com>
 <20110628152827.GE1159@sun>
 <20110628153731.GY3765@redhat.com>
 <20110628154422.GG1159@sun>
 <20110628154646.GH1159@sun>
 <CABPqkBS4ukQ-asVD68MR_Bb_E89+EcHOcMP3Vv=RMJ9RnuYBSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBS4ukQ-asVD68MR_Bb_E89+EcHOcMP3Vv=RMJ9RnuYBSw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 05:53:31PM +0200, Stephane Eranian wrote:
> Cyrill,
> 
> #ifdef CONFIG_HARDLOCKUP_DETECTOR
> +void __weak hw_nmi_watchdog_set_attr(struct perf_event_attr *wd_attr) { }
> 
> The weak function has to remain inside the #ifdef. Remember it's just an
> override in case you cannot using the generic cycle event. It is only needed
> when you have the HARDLOCK detector, i.e., are using the PMU to detect
> deadlocks.
> 
> I suspect P4 may be the only one so far which exhibited a problem there.
> 

heh ;) Guys, maybe we're talking about different things? Don, when you said
"Though I do wonder about this call in the watchdog" you meant the 

 	wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
-->	hw_nmi_watchdog_set_attr(wd_attr);

itself? Ie you suspect some different point where to call it?

When I said not a "best place" I meant about __weak function bare implementation
placed that near to call (which is looked somehow suspicious for me from overall
code structure), but I didn't mean the call sequence itself ;)

	Cyrill
