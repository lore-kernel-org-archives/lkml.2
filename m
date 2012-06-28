Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab2F1EM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 00:12:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50092 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab2F1EMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 00:12:55 -0400
MIME-Version: 1.0
In-Reply-To: <87txxwxjmu.fsf@sejong.aot.lge.com>
References: <CACV3sb+EqVR0Z7qtCOpFtmRS+7xvv0b4S0Jrk7o7b__89_WVcA@mail.gmail.com>
	<87bok7x0e1.fsf@sejong.aot.lge.com>
	<CACV3sbKJiORogfjjRfyFz4Vw7Re8EYZ7K+vuU6GCb5d7w=ZgzQ@mail.gmail.com>
	<87txxwxjmu.fsf@sejong.aot.lge.com>
Date: Thu, 28 Jun 2012 12:12:53 +0800
Message-ID: <CACV3sbLsn63tafd-brms3LVo+iwynhT+dhhwEx8PLavHQW6g4g@mail.gmail.com>
Subject: Re: perf support user-space hw_breakpoint?
From: Jovi Zhang <bookjovi@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 28, 2012 at 10:20 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> On Thu, 28 Jun 2012 09:02:02 +0800, Jovi Zhang wrote:
>> On Mon, Jun 25, 2012 at 4:26 PM, Namhyung Kim <namhyung@kernel.org> wrote:
>>> BTW, when I perf record on a hwbp, it failed with ENOSPC.
>>> I guess it's because each per-task-per-cpu event tried to
>>> create an event so it'd get more than supported by h/w.
>>> The strace told me that the fifth call to perf_event_open
>>> failed on my 6-core machine.
>>>
>> I have same result as you in my linux box.
>> This should be a bug cause by commit d1cb9f(perf target: Add uses_mmap field)
>>
>> Namhyung, How about below patch?
>>
>
> NAK. This uses_mmap field is needed to setup per-task-per-cpu events for
> perf record (mostly). Without it, perf suffered from severe scalability
> issues. Maybe we can change it not to create per-task-per-cpu events iff
> for hwbp events only, but I'm not sure it's the right thing.
>
> Thanks,
> Namhyung
>
perf tool create cpumaps and threadmaps for evlist, not for evsel, this means
we cannot easily create a dummy cpumaps for hwbp event even when
evlist include hwbp type evsel.

Any ideas?

.jovi
