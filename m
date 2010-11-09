Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab0KIOTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 09:19:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55776 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab0KIOTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 09:19:04 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/6] fs: icache RCU free inodes
References: <20101109124610.GB11477@amd>
Date: Tue, 09 Nov 2010 15:19:02 +0100
In-Reply-To: <20101109124610.GB11477@amd> (Nick Piggin's message of "Tue, 9
	Nov 2010 23:46:10 +1100")
Message-ID: <87lj52pokp.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@kernel.dk> writes:

> So here is the inode RCU code. It's obviously not worth doing until the
> actual rcu-walk path walking is in, but I'd like to get opinions on it.
> It would be nice to merge it in Al's tree at some point, though.

I read the patch. It was quite monotonous (I guess that's a good thing)
But it wasn't clear to me why you added the INIT_LIST_HEAD()s
everywhere. Is this for stopping parallel walkers?

Ok there's a comment in the doc: "VFS expects it to be initialized"
Is that really true today?  I don't think the old code does that.

Other than that it seems straight forward.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
