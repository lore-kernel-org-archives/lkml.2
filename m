Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab1BEPTl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 10:19:41 -0500
Received: from smtp-out.google.com ([74.125.121.67]:37286 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab1BEPTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 10:19:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iapVOZE+STcwIUgXNKNsNWZj82sObVFAuOlLozIgDNY8loDStHa5/gauQWQDj61k5w
         6xCwcU7p7WLVrM8VB53A==
MIME-Version: 1.0
In-Reply-To: <AANLkTintvA8QUYzJUXWc792uYD-tACCxUzvY_XCQtD=u@mail.gmail.com>
References: <4d4bf9ac.cf03d90a.2908.2186@mx.google.com>
	<1296825160.26581.652.camel@laptop>
	<AANLkTintvA8QUYzJUXWc792uYD-tACCxUzvY_XCQtD=u@mail.gmail.com>
Date: Sat, 5 Feb 2011 16:19:36 +0100
Message-ID: <AANLkTimOxf_GZtWwn3fEojKLjeVpQSiAwOn7=vBmiWRz@mail.gmail.com>
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

Hi,

Ok, another, easier, choice would be to use event code 0 (and
umaks 0x1 for instance). I doubt that one will ever be used.


On Fri, Feb 4, 2011 at 2:19 PM, Stephane Eranian <eranian@google.com> wrote:
> On Fri, Feb 4, 2011 at 2:12 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Fri, 2011-02-04 at 14:00 +0200, Stephane Eranian wrote:
>>
>>> This series of patches solves this problem by introducing a custom
>>> encoding for UNHALTED_REFERENCE_CYCLES (0xff3c) and improving
>>> the constraint infrastructure to handle events which can ONLY be
>>> measured on fixed counters.
>>
>> Right, so the only problem I can see with this is that Intel will at
>> some point in the future put an actual event there.
>>
> I doubt that but I will check with them.
>
> The alternative I thought about would be to use a bit in the upper 32
> bit section
> of attr.config and use the constraint->cmask to catch it. That would
> be a special
> cmask. That would probably work because ALL events have to go through
> get_constraints().
>
