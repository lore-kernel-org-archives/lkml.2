Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab0JUNXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:23:20 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:50996 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758035Ab0JUNWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:22:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoAGAGfav0x5LdoFgWdsb2JhbACUZ4xxFgEBFiIiwC+FSgSKTYUB
Message-Id: <20101021130829.442910807@kernel.dk>
User-Agent: quilt/0.48-1
Date: Fri, 22 Oct 2010 00:08:29 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk
Subject: [patch 00/14] reworked minimal inode_lock breaking series
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am still very much against the locking design of Dave's patchset, but
especially the way it is broken out. I could fathom accepting some of the
i_lock width reduction if they are properly broken out and justified and
documented why they are safe. But lumping this huge series of stuff before
inode_lock is even lifted is not the right way to go about it.

I still maintain that i_lock for icache state lock is the way to go at least
until we get quite a way down the track. I think a lot of people can't see it
maybe because my patchset wasn't broken out terribly well.

So I am posting here just the initial lock breaking part, reworked. In
particular, i_lock coverage is established before adding broken out data
structure locks, but it also cleans things up and attempts not to move stuff
around that isn't strictly required.

I still wait until everything is covered before touching inode_lock, but I have
explained how it is actually possible to start removing some of inode_lock even
before then, which I think is a good demonstration of the power of having full
i_lock coverage.

The steps here should be relatively easy to follow and verify (I hope), and
they lead quite easily to the actual scalability improvement steps. So please
don't get sidetracked on the temporary trylock ugliness!

Thanks,
Nick


