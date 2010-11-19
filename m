Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750933Ab0KSFBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 00:01:13 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:14653 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724Ab0KSFBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 00:01:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJWQ5Ux5LdBa/2dsb2JhbACiVnK9JYVLBI9q
Date: Fri, 19 Nov 2010 16:01:08 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: David Miller <davem@davemloft.net>
Cc: npiggin@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 01/28] fs: d_validate fixes
Message-ID: <20101119050108.GB3284@amd>
References: <20101116140900.039761100@kernel.dk>
 <20101116142028.254946611@kernel.dk>
 <20101118.125123.241932424.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118.125123.241932424.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 12:51:23PM -0800, David Miller wrote:
> From: Nick Piggin <npiggin@kernel.dk>
> Date: Wed, 17 Nov 2010 01:09:01 +1100
> 
> > d_validate has been broken for a long time.
> > 
> > kmem_ptr_validate does not guarantee that a pointer can be dereferenced
> > if it can go away at any time. Even rcu_read_lock doesn't help, because
> > the pointer might be queued in RCU callbacks but not executed yet.
> > 
> > So the parent cannot be checked, nor the name hashed. The dentry pointer
> > can not be touched until it can be verified under lock. Hashing simply
> > cannot be used.
> > 
> > Instead, verify the parent/child relationship by traversing parent's
> > d_child list. It's slow, but only ncpfs and the destaged smbfs care
> > about it, at this point.
> > 
> > Signed-off-by: Nick Piggin <npiggin@kernel.dk>
> 
> This won't apply because is conflicts with Christoph Hellwig's
> RCU conversion of d_validate().
> 
> Which is a change that went in more than a month ago.

Sorry yeah I had a local revert that I didn't send out, otherwise
it should be a vanilla upstream kernel.

 
> Thus I'd really appreciate if you mentioned what tree your patches are
> against in your "0/N" posting, always.

Try to remember. I'll put some time into polishing up a git tree
and submitting the more interesting patches as well, this weekend.

Thanks,
Nick
