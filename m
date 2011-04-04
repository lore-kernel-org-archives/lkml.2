Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab1DDKGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 06:06:25 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54196 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab1DDKGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 06:06:23 -0400
X-AuditID: b753bd60-9cf54ba000007e19-bd-4d99981d77ed
X-AuditID: b753bd60-9cf54ba000007e19-bd-4d99981d77ed
Message-ID: <4D99981A.4070400@hitachi.com>
Date: Mon, 04 Apr 2011 19:06:18 +0900
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH -tip v3 0/6] perf: Introduce branch sub commands
References: <20110324113137.20235.42265.stgit@localhost6.localdomain6> <20110401144312.GB2335@nowhere>
In-Reply-To: <20110401144312.GB2335@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/04/01 23:43), Frederic Weisbecker wrote:
> On Thu, Mar 24, 2011 at 08:31:37PM +0900, Akihiro Nagai wrote:
>> Hi,
>>
>> This patch series provides the commands 'perf branch record' and 'perf branch trace'
>> version 3. These commands record and analyze a BTS (Branch Trace Store) log.
>> And, they provide the interface to use BTS log for application developers.
>>
>> BTS is a facility of Intel x86 processors, which records the address of
>> 'branch to/from' on every branch/jump instruction and interrupt.
>> This facility is very useful for developers to test their software,
>> for example, coverage test, execution path analysis, dynamic step count ...etc.
>> These test tools have a big advantage, which user doesn't have to modify target
>> executable binaries, because the BTS is a hardware feauture.
>>
>> But, there are few applications using BTS. Reasons I guess are ...
>>   - Few people know what BTS is.
>>   - Few people know how to use BTS on Linux box.
>>   - It's hard to analyze the BTS log because it includes just a series of addresses.
>>
>> So, I want to provide a user-friendly interface to BTS for application developers.
>>
>>
>>   About new sub commands
>> ========================
>> 'perf branch record' provides an easy way to record BTS log.
>> Usage is 'perf branch record<command>'.  This command is just an alias to
>> 'perf record -e branches:u -c 1<command>'. But, new one is more simple and
>> more intuitive.
>>
>> 'perf branch trace' can parse and analyze recorded BTS log and print various
>> information of execution path. This command can show address, pid, command name,
>> function+offset, file path of elf.
>> You can choose the printed information with option.
>>
>> Example: 'perf branch trace'
>> function+offset
>> irq_return+0x0  =>  _start+0x0
>> irq_return+0x0  =>  _start+0x0
>> _start+0x3      =>  _dl_start+0x0
>> irq_return+0x0  =>  _dl_start+0x0
>> irq_return+0x0  =>  _dl_start+0x26
>> irq_return+0x0  =>  _dl_start+0x2d
>> _dl_start+0x71  =>  _dl_start+0x93
>> _dl_start+0x97  =>  _dl_start+0x78
>> ...
>>
>> This is the default behavior of 'perf branch trace'. It prints function+offset.
>>
>>
>> Example2: 'perf branch -cas trace'
>> command address            function+offset
>> ls      0xffffffff8146fe0e irq_return+0x0  =>  ls   0x0000003806200b20 _start+0x0
>
> You probably want to display the comm (and/or the pid/tid) only once. Those are not
> going to change between the source and destination.
Exactly, perf_sample has only one pid/tid field.
So, pid/tid and command don't change between source and destination.
I'll remove desitination's pid/tid and command fields.
Thank you.
