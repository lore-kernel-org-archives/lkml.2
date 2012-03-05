Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab2CEQBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:01:34 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58732 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab2CEQBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:01:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.204.136.197 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
Date: Mon, 5 Mar 2012 20:01:27 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
Message-ID: <20120305160127.GM7366@moon>
References: <20120301191714.GF9930@moon>
 <20120301194120.GA11400@redhat.com>
 <20120302142630.GK8681@moon>
 <20120302152621.GA29744@redhat.com>
 <20120302161247.GO8681@moon>
 <20120303223333.GB26846@moon>
 <20120305142130.GA9393@redhat.com>
 <20120305142655.GC9393@redhat.com>
 <20120305144648.GA12341@moon>
 <20120305154029.GB12427@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305154029.GB12427@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 04:40:29PM +0100, Oleg Nesterov wrote:
> >
> > Hi Oleg!
> >
> > Replying to both your email -- I wanted to be as close to open_exec
> > as possible.
> 
> I see. But open_exec() is different, it returns the file we are going
> to read/mmap. PR_SET_MM_EXE_FILE is different, I think O_RDONLY buys
> nothing and looks confusing.
> 
> Anyway, as I said I won't argue.
> 

OK

> > This prctl does cheat the kernel
> 
> Yep. Except, well, it cheats the user-space.

And kernel as well, since this link is not anymore
the same as it was, and memory read from this file
(at execution time) will keep data irrelevant to what
the new symlink points to (but it's exactly by design).

> 
> > but with this tests
> > the cheating should be minimized (it's almost the same as open_exec
> > does).
> 
> I don't reallt understand "minimized" ;) With this tests
> proc/pid/exe can't look "obviously wrong", I agree. But that is all.

call it "minimized wrong" ;)

> 
> > > Seriously, I think we should cleanup this before c/r adds more
> > > ugliness. I'll try to make the patch today.
> >
> > Cleanup what? If you mean this patch -- just point me what
> > should I do.
> 
> I just sent the patch, "turn mm->exe_file into mm->exe_path"
> 

Cool, just got it, thanks!

> > > And with all these checks I am no longer sure that fd is better
> > > than filename ;)
> >
> > This security tests was a reason why I've used open_exec in
> > first version of the patch
> 
> Yes, but me and Pavel forced you to use "int fd" ;)
> 

With plain fd it doesn't require kernel to allocate temp
memory and copy path from user space, this is a positive
effect.

> > (and I still would prefer to
> > have open_exec here instead of fd).
> 
> With the patch I sent "struct file *" is not needed at all.
> I think prctl() can use user_path().

OK!

> 
> > As to allow-write-access -- it should be cleaned once process
> > finished, no?
> 
> Exactly! And who will increment ->i_writecount? Nobody, that is
> the problem.

I see, thanks!

	Cyrill
