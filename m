Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467Ab1CXDjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 23:39:13 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41016 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933110Ab1CXDjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 23:39:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Mct/Ja7Suh6+xVxx/DwsYKuHZTENJ5BB5GmjC5/pa+UAYzhgoNvD1vdcWtLdlmxERK
         DebD1x4h5IY2yShjZ5gtrhBWQToaafEhwZJb5nBdo71ribZe2HyYFhQ+CnyR9avtqKfm
         M5WWjoL0GGh1NwJq1fB5BFLX1dq5VP5ZsOOkU=
MIME-Version: 1.0
In-Reply-To: <4D8A8DC9.1060502@suse.cz>
References: <20110323203426.GC7709@kroah.com>
	<20110323203437.GD7709@kroah.com>
	<4D8A8DC9.1060502@suse.cz>
Date: Thu, 24 Mar 2011 11:39:09 +0800
Message-ID: <AANLkTin_UXOjnFuQ5DQgkYH1ZciVBa=3iQmcdUej6r=B@mail.gmail.com>
Subject: Re: Linux 2.6.32.34
From: Teck Choon Giam <giamteckchoon@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Slaby <jirislaby@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 8:18 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> On 03/23/2011 09:34 PM, Greg KH wrote:
>> --- a/kernel/perf_event.c
>> +++ b/kernel/perf_event.c
>> @@ -4167,6 +4167,8 @@ static void tp_perf_event_destroy(struct perf_event *event)
>>
>>  static const struct pmu *tp_perf_event_init(struct perf_event *event)
>>  {
>> +     if (event->hw.state & PERF_HES_STOPPED)
>> +             return 0;
>>       /*
>>        * Raw tracepoint data is a severe data leak, only allow root to
>>        * have these.
>
> This causes build to fail:
> /usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:
> In function 'tp_perf_event_init':
> /usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:4170:
> error: 'struct hw_perf_event' has no member named 'state'
> /usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:4170:
> error: 'PERF_HES_STOPPED' undeclared (first use in this function)
> /usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:4170:
> error: (Each undeclared identifier is reported only once
> /usr/src/packages/BUILD/kernel-vanilla-2.6.32.34/linux-2.6.32/kernel/perf_event.c:4170:
> error: for each function it appears in.)
>
>
> The source:
> commit 6f197b73304b3bd3d5a43b931383a5331d6b2987
> Author: Frederic Weisbecker <fweisbec@gmail.com>
> Date:   Mon Mar 7 21:27:09 2011 +0100
>
>    perf: Handle stopped state with tracepoints
>
>    commit a0f7d0f7fc02465bb9758501f611f63381792996 upstream.
>
>    We toggle the state from start and stop callbacks but actually
>    don't check it when the event triggers. Do it so that
>    these callbacks actually work.

It builds fine for me with gcc version 4.1.2 for both x86_32 and x86_64.

Thanks.

Kindest regards,
Giam Teck Choon
