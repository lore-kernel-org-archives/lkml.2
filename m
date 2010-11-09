Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab0KIQDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:03:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792Ab0KIQDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:03:45 -0500
MIME-Version: 1.0
In-Reply-To: <20101109124610.GB11477@amd>
References: <20101109124610.GB11477@amd>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Nov 2010 08:02:38 -0800
Message-ID: <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
Subject: Re: [patch 1/6] fs: icache RCU free inodes
To: Nick Piggin <npiggin@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 4:46 AM, Nick Piggin <npiggin@kernel.dk> wrote:
> So here is the inode RCU code. It's obviously not worth doing until the
> actual rcu-walk path walking is in, but I'd like to get opinions on it.
> It would be nice to merge it in Al's tree at some point, though.

Remind me why it wasn't sufficient to just use SLAB_DESTROY_BY_RCU?

Especially if we still lock things for the actual (few) inode list
operations, the added complexity of actually freeing _individual_
inodes by RCU seems to be a bad thing.

The only thing we care about is the pathname walk - there are no other
inode operations that are common enough to worry about. And the only
thing _that_ needs is the ability to look at the inode under RCU, and
SLAB_DESTROY_BY_RCU should be entirely sufficient for that.

But we had some discussion about this long ago, and I may have
forgotten some of the context.

                             Linus
