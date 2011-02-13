Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab1BMCGL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 21:06:11 -0500
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:64053 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1BMCGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 21:06:04 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH] fix filp_cachep memory corruption
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        viro@zeniv.linux.org.uk
In-Reply-To: <20110210145753.9bec879f.akpm@linux-foundation.org>
References: <12967.1296674338@jrobl> <20110210145753.9bec879f.akpm@linux-foundation.org>
Date: Sun, 13 Feb 2011 11:05:54 +0900
Message-ID: <7033.1297562754@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew Morton:
> Anyway, as Nick appears to have done a dump-and-run on the kernel
> project, I shall send your fix into Linus as-is.  Perhaps you or Nick
> could look into cleaning things up later on?

Before I say "I agree and will clean up", Linus did it and the refined
patch is already merged.
Reading his patch, I am afraid there exists a possibitily of a problem.
In creating a file (and in rcu-walk mode), if ->open returns ESTALE,
then the problem may happen in the next ref-walk mode because
intent.open.file is reset to NULL. But I don't know whether such ->open
exists currently or not.


J. R. Okajima
