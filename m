Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2EHOK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 10:10:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34513 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab2EHOK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 10:10:27 -0400
Message-ID: <4FA9294F.7070203@gmail.com>
Date: Tue, 08 May 2012 08:10:23 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] perf record: fix fallback to cpu-clock on ppc
References: <1336452004-55724-1-git-send-email-dsahern@gmail.com> <20120508131207.GG2485@infradead.org>
In-Reply-To: <20120508131207.GG2485@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/12 7:12 AM, Arnaldo Carvalho de Melo wrote:
> Em Mon, May 07, 2012 at 10:40:04PM -0600, David Ahern escreveu:
>> perf-record on PPC is not falling back to cpu-clock:
>>
>> Old kernel, cannot exclude guest or host samples.
>>
>>    Error: sys_perf_event_open() syscall returned with 6 (No such device or address).  /bin/dmesg may provide additional information.
>>
>>    Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
>>
>> The problem is that until 2.6.37 (behavior changed with commit b0a873e)
>> perf on PPC returns ENXIO when hw_perf_event_init() fails. With this
>> patch we get the expected behavior:
>>
>> Old kernel, cannot exclude guest or host samples.
>> The cycles event is not supported, trying to fall back to cpu-clock-ticks
>> [ perf record: Woken up 1 times to write data ]
>> [ perf record: Captured and wrote 0.150 MB /tmp/perf.data (~6569 samples) ]
>
> Would be good to have this documented on the spot, i.e. just before that
> if.
>
> Also, have you checked that 'perf stat' and 'perf top' works as well? We
> really need to move all this logic to a central place, namely
> perf_evlist__open().
>
> For now checking if stat and top ara ok should be enough.

perf-top works because it drops back to cpu-clock for any 
perf_event_open failure; perf-stat does not. Will fix it and add a 
comment about PPC and ENXIO errno to both.

David
