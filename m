Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab2FYXzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:55:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39591 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465Ab2FYXzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:55:36 -0400
Date: Mon, 25 Jun 2012 16:55:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "kay.sievers" <kay.sievers@vrfy.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
Message-ID: <20120625235531.GB3652@kroah.com>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com>
 <20120625150722.8cd4f45d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120625150722.8cd4f45d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 03:07:22PM -0700, Andrew Morton wrote:
> On Mon, 25 Jun 2012 15:05:42 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > This brings back the old way of printk() that always prints to the console
> > and does not buffer the data. As printk_emit() is used by other 'facilities'
> > this only affects printk(), but keeps pretty much the new behavior.
> 
> If you say so.  The core printk code is starting to make one think of
> things like "cleansing with fire".
> 
> Why did that logging code need to futz with this printk behaviour in
> the first place?

Because, as Kay, and I think Linus, showed a while ago, the behavior
really wasn't all that good and it wasn't doing what people thought it
was doing, especially when printks from multiple cpus happened at the
same time.  There were other cases that had problems as well, the long
thread a few months ago detailed it all, which drove the creation of
these changes.

> I don't think the thing which you're fixing here was a real
> showstopper.  If a non-newline-terminated printk gets delayed, then so
> be it - we identify and fix all callers and remember the new rule and
> move on, although I still don't know why this change was deemed
> necessary.  If that results in a cleaner, clearer and more reliable
> core printk() then we win.

I'm beginning to agree here as well.

Actually, didn't I say that at the beginning of this?  :)

Stephen and Ingo, I understand that your tests now would require
multiple printk() lines, but this affects what, 10 boxes in the world
that run these tests (I'm not trying to be mean, just understand the
issues).  The fixes that now are in place fix problems for many more
systems, and provide the infrastructure for proper logging that people
have been screaming at us for over 10 years to accomplish.

I'll be glad to make the patch to fix up these test printks, (remember,
as a bonus, you now get a timestamp showing exactly how long your tests
take, which you didn't get before, how can you pass up an offer like
that?)  I think that's the best solution here, and easiest for everyone
involved (your tests then properly show what failed, you get bonus
timestamps, multi-cpu printks happen properly, proper logging messages
get sent to userspace, everone wins.)

> And we do need a cleaner, clearer and more reliable core printk() :(
> wtf have you guys been up to??  

See, Andrew even agrees with me :)

thanks,

greg k-h
