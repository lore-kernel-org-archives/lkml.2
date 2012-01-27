Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab2A0Sb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:31:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38512 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab2A0Sb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:31:56 -0500
Date: Fri, 27 Jan 2012 19:31:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
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
Message-ID: <20120127183155.GE11715@one.firstfloor.org>
References: <20120127175342.273260614@openvz.org> <20120127175939.795551339@openvz.org> <20120127181525.GD11715@one.firstfloor.org> <20120127182403.GG11086@moon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127182403.GG11086@moon>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 10:24:03PM +0400, Cyrill Gorcunov wrote:
> Sure, I'll try to (btw, where I should send it to? And in which
> format novadays mans are written? In plain old troff or some
> human readable asciidocs?) And... should I post man page
> on LKML as well?

Manpages are written in troff with -man and you would add the ASCII output
of the manpage to the commit log and send the troff source at some
point to linux-man.

> 
> > 
> > As I understand it every time the kernel adds some new kind of state
> > this would need to be extended too? This would seem like a lot of work,
> > especially since you always need to synchronize kernel/user space.
> > How would the user space break if it doesn't know about some newly
> > added state?
> 
> Wait, maybe I should use kernel-doc here and put comments with example
> right on top of SYSCALL definition?

The basic problem is if this interface is at the right level of abstraction.
I have some doubts on that. It seems like a long term maintenance nightmare to 
me.  It may be better to put the loop that would call this into the kernel.

> > > +#ifdef CONFIG_SYSVIPC
> > > +		ret = kcmp_ptr((long)task1->sysvsem.undo_list,
> > > +			       (long)task2->sysvsem.undo_list,
> > > +			       KCMP_SYSVSEM);
> > 
> > I assume that's normally NULL.
> > 
> 
> Hmm.. Andi, I seem not following. And?

It just doesn't seem like a very useful thing to compare.

-Andi
