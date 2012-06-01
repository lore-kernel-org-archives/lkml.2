Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965Ab2FAOUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:20:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14806 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758804Ab2FAOUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:20:30 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wwwCnHkgN0EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=R019HrRdPH0tZWlj5TQA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338560427.13348.466.camel@gandalf.stny.rr.com>
Subject: Re: [RFC PATCH -tip  0/9]ftrace, kprobes: Ftrace-based kprobe
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
Date: Fri, 01 Jun 2012 10:20:27 -0400
In-Reply-To: <4FC8C557.9010407@hitachi.com>
References: <20120529124833.9191.23007.stgit@localhost.localdomain>
	   <1338331514.13348.298.camel@gandalf.stny.rr.com>
	   <4FC5C55E.9000909@hitachi.com>
	  <1338377978.13348.308.camel@gandalf.stny.rr.com>
	  <4FC787D8.4010904@hitachi.com>
	 <1338477346.13348.351.camel@gandalf.stny.rr.com>
	 <4FC8C557.9010407@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 22:36 +0900, Masami Hiramatsu wrote:

> OK, so I've introduced new noprobe tag and replaced __kprobes
> with it. And now __kprobes tag which is a combination of noprobe
> and notrace, means that the function is not probed and it can be
> called from kprobe handler. (thus user must use this with their
> handlers and functions which will be used from the handlers)
> And also most of __kprobes tags are replaced by noprobe only.

You still haven't answered my question. Why can't function tracer still
trace these? If kprobes does not allow it to be probed, it should not
interfere with your code. But normal function tracing should still allow
these.

I still do not understand why you need to add 'notrace' at all.

> This means that you can trace those by function tracer :)
> 
> BTW, currently kprobes allows user cases pagefault in their
> handler (kprobe.fault_handler will handle it). I guess that
> can cause some problem with ftrace, isn't it? If so, I need
> to deny a kprobe using ftrace if it has fault_handler.

As long as there's recursion protection you are fine. In fact, I may add
recursion protection within the assembly itself, that will make all
function tracing safe. (does not solve the breakpoint bug from the other
thread, but will solve most other things). In fact, this may allow us to
remove notraces that were added because of recursion issues.

-- Steve


