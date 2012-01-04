Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab2ADCu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 21:50:28 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:18347 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477Ab2ADCuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 21:50:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiEFAPm9A095LLu4/2dsb2JhbABDggWqXIEGgXIBAQQBJxMcIwULCAMYLhQlAyETh3q1YROLfASVAZJJ
Date: Wed, 4 Jan 2012 13:50:20 +1100
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the vfs tree
Message-ID: <20120104025020.GW23662@dastard>
References: <20120103124331.f0f0043f8ca464c9ff13f4d3@canb.auug.org.au>
 <20120103133942.GC31457@quack.suse.cz>
 <20120103144531.GA23916@ZenIV.linux.org.uk>
 <20120104021754.GD23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104021754.GD23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 02:17:54AM +0000, Al Viro wrote:
> I'm still not
> sure about ->statfs(), BTW - any input on that would be welcome.  Can
> it end up blocked on a frozen fs until said fs is thawed?

I don't see why this should ever happen - ->statfs has to work on
read-only filesystems so shoul dnot be modifying state, and hence
should never need to care about the frozen state of the superblock.
So from a ->statfs POV, a frozen filesystem should look just like a
read-only filesystem. If frozen filesystems are holding locks that
->statfs can block on until the filesystem us thawed, then I'd
consider that a bug in the filesystem freeze implementation....

> to convert ustat(2) to "wait for thaw" semantics (should be interruptible,
> BTW) or document that ->statfs() is not allowed to wait for thawing.
> It's far too subtle to leave undocumented...

The latter, IMO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
