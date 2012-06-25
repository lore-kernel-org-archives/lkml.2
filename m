Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab2FYWHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 18:07:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757718Ab2FYWHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 18:07:24 -0400
Date: Mon, 25 Jun 2012 15:07:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "kay.sievers" <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
Message-Id: <20120625150722.8cd4f45d.akpm@linux-foundation.org>
In-Reply-To: <1340651142.7037.2.camel@gandalf.stny.rr.com>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2012 15:05:42 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> This brings back the old way of printk() that always prints to the console
> and does not buffer the data. As printk_emit() is used by other 'facilities'
> this only affects printk(), but keeps pretty much the new behavior.

If you say so.  The core printk code is starting to make one think of
things like "cleansing with fire".

Why did that logging code need to futz with this printk behaviour in
the first place?

I don't think the thing which you're fixing here was a real
showstopper.  If a non-newline-terminated printk gets delayed, then so
be it - we identify and fix all callers and remember the new rule and
move on, although I still don't know why this change was deemed
necessary.  If that results in a cleaner, clearer and more reliable
core printk() then we win.

And we do need a cleaner, clearer and more reliable core printk() :(
wtf have you guys been up to??  

<wonders why vprintk_emit() is asmlinkage, global, exported to modules
and has no callers outside printk.c>

>	/* This stops the holder of console_sem just where we want him */

This poor comment is now stranded half a page away from the code it's
documenting.  Please check that it's still true and then relocate it?

>
> ...
>

must.. stop.. thinking.. about.. fire..
