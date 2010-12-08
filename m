Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab0LHBxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:53:54 -0500
Received: from bld-mail20.adl6.internode.on.net ([150.101.137.105]:57244 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932124Ab0LHBxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:53:49 -0500
Date: Wed, 8 Dec 2010 12:53:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/46] fs: d_validate fixes
Message-ID: <20101208015344.GE29333@dastard>
References: <cover.1290852958.git.npiggin@kernel.dk>
 <0fff695735c9b652a3f63b8480686c64811e89d0.1290852958.git.npiggin@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fff695735c9b652a3f63b8480686c64811e89d0.1290852958.git.npiggin@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 27, 2010 at 08:44:32PM +1100, Nick Piggin wrote:
> d_validate has been broken for a long time.
> 
> kmem_ptr_validate does not guarantee that a pointer can be dereferenced
> if it can go away at any time. Even rcu_read_lock doesn't help, because
> the pointer might be queued in RCU callbacks but not executed yet.
> 
> So the parent cannot be checked, nor the name hashed. The dentry pointer
> can not be touched until it can be verified under lock. Hashing simply
> cannot be used.
> 
> Instead, verify the parent/child relationship by traversing parent's
> d_child list. It's slow, but only ncpfs and the destaged smbfs care
> about it, at this point.

I'd drop the previous revert patch and just convert the RCU hash
traversal straight to the d_child traversal code you introduce here.
This is a much better explanation of why the d_validate mechanism
needs to be changed, and the revert is really an unnecessary extra
step...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
