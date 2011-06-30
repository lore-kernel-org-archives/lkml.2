Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab1F3MKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 08:10:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:31747 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab1F3MKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 08:10:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=Xwc1FAMuEsVOoVHHWAFTZvdtDTJHVSJ/Cmjn+Vc8LAHGjumG7IgTbEKy+eP9YkLYC
	YptxLL8NlQ4sUNx7nnEjA==
MIME-Version: 1.0
In-Reply-To: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
Date: Thu, 30 Jun 2011 14:10:39 +0200
Message-ID: <CABPqkBRs1nd7KptkVCg5QeG0AJJck=VHAgCpSOJKpOgdDuN-6A@mail.gmail.com>
Subject: Re: [PATCH 0/4] perf: Intel uncore pmu counting support
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

On Thu, Jun 30, 2011 at 10:09 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> Hi, all
>
> I posted uncore patches months ago, but it was pended due to an uncore
> interrupt problem.
>
> This series are cut to support uncore pmu counting only.
> So uncore interrupt handling is not needed.
>
You're making the assumption that when counting, you can never construct
a measurement that will cause a counter to overflow the 39 bits. If not, then
you need interrupt handling even when counting.


> The uncore pmu type is allocated dynamically and exported via sysfs.
> $ cat /sys/bus/event_source/devices/uncore/type
> 6
>
> You can count uncore raw events as below,
> $ perf stat -e uncore:r0101 ls
>
> It reads uncore pmu type id from sysfs to setup perf_event_attr::type.
>
> Comments are appreciated.
>
> Thanks,
> Lin Ming
>
>
