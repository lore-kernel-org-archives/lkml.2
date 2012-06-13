Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab2FMIZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:25:55 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46128 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab2FMIZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:25:50 -0400
X-AuditID: b753bd60-996f1ba000000f6c-ff-4fd84e8c6125
X-AuditID: b753bd60-996f1ba000000f6c-ff-4fd84e8c6125
Message-ID: <4FD84E84.1090001@hitachi.com>
Date: Wed, 13 Jun 2012 17:25:40 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC][PATCH 00/13 v2] kprobes/ftrace: Making ftrace usable for
 kprobes
References: <20120612224327.426900129@goodmis.org>
In-Reply-To: <20120612224327.426900129@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/13 7:43), Steven Rostedt wrote:
> If an arch supports passing of ftrace ops, it must also pass regs.
> But it does not need to support passing regs. By default
> an arch can just pass NULL. If it supports  regs, then
> it can allow tools like kprobes to ask for regs. Otherwise the
> regs parameter should just be NULL.

Hmm, by default, will the ftrace_ops be also NULL? or NULL only if
the arch doesn't support passing ftrace ops?
I mean, should the generic handler always check if ftrace_ops
isn't NULL before using it?

> The second set is Masami's patches ported on top of these changes.
> 
> This is v2, and I've cleaned the patches up a bit and added a lot more
> comments. This is a more serious RFC as this is the current way I plan
> on pushing it to mainline. But I'm posting first in case someone spots
> something that I missed. I'll also be doing more testing on it and if
> someting comes up I'll obviously will fix it before pushing.
> 
> Some change since v1:
> 
>  Added fix for undefined ftrace_location() when compiling with !DYNAMIC_FTRACE.
>  
>  Added missing regs passed for x86_64 (segment regs, and r11).
> 
>  Saved flags for when regs are being saved. The cmp in the mcount trampoline
>  that checks if function tracing is disabled will save flags before
>  the compare, and restore flags before returning back to the function.

Nice! :) this is what I hope in previous thread.

>  Decided that passing partial regs is a bad idea. Either the arch should
>  pass all regs or NULL. Even though partial regs are saved for calling the
>  function, it does't make sense to give that to the callback. By making
>  regs be full pt_regs or NULL, then the callbacks can simply check if
>  regs is NULL and if it isn't it can do more functionality, but if it
>  is NULL then it just does limited work. Having 'partial regs' would just
>  complicate that for no good reason. If in the future we want partial regs,
>  we can add another flag to request it.

Agreed.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
