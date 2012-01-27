Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab2A0SYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:24:12 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42469 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab2A0SYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:24:09 -0500
Date: Fri, 27 Jan 2012 22:24:03 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC c/r 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
Message-ID: <20120127182403.GG11086@moon>
References: <20120127175342.273260614@openvz.org>
 <20120127175939.795551339@openvz.org>
 <20120127181525.GD11715@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127181525.GD11715@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 07:15:25PM +0100, Andi Kleen wrote:
> > It takes up to 5 agruments - the pids of the two tasks (which
> > characteristics should be compared), the comparision type and
> > (in case of comparision of files) two file descriptors.
> 
> Can you please write a manpage for it? That's really required
> to evaluate the interface properly.

Sure, I'll try to (btw, where I should send it to? And in which
format novadays mans are written? In plain old troff or some
human readable asciidocs?) And... should I post man page
on LKML as well?

> 
> As I understand it every time the kernel adds some new kind of state
> this would need to be extended too? This would seem like a lot of work,
> especially since you always need to synchronize kernel/user space.
> How would the user space break if it doesn't know about some newly
> added state?

Wait, maybe I should use kernel-doc here and put comments with example
right on top of SYSCALL definition?

> 
> Maybe it would be better to put more of the relevant code into the
> kernel to encapsulate this better.
> 
> 
> > +	case KCMP_SYSVSEM:
> > +#ifdef CONFIG_SYSVIPC
> > +		ret = kcmp_ptr((long)task1->sysvsem.undo_list,
> > +			       (long)task2->sysvsem.undo_list,
> > +			       KCMP_SYSVSEM);
> 
> I assume that's normally NULL.
> 

Hmm.. Andi, I seem not following. And?

> > +#ifdef CONFIG_X86_64
> > +static long syscall5(int nr, unsigned long arg0, unsigned long arg1,
> > +		unsigned long arg2, unsigned long arg3,
> > +		unsigned long arg4)
> 
> Why not just use syscall() in glibc?
> 

Never heard of it. I'll take a look, thanks. But I suppose all this
comments might be addressed in patch on top?

	Cyrill
