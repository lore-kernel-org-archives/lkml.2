Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297Ab2JSP6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:58:13 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49464 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab2JSP6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:58:11 -0400
MIME-Version: 1.0
In-Reply-To: <20121019154958.GY2095@tassilo.jf.intel.com>
References: <1350658326-14715-1-git-send-email-eranian@google.com>
	<1350658326-14715-3-git-send-email-eranian@google.com>
	<20121019154958.GY2095@tassilo.jf.intel.com>
Date: Fri, 19 Oct 2012 17:58:09 +0200
Message-ID: <CABPqkBQgoVPn2D03oZvVXxT59wwpH-NYE3XBqQDTJ=2fLRqE8A@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf: SNB exclusive PMU access for INST_RETIRED:PREC_DIST
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 5:49 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> +     /*
>> +      * for INST_RETIRED.PREC_DIST to work correctly with PEBS, it must
>> +      * be measured alone on SNB (exclusive PMU access) as per Intel SDM.
>> +      */
>> +     if ((cfg & INTEL_ARCH_EVENT_MASK) == 0x01c0 && !event->attr.exclusive) {
>> +             pr_info("perf: INST_RETIRED.PREC_DIST only works in exclusive mode\n");
>> +             return -EINVAL;
>> +     }
>
>
> Strictly you have to check for precise too, right?
>
Yes, the restriction is enforced only when PEBS is active and
this is what I do based on where pebs_aliases() is called.


> -Andi
