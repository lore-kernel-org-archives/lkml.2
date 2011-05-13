Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318Ab1EMXCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 19:02:36 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:42900 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab1EMXCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 19:02:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rdy5wQYT9fX8UvlJVtB0t+Vzko8eCTYZb7/cHC4Zo/5iDtwt5WYhijqQyc+nZMy87H
         MH0n/lvkikJbEbnvfdJCBn5UmCpSEL6QKawnXBuy/N7lQsNJP1Jm3E0198b2DYBWcqTn
         SVFb67ovwOaSM4Kqy2jT2QqvDtk9j8r8Dh/Gw=
Message-ID: <4DCDB886.7090909@gmail.com>
Date: Fri, 13 May 2011 17:02:30 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110421 Fedora/3.1.9-2.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Wim Heirman <wim@heirman.net>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Brice Goglin <Brice.Goglin@inria.fr>
Subject: Re: perf-stat per thread results
References: <BANLkTimTOTz4qNwYPa6Ey7=QRjOhQHWt-Q@mail.gmail.com> <4DCD4FC5.8020608@gmail.com> <20110513154410.GA6373@elte.hu> <BANLkTi=UKJ2Ztkcui_+8UHF16b_8mTvpnA@mail.gmail.com>
In-Reply-To: <BANLkTi=UKJ2Ztkcui_+8UHF16b_8mTvpnA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/13/11 14:32, Wim Heirman wrote:
> Hi,
> 
>> It's supposed to do that if --stat is specified, and it used to work - see this
>> commit:
>>
>>  8d51327090ac: perf report: Fix and improve the displaying of per-thread event counters
>>
>> and the output there:
>>
>>     #  PID   TID  cache-misses  cache-references
>>       4658  4659        495581           3238779
>>       4658  4662        498246           3236823
>>       4658  4663        499531           3243162
>>
>> which appears to be roughly what Wim is asking for, AFAICT.
> 
> Thanks, this is exactly what I'm looking for. In 2.6.32 (Ubuntu 10.04)
> it works, although if I use --pid rather than the -- <command> variant
> the first thread seams to be missing. In 2.6.38 (Ubuntu 11.04) the
> first thread is missing in both use cases, and I get one column per
> processor (which in itself is fine).
> 
> Regards,
> Wim

Hmm.... my mileage varies using latest kernel
(446cc6345d3de6571bdd0840f48aca441488a28d)

$ /tmp/build-perf/perf record --stat -fo /tmp/perf.data -p $(pidof rsyslogd)
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.007 MB /tmp/perf.data (~308 samples) ]

$ /tmp/build-perf/perf report -T -i /tmp/perf.data
# Events: 6  cycles
#
# Overhead   Command      Shared Object                      Symbol
# ........  ........  .................  ..........................
#
    97.61%  rsyslogd  libc-2.13.so       [.] __libc_disable_asynccancel
     2.39%  rsyslogd  [kernel.kallsyms]  [k] native_write_msr_safe


#
# (For a higher level overview, try: perf report --sort comm,dso)
#
# PID  TID


ie., I do not get the counter values. Specifying the counter with -e
(e.g., -e branch-misses) does not help -- still no counter output.

David
