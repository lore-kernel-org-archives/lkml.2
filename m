Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab1FUQAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 12:00:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36226 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab1FUQAy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 12:00:54 -0400
Subject: Re: [RFC -tip] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTi=zPq81nScodFcPxcLSrTGPNA1HWA@mail.gmail.com>
References: <4DB989B5.1030703@openvz.org> <20110621152301.GA5155@redhat.com>
	 <BANLkTi=zPq81nScodFcPxcLSrTGPNA1HWA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Jun 2011 17:58:53 +0200
Message-ID: <1308671933.26237.183.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-21 at 19:40 +0400, Cyrill Gorcunov wrote:
> On Tue, Jun 21, 2011 at 7:23 PM, Don Zickus <dzickus@redhat.com> wrote:
> > On Thu, Apr 28, 2011 at 07:37:25PM +0400, Cyrill Gorcunov wrote:
> >> Due to restriction and specifics of Netburst PMU we need a separated
> >> event for NMI watchdog. In particular every Netburst event consume not
> >> just a counter and config register, but also an additional ESCR register.
> >> Since ESCR registers are grouped upon counters (i.e. if ESCR is occupied
> >> for some event there is no room for another event to enter the room until
> >> it's released) we need to pick up "least" used ESCR (or most available)
> >> for nmi-watchdog purpose -- MSR_P4_CRU_ESCR2/3 was chosen.
> >>
> >> Note that on all other PMUs which support relocation of events between
> >> counters this event is a simple alias for PERF_COUNT_HW_CPU_CYCLES.
> >
> > Cyril,
> >
> > What ever happened with this patch?
> >
> > Cheers,
> > Don
> >
> 
> Well, it's flowing around, I didn't get any more Ack's other than your. Since it
> introduces kind of abi I presume more ack's would be welcome before it
> (possibly) get merged.

we could avoid that abi thing by simply not making it an exposed event

Its not like userspace ever should be using it anyway
