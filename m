Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab2HFTu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 15:50:56 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63648 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500Ab2HFTuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 15:50:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120806181436.GF21441@infradead.org>
References: <1344247319-304069-1-git-send-email-avagin@openvz.org>
	<1344247319-304069-4-git-send-email-avagin@openvz.org>
	<20120806181436.GF21441@infradead.org>
Date: Mon, 6 Aug 2012 23:50:53 +0400
Message-ID: <CANaxB-xffLyn00U-dHMxkEXQZ7nMBxTyTcfgJnaah0rBaDCrKg@mail.gmail.com>
Subject: Re: [PATCH 3/3] perf: mark a dso if it's used
From: Andrey Wagin <avagin@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/6 Arnaldo Carvalho de Melo <acme@ghostprotocols.net>:
> Em Mon, Aug 06, 2012 at 02:01:59PM +0400, Andrew Vagin escreveu:
>> -     if (inject_build_ids) {
>> +     if (inject_build_ids || inject_sched_stat) {
>>               perf_inject.sample       = perf_event__inject_buildid;
>>               perf_inject.mmap         = perf_event__repipe_mmap;
>>               perf_inject.fork         = perf_event__repipe_task;
>>               perf_inject.tracing_data = perf_event__repipe_tracing_data;
>> -     } else if (inject_sched_stat) {
>> +     }
>> +
>> +     if (inject_sched_stat) {
>>               perf_inject.sample      = perf_event__sched_stat;
>>               perf_inject.ordered_samples = true;
>>       }
>
> Huh? so if inject_sched_stat is true we will first set
> perf_inject.sample to something, then to another?

Yes, we will. I though that it will be better then this:

if (inject_build_ids || inject_sched_stat) {
               perf_inject.mmap         = perf_event__repipe_mmap;
               perf_inject.fork         = perf_event__repipe_task;
               perf_inject.tracing_data = perf_event__repipe_tracing_data;
}

if (inject_build_ids) {
               perf_inject.sample       = perf_event__inject_buildid;
} else if (inject_sched_stat) {
               perf_inject.sample      = perf_event__sched_stat;
               perf_inject.ordered_samples = true;
}
