Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab1IBRvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:51:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab1IBRvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:51:21 -0400
Date: Fri, 2 Sep 2011 19:48:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Earl Chew <echew@ixiacom.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: Re: [PATCH 1/1 v2]: coredump: use current->group_leader->comm
	instead of current->comm
Message-ID: <20110902174806.GA9238@redhat.com>
References: <4E5FBA73.2050108@ixiacom.com> <20110901195554.667c5e58@lxorguk.ukuu.org.uk> <4E5FD937.7050307@ixiacom.com> <20110902163037.GA4808@redhat.com> <4E610DAE.4080607@ixiacom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E610DAE.4080607@ixiacom.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02, Earl Chew wrote:
>
> Oleg,
>
> >> The patterns %n or %N are the same as %e and %E except that they
> >> use current->group_leader->comm instead of current->comm.
> >
> > I simply do not know what is better. Alan has a point imho, "might
> > break stuff" is true.
> >
> > OTOH, %p always reports tgid, not tid...
>
> Which speaks partly to my notion of "consistency".

That is why I mentioned it with "otoh" ;)

> I viewed my original change as more "consistent" because it
> yielded the attribute alluded to in the documentation --- the
> same value for all threads in the one process:
>
> 	- Consistent with the documentation
> 	- Consistent with respect to process name (as opposed to thread name)
>
> >> A core dump can be triggered from any task in a group,
> >
> > Indeed. The important case is the private/synchronous signals like
> > SIGSEGV, you can see the name of the thread which triggered the crash.
>
> While that is true, it doesn't seem to have been the original intent as
> per the %e documentation.

May be. May be not. I do not know.

> Should get_mm_exe_file() just use current->group_leader->comm since it's
> meant to be process specific anyway,

Probably. Although group_leader->comm is thread specific too, but
at least we do not use the "random" thread. My only point was, imho
this doesn't deserve another option.

> and there isn't an existing code base
> for %E ?

Who knows? But once again, we use ->comm in the very unlikely case.



And let me repeat just in case. I do not argue, I agree either way.

Oleg.

