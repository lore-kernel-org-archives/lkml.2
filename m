Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762866Ab2FVXtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:49:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51961 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab2FVXtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:49:19 -0400
Date: Fri, 22 Jun 2012 16:49:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
Message-Id: <20120622164917.3121168a.akpm@linux-foundation.org>
In-Reply-To: <1340408464.27036.282.camel@gandalf.stny.rr.com>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
	<20120622145402.8047a669.akpm@linux-foundation.org>
	<1340408464.27036.282.camel@gandalf.stny.rr.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2012 19:41:04 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 2012-06-22 at 14:54 -0700, Andrew Morton wrote:
> > On Thu, 21 Jun 2012 19:52:03 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > But with the new printk() changes, text without a newline gets buffered
> > > and does not print out to the console at the location of the printk.
> > 
> > uh, how about we fix that?  The old behaviour was good, the new
> > behaviour is noxious.
> > 
> > Please idenfity these "new printk() changes".  Was the new noxiousness
> > an unavoidable effect of them?
> 
> See commit 7ff9554bb578 ("printk: convert byte-buffer to variable-length
> record buffer") and related commits.
> 
> But that said, there may be a way that I can make it still always flush
> and not add a new API. We can flush on partial writes, and keep track of
> the current task (as it already does). If a new task comes in, we can
> then force a newline before printing the content of the old task (if
> there wasn't a newline printed before).
> 
> This is basically what it does now, except that it buffers the data. If
> a new task were to do a print in between the two partial writes, it
> flushes what was buffered and adds a newline before printing the new
> text.

If a driver does

	printk("testing the frobnozzle ...");
	do_test();
	printk(" OK\n");

and do_test() hangs up, we really really want the user to know that
there was a frobnozzle testing problem.  Please tell me this isn't
broken.
