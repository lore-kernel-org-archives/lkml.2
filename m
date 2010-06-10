Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897Ab0FJLwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:52:40 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39665 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758786Ab0FJLwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:52:38 -0400
To: Tejun Heo <tj@kernel.org>
CC: miklos@szeredi.hu, hmajxxlh@corbac.com, fuse-devel@lists.sourceforge.net,
       mszeredi@suse.cz, linux-kernel@vger.kernel.org
In-reply-to: <4C10CB39.70002@kernel.org> (message from Tejun Heo on Thu, 10
	Jun 2010 13:23:37 +0200)
Subject: Re: [fuse-devel] OSS Proxy Jack slave
References: <20100601092456.GA23572@alia.nute.net> <4C066CF4.2050902@gmail.com>	<20100605085045.GA5630@alia.nute.net> <4C0A1369.9010601@kernel.org> <E1OMICc-0005f8-G5@pomaz-ex.szeredi.hu> <4C10CB39.70002@kernel.org>
Message-Id: <E1OMgIz-0005Wb-2a@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 10 Jun 2010 13:52:17 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010, Tejun Heo wrote:
> > First, I think server side mmap might be nice to have but not strictly
> > necessary.  I looked at osspd and it just memcopies in and out of the
> > mmaped ring buffer.  Replacing those memcopies with explicit syscalls
> > to get and put the data should work fine.  I doubt that the latency or
> > CPU overhead introduced by the syscalls would actually matter in
> > practice.
> 
> The latency and CPU overhead perse aren't problematic and for osspd,
> copying in and out should be just fine as all update events are
> clearly denoted.

Good.

> How does the kernel know when to issue store or retrieve?

No, it's userspace that initiates store and retrieve.

> > Next thing is how to deal with multiple buffers for each char device.
> > For the above to continue to work we need to make sure there's a
> > separate nodeid associated with each buffer.  The most general thing
> > would be if MMAP reply contained a nodeid which identified the buffer.
> > 
> > Do you see any issues with the above?
> 
> It relates to the previous question but mmap can also be used without
> all updates being notified by some kind of event where the server is
> expected to watch the mmapped area and react which is okay if server
> can share the mapped page but if it has to poll by copying data out of
> kernel buffer each time, it can get prohibitively expensive unless it
> can ask kernel "what changes since when?" which would be pretty nasty
> to implement.

If necessary we could export page protection and page fault interfaces
to userspace, which would allow it to watch for changes.

But that's not needed for OSSP, right?

Thanks,
Miklos
