Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab1JJOPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 10:15:07 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:59670 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab1JJOPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 10:15:05 -0400
X-AuditID: b753bd60-a16a6ba000005c89-bb-4e92fde7c9ad
X-AuditID: b753bd60-a16a6ba000005c89-bb-4e92fde7c9ad
Message-ID: <4E92FDE3.8050301@hitachi.com>
Date: Mon, 10 Oct 2011 23:14:59 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH 1/4] [BUGFIX] ftrace/kprobes: Fix not to delete probes
 if in use
References: <20111004104438.14591.6553.stgit@fedora15> <1318050006.4729.103.camel@gandalf.stny.rr.com>
In-Reply-To: <1318050006.4729.103.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/08 14:00), Steven Rostedt wrote:
> On Tue, 2011-10-04 at 19:44 +0900, Masami Hiramatsu wrote:
>> Fix kprobe-tracer not to delete a probe if the probe is in use.
>> In that case, delete operation will return -EBUSY.
>>
>> This bug can cause a kernel panic if enabled probes are deleted
>> during perf record.
>>
>> (Add some probes on functions)
>> # perf record -e probe:\* -aR sh
>> sh-4.2# perf probe --del probe:\*
>> sh-4.2# exit
>> (kernel panic)
> 
> 
> Hi Masami,
> 
> I was able to reproduce the panic. I'm currently running patch 1 and 4
> through my standard tests before pushing this out as urgent.
> 
> Does this exist in previous kernels? If so, I'll also add the stable tag
> to it.

I guess so, since the perf's tracepoint handler locks target module
while recording, it is required for perf not to remove undergo events.

> Could you resend the trivial patches when you make your necessary
> corrections. They are not important as these are and I'll add them to a
> separate queue.

Right, that's not a matter. The first patch should be merged soon.

Thank you,

> 
> Thanks!
> 
> -- Steve
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
