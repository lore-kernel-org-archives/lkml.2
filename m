Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935811Ab1KJQ7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:59:25 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60911 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832Ab1KJQ7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:59:24 -0500
MIME-Version: 1.0
In-Reply-To: <20111110164135.GA4659@redhat.com>
References: <20111107110149.GA5177@quad>
	<1320935860.13800.25.camel@twins>
	<CABPqkBS_4TBYUvw_bPbtgpAfp8+vnSRZBYQoSAOKjOYV4GHmXA@mail.gmail.com>
	<20111110164135.GA4659@redhat.com>
Date: Thu, 10 Nov 2011 17:59:22 +0100
Message-ID: <CABPqkBQsQuzGP2YT+hucoZxgF4H1s9T3kriw37zTMrUwzTmLYA@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
From: Stephane Eranian <eranian@google.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, mingo@elte.hu, ming.m.lin@intel.com,
        ak@linux.intel.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 5:41 PM, Gleb Natapov <gleb@redhat.com> wrote:
> On Thu, Nov 10, 2011 at 04:09:32PM +0100, Stephane Eranian wrote:
>> On Thu, Nov 10, 2011 at 3:37 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > Just throwing this out there (hasn't event been compiled etc..).
>> >
>> > The idea is to try the fixed counters first so that we don't
>> > 'accidentally' fill a GP counter with something that could have lived on
>> > the fixed purpose one and then end up under utilizing the PMU that way.
>> >
>> > It ought to solve the most common PMU programming fail on Intel
>> > thingies.
>> >
> Heh, just looked into doing exactly that here.
>
>> What are the configs for which you have failures on Intel?
>>
> Suppose you have 3 fixed event counters and 2 GP counters and 3 event.
> One can go to one of the fixed counters or any GP, 2 others can be only on
> GP. If the event that can go to fixed counter will be placed into GP
> counter then one of the remaining events will fail to be scheduled.
>
Yes and the current algorithm does the right thing.
 e1 (1 fixed +2 GP) -> weight = 3
 e2 (2 GP) -> weight = 2
 e3 (2 GP) -> weight = 2

The current algorithm schedules the event from light to heavy
weight. Thus, it schedules e2, e3 first on the GPs and then
e1 necessarily ends up on the fixed counter.

Do you have a test case where this does not work on Intel?
