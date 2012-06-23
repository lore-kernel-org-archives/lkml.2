Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab2FWGNU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 02:13:20 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59063 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab2FWGNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 02:13:18 -0400
Date: Sat, 23 Jun 2012 08:13:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
Message-ID: <20120623061313.GA21895@gmail.com>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
 <20120622145402.8047a669.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622145402.8047a669.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 21 Jun 2012 19:52:03 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > But with the new printk() changes, text without a newline 
> > gets buffered and does not print out to the console at the 
> > location of the printk.
> 
> uh, how about we fix that?  The old behaviour was good, the 
> new behaviour is noxious.

Absolutely.

pr_flush() really seems to be a workaround.

> Please idenfity these "new printk() changes".  Was the new 
> noxiousness an unavoidable effect of them?

Fundamentally:

e2ae715d66bf kmsg - kmsg_dump() use iterator to receive log buffer content
c313af145b9b printk() - isolate KERN_CONT users from ordinary complete lines
3ce9a7c0ac28 printk() - restore prefix/timestamp printing for multi-newline strings
649e6ee33f73 printk() - restore timestamp printing at console output
5c5d5ca51abd printk() - do not merge continuation lines of different threads
7f3a781d6fd8 printk - fix compilation for CONFIG_PRINTK=n
5fc3249068c1 kmsg: use do_div() to divide 64bit integer
e11fea92e13f kmsg: export printk records to the /dev/kmsg interface
7ff9554bb578 printk: convert byte-buffer to variable-length record buffer

Should we revert them or can they be fixed sanely? Kay seems to 
be busy with other things so I guess a revert is the best we can 
do. Greg, Kay?

Thanks,

	Ingo
