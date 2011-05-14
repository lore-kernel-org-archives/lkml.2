Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab1ENMtu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 08:49:50 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:32958 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757326Ab1ENMtt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 08:49:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=oARZsgIuW9VJgO8FXWf88eIt1QvbCdav6cfCD3oMOmlQgktfVo9dVLY1CMtZelRLSP
         EP7tVw8xXFoiYNpXgMd29Wp8bNNY58ThTdIhXn/ztwx3oRhhfsSGDdiEaKNpdJxh8T/j
         Gm29d/4JpImUUxoBw5NefS3TulkLtLxk3lq/k=
MIME-Version: 1.0
In-Reply-To: <4DCDB886.7090909@gmail.com>
References: <BANLkTimTOTz4qNwYPa6Ey7=QRjOhQHWt-Q@mail.gmail.com>
 <4DCD4FC5.8020608@gmail.com> <20110513154410.GA6373@elte.hu>
 <BANLkTi=UKJ2Ztkcui_+8UHF16b_8mTvpnA@mail.gmail.com> <4DCDB886.7090909@gmail.com>
From: Wim Heirman <wim@heirman.net>
Date: Sat, 14 May 2011 14:49:28 +0200
X-Google-Sender-Auth: nxpCeQF3cTQyunb1JuLtvFMOZ2g
Message-ID: <BANLkTimBDwnYCTCEJspPoTKjAv0GXRzb6Q@mail.gmail.com>
Subject: Re: perf-stat per thread results
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Brice Goglin <Brice.Goglin@inria.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 May 2011 01:02, David Ahern <dsahern@gmail.com> wrote:
>
>
> On 05/13/11 14:32, Wim Heirman wrote:
>> Hi,
>>
>>> It's supposed to do that if --stat is specified, and it used to work - see this
>>> commit:
>>>
>>>  8d51327090ac: perf report: Fix and improve the displaying of per-thread event counters
>>>
>>> and the output there:
>>>
>>>     #  PID   TID  cache-misses  cache-references
>>>       4658  4659        495581           3238779
>>>       4658  4662        498246           3236823
>>>       4658  4663        499531           3243162
>>>
>>> which appears to be roughly what Wim is asking for, AFAICT.
>>
>> Thanks, this is exactly what I'm looking for. In 2.6.32 (Ubuntu 10.04)
>> it works, although if I use --pid rather than the -- <command> variant
>> the first thread seams to be missing. In 2.6.38 (Ubuntu 11.04) the
>> first thread is missing in both use cases, and I get one column per
>> processor (which in itself is fine).
>>
>> Regards,
>> Wim
>
> Hmm.... my mileage varies using latest kernel
> (446cc6345d3de6571bdd0840f48aca441488a28d)
>
> $ /tmp/build-perf/perf record --stat -fo /tmp/perf.data -p $(pidof rsyslogd)
> ^C[ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.007 MB /tmp/perf.data (~308 samples) ]
>
> $ /tmp/build-perf/perf report -T -i /tmp/perf.data
> # Events: 6  cycles
> #
> # Overhead   Command      Shared Object                      Symbol
> # ........  ........  .................  ..........................
> #
>    97.61%  rsyslogd  libc-2.13.so       [.] __libc_disable_asynccancel
>     2.39%  rsyslogd  [kernel.kallsyms]  [k] native_write_msr_safe
>
>
> #
> # (For a higher level overview, try: perf report --sort comm,dso)
> #
> # PID  TID
>
>
> ie., I do not get the counter values. Specifying the counter with -e
> (e.g., -e branch-misses) does not help -- still no counter output.

Is rsyslogd multithreaded? (Or at least, do the non-main threads
execute any work during your perf-record measurement) If not, then
what you see is consistent with what I'm getting, i.e. everything but
the main thread is reported.

Regards,
Wim
