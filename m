Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab2FYPzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 11:55:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30519 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab2FYPzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 11:55:44 -0400
X-Authority-Analysis: v=2.0 cv=cIliQyiN c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=hVM6Fzsi8tMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=qpUykWU5KyzluN_Cnc4A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340639741.27036.337.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v2] printk: Have printk() never buffer its data
From: Steven Rostedt <rostedt@goodmis.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 25 Jun 2012 11:55:41 -0400
In-Reply-To: <CAPXgP13=4fgTuL3fawZUV+Khzx=RK9froKe-iD5KBY1c8wWVGw@mail.gmail.com>
References: <1340630505.27036.294.camel@gandalf.stny.rr.com>
	 <20120625135611.GA1301@gmail.com>
	 <1340634366.27036.324.camel@gandalf.stny.rr.com>
	 <CAPXgP13=4fgTuL3fawZUV+Khzx=RK9froKe-iD5KBY1c8wWVGw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 17:22 +0200, Kay Sievers wrote:
> On Mon, Jun 25, 2012 at 4:26 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Mon, 2012-06-25 at 15:56 +0200, Ingo Molnar wrote:
> 
> >> Anyway, bike shed painting aside, the patch looks like a
> >> workable solution to me.
> >
> > Great! Lets hope Kay feels the same way.
> 
> Hmm, what I still miss, is how the log record export should work
> properly with unbuffered continuation lines.
> 
> The buffering of continuation line users resulted in a clean one
> record per logged line. Now we will get all separated records for all
> continuation prints of a single line, which would either need to be
> merged in userspace, or internally.

Merge it in userspace.

> 
> Non-buffered continuation lines and and a record buffer don't play
> that well with each other.

Yeah, I know, as they seem to be a problem together in the coding.

>  It also sounds like quite a lot of wasted
> headers in the buffer, which we need to carry around and throw away
> when we reconstruct the line for output again. If we merge them
> internally we mess around with the sequence numbers, if we merge them
> in userspace we would need to export the flags to do that.

As I'm still on debian and fedora 14, I have to admit that I do not
quite understand exactly what you are trying to do with systemd or your
logging facility. But it seems to become clear that printk isn't a tool
for it.

What exactly are you trying to record from the kernel? Device
information, kernel diagnostics, or something else? Maybe there should
be another facility besides printk that can pass what you want to your
utilities.

printk is the first line of attack for kernel developers to find their
bugs. If it becomes bloated and focused on users, it will make
development of the kernel much more difficult.

Perhaps we should have added a hook or a tracepoint at the beginning of
printk that your logging facility could attach to, and then it could do
logging and buffering in any manner it would like, instead of hijacking
the best debugging tool that kernel developers use.

I'm starting to side with Ingo that the new printk should be reverted
and rethought, and find another answer to the fixes that it solved.

-- Steve




