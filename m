Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab2ADXCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 18:02:46 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:51601 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757163Ab2ADXCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 18:02:44 -0500
MIME-Version: 1.0
In-Reply-To: <1325717396.3084.12.camel@laptop>
References: <20120104143945.GA4783@quad>
	<1325712298.3084.5.camel@laptop>
	<CABPqkBSR4a7PCyYxhE0kpepc3f0f6Rh6JU55_A3ubWYnN+G3iA@mail.gmail.com>
	<1325717396.3084.12.camel@laptop>
Date: Wed, 4 Jan 2012 23:02:42 +0000
Message-ID: <CABPqkBQ_MFdi1gc7Tje=u0n+RLd1gzo1mHb9e6i20T8JPNrpwA@mail.gmail.com>
Subject: Re: perf_events: proposed fix for broken intr throttling (repost)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, gleb@redhat.com,
        asharma@fb.com, vince@deater.net, wcohen@redhat.com
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 4, 2012 at 10:49 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-01-04 at 21:33 +0000, Stephane Eranian wrote:
>> > I don't think it needs that, I do dislike the unconditional iterate all
>> > events thing though. Maybe we can set some per-cpu state indicating
>> > someone got throttled (rare under normal operation -- you'd hope) and
>> > only iterate to unthrottle when we find this set.
>> >
>> Could try that too.
>>
>> > I think the event scheduling resulting from migration will already
>> > re-enable the event, avoiding the loss of unthrottle due to that..
>> > although it would be good to verify that.
>> >
>> Yes, you're not dead forever, but still it is not acceptable as is.
>
> Oh for sure, I didn't mean it like that. What I was getting at is a
> counter getting throttled on one cpu, setting the per-cpu variable,
> getting migrated and not getting unthrottled due to now living on
> another cpu which doesn't have the per-cpu thing set.
>
Yes, that is true.
I think that throttled counter needs to live in ctx and not per-cpu.
