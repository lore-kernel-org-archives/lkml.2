Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab1GAFnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 01:43:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:54515 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab1GAFnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 01:43:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,456,1304319600"; 
   d="scan'208";a="22235047"
Subject: Re: [PATCH 0/4] perf: Intel uncore pmu counting support
From: Lin Ming <ming.m.lin@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <CABPqkBRs1nd7KptkVCg5QeG0AJJck=VHAgCpSOJKpOgdDuN-6A@mail.gmail.com>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
	 <CABPqkBRs1nd7KptkVCg5QeG0AJJck=VHAgCpSOJKpOgdDuN-6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jul 2011 13:49:14 +0800
Message-ID: <1309499354.24590.111.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-30 at 20:10 +0800, Stephane Eranian wrote:
> On Thu, Jun 30, 2011 at 10:09 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> > Hi, all
> >
> > I posted uncore patches months ago, but it was pended due to an uncore
> > interrupt problem.
> >
> > This series are cut to support uncore pmu counting only.
> > So uncore interrupt handling is not needed.
> >
> You're making the assumption that when counting, you can never construct
> a measurement that will cause a counter to overflow the 39 bits. If not, then
> you need interrupt handling even when counting.

Is it enough to get the delta when overflow like below?

        unsigned int a = 0xfffffffe;
        unsigned int b = 10;
        unsigned int delta = (int)b - (int)a;

> 
> 
> > The uncore pmu type is allocated dynamically and exported via sysfs.
> > $ cat /sys/bus/event_source/devices/uncore/type
> > 6
> >
> > You can count uncore raw events as below,
> > $ perf stat -e uncore:r0101 ls
> >
> > It reads uncore pmu type id from sysfs to setup perf_event_attr::type.
> >
> > Comments are appreciated.
> >
> > Thanks,
> > Lin Ming
> >
> >


