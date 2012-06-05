Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab2FEXh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 19:37:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2763 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab2FEXhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 19:37:55 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=MiGSmKHM__4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=yzjbzWvirs0ToGFTdAIA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338939470.13348.541.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH -tip v2 3/9] ftrace/x86: Support SAVE_REGS feature on
 i386
From: Steven Rostedt <rostedt@goodmis.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Tue, 05 Jun 2012 19:37:50 -0400
In-Reply-To: <20120605212411.GC11575@redhat.com>
References: <20120605102734.27845.43401.stgit@localhost.localdomain>
	 <20120605102802.27845.49309.stgit@localhost.localdomain>
	 <1338928666.13348.538.camel@gandalf.stny.rr.com>
	 <20120605212411.GC11575@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 17:24 -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> On Tue, Jun 05, 2012 at 04:37:46PM -0400, Steven Rostedt wrote:
> > [...]
> > I'm not sure we really need to restore all the regs. I'll keep this for
> > now, but for an optimization, we can just restore the ones that mcount
> > mcount needs to.
> > 
> > Or do you expect kprobes to change any of theses?
> 
> That would be the way for a kprobe to modify variables/values that
> happen to be in the registers.  In systemtap, for example:
> 
> # stap -g -e 'probe kernel.function("foo") { $bar = 1 }'
> 

And why would we want to allow this?


Modifying variables with probes is another way to lead to disaster. If
the system did not intend for a variable to be a certain value, why let
someone change it?

What real world example leads to external sources modifying internal
core variables? With the obvious exception of rootkits.

-- Steve


