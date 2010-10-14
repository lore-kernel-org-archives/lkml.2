Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab0JNTzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:55:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755249Ab0JNTza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:55:30 -0400
Date: Thu, 14 Oct 2010 12:54:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        agruen@suse.de, jengelh@medozas.de, davem@davemloft.net,
        andi@firstfloor.org
Subject: Re: Process to push changes to include/linux/types.h
Message-Id: <20101014125458.9e51ac58.akpm@linux-foundation.org>
In-Reply-To: <1287084892.3367.18.camel@dhcp231-212.rdu.redhat.com>
References: <1287084892.3367.18.camel@dhcp231-212.rdu.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010 15:34:52 -0400
Eric Paris <eparis@redhat.com> wrote:

> A patch was posted a bit ago by agruen which made a change to
> include/linux/types.h changing aligned_u64 to __aligned_u64 and exposing
> this new type to userspace.
> 
> http://marc.info/?l=linux-kernel&m=128316627912457&w=2
> 
> Everyone seemed to agree the patch was a good idea and was correct.  At
> the moment this change only really affects network code, but I would
> very much like to make use of this change in the notification tree.
> Dave Miller did not apply the patch because "Someone has to first add
> the types to linux/types.h, and that doesn't go through my tree."
> 
> http://marc.info/?l=linux-kernel&m=128634544524035&w=2
> 
> I'm a little stuck as to the right path forward.  I normally would have
> had no qualms about adding __aligned_u64 to types.h in the notification
> tree and pushing it to Linus next go-round and then the net tree could
> convert and potentially drop the old aligned_u64 type (but again that
> would be outside the net tree).  Since Dave isn't willing to add the
> type and I don't want to get called too many bad names, I figured I
> should try to find if there is some better way, maintainer, or tree who
> should be adding this new type.
> 
> Who needs to sign off on a new type in types.h?  Who should add it?
> Should I just ram it on in there myself, take any flames that come
> along, and then let net finish their cleanups after I've been charred?
> Any suggestions on the best course of action would be appreciated.
> 

The usual approach here is someone sends it to me and I send it to
Linus ;)

If the change is simple, obviously safe and is needed in two or more
subsystem trees then I'll usually sneak it into mainline late in -rc,
simply to make everyone's life easier.  Of course, you could both agree
to merge the same patch into local trees and I assume that git will
sort it all out.

For this particular patch I'd suggest it be split into two: one adds
the new __aligned_u64 and friends.  The second patch kills off
aligned_u64 and friends.  I'd say the first four-liner would then be
safe for immediate merge and the cleanup patch can go in any old time.



Regarding the patch itself: it uses open-coded
__attribute__((aligned(...))), however we have the __aligned(...)
helpers in compiler.h.

I'm always a bit ambivalent about those helpers (__packed, etc). 
They're not a very kernely thing to do, but the gcc __attribute__
syntax really is a mouthful.

And adding a compiler.h dependency to the shared-with-userspace types.h
may not be practical or safe, dunno.


So if this works, I'd suggest preparing the simple four-liner with the
intention of an immediate merge.

