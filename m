Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab1F1Q3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:29:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758539Ab1F1Q1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:27:23 -0400
Date: Tue, 28 Jun 2011 12:27:14 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf, x86: Add hw_watchdog_set_attr() in a sake of
 nmi-watchdog on P4
Message-ID: <20110628162714.GV7027@redhat.com>
References: <20110623124918.GC13050@sun>
 <20110627190358.GQ3765@redhat.com>
 <20110627193201.GB1159@sun>
 <CABPqkBTE_6ma70ZQbbz1NnznCGB7YO74kmL+=fP66qFVvVFLBw@mail.gmail.com>
 <20110628152827.GE1159@sun>
 <20110628153731.GY3765@redhat.com>
 <20110628154422.GG1159@sun>
 <20110628154646.GH1159@sun>
 <CABPqkBS4ukQ-asVD68MR_Bb_E89+EcHOcMP3Vv=RMJ9RnuYBSw@mail.gmail.com>
 <20110628161110.GJ1159@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110628161110.GJ1159@sun>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 08:11:10PM +0400, Cyrill Gorcunov wrote:
> 
>  	wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
> -->	hw_nmi_watchdog_set_attr(wd_attr);
> 
> itself? Ie you suspect some different point where to call it?
> 
> When I said not a "best place" I meant about __weak function bare implementation
> placed that near to call (which is looked somehow suspicious for me from overall
> code structure), but I didn't mean the call sequence itself ;)

Sorry I was probably vague.  What I meant to say is that the call
'hw_nmi_watchdog_set_attr' is really x86 specific and thought we could
bury it down there somehow.  Yeah the __weak symbol cleverly gets around
it.

I was thinking it would be nice to stick it in hw_nmi_get_sample_period as
that is arch specific.  But it really wouldn't make sense there.

It's probably fine for now and maybe someday we can come up with a better
idea where to put it.

I don't want to waste to much time thinking about it as I have other
issues I am dealing with.  I just wanted to get this resolved so I can
push this patch into RHEL-6.

Cheers,
Don
