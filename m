Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750938Ab0EHEIf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 00:08:35 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61390 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab0EHEId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 00:08:33 -0400
Message-ID: <4BE4E2F5.4090001@vflare.org>
Date: Sat, 08 May 2010 09:35:09 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       Minchan Kim <minchan.kim@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ramzswap: Eliminate stale data from compressed memory
 (v2)
References: <1273217107-2023-1-git-send-email-ngupta@vflare.org> <20100507155504.10532b3e.akpm@linux-foundation.org>
In-Reply-To: <20100507155504.10532b3e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 8, 2010 at 1:25 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri,  7 May 2010 12:55:04 +0530
> Nitin Gupta <ngupta@vflare.org> wrote:

<snip>
>
> <hasty review>
>
> Looking at the changelogs I'm seeing no information about the
> effectiveness of ramzswap - how much memory it saves.  As that's the
> entire point of the driver, that would be a rather important thing to
> have included in the commit comments.  We cannot make the decision to
> merge ramzswap without this info.
>

Documentation (drivers/staging/ramzswap/ramzswap.txt) points to the project
home page which has lots of performance numbers -- both positive and
negative cases.

Lot of your points are regarding lack of documentation and code comments.
Instead of replying to all such points individually, let me first send
patches with all the code commentary.


> The driver appears to be controlled by some nasty-looking ioctl against
> some fd.  None of it is documented anywhere.  It should be.  You're
> proposing here a permanent extension to the kernel ABI which we will
> need to maintain for ever.  That's a big deal and it is the very first
> thing reviewers will look at, before even considering the code.
>

ramzswap.txt points to 'rzscontrol' manpage where the effect of each of
these ioctls is documented:
http://compcache.googlecode.com/hg/sub-projects/rzscontrol/man/rzscontrol.html
I will add appropriate comments in code too.


> The compat implications of the ioctl args will need to be examined.
>

Ok, I will look into this.


> RZSIO_GET_STATS looks to be hopeless from a long-term maintainability
> POV.  It's debug code and it would be better to move it into a debugfs
> file, where we can then add and remove things at will.
>

RZSIO_GET_STATS is how we send stats to userspace. Its not some debug code.


> The driver appears to create a /dev node called "ramzswap".  If so, I
> should be able to run mke2fs on it and cheerily use it as a regular
> filesystem, should I not?  If so then the entire driver is not
> swap-specific at all and there should be no mention of "swap" anywhere!
> ramzblock would be more appropriate.
>

You cannot use /dev/ramzswap{0,1,2...} devices for anything other than
swap devices since they can only handle page-aligned I/O requests.
This restriction highly simplifies the code as handling compression/
decompression for sub-page requests is hard and wasteful.

If someone needs a generic in-memory compressed block device, they
are welcome to extend ramzswap (or create a new driver).

>
> I've completely forgotten why we need this xvmalloc thing and I don't
> recall whether we decided it would be a good thing to have as a generic
> facility and of course it's all unexplained and undocumented.  I won't
> be looking at it today, for this reason.
>

Justification for xvmalloc is present in initial commit message (644bf7)


>
> I'll give up there.
>
> The overall idea and utility appear to be good and desirable, IMO.  But
> the code isn't productively reviewable in this state.
>

I will soon send patches for adding all these code comments. I hope that
will make code more reviewable.


In the meantime, would it be possible to commit these swap free notify
patches?


Thanks for your detailed comments.
Nitin

