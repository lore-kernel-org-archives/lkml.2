Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591Ab0DHVOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 17:14:20 -0400
Received: from smtp-out.google.com ([74.125.121.35]:32471 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933038Ab0DHVOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 17:14:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=LqS7+0RTSaBz+mW9/XCKTSQaO9iUEr4Tlm8YJqZ1QJwizgr5EOzCL2ayy2fTa/sIM
	b/F+QOm/Ao2if7rgit6Kw==
MIME-Version: 1.0
In-Reply-To: <1270761083.20295.3158.camel@laptop>
References: <4bbe4175.5124cc0a.5bd3.22d6@mx.google.com>
	 <1270760136.20295.3121.camel@laptop>
	 <v2xbd4cb8901004081408mf761d04ag5a365d068c58d64b@mail.gmail.com>
	 <1270761083.20295.3158.camel@laptop>
Date: Thu, 8 Apr 2010 23:14:15 +0200
Message-ID: <g2rbd4cb8901004081414l505e6b04td902794f381224af@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix bogus warn_on(_once) in 
	perf_prepare_sample()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 8, 2010 at 11:11 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-04-08 at 23:08 +0200, Stephane Eranian wrote:
>>
>> Are you suggesting you add some padding the PEBS raw sample you
>> return as PERF_SAMPLE_RAW? Then you need to define what RAW
>> actually means? Seems here, it would mean more than what the
>> HW returns.
>
> Well, RAW doesn't mean anything much at all, its really a fugly pass
> some crap around thing.
>
> So yeah, adding padding seems just fine.
>
I would rather see size as u64. Who's using raw today anyway?

The PEBS record itself is always a multiple of u64. The size header is the one
causing the problems.

>
