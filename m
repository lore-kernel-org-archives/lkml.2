Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab2HSOxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 10:53:55 -0400
Received: from mail.nonattached.net ([193.160.39.60]:55322 "EHLO
	mail.nonattached.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab2HSOxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 10:53:52 -0400
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
From: Dan Luedtke <mail@danrl.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120819142732.GB23464@ZenIV.linux.org.uk>
References: <1345333117-2826-1-git-send-email-mail@danrl.de>
	 <CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com>
	 <1345371135.4441.2.camel@tunafish> <5030BC7E.3030000@gmail.com>
	 <1345383264.4441.56.camel@tunafish>
	 <20120819120254.GA2369@pompeji.miese-zwerge.org>
	 <1345390432.2716.34.camel@tunafish>
	 <20120819142732.GB23464@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Aug 2012 18:53:37 +0200
Message-ID: <1345395217.2716.58.camel@tunafish>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-08-19 at 15:27 +0100, Al Viro wrote:
> 	* unlimited recursion
I am already working on that one, but it's tricky.

> 	* unlink() does *not* truncate the file contents;
I did not know that.

> 	* while we are at it, neither of those should free the on-disk
> inode; again, that should happen only when the inode is evicted.
Makes sense now. Thanks!

> 	* I might be missing something, but copying a bunch of files
> with something like cp /foo/* /mnt seems to be guaranteed to create
> really lousy binary tree in target directory (they will go in lexicographical
> order and you don't seem to rebalance the tree at all)
You missed nothing, there is no rebalancing yet. Thats why performance
is bad at the moment as soon as the "tree" stops being a tree.

> 	* you are really abusing iget() there.
Noted. Thanks!

> 	* minor point, but endianness-flipping in place is *the* way to get
> hard-to-catch endianness bugs.  foo = cpu_to_le64(foo) is a bloody bad idea;
> either use object for host-endian all along, or use it only for (in your
> case) little-endian.
I am not sure I understood this right.
At what point should I convert e.g. the file size (little endian 64bit
value stored on disk) to host endianess? When filling the inode?
Is inode->i_size = le64_to_cpu(size) bad, too?

Thank you very much for your comments! That'll keep me busy a few weeks.

regards,
Dan


PS: As Jochen Striepe pointed out, lanyfs@librelist.com behaves badly, I
removed it.
-- 
Dan Luedtke
http://www.danrl.de

