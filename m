Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab0KIVg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:36:26 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:16719 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753850Ab0KIVgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:36:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMtN2Ux5LcZK/2dsb2JhbACiJ3K+AoVKBA
Date: Wed, 10 Nov 2010 08:36:19 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101109213619.GA3246@amd>
References: <20101109124610.GB11477@amd>
 <87lj52pokp.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lj52pokp.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 03:19:02PM +0100, Andi Kleen wrote:
> Nick Piggin <npiggin@kernel.dk> writes:
> 
> > So here is the inode RCU code. It's obviously not worth doing until the
> > actual rcu-walk path walking is in, but I'd like to get opinions on it.
> > It would be nice to merge it in Al's tree at some point, though.
> 
> I read the patch. It was quite monotonous (I guess that's a good thing)
> But it wasn't clear to me why you added the INIT_LIST_HEAD()s
> everywhere. Is this for stopping parallel walkers?
> 
> Ok there's a comment in the doc: "VFS expects it to be initialized"
> Is that really true today?  I don't think the old code does that.

It is in the inode_init_once pile, so yes it has to be returned
to the allocator initialized.

> 
> Other than that it seems straight forward.
> 
> Reviewed-by: Andi Kleen <ak@linux.intel.com>

Thanks,
Nick
