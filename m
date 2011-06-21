Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab1FUQVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 12:21:19 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61221 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab1FUQVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 12:21:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jyWd52Co+0NWA5znyz6SaOaXWRVx8od17oFHLWmmWIqvlamx5HWtbCJevFOqBhbYis
         1Cbe8xatgNgAb0zBo5Hw==
MIME-Version: 1.0
In-Reply-To: <BANLkTim-2p1DgV1XD_J2vH514aL_KuFaEQ@mail.gmail.com>
References: <4DB989B5.1030703@openvz.org>
	<20110621152301.GA5155@redhat.com>
	<BANLkTi=zPq81nScodFcPxcLSrTGPNA1HWA@mail.gmail.com>
	<1308671933.26237.183.camel@twins>
	<BANLkTim-2p1DgV1XD_J2vH514aL_KuFaEQ@mail.gmail.com>
Date: Tue, 21 Jun 2011 18:20:56 +0200
Message-ID: <BANLkTikxWV8tjXrZnOrNnsw+nmsjGaxWbw@mail.gmail.com>
Subject: Re: [RFC -tip] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event v2
From: Stephane Eranian <eranian@google.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill,
[repost because of MIME crap]

I admit I don't quite understand how this patch works around
the limitation. In the end you are still going to program some cycle
event into a P4 PMU register. So how it is going to free more counters
for regular users?


On Tue, Jun 21, 2011 at 6:13 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
>
> Ok, I'll take a look (sorry for top posting, ISP problem)
>
> On Tuesday, June 21, 2011, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Tue, 2011-06-21 at 19:40 +0400, Cyrill Gorcunov wrote:
> >> On Tue, Jun 21, 2011 at 7:23 PM, Don Zickus <dzickus@redhat.com> wrote:
> >> > On Thu, Apr 28, 2011 at 07:37:25PM +0400, Cyrill Gorcunov wrote:
> >> >> Due to restriction and specifics of Netburst PMU we need a separated
> >> >> event for NMI watchdog. In particular every Netburst event consume not
> >> >> just a counter and config register, but also an additional ESCR register.
> >> >> Since ESCR registers are grouped upon counters (i.e. if ESCR is occupied
> >> >> for some event there is no room for another event to enter the room until
> >> >> it's released) we need to pick up "least" used ESCR (or most available)
> >> >> for nmi-watchdog purpose -- MSR_P4_CRU_ESCR2/3 was chosen.
> >> >>
> >> >> Note that on all other PMUs which support relocation of events between
> >> >> counters this event is a simple alias for PERF_COUNT_HW_CPU_CYCLES.
> >> >
> >> > Cyril,
> >> >
> >> > What ever happened with this patch?
> >> >
> >> > Cheers,
> >> > Don
> >> >
> >>
> >> Well, it's flowing around, I didn't get any more Ack's other than your. Since it
> >> introduces kind of abi I presume more ack's would be welcome before it
> >> (possibly) get merged.
> >
> > we could avoid that abi thing by simply not making it an exposed event
> >
> > Its not like userspace ever should be using it anyway
> >
