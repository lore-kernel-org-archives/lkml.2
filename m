Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab2ARWuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 17:50:04 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41716 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab2ARWuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 17:50:02 -0500
Date: Thu, 19 Jan 2012 02:49:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: david@lang.hm
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
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
Message-ID: <20120118224956.GF15652@moon>
References: <20120117142759.GE16213@moon>
 <CACVxJT8TJXopJ5-_0j=6CsWXJL8wMOFCerfvmhWa7wcYnejFEg@mail.gmail.com>
 <20120117144452.GG16213@moon>
 <4F15C249.3000602@zytor.com>
 <m1obu29fnf.fsf@fess.ebiederm.org>
 <alpine.DEB.2.02.1201181404480.6780@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1201181404480.6780@asgard.lang.hm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 02:05:31PM -0800, david@lang.hm wrote:
...
> >>
> >>Why on Earth would user space need to know which order in memory certain
> >>kernel objects are?
> >
> >For checkpoint restart and for some other kinds of introspection what is
> >needed is a comparison function to see if two processes share the same
> >object.  The most interesting of these objects from a checkpoint restart case
> >are file descriptors, and there can be a lot of file descriptors.
> >
> >The order in memory does not matter.  What does matter is that the
> >comparison function return some ordering between objects.  The algorithm
> >for figuring out of N items which of them are duplicates is O(N^2) if
> >the comparison function can only return equal or not equal.  The
> >algorithm for finding duplications is only O(NlogN) if the comparison
> >function will return an ordering among the objects.
> 
> so what you really want is a syscall that can take a list of objects
> instead of having to do a syscall per object. right?
> 

It doesn't matter. Even if we take a list of objects the kernel either
should return us some ordering info or find duplicates, in any case it
makes things more complex i think. So we wanted to bring some minimum
into kernel leaving the rest of work to user-space.

(and, btw, Eric, I'm really sorry that I didn't mentioned this sorting
 problem at the very first email).

	Cyrill
