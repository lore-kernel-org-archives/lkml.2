Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab2B0Vaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:30:52 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39804 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab2B0Vau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:30:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.219.232 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Mon, 27 Feb 2012 13:29:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        stable@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/nmi: Test saved %cs in NMI to determine
 nested NMI case
Message-ID: <20120227212947.GA3002@kroah.com>
References: <1329687817.1561.27.camel@acer.local.home>
 <tip-45d5a1683c04be28abdf5c04c27b1417e0374486@git.kernel.org>
 <1329756701.25686.31.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329756701.25686.31.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 11:51:41AM -0500, Steven Rostedt wrote:
> On Mon, 2012-02-20 at 03:47 -0800, tip-bot for Steven Rostedt wrote:
> > Commit-ID:  45d5a1683c04be28abdf5c04c27b1417e0374486
> > Gitweb:     http://git.kernel.org/tip/45d5a1683c04be28abdf5c04c27b1417e0374486
> > Author:     Steven Rostedt <rostedt@goodmis.org>
> > AuthorDate: Sun, 19 Feb 2012 16:43:37 -0500
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Mon, 20 Feb 2012 09:09:57 +0100
> > 
> > x86/nmi: Test saved %cs in NMI to determine nested NMI case
> > 
> > Currently, the NMI handler tests if it is nested by checking the
> > special variable saved on the stack (set during NMI handling)
> > and whether the saved stack is the NMI stack as well (to prevent
> > the race when the variable is set to zero).
> > 
> > But userspace may set their %rsp to any value as long as they do
> > not derefence it, and it may make it point to the NMI stack,
> > which will prevent NMIs from triggering while the userspace app
> > is running. (I tested this, and it is indeed the case)
> > 
> > Add another check to determine nested NMIs by looking at the
> > saved %cs (code segment register) and making sure that it is the
> > kernel code segment.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: <stable@kernel.org>
> 
> Just so that we do not confuse Greg, the bug was introduced in the 3.3
> merge window. It does not exist in 3.2 or earlier.

Thanks for letting me know, I would have been confused :)

greg k-h
