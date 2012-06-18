Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab2FRJPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:15:10 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58563 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2FRJPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:15:08 -0400
X-AuditID: b753bd60-98cf0ba000000f6c-95-4fdef1995406
X-AuditID: b753bd60-98cf0ba000000f6c-95-4fdef1995406
Message-ID: <4FDEF191.7000009@hitachi.com>
Date: Mon, 18 Jun 2012 18:14:57 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC][PATCH 05/13 v2] ftrace/x86: Add separate function to save
 regs
References: <20120612224327.426900129@goodmis.org>  <20120612225425.218922417@goodmis.org> <4FDAEF18.6040703@hitachi.com> <1339760011.13377.338.camel@gandalf.stny.rr.com>
In-Reply-To: <1339760011.13377.338.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/15 20:33), Steven Rostedt wrote:
> On Fri, 2012-06-15 at 17:15 +0900, Masami Hiramatsu wrote:
> 
>>> It is OK for an arch to pass NULL regs. All function trace users that
>>> require regs passing must add the flag FTRACE_OPS_FL_SAVE_REGS when
>>> registering the ftrace_ops and either check if regs is not NULL or
>>> check if ARCH_SUPPORTS_FTRACE_SAVE_REGS. If the arch supports passing
>>> regs it will set this macro and pass regs for ops that request them.
>>> All other archs will just pass NULL.
>>
>> Hmm, so would you mean that user is responsible for checking
>> whether the arch supports save_regs or not?
>> I would rather like ftrace to check it as my patch has done.
>> I think ARCH_SUPPORTS_FTRACE_SAVE_REGS macro checking in all
>> handler code is something like odd...
> 
> I was thinking of routines that may or may not use regs. Actually, I was
> thinking about perf in general, that could use regs if supported, or get
> its own set.
> 
> But I agree that it may not be the best for those that must have regs.
> 
> Perhaps we could add another flag:
> 
> FTRACE_OPS_FL_SAVE_REGS_IF_SUPPORTED
> 
> Where it wont error out if you have this set. But if you just pass in
> FTRACE_OPS_FL_SAVE_REGS (as kprobes does) it will fail.
> 
> How's that sound?

Yeah, that's good for me. :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
