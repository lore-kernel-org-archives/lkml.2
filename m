Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab0JGRuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:50:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab0JGRuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:50:22 -0400
Subject: Re: Linux 2.6.36-rc7
From: Eric Paris <eparis@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        agruen@suse.de
In-Reply-To: <20101007190741.2dc62626@lxorguk.ukuu.org.uk>
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com>
	 <201010071710.46938.tvrtko.ursulin@sophos.com>
	 <201010071815.54303.tvrtko.ursulin@sophos.com>
	 <1286472835.2656.15.camel@dhcp231-98.rdu.redhat.com>
	 <20101007190741.2dc62626@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 13:49:28 -0400
Message-ID: <1286473768.2656.21.camel@dhcp231-98.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-07 at 19:07 +0100, Alan Cox wrote:
> > I see two possibilities off the top of my head:
> > 
> > I could just slap an (unused) priority field onto the end of the
> > fanotify_init() syscall (assuming Linus doesn't murder me) so we can
> > build that support out with explicit priorities down the line, which I
> > think might be overkill, or
> > 
> > The other option (without breaking ABI as it stands today) is to define
> > some set of the fanotify_init() flags to be a priority field, we've got
> > 32 bits and only use 2 of them so giving 4-8 bits of that as a priority
> > (next cycle) isn't an issue and can be easily backwards compatible.
> 
> Except you've then got a magic release that works differently to every
> other release afterwards and which sods law says will get shipped by some
> big vendor. Both your proposals are "we got the API wrong,

Correct.

>  lets have one
> kernel that is special", that isn't good in the bigger scheme of things
> and will have if kernel 2.6.blah then crap forced into bits of app/lib
> code forever.

Not sure I understand this logic completely.  I see both of those
options as: we'd have a 2.6.36 kernel which don't have a priority
feature (and would reject apps that try to use it) and that feature
could be built into 2.6.37.  Apps built against 2.6.36 kernels would
still work on 2.6.37 (with a priority of 0 since that's all they could
set in 2.6.36)

> Given two chunks of "oh dear" last minute stuff would it be safer to
> simply punt and just pull the syscall/prototype itself (leaving the rest)
> for the release. That can go into the first pass of the next kernel tree,
> and if it the fixes and priority bits all work out may well then be tiny
> enough for -stable.

The safest thing would probably be to punt the syscalls to 2.6.37.
Which is sad since I know a number of people are already working against
them, but maybe that proves it's the best approach?

-Eric

