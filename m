Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463Ab2JSQbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:31:16 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:44630 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab2JSQbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:31:14 -0400
MIME-Version: 1.0
In-Reply-To: <1350664077.2768.32.camel@twins>
References: <1350658326-14715-1-git-send-email-eranian@google.com>
	<1350658326-14715-3-git-send-email-eranian@google.com>
	<1350664077.2768.32.camel@twins>
Date: Fri, 19 Oct 2012 18:31:12 +0200
Message-ID: <CABPqkBQ5kCyGByFS-D62RYg2VUf_W-rJKDH=AzyrcaBPVY-eFQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf: SNB exclusive PMU access for INST_RETIRED:PREC_DIST
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 6:27 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2012-10-19 at 16:52 +0200, Stephane Eranian wrote:
>> +static int intel_pebs_aliases_snb(struct perf_event *event)
>> +{
>> +       u64 cfg = event->hw.config;
>> +       /*
>> +        * for INST_RETIRED.PREC_DIST to work correctly with PEBS, it must
>> +        * be measured alone on SNB (exclusive PMU access) as per Intel SDM.
>> +        */
>> +       if ((cfg & INTEL_ARCH_EVENT_MASK) == 0x01c0 && !event->attr.exclusive) {
>> +               pr_info("perf: INST_RETIRED.PREC_DIST only works in exclusive mode\n");
>> +               return -EINVAL;
>
> This isn't limited to admin, right? So the above turns into a DoS on the
> console.
>
Ok, so how about a WARN_ON_ONCE() instead?
