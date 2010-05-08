Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab0EHG31 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 02:29:27 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52207 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab0EHG3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 02:29:25 -0400
Message-ID: <4BE504AD.4030807@cs.helsinki.fi>
Date: Sat, 08 May 2010 09:29:01 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Nitin Gupta <ngupta@vflare.org>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
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
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Andrew Morton wrote:
> Looking at the changelogs I'm seeing no information about the
> effectiveness of ramzswap - how much memory it saves.  As that's the
> entire point of the driver, that would be a rather important thing to
> have included in the commit comments.  We cannot make the decision to
> merge ramzswap without this info.

There's some benchmarks at ramzswap pages:

http://code.google.com/p/compcache/wiki/Performance

http://code.google.com/p/compcache/wiki/SwapDiskVsRamz

[ snip bunch of comments from Andrew that need to be addressed,
   hopefully we'll get some help from the staging people ]

> The driver appears to be controlled by some nasty-looking ioctl against
> some fd.  None of it is documented anywhere.  It should be.  You're
> proposing here a permanent extension to the kernel ABI which we will
> need to maintain for ever.  That's a big deal and it is the very first
> thing reviewers will look at, before even considering the code.

I thought we got rid of it? Nitin?

> RZSIO_GET_STATS looks to be hopeless from a long-term maintainability
> POV.  It's debug code and it would be better to move it into a debugfs
> file, where we can then add and remove things at will.

Yup.

> I've completely forgotten why we need this xvmalloc thing and I don't
> recall whether we decided it would be a good thing to have as a generic
> facility and of course it's all unexplained and undocumented.  I won't
> be looking at it today, for this reason.

We need it because the slab allocator is not a good fit for this special 
purpose driver due to fragmentation. Nitin, you had a nice web page 
showing all the relevant numbers but I can't find it anymore.

Andrew, FWIW, I'm ok with xvmalloc() for this particular driver. There 
was some discussion on making it more generic but I don't see it as a 
merge-stopper for the driver.

> The overall idea and utility appear to be good and desirable, IMO.  But
> the code isn't productively reviewable in this state.

I agree that the whole graduation step from staging to kernel proper is 
not well-defined. Any suggestions? That said, I hope that doesn't stop 
us from merging this patch series because the lack of notifiers cripples 
the current ramzswap performance.

			Pekka
