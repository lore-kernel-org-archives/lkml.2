Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab1KVWPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:15:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52313 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab1KVWPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:15:31 -0500
Date: Tue, 22 Nov 2011 14:15:14 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
        Will Drewry <wad@chromium.org>, Elly Jones <ellyjones@chromium.org>,
        Milan Broz <mbroz@redhat.com>, Olof Johansson <olofj@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dm: verity target
Message-ID: <20111122221514.GC2096@google.com>
References: <20111110074408.GE10138@secunet.com>
 <1321032884-14621-1-git-send-email-msb@chromium.org>
 <20111114092252.GA11359@secunet.com>
 <20111114175423.GA13132@google.com>
 <20111115091922.GC20943@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115091922.GC20943@secunet.com>
X-Operating-System: Linux/2.6.38.8-gg621 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steffen,

Sorry for the delayed repsonse.

Steffen Klassert (steffen.klassert@secunet.com) wrote:
> Hi.
> 
> On Mon, Nov 14, 2011 at 09:54:23AM -0800, Mandeep Singh Baines wrote:
> > 
> > Hi Steffen,
> > 
> > We use a hash per CPU to avoid allocating and freeing a context per
> > computation. We could allocate the context on the stack as you suggest.
> > However, we were worried about overflowing the stack. The context can be
> > quite large (close to 200 bytes for sha512).
> 
> Indeed, but preallocating on percpu basis can be also quite large on
> bigsmp machines.
> 

Yes, you'll consume NUM_CPUS*sizeof(context) but I'm not sure that its
a lot of memory relative to the total amount of memory you'd see on a
big SMP/NUMA system.

> > 
> > We use a hash per CPU because there can be at most one hash in progress
> > on each CPU at any one time.
> > 
> 
> Ok, this is the case because you use a workqueue and this processes
> at most one work item on each cpu the time.
> 
> On another note, you might want to use ahash here. Most crypto hardware
> accelerators need to use asynchronous ciphers. These can't be used if
> you use the synchronous interface.
> 

We definitely want to look at ahash but I'd like to get the baseline
functionality in and then iterate. Do you think it would be cool
if we deferred looking into ahash until later?

> And at the latest when you switch to ahash, you need more than one
> preallocated ahash request on each cpu, as there can be many ahash
> requests submitted on each cpu :)
> 

Thanks much for all the feedback.

Regards,
Mandeep
