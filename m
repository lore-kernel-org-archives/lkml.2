Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759079Ab0DHVWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 17:22:13 -0400
Received: from smtp-out.google.com ([74.125.121.35]:34908 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759059Ab0DHVWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 17:22:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=SZznR4DJqUyrSxusEKijYUBirCoyONSdWxrgl5FHy9ttSqT7EtgVu6rUG+I6/fl9h
	70vQ+s1kxmyYj1hOksn6A==
MIME-Version: 1.0
In-Reply-To: <20100408211727.GA7990@nowhere>
References: <4bbe4175.5124cc0a.5bd3.22d6@mx.google.com>
	 <1270760136.20295.3121.camel@laptop>
	 <v2xbd4cb8901004081408mf761d04ag5a365d068c58d64b@mail.gmail.com>
	 <1270761083.20295.3158.camel@laptop>
	 <g2rbd4cb8901004081414l505e6b04td902794f381224af@mail.gmail.com>
	 <20100408211727.GA7990@nowhere>
Date: Thu, 8 Apr 2010 23:22:05 +0200
Message-ID: <u2nbd4cb8901004081422pe7088569s430734577b576b43@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix bogus warn_on(_once) in 
	perf_prepare_sample()
From: Stephane Eranian <eranian@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       robert.richter@amd.com, perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 8, 2010 at 11:17 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Thu, Apr 08, 2010 at 11:14:15PM +0200, Stephane Eranian wrote:
>> On Thu, Apr 8, 2010 at 11:11 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Thu, 2010-04-08 at 23:08 +0200, Stephane Eranian wrote:
>> >>
>> >> Are you suggesting you add some padding the PEBS raw sample you
>> >> return as PERF_SAMPLE_RAW? Then you need to define what RAW
>> >> actually means? Seems here, it would mean more than what the
>> >> HW returns.
>> >
>> > Well, RAW doesn't mean anything much at all, its really a fugly pass
>> > some crap around thing.
>> >
>> > So yeah, adding padding seems just fine.
>> >
>> I would rather see size as u64. Who's using raw today anyway?
>
>
> The trace events. Hence the size of the size shouldn't be touched, it
> is an ABI now.

Given your alignment constraints, it seems like it was a bad choice to pick
u32 for size to begin with.
