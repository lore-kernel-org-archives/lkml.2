Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0EKPRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:17:19 -0400
Received: from smtp-out.google.com ([74.125.121.35]:24122 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab0EKPRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:17:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=PgW4rW2UYkREfR6gK16haFBaUnSAyF4JawF5hCswk2/vZwimetM8afcloNYj/nHih
	doImI8cAdPrIJARhOdCmw==
MIME-Version: 1.0
In-Reply-To: <1273590800.1810.19.camel@laptop>
References: <AANLkTinsEANHEicdjOaE6jwUa0bVqH5PBwuGQ3_L59hT@mail.gmail.com>
	 <20100511150052.GE19192@ghostprotocols.net>
	 <1273590800.1810.19.camel@laptop>
Date: Tue, 11 May 2010 17:17:11 +0200
Message-ID: <AANLkTilvtBMOE6MecY4P51MLRz0-LRgru4lDBQrQnXbZ@mail.gmail.com>
Subject: Re: [RFC] perf: perf record sets inherit by default
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       mingo@elte.hu, Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 5:13 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-05-11 at 12:00 -0300, Arnaldo Carvalho de Melo wrote:
>>
>> Humm, since for -C and -a using -i doesn't make sense, I guess it should
>> be off by default and only be auto-activated if we don't specify any
>> option, i.e. when using it like:
>>
>> perf record ./hackbench
>>
>> What do you think?
>
> -ENOPARSE
>
> -a/-C usage creates per-cpu counters and will thus ignore any and all
> perf_event_attr::inherit state.
>
> Your above suggestion would still have inherit enabled by default, and
> would thus not change anything.
>
> The thing is that perf-record defaults to inherited per-task-per-cpu
> counters, which, I think, is a reasonable default, just sub-optimal for
> single threaded/!forking subjects.
>
> So what would make sense is for -i to mean --no-inherit, and for !
> inherit create a per-task counter instead of a per-task-per-cpu counter.
>

If inherit is the preferred default, then yes, the solution is to revert
the meaning of -i. You'd have to be consistent across all commands
using -i for inherit such as perf stat.
