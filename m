Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0KYOMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:12:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:44107 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab0KYOMX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:12:23 -0500
Subject: Re: [RFC PATCHv3] perf tools: add event grouping capability to
 "perf stat"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Julia Lawall <julia@diku.dk>,
        Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt@console-pimps.org>
In-Reply-To: <AANLkTinyL2eEfWoLoZqU-CFwC6Z3hGd0=9HgBhC_+Uef@mail.gmail.com>
References: <1290650053-3486-1-git-send-email-cjashfor@linux.vnet.ibm.com>
	 <1290666760.2072.539.camel@laptop>
	 <AANLkTinTNAwMCe_zu1snG1U5hSRafdBHQdzAr4e9nuWO@mail.gmail.com>
	 <1290693720.2145.34.camel@laptop>
	 <AANLkTinyL2eEfWoLoZqU-CFwC6Z3hGd0=9HgBhC_+Uef@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 25 Nov 2010 15:12:28 +0100
Message-ID: <1290694348.2145.37.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 15:07 +0100, Stephane Eranian wrote:
> On Thu, Nov 25, 2010 at 3:02 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Thu, 2010-11-25 at 14:19 +0100, Stephane Eranian wrote:
> >
> >> I think using PERF_SAMPLE_READ may expose a problem in the
> >> perf.data format. To correctly parse a sample created with SAMPLE_READ,
> >> you need to know the attr.read_format. But for that you need to know the
> >> event which caused the sample, but for that you need the SAMPLE_ID,
> >> and you don't know if it's there or not. In other words, there is a chicken
> >> and egg problem.
> >>
> >> I think the issue is that PERF_RECORD_SAMPLE is missing a mandatory
> >> piece of information: overflow event ID. This must a mandatory field, not
> >> optional as it is today. It is okay when you have only one group, but we'd
> >> like to go beyond that.
> >
> >
> >
> > I'm not sure I get it, there's both PERF_FORMAT_ID and PERF_SAMPLE_ID,
> > so afaict there's a working combination for what you want to do.
> >
> Ok, I had forgotten about PERF_SAMPLE_ID. But that means that if the
> number of groups > 1, then if you use PERF_SAMPLE_READ, you MUST
> also use PERF_SAMPLE_ID. Otherwise you cannot get back to the event
> that generated the sample and thus attr.read_format.

perf-record already does that:

        if (nr_counters > 1)
                attr->sample_type |= PERF_SAMPLE_ID;



