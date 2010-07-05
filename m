Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab0GEVlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 17:41:36 -0400
Received: from cynthia.allandria.com ([76.245.85.235]:52912 "EHLO
	cynthia.pants.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab0GEVlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 17:41:35 -0400
X-Greylist: delayed 2592 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jul 2010 17:41:35 EDT
Date: Mon, 5 Jul 2010 13:58:06 -0700
From: Brad Boyer <flar@allandria.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] new stat*fs-like syscall?
Message-ID: <20100705205806.GA12517@cynthia.pants.nu>
References: <20100624131455.GA10441@laptop> <7897.1277531612@jrobl> <20100626093544.GA27715@infradead.org> <13226.1277556884@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13226.1277556884@jrobl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 26, 2010 at 09:54:44PM +0900, J. R. Okajima wrote:
> Christoph Hellwig:
> > That's really job for a pathconf system call that allows quering random
> > paramters.
> 
> Do you mean it should be implemented such like this?
> vfs_pathconf(struct dentry, int parm)
> --> return d_sb->s_op->pathconf(parm)

I would suggest making it an inode operation if we do actually add it. Most
cases are going to be per super-block, but it might be easier to transparently
handle things like _PC_PIPE_BUF in glibc if it could call an fpathconf type
system call on the pipe fd. I haven't looked at the current glibc code for
that particular selector. The only one I looked at in any detail was
_PC_LINK_MAX, which is the one you already discussed and is obviously a
per-sb option. The only drawback I can see is that making it an inode
operation would make the vfs_pathconf fail on a negative dentry, but that
seems like a very strange thing to support in any case.

> I am afraid it is overdesign because the actual parameter(for FS) is
> _PC_LINK_MAX only. All other params are already handled by VFS, glibc or
> sb->statfs.

	Brad Boyer
	flar@allandria.com

