Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793Ab2GLMMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 08:12:46 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:57558 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933748Ab2GLMMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 08:12:44 -0400
X-AuditID: b753bd60-8ecbeba0000047ca-31-4ffebf39000d
X-AuditID: b753bd60-8ecbeba0000047ca-31-4ffebf39000d
Message-ID: <4FFEBF38.7080406@hitachi.com>
Date: Thu, 12 Jul 2012 21:12:40 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC][PATCH 1/4 v4] ftrace/x86: Add separate function to save
 regs
References: <20120711195048.885039013@goodmis.org> <20120711195745.107705970@goodmis.org>
In-Reply-To: <20120711195745.107705970@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/12 4:50), Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Add a way to have different functions calling different trampolines.
> If a ftrace_ops wants regs saved on the return, then have only the
> functions with ops registered to save regs. Functions registered by
> other ops would not be affected, unless the functions overlap.
> 
> If one ftrace_ops registered functions A, B and C and another ops
> registered fucntions to save regs on A, and D, then only functions
> A and D would be saving regs. Function B and C would work as normal.
> Although A is registered by both ops: normal and saves regs; this is fine
> as saving the regs is needed to satisfy one of the ops that calls it
> but the regs are ignored by the other ops function.
> 
> x86_64 implements the full regs saving, and i386 just passes a NULL
> for regs to satisfy the ftrace_ops passing. Where an arch must supply
> both regs and ftrace_ops parameters, even if regs is just NULL.
> 
> It is OK for an arch to pass NULL regs. All function trace users that
> require regs passing must add the flag FTRACE_OPS_FL_SAVE_REGS when
> registering the ftrace_ops. If the arch does not support saving regs
> then the ftrace_ops will fail to register. The flag
> FTRACE_OPS_FL_SAVE_REGS_IF_SUPPORTED may be set that will prevent the
> ftrace_ops from failing to register. In this case, the handler may
> either check if regs is not NULL or check if ARCH_SUPPORTS_FTRACE_SAVE_REGS.
> If the arch supports passing regs it will set this macro and pass regs
> for ops that request them. All other archs will just pass NULL.

OK, this is good for me:)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> 
> Cc: Alexander van Heukelum <heukelum@fastmail.fm>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


