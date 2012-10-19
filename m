Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495Ab2JSQqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:46:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:51961 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758293Ab2JSQqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:46:36 -0400
Message-ID: <1350665152.2768.41.camel@twins>
Subject: Re: [PATCH 2/2] perf: SNB exclusive PMU access for
 INST_RETIRED:PREC_DIST
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Date: Fri, 19 Oct 2012 18:45:52 +0200
In-Reply-To: <CABPqkBQ5kCyGByFS-D62RYg2VUf_W-rJKDH=AzyrcaBPVY-eFQ@mail.gmail.com>
References: <1350658326-14715-1-git-send-email-eranian@google.com>
	 <1350658326-14715-3-git-send-email-eranian@google.com>
	 <1350664077.2768.32.camel@twins>
	 <CABPqkBQ5kCyGByFS-D62RYg2VUf_W-rJKDH=AzyrcaBPVY-eFQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-19 at 18:31 +0200, Stephane Eranian wrote:
> On Fri, Oct 19, 2012 at 6:27 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2012-10-19 at 16:52 +0200, Stephane Eranian wrote:
> >> +static int intel_pebs_aliases_snb(struct perf_event *event)
> >> +{
> >> +       u64 cfg = event->hw.config;
> >> +       /*
> >> +        * for INST_RETIRED.PREC_DIST to work correctly with PEBS, it must
> >> +        * be measured alone on SNB (exclusive PMU access) as per Intel SDM.
> >> +        */
> >> +       if ((cfg & INTEL_ARCH_EVENT_MASK) == 0x01c0 && !event->attr.exclusive) {
> >> +               pr_info("perf: INST_RETIRED.PREC_DIST only works in exclusive mode\n");
> >> +               return -EINVAL;
> >
> > This isn't limited to admin, right? So the above turns into a DoS on the
> > console.
> >
> Ok, so how about a WARN_ON_ONCE() instead?

That should be fine I guess ;-)
