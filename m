Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab1HaMVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 08:21:36 -0400
Received: from smtp-out.google.com ([216.239.44.51]:30776 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab1HaMVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 08:21:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=p6caBAF+2ZdmU/JHwqPK7wjDP2MwAkwIYMYzetDGemVSwWyss8bs6sY6LUcCgpxRH
	4eh7Spnm2Wb9Ytnsvyh5Q==
MIME-Version: 1.0
In-Reply-To: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
Date: Wed, 31 Aug 2011 14:21:29 +0200
Message-ID: <CABPqkBRncSybcdFiEOTSw_xfmbgO_jvcW0QX4H9XsrOk7aFy+g@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] perf: Intel uncore pmu counting support
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So I finally got a bit of time to test the Ming's uncore PMU patch series
on Intel NHM and SNB. I found several problems which I fixed and I also
made some small improvements. With those fixes + improvements, the
NHM/WSM patches look okay.

OTOH, the SNB patch needs more work. The SNB uncore PMU is more
complicated than what the code supports today based on the info in Vol3b.
For instance, SNB uncore events have constraints, therefore you need a
proper scheduling function.

I will post my patch in separate email thread.



On Fri, Jul 15, 2011 at 4:34 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> Hi, all
>
> This is the v2 patches to support uncore pmu counting.
> The most important change is to use hrtimer to pull uncore counters
> to handle overflow, because uncore pmu interrupt does not work.
>
> v2 -> v1:
> - Use hrtimer to pull counters
> - Add interface to add general events to sysfs
> - Move MSRs to msr-index.h
> - Add uncore fixed counter
> - Allow system-wide 'perf stat' without 'command'
>
> Comments are appreciated.
>
> Thanks,
> Lin Ming
>
>
