Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab0IUEcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 00:32:32 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54404 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab0IUEcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 00:32:31 -0400
X-AuditID: b753bd60-a4d2fba000000226-a8-4c98355d3a24
Message-ID: <4C983551.5060700@hitachi.com>
Date: Tue, 21 Sep 2010 13:32:17 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: Is it supported to perf probe data?
References: <AANLkTinJBUxr-GtxxMFsnn_tb-0FS9b1KOe06YiBr5En@mail.gmail.com>	<4C97F451.5090907@hitachi.com> <AANLkTinuDWweEt80Kchwzx3B5yeVA5SaFHxJyv9d9pao@mail.gmail.com>
In-Reply-To: <AANLkTinuDWweEt80Kchwzx3B5yeVA5SaFHxJyv9d9pao@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/09/21 10:19), Luming Yu wrote:
> On Tue, Sep 21, 2010 at 7:54 AM, Masami Hiramatsu
> <masami.hiramatsu.pt@hitachi.com> wrote:
>> Hi Luming,
>>
>> (2010/09/20 17:03), Luming Yu wrote:
>>> Hi there,
>>>
>>> I need to analyze accessing pattern to a data in kernel. Wanna to
>>> check with you if perf probe can help to get that trace.
>>
>> Yes, perf probe can add new trace events which can be used
>> from perf record/report/trace or ftrace as same as other pre-defined
>> trace events. Those new events can record variables as arguments too.
>> So you can define new events with accessed data, record it by perf record,
>> and see it by perf trace.
> 
> e.g. I need to trace accessing to thread_info.flags of a specific task,
> would you please show me an example how to do it.

OK, if your tracing function 'func' has a local pointer 'thread_info' which points
to the thread_info structure, you can do;

# perf probe --add 'func thread_info->flags'

to trace flags.
But if you are willing to trace (struct *thread_info)(current->stack)->flags,
sorry, currently perf probe doesn't support (1)"current" special macro, and
(2)force type casting.
If you need that kind of complicated tracing ASAP, I'd like to recommend
you to use systemtap. (which I'm trying to catch up...)

Thank you,


> 
> Thanks,
> Luming
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
