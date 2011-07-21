Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab1GUJg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:36:58 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:51877 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab1GUJg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:36:56 -0400
X-AuditID: b753bd60-a327cba0000050a4-de-4e27f335e43b
X-AuditID: b753bd60-a327cba0000050a4-de-4e27f335e43b
Message-ID: <4E27F332.8020501@hitachi.com>
Date: Thu, 21 Jul 2011 18:36:50 +0900
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v2 4/6] perf script: print DSOs and symbols for BTS
 branch_from addr
References: <20110717093031.3447.52715.stgit@linux3> <20110717093103.3447.98227.stgit@linux3> <4E230C63.50601@gmail.com>
In-Reply-To: <4E230C63.50601@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/18 1:22), David Ahern wrote:
>
>
> On 07/17/2011 03:31 AM, Akihiro Nagai wrote:
>> Print DSOs and symbols for branch_from address of BTS.
>> BTS records branch_from address in 'addr' fields,
>> and branch_to address in 'ip' field. Latest perf-script
>> resolves DSOs and symbols only for 'ip' field.
>> This patch resolves them for 'addr' field too.
>
> Description does not match code change. What you are doing is enhancing
> the detection of when a sample address should correlate to a symbol. In
> this case you are adding HW_BRANCH_INSTRUCTIONS event.
I see. In the next patch set, I'd like to fix it. For example,
"Enhance IP and ADDR correlation detection of BTS event"

Thank you.

>
> David
>
>
>>
>> # perf script -f ip,addr,dso,sym
>> 3f03e016b0 (unknown) ([kernel.kallsyms]) ffffffff814675d2 irq_return ([kernel.kallsyms])
>> 3f03e016b0    _start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
>> 3f03e04b80 _dl_start (/lib64/ld-2.14.so)       3f03e016b3 _start (/lib64/ld-2.14.so)
>> 3f03e04b80 _dl_start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
>> 3f03e04ba6 _dl_start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
>> 3f03e04bad _dl_start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
>> 3f03e04c1d _dl_start (/lib64/ld-2.14.so)       3f03e04bfb _dl_start (/lib64/ld-2.14.so)
>> [snip]
>>
>> Signed-off-by: Akihiro Nagai<akihiro.nagai.hw@hitachi.com>
>> Cc: Peter Zijlstra<peterz@infradead.org>
>> Cc: Frederic Weisbecker<fweisbec@gmail.com>
>> Cc: Paul Mackerras<paulus@samba.org>
>> Cc: Ingo Molnar<mingo@elte.hu>
>> Cc: Arnaldo Carvalho de Melo<acme@infradead.org>
>> Cc: David Ahern<dsahern@gmail.com>
>> Cc: Masami Hiramatsu<masami.hiramatsu.pt@hitachi.com>
