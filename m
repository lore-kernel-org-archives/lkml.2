Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab1BDNTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 08:19:18 -0500
Received: from smtp-out.google.com ([74.125.121.67]:28038 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab1BDNTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:19:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FRtO0CRrfT3NIgFtqu1ZHsmqfX16e+dy7IVHc5HrO59Rn70rZuuzoMtkL9LwE49U7C
         POzd0X3hr5rGJ0gVxvpg==
MIME-Version: 1.0
In-Reply-To: <1296825160.26581.652.camel@laptop>
References: <4d4bf9ac.cf03d90a.2908.2186@mx.google.com>
	<1296825160.26581.652.camel@laptop>
Date: Fri, 4 Feb 2011 14:19:13 +0100
Message-ID: <AANLkTintvA8QUYzJUXWc792uYD-tACCxUzvY_XCQtD=u@mail.gmail.com>
Subject: Re: [PATCH 0/2] perf_events: add support for Intel fixed counter 2
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        gorcunov@gmail.com, ming.m.lin@intel.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 4, 2011 at 2:12 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2011-02-04 at 14:00 +0200, Stephane Eranian wrote:
>
>> This series of patches solves this problem by introducing a custom
>> encoding for UNHALTED_REFERENCE_CYCLES (0xff3c) and improving
>> the constraint infrastructure to handle events which can ONLY be
>> measured on fixed counters.
>
> Right, so the only problem I can see with this is that Intel will at
> some point in the future put an actual event there.
>
I doubt that but I will check with them.

The alternative I thought about would be to use a bit in the upper 32
bit section
of attr.config and use the constraint->cmask to catch it. That would
be a special
cmask. That would probably work because ALL events have to go through
get_constraints().
