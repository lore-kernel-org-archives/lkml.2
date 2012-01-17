Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab2AQMDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:03:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35624 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab2AQMDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:03:35 -0500
X-Authority-Analysis: v=2.0 cv=Hf6Wv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=KHR86nk1PkcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=Xzg2R8yLFMHD5Fx3ua8A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326801811.7642.188.camel@gandalf.stny.rr.com>
Subject: Re: [GIT PULL] tracing: make signal tracepoints more useful
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Tue, 17 Jan 2012 07:03:31 -0500
In-Reply-To: <20120117100222.GH10397@elte.hu>
References: <20120110174509.GA30802@redhat.com>
	 <20120113182015.GA3902@redhat.com> <20120115182441.GA24694@redhat.com>
	 <20120116074540.GE15641@elte.hu>
	 <1326717070.7642.144.camel@gandalf.stny.rr.com>
	 <20120116125329.GB31667@elte.hu>
	 <1326729123.7642.146.camel@gandalf.stny.rr.com>
	 <20120117100222.GH10397@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-17 at 11:02 +0100, Ingo Molnar wrote:

> That is not true *AT ALL* in such an unqualified manner. Steve, 
> stop being stupid.
> 
> The kernel syscall ABI may indeed sometimes expand *INPUT* 
> structures (if via some mechanism it's possible to make sure 
> that old ABI uses don't cause the kernel to read undefined 
> data), but the trace events are *OUTPUT* structures.

The difference between syscalls and tracepoints is that a tracepoint
always reports the size of the structure that was read, where a syscall
does not. So I do consider this similar to reading the /proc/stat file
as the user can see how much was read. The backwards compatibility
should be easy to write. Old tools should not break, because it wont be
reading the new fields, and new tools can determine which tracepoint is
there because it is trivial to see which version of the tracepoint is
there because of the size read.

But as I'm stupid, I'll shut up now.

-- Steve


