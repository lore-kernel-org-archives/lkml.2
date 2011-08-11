Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab1HKFtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 01:49:19 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:57330 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1HKFtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 01:49:17 -0400
X-AuditID: b753bd60-a327cba0000050a4-62-4e436d5a1614
X-AuditID: b753bd60-a327cba0000050a4-62-4e436d5a1614
Message-ID: <4E436D56.1090602@hitachi.com>
Date: Thu, 11 Aug 2011 14:49:10 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH][3.0] Tracepoint: dissociate from module mutex (v2)
References: <20110810191839.GC8525@Krystal>  <4E434928.9020304@hitachi.com> <1313033007.18583.283.camel@gandalf.stny.rr.com>
In-Reply-To: <1313033007.18583.283.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/08/11 12:23), Steven Rostedt wrote:
> On Thu, 2011-08-11 at 12:14 +0900, Masami Hiramatsu wrote:
>> (2011/08/11 4:18), Mathieu Desnoyers wrote:
>>> Copy the information needed from struct module into a local module list
>>> held within tracepoint.c from within the module coming/going notifier.
>>>
>>> This vastly simplifies locking of tracepoint registration /
>>> unregistration, because we don't have to take the module mutex to
>>> register and unregister tracepoints anymore. Steven Rostedt ran into
>>> dependency problems related to modules mutex vs kprobes mutex vs ftrace
>>> mutex vs tracepoint mutex that seems to be hard to fix without removing
>>> this dependency between tracepoint and module mutex. (note: it should be
>>> investigated whether kprobes could benefit of being dissociated from the
>>> modules mutex too.)
>>
>> Thanks, it seems that kprobes has already mostly done that.
>> It holds module_mutex only in kprobe_optimizer. However,
>> it seems meaningless, because kprobe_mutex already protects
>> kprobe_optimizer against the kprobes module notifier.
>> Thus, a module removing will stays on the notifier until
>> the optimizer runs out. So I think we can remove that mutex lock.
>>
> 
> So should I change my patch 4/5 to just remove the module_mutex?
> 
> [PATCH 4/5][RFC] kprobes: Inverse taking of module_mutex with kprobe_mutex

Right, it should be changed. :-)

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
