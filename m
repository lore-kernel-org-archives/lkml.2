Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab2EaPPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:15:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26560 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483Ab2EaPPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:15:48 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=oi6mPzrycosA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=nwS0t3WeWGV9GlwFZ-AA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338477346.13348.351.camel@gandalf.stny.rr.com>
Subject: Re: Re: [RFC PATCH -tip  0/9]ftrace, kprobes: Ftrace-based kprobe
 optimization
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Thu, 31 May 2012 11:15:46 -0400
In-Reply-To: <4FC787D8.4010904@hitachi.com>
References: <20120529124833.9191.23007.stgit@localhost.localdomain>
	  <1338331514.13348.298.camel@gandalf.stny.rr.com>
	  <4FC5C55E.9000909@hitachi.com>
	 <1338377978.13348.308.camel@gandalf.stny.rr.com>
	 <4FC787D8.4010904@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 00:01 +0900, Masami Hiramatsu wrote:

> OK, that's same as what I expected. In that case,
> all __kprobes functions are already filtered out
> by kprobes itself. So we don't need to set that anymore.
> 
> Hmm, CFLAGS_REMOVE_kprobes.o can also keep kprobes from
> function tracer. So I'd like to try to use that instead
> of including notrace into __kprobes.
> However, in that case, kprobe users must remove -pg from
> their kernel modules too, and take care that they must
> call only notrace kernel APIs...
> 
> Perhaps, we'd better introduce new kprobe flag which allow
> kprobe to accept new probe on ftrace, so that user can
> explicitly understand what he will do.

Please do not make kprobe functions not allow function tracing! I *want*
to trace these functions! For example, I trace functions in NMIs all the
time, and I know these are prohibited by kprobes.

Why can't we function trace this? If kprobes does not trace functions
marked with kprobes already, then it should not have any issue. Kprobes
will only use the function tracer for what its allowed to use.

Do not remove -pg from anything to satisfy kprobes. It shouldn't need
it.

-- Steve




