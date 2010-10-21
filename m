Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab0JUIvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:51:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58812 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753004Ab0JUIvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:51:32 -0400
Message-ID: <4CBFFF43.2010100@cn.fujitsu.com>
Date: Thu, 21 Oct 2010 16:52:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: subrata@linux.vnet.ibm.com
CC: rostedt <rostedt@goodmis.org>, Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        ltp-list <ltp-list@lists.sf.net>
Subject: Re: [2.6.36-rc7, Power6] LTP Ftrace Stress tests causes KERNEL	PANIC
 and brings the system to xmon
References: <1286998463.4893.26.camel@subratamodak.linux.ibm.com> <1287649998.22128.1.camel@subratamodak.linux.ibm.com>
In-Reply-To: <1287649998.22128.1.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I guess you didn't notice I've also forwarded the bug report to LKML?
 http://marc.info/?l=linux-kernel&m=128737193919500&w=2)

Subrata Modak wrote:
> Stefen,
> 
> Can you please know your thoughts on this issue ?
> 

Stefen? Steven? :)

> Regards--
> Subrata
> 
> On Thu, 2010-10-14 at 01:04 +0530, Subrata Modak wrote:
>> Hi,
>>
>> Executing LTP Ftrace Stress tests on 2.6.36-rc7, Power6 creates kernel
>> Panic and xmon is invoked:
>>

...

>>
>> However Peter Zijlstraś proposed patch did not fix this issue. The patch
>> was
>> posted to LTP:
>> http://marc.info/?l=ltp-list&m=128696942432669&w=2
>>
>> The Kernel paniked even after the patch. However this time th message was
>> different. Other xmon output is also shown below:
>>

So they are 2 different bugs, and Peter's patch fixed the first one.
But that patch is too bug for .36..

For the second bug, as I said, it's a dead loop, and it's PowerPC specific,
so better have someone in PPC fixed it, and Steven has proposed to add
recursive check.

...

>>  pid   = 1668, cc0000000002226b0 .rb_reserve_next_event+0x20c/0x804
>> [c0000000d9f8b9b0] c000000000223178 .ring_buffer_lock_reserve+0x24c/0x2a4
>> [c0000000d9f8ba40] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
>> [c0000000d9f8baf0] c00000000022ec9c
>> .trace_current_buffer_lock_reserve+0x44/0x6c
>> [c0000000d9f8bb80] c000000000011c5c .ftrace_raw_event_hcall_entry+0x7c/0x144
>> [c0000000d9f8bc40] c000000000096624 .__trace_hcall_entry+0xa0/0xec
>> [c0000000d9f8bcd0] c00000000009786c .plpar_hcall_norets+0x50/0xd0
>> [c0000000d9f8bd40] c0000000000749c8 .__spin_yield+0x130/0x15c
>> [c0000000d9f8bdd0] c000000000213458 .trace_clock_global+0x11c/0x2a0
>> [c0000000d9f8be90] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
>> [c0000000d9f8bfa0] c000000000223178 .ring_buffer_lock_reserve+0x24c/0x2a4
>> [c0000000d9f8c030] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
>> [c0000000d9f8c0e0] c00000000022ec9c
>> .trace_current_buffer_lock_reserve+0x44/0x6c
>> [c0000000d9f8c170] c000000000011c5c .ftrace_raw_event_hcall_entry+0x7c/0x144
>> [c0000000d9f8c230] c000000000096624 .__trace_hcall_entry+0xa0/0xec
>> [c0000000d9f8c2c0] c00000000009786c .plpar_hcall_norets+0x50/0xd0
>> [c0000000d9f8c330] c0000000000749c8 .__spin_yield+0x130/0x15c
>> [c0000000d9f8c3c0] c000000000213458 .trace_clock_global+0x11c/0x2a0
>> [c0000000d9f8c480] c0000000002226b0 .rb_reserve_next_event+0x20c/0x804
>> [c0000000d9f8c590] c000000000223178 .ring_buffer_lock_reserve+0x24c/0x2a4
>> [c0000000d9f8c620] c00000000022d6f4 .trace_buffer_lock_reserve+0x58/0xe4
