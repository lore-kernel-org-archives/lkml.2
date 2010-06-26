Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0FZMzX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 08:55:23 -0400
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:41994 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab0FZMzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 08:55:21 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [rfc] new stat*fs-like syscall?
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20100626093544.GA27715@infradead.org>
References: <20100624131455.GA10441@laptop> <7897.1277531612@jrobl> <20100626093544.GA27715@infradead.org>
Date: Sat, 26 Jun 2010 21:54:44 +0900
Message-ID: <13226.1277556884@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Christoph Hellwig:
> That's really job for a pathconf system call that allows quering random
> paramters.

Do you mean it should be implemented such like this?
vfs_pathconf(struct dentry, int parm)
--> return d_sb->s_op->pathconf(parm)

I am afraid it is overdesign because the actual parameter(for FS) is
_PC_LINK_MAX only. All other params are already handled by VFS, glibc or
sb->statfs.


J. R. Okajima

(pathconf(3) parameters from the manual)
       _PC_LINK_MAX
              returns  the  maximum number of links to the file.  If fd or path refer to a direc-
              tory, then the value applies to the whole directory.  The  corresponding  macro  is
              _POSIX_LINK_MAX.

       _PC_MAX_CANON
              returns  the  maximum length of a formatted input line, where fd or path must refer
              to a terminal.  The corresponding macro is _POSIX_MAX_CANON.

       _PC_MAX_INPUT
              returns the maximum length of an input line, where fd or path must refer to a  ter-
              minal.  The corresponding macro is _POSIX_MAX_INPUT.

       _PC_NAME_MAX
              returns  the maximum length of a filename in the directory path or fd that the pro-
              cess is allowed to create.  The corresponding macro is _POSIX_NAME_MAX.

       _PC_PATH_MAX
              returns the maximum length of a relative pathname when path or fd  is  the  current
              working directory.  The corresponding macro is _POSIX_PATH_MAX.

       _PC_PIPE_BUF
              returns the size of the pipe buffer, where fd must refer to a pipe or FIFO and path
              must refer to a FIFO.  The corresponding macro is _POSIX_PIPE_BUF.

       _PC_CHOWN_RESTRICTED
              returns non-zero if the chown(2) call may not be used on this file.  If fd or  path
              refer to a directory, then this applies to all files in that directory.  The corre-
              sponding macro is _POSIX_CHOWN_RESTRICTED.

       _PC_NO_TRUNC
              returns non-zero if accessing filenames longer than  _POSIX_NAME_MAX  generates  an
              error.  The corresponding macro is _POSIX_NO_TRUNC.

       _PC_VDISABLE
              returns  non-zero if special character processing can be disabled, where fd or path
              must refer to a terminal.
