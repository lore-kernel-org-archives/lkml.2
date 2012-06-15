Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab2FOIPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 04:15:34 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41412 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab2FOIPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 04:15:25 -0400
X-AuditID: b753bd60-9fe84ba000000655-f3-4fdaef1a1f96
X-AuditID: b753bd60-9fe84ba000000655-f3-4fdaef1a1f96
Message-ID: <4FDAEF18.6040703@hitachi.com>
Date: Fri, 15 Jun 2012 17:15:20 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC][PATCH 05/13 v2] ftrace/x86: Add separate function to
 save regs
References: <20120612224327.426900129@goodmis.org> <20120612225425.218922417@goodmis.org>
In-Reply-To: <20120612225425.218922417@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/13 7:43), Steven Rostedt wrote:
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
> registering the ftrace_ops and either check if regs is not NULL or
> check if ARCH_SUPPORTS_FTRACE_SAVE_REGS. If the arch supports passing
> regs it will set this macro and pass regs for ops that request them.
> All other archs will just pass NULL.

Hmm, so would you mean that user is responsible for checking
whether the arch supports save_regs or not?
I would rather like ftrace to check it as my patch has done.
I think ARCH_SUPPORTS_FTRACE_SAVE_REGS macro checking in all
handler code is something like odd...

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
