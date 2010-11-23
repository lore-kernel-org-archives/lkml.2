Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab0KWJTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 04:19:05 -0500
Received: from smtp-out.google.com ([216.239.44.51]:34983 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab0KWJTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 04:19:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=u6mqecKV+efiHlCXnWt5BUfqMpMPBZSx61hUMigzgGZjHQ/oZR1zLrskuIyDuPZl+s
         oK+l5y/i2JGhAIfy9brQ==
MIME-Version: 1.0
In-Reply-To: <3889bf3ab66bbb35ea239b63d95cc4c4.squirrel@www.firstfloor.org>
References: <1290340907.2245.125.camel@localhost>
	<340872239c47b2ec237c88488cb7b6ac.squirrel@www.firstfloor.org>
	<AANLkTi=bxEgsLjk-1CK4pSmknyxR_y3OxTJ9DZ_dBW8n@mail.gmail.com>
	<3889bf3ab66bbb35ea239b63d95cc4c4.squirrel@www.firstfloor.org>
Date: Tue, 23 Nov 2010 10:18:58 +0100
Message-ID: <AANLkTi=9SYgy-bVvYVt5rb3G=yWJYYA4ym+SCDs-5o+y@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3 v2] perf: Update perf tool to monitor uncore events
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 5:52 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
>>>
>>> In fact I suspect uncore events are only really useful
>>> with "stat", but not with "top", or if they are used in top
>>> then the symbol reporting should be disabled.
>>>
>> I agree, uncore should only be used for counting on a
>> per-cpu basis. You can leave the perf tool as is, but
>

I meant one cpu per socket: perf stat -a -C 0 -e unc_clk_unhalted.
One could envision the tool picking one CPU per socket. It can
figure this out from the topology information in sysfs.

If you do perf stat -a -e unc_*, then you'll get into multiplexing very
quickly AND it is useless especially because auto aggregation will
yield bogus counts.

> I think you mean per socket base, right? per cpu (= cpu core thread)
> doesn't make sense for the uncore either.
>
> Per socket would need a new command line mode. The new mode should
> never report any symbols or processes, just events per socket.
>
> -Andi
>
>
