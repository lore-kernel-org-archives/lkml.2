Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab2DWLRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:17:20 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48143 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957Ab2DWLRT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:17:19 -0400
MIME-Version: 1.0
In-Reply-To: <1335178132.28150.117.camel@twins>
References: <CABPqkBQJU2vYLbr-=qjkpG=sB8n-8aXJ3QkWcASzy5h4rtFAig@mail.gmail.com>
	<1335178132.28150.117.camel@twins>
Date: Mon, 23 Apr 2012 13:17:17 +0200
Message-ID: <CABPqkBQ2w3RLRwq3fsaJQ_L=_=H+5kounBeuxUv_fk1ksimTOQ@mail.gmail.com>
Subject: Re: [BUG] perf stat: useless output for raw events with new event parser
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, mingo@elte.hu,
        David Ahern <dsahern@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 12:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2012-04-23 at 12:45 +0200, Stephane Eranian wrote:
>> Hi,
>>
>> With the new event parser, one can express raw events field by field:
>>
>> $ perf stat -e cpu/event=0x3c,umask=0x0/,cpu/event=0xc5,umask=0x0/ noploop 1
>>
>> The problem with this is that the output of perf stat becomes useless:
>>
>> $ perf stat -e cpu/event=0x3c,umask=0x0/,cpu/event=0xc5,umask=0x0/ noploop 1
>> noploop for 1 seconds
>>
>>  Performance counter stats for 'noploop 1':
>>
>>         2395038678 pmu
>>             10787 pmu
>>                        ^^^^^^
>>        1.000802603 seconds time elapsed
>
> Yeah, I already complained about that.. Jolsa proposed adding a name=
> parameter so you could explicitly name your events. I think I've seen a
> patch adding that, but can't atm seem to locate it.
>
If the proposed solution is to add a pseudo field called "name", then I don't
see the point of this new parser compared to directly using my libpfm4
library which already allows:

 perf stat -e inst_retired:any,wsm_unc:unc_cycles:u ...
And
 perf record -e instr_retired:period=200000,cpu_clk_unhalted:freq=100 ...

If you have to make up names, you might as well, use the actual PMU
event names, but if you do so, why would you have to bother breaking
down the encoding into fields?
