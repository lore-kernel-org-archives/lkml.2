Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab2EaP2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:28:37 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:57248 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468Ab2EaP2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:28:35 -0400
X-AuditID: b753bd60-a1c87ba000000655-74-4fc78e1d2775
X-AuditID: b753bd60-a1c87ba000000655-74-4fc78e1d2775
Message-ID: <4FC78E1A.90907@hitachi.com>
Date: Fri, 01 Jun 2012 00:28:26 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH -tip  0/9]ftrace, kprobes: Ftrace-based kprobe optimization
References: <20120529124833.9191.23007.stgit@localhost.localdomain>   <1338331514.13348.298.camel@gandalf.stny.rr.com>   <4FC5C55E.9000909@hitachi.com>  <1338377978.13348.308.camel@gandalf.stny.rr.com>  <4FC787D8.4010904@hitachi.com> <1338477346.13348.351.camel@gandalf.stny.rr.com>
In-Reply-To: <1338477346.13348.351.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/01 0:15), Steven Rostedt wrote:
> On Fri, 2012-06-01 at 00:01 +0900, Masami Hiramatsu wrote:
> 
>> OK, that's same as what I expected. In that case,
>> all __kprobes functions are already filtered out
>> by kprobes itself. So we don't need to set that anymore.
>>
>> Hmm, CFLAGS_REMOVE_kprobes.o can also keep kprobes from
>> function tracer. So I'd like to try to use that instead
>> of including notrace into __kprobes.
>> However, in that case, kprobe users must remove -pg from
>> their kernel modules too, and take care that they must
>> call only notrace kernel APIs...
>>
>> Perhaps, we'd better introduce new kprobe flag which allow
>> kprobe to accept new probe on ftrace, so that user can
>> explicitly understand what he will do.
> 
> Please do not make kprobe functions not allow function tracing! I *want*
> to trace these functions! For example, I trace functions in NMIs all the
> time, and I know these are prohibited by kprobes.
> 
> Why can't we function trace this? If kprobes does not trace functions
> marked with kprobes already, then it should not have any issue. Kprobes
> will only use the function tracer for what its allowed to use.

Because when I removed notrace from the __kprobes, the kernel caused
triple fault and didn't boot, even kprobes was not used.
I guess that it is because some recursive call of function tracer
has happened. So, I've added notrace to __kprobes (but it was too
widely applied).

> Do not remove -pg from anything to satisfy kprobes. It shouldn't need
> it.

But some kprobes functions will/must be called from kprobes handlers.
Those should be marked as notrace, shouldn't it?

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
