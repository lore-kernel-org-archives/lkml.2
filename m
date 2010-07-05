Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab0GEXc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 19:32:26 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:40627 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988Ab0GEXcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 19:32:24 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [rfc] new stat*fs-like syscall?
To: Brad Boyer <flar@allandria.com>
Cc: Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20100705205806.GA12517@cynthia.pants.nu>
References: <20100624131455.GA10441@laptop> <7897.1277531612@jrobl> <20100626093544.GA27715@infradead.org> <13226.1277556884@jrobl> <20100705205806.GA12517@cynthia.pants.nu>
Date: Tue, 06 Jul 2010 08:31:30 +0900
Message-ID: <6419.1278372690@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Brad Boyer:
> I would suggest making it an inode operation if we do actually add it. Most
> cases are going to be per super-block, but it might be easier to transparently
> handle things like _PC_PIPE_BUF in glibc if it could call an fpathconf type
> system call on the pipe fd. I haven't looked at the current glibc code for
> that particular selector. The only one I looked at in any detail was
> _PC_LINK_MAX, which is the one you already discussed and is obviously a
> per-sb option. The only drawback I can see is that making it an inode
> operation would make the vfs_pathconf fail on a negative dentry, but that
> seems like a very strange thing to support in any case.

Recently the size of the pipe buffer becomes customizable, doesn't it?
For _PC_PIPE_BUF, fpathconf should issue fcntl(F_GETPIPE_SZ).

For negative dentry, it should be supported as long as some
standard/specification doesn't prohibit explicitly. So I still think
statfs is the best place to implement _PC_LINK_MAX.


J. R. Okajima
