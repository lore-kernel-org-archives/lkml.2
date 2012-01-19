Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab2ASGzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 01:55:50 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42748 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2ASGzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 01:55:47 -0500
Date: Thu, 19 Jan 2012 10:55:41 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: david@lang.hm, "H. Peter Anvin" <hpa@zytor.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] syscalls, x86: Add __NR_kcmp syscall
Message-ID: <20120119065541.GA31379@moon>
References: <20120117142759.GE16213@moon>
 <CACVxJT8TJXopJ5-_0j=6CsWXJL8wMOFCerfvmhWa7wcYnejFEg@mail.gmail.com>
 <20120117144452.GG16213@moon>
 <4F15C249.3000602@zytor.com>
 <m1obu29fnf.fsf@fess.ebiederm.org>
 <alpine.DEB.2.02.1201181404480.6780@asgard.lang.hm>
 <20120118224956.GF15652@moon>
 <m1zkdk4mj5.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zkdk4mj5.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 03:29:50PM -0800, Eric W. Biederman wrote:
> >
> > It doesn't matter. Even if we take a list of objects the kernel either
> > should return us some ordering info or find duplicates, in any case it
> > makes things more complex i think. So we wanted to bring some minimum
> > into kernel leaving the rest of work to user-space.
> 
> Agreed a syscall does the duplication is probably not the way to go.
> 
>  A syscall that takes a huge list of objects would solve any security
> concerns that we have with returning the object order to user space if
> done carefully, but it would require a bunch of additional user space
> and kernel memory.
> 

yes, an it increase syscall time itself since we will have to provide
this memory dynamically

> Sometimes taking a data structure transforming it into a weird form for
> a specific task and then transforming the data structure back to it's
> original form is a useful way to go.  So I think a general kernel object
> deduplicating system call is an interesting plan B, but a straight
> comparison function if we can make it work is a lot more flexible and
> useful.
> 

I hope the root-only restriction would resolve the potential security
problem, since as I mentioned if I've hijacked the machine and already
goot root -- mem order is not that interesting info I could obtain from
such computer :)

	Cyrill
