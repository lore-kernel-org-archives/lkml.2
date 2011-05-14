Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab1ENSxU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 14:53:20 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33001 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab1ENSxT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 14:53:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=XsprwV6fUiRe0S1XsejFA+shI9N1FySLo97jhyZkBrCVwjSKFftnSVAMEw9kOeUqbb
         j4M0jDAMR38hmYoVcFLX71M1aOUW6N7FgiPRb7XGewS7O7Fi4wCfvACHcIW96G54X7vH
         pHE1CfMGk/1/TfFBBmKnPLOfTpPf3BMpuLhBw=
MIME-Version: 1.0
In-Reply-To: <4DCEC068.3050301@gmail.com>
References: <BANLkTimTOTz4qNwYPa6Ey7=QRjOhQHWt-Q@mail.gmail.com>
 <4DCD4FC5.8020608@gmail.com> <20110513154410.GA6373@elte.hu>
 <BANLkTi=UKJ2Ztkcui_+8UHF16b_8mTvpnA@mail.gmail.com> <4DCDB886.7090909@gmail.com>
 <BANLkTimBDwnYCTCEJspPoTKjAv0GXRzb6Q@mail.gmail.com> <4DCEC068.3050301@gmail.com>
From: Wim Heirman <wim@heirman.net>
Date: Sat, 14 May 2011 20:52:57 +0200
X-Google-Sender-Auth: M_A_DSMUBceLjnTob5RmTTx_1C0
Message-ID: <BANLkTimZFpFedMR01rHtnmiRVffEw2FTeQ@mail.gmail.com>
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

2011/5/14 David Ahern <dsahern@gmail.com>:
> On 05/14/11 06:49, Wim Heirman wrote:
>>> Hmm.... my mileage varies using latest kernel
>>> (446cc6345d3de6571bdd0840f48aca441488a28d)
>>>
>>> $ /tmp/build-perf/perf record --stat -fo /tmp/perf.data -p $(pidof rsyslogd)
>>> ^C[ perf record: Woken up 1 times to write data ]
>>> [ perf record: Captured and wrote 0.007 MB /tmp/perf.data (~308 samples) ]
>>>
>>> $ /tmp/build-perf/perf report -T -i /tmp/perf.data
>>> # Events: 6  cycles
>>> #
>>> # Overhead   Command      Shared Object                      Symbol
>>> # ........  ........  .................  ..........................
>>> #
>>>    97.61%  rsyslogd  libc-2.13.so       [.] __libc_disable_asynccancel
>>>     2.39%  rsyslogd  [kernel.kallsyms]  [k] native_write_msr_safe
>>>
>>>
>>> #
>>> # (For a higher level overview, try: perf report --sort comm,dso)
>>> #
>>> # PID  TID
>>>
>>>
>>> ie., I do not get the counter values. Specifying the counter with -e
>>> (e.g., -e branch-misses) does not help -- still no counter output.
>>
>> Is rsyslogd multithreaded? (Or at least, do the non-main threads
>> execute any work during your perf-record measurement) If not, then
>> what you see is consistent with what I'm getting, i.e. everything but
>> the main thread is reported.
>
> It is multithreaded, but my point is that I do not get counter output at
> the end -- the PID/TID table is empty. I do not get counters for single
> threaded processes nor for commands run by perf record -- e.g.,
> /tmp/build-perf/perf record --stat -e instructions -fo /tmp/perf.data --
> sleep 1

My guess was that none of the threads got scheduled while you did your
perf-record run (rsyslogd usually isn't exactly very CPU intensive).
And the main thread isn't ever reported, at least that's the bug I'm
seeing. Can you try with a compute-intensive, multi-threaded program?

Wim.
