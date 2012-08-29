Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab2H2IJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 04:09:09 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:57514 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2H2IJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 04:09:06 -0400
X-AuditID: b753bd60-9255dba000007c38-c3-503dce144747
X-AuditID: b753bd60-9255dba000007c38-c3-503dce144747
Message-ID: <503DCE13.5030400@hitachi.com>
Date: Wed, 29 Aug 2012 17:08:51 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: BUG: Kprobe smoke test: 2 out of 6 tests failed
References: <20120824071512.GA965@localhost>  <1345815698.12440.12.camel@gandalf.local.home> <1345856440.12440.21.camel@gandalf.local.home>
In-Reply-To: <1345856440.12440.21.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven and Fengguang,

(2012/08/25 10:00), Steven Rostedt wrote:
> On Fri, 2012-08-24 at 09:41 -0400, Steven Rostedt wrote:
> 
>> On Fri, 2012-08-24 at 15:15 +0800, Fengguang Wu wrote:
>>> Hi Steven,
>>>
>>> The following test fails are mostly due to this commit, or one of the
>>> last 4 commits in
>>>
>>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git tip/perf/core
>>> head:   d57c5d51a30152f3175d2344cb6395f08bf8ee0c
>>> commit: d57c5d51a30152f3175d2344cb6395f08bf8ee0c [100/100] ftrace/x86: Add support for -mfentry to x86_64
>>>
>>> [    9.084881] Kprobe smoke test failed: register_jprobe returned -22
>>> [    9.086786] Kprobe smoke test failed: register_jprobes returned -22
> 
> Masami,
> 
> Seems that when we use fentry, we break jprobes. I thought the patches
> that we added would just move the call to the next op, not fail totally?

Ah! yes, it would be kprobe-side problem.

Since ftrace_regs_call allows handlers to set regs->ip, it is not necessarily
to move jprobe onto the next instruction (even it will be the simplest one).
Instead, I think we can allow it on ftrace entries. Of course, ftrace side
change is also needed, e.g. sorting handlers for moving such ip-modifying
handler to the last.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


