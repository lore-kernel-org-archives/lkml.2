Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929Ab1EWT3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:29:23 -0400
Received: from smtp-out.google.com ([74.125.121.67]:62820 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab1EWT3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:29:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Aqlf6t+pHKWN9iqJDahQ/5+n3QwIfC3vG2ziA39Hd6VJ8KQOs+VzOzTtWmUwa4T+pZ
         4badVB06qP/m0vx0YzAw==
MIME-Version: 1.0
In-Reply-To: <1306167687.18455.22.camel@twins>
References: <20110523161256.GA11624@quad>
	<1306167687.18455.22.camel@twins>
Date: Mon, 23 May 2011 21:29:18 +0200
Message-ID: <BANLkTikQH-p1+j5vA30p1tae9aYcYD=eAA@mail.gmail.com>
Subject: Re: [PATCH 3/3] perf_events: add Intel Sandy Bridge offcore_response
 low-level support (v3)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 6:21 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-05-23 at 18:12 +0200, Stephane Eranian wrote:
>> This patch adds Intel Sandy Bridge offcore_response support by
>> providing the low-level constraint table for those events.
>>
>> On Sandy Bridge, there are two offcore_response events. Each uses
>> its own dedictated extra register. But those registers are NOT shared
>> between sibling CPUs when HT is on unlike Nehalem/Westmere. They are
>> always private to each CPU. But they still need to be controlled within
>> an event group. All events within an event group must use the same
>> value for the extra MSR. That's not controlled by the second patch in
>> this series.
>>
>> Furthermore on Sandy Bridge, the offcore_response events have NO
>> counter constraints contrary to what the official documentation
>> indicates, so drop the events from the contraint table.
>
> You sending this suggests you actually have a SNB machine, do you also
> happen to know how to use those SNB RSP MSRs? Lin Ming and I were
> wondering how to fill out the extra-regs for
> snb_hw_cache_events_jds[C(LL)].
>
You first need to describe what you want to measure with those generic
events. Then, from that, we can try and find a match with the offcore_resp
bits.
