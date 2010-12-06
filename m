Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab0LFK3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 05:29:01 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:52318 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab0LFK3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 05:29:00 -0500
X-Greylist: delayed 1218 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Dec 2010 05:28:59 EST
X-AuditID: b753bd60-a5711ba00000392d-64-4cfcbae9db5a
Message-ID: <4CFCBAE1.9000007@hitachi.com>
Date: Mon, 06 Dec 2010 19:28:49 +0900
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH -tip  6/7] perf bts trace: print function+offset
References: <20101203035832.7827.16528.stgit@localhost6.localdomain6> <20101203040015.7827.38870.stgit@localhost6.localdomain6> <20101206024244.GA2418@nowhere>
In-Reply-To: <20101206024244.GA2418@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/06 11:42), Frederic Weisbecker wrote:
> On Fri, Dec 03, 2010 at 01:00:15PM +0900, Akihiro Nagai wrote:
>> Provide the function to print function+offset.
>> And, set it as the default behavior of 'perf bts trace'.
>> To use this function, users can also specify the option '-s' or '--symbol'.
>>
>> Example: 'perf bts -as trace'
>> This command prints address and function+offset.
>>
>> Output sample:
>> address            function+offset
>> 0xffffffff8146fe0e irq_return+0x0         =>  0x00007fd4038e3b20 _start+0x0
>> ...
>> 0x000000380661ee79 __libc_start_main+0xf9 =>  0x00000000004035c3 main+0x0
>> 0xffffffff8146ef4e irq_return+0x0         =>  0x00000000004035c3 main+0x0
>> 0x00000000004035e8 main+0x25              =>  0x000000000040bca0 set_program_name+0x0
>> 0xffffffff8146ef4e irq_return+0x0         =>  0x000000000040bca0 set_program_name+0x0
>> 0x000000000040bcae set_program_name+0xe   =>  0x00000000004023d0 strrchr@plt+0x0
>> 0x00000000004023d0 strrchr@plt+0x0        =>  0x00000000004023d6 strrchr@plt+0x6
>> ...
>> 0x0000000000403e0c main+0x849             =>  0x00000000004021f0 exit@plt+0x0
>> 0x00000000004021f0 exit@plt+0x0           =>  0x00000000004021f6 exit@plt+0x6
>> 0x00000000004021fb exit@plt+0xb           =>  0x00000000004020d0 _init+0x18
>> 0x00000000004020d6 _init+0x1e             =>  0x00000038062149d0 _dl_runtime_resolve+0x0
>> ...
>
> There is another kind of mode that I suspect would be very useful: something like
> a userspace function graph tracer (you can have a look into the kernel function
> graph tracer we have in ftrace to get an overview).
>
> So, the idea would be to rebuild the whole function call flow:
>
> main() {
> 	func1()
> 	func2() {
> 		func3()
> 	}
> }
>
>
> This would require to deref the instructions into the dso addresses from
> the bts trace, keep only the "call" and the "ret" (there would be a small arch
> backend for this mode) and rebuild the whole tree of calls.
> We already have all the dso address mapping API in place with perf.
>
> I really think this could be a very useful tool. Also we can even later
> expand this to the branches, as Peter suggested. But starting with calls
> would a very great start already.
>
> Thanks.
It's very good idea!
I'll try it.

Thank you for your suggestion!

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
