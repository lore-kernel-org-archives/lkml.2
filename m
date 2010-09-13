Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab0IMTMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:12:38 -0400
Received: from smtp-out.google.com ([74.125.121.35]:28623 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab0IMTMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:12:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=A4WFx8O6OsPHFwS6Yc/pX4vY85hORv4mVPsH5wJ0TusFo5iV2KelfMZUxtkicEMvZi
         e92fvVYSgn10iHK/0ihA==
MIME-Version: 1.0
In-Reply-To: <1284404272.2275.419.camel@laptop>
References: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com>
	<20100913150914.GA6155@nowhere>
	<AANLkTi=OR69sDbUMkSnx_-bpF=yHF_xNY1v=-BJgLpp5@mail.gmail.com>
	<1284391000.2275.338.camel@laptop>
	<AANLkTin35TXPcs9u3pLfo8QRUmGnftT1DPfswRUVEvJW@mail.gmail.com>
	<1284391480.2275.350.camel@laptop>
	<AANLkTik8r4moPy5muNyT2oKGH5aEaMOLL0Zqn=-hkpos@mail.gmail.com>
	<1284392476.2275.369.camel@laptop>
	<AANLkTimZTzCjea3KFxGcaQ7kscod7sOrz13LkNF_u38w@mail.gmail.com>
	<1284399329.2275.387.camel@laptop>
	<AANLkTi=DGnP-r++PhzWFMdwdu_ReUKAmGLCA2zPNBG5J@mail.gmail.com>
	<1284403335.2275.418.camel@laptop>
	<AANLkTimsp5NphG3VuwO_FoWZhjF8crD3=bKhXDq-_wyn@mail.gmail.com>
	<1284404272.2275.419.camel@laptop>
Date: Mon, 13 Sep 2010 21:12:33 +0200
Message-ID: <AANLkTik=rtizgPhetRJB5nt0WW+3=NiLevvyXu8sdOO-@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com,
        "markus.t.metzger" <markus.t.metzger@intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 8:57 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-09-13 at 20:49 +0200, Stephane Eranian wrote:
>> On Mon, Sep 13, 2010 at 8:42 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Mon, 2010-09-13 at 20:40 +0200, Stephane Eranian wrote:
>> >> Ok, so can we play the same trick you're playing with the sampling
>> >> buffer, i.e., you use alloc_pages_node() for one page at a time, and
>> >> then you stitch them on demand via SW?
>> >
>> > Not for BTS, it wants a linear range, getting the vmalloc vs NMI thing
>> > sorted would be best I think.
>> >
>> What is annoying in this is that you run into the problem even though
>> you may not be using BTS nor PEBS.
>
> Yes, one thing we could do is simply disable BTS when we fail that
> alloc, instead of fail everything.
>
>> What mitigates the problem, I think, is the NMI watchdog. It is the first
>> user of perf_events. As such, the BTS and PEBS buffers get allocated
>> during kernel initialization thereby increasing the chances of finding
>> contiguous chunks of memory. What would partly help would be to use of
>> kmalloc_node() to at least balance allocations amongst the various NUMA
>> nodes. That would be until the vmalloc() vs. NMI is sorted out.
>
> Right, that would be a simple change to make.
>

Ok, I will resubmit with those changes.
Thanks.
