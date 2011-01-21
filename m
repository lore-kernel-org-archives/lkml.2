Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab1AUR1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:27:21 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56374 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1AUR1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:27:19 -0500
Date: Fri, 21 Jan 2011 17:26:58 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stuart Swales <stuart.swales.croftnuisk@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adfs: add hexadecimal filetype suffix option
Message-ID: <20110121172658.GA17911@flint.arm.linux.org.uk>
References: <4D2DEDDB.1070605@gmail.com> <20110119154915.a0bb2878.akpm@linux-foundation.org> <alpine.DEB.2.00.1101211431490.3490@dc5850.croftnuisk.local> <201101211747.17544.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101211747.17544.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 05:47:17PM +0100, Arnd Bergmann wrote:
> On Friday 21 January 2011 15:34:12 Stuart Swales wrote:
> > 
> > [PATCH] adfs: add hexadecimal filetype suffix option
> > 
> > ADFS (FileCore) storage complies with the RISC OS filetype specification
> > (12 bits of file type information is stored in the file load address, rather
> > than using a file extension).  The existing driver largely ignores this
> > information and does not present it to the end user.
> > 
> > It is desirable that stored filetypes be made visible to the end user to
> > facilitate a precise copy of data and metadata from a hard disc (or image
> > thereof) into a RISC OS emulator (such as RPCEmu) or to a network share which
> > can be accessed by real Acorn systems.
> > 
> > This patch implements a per-mount filetype suffix option (use -o ftsuffix=1)
> > to present any filetype as a ,xyz hexadecimal suffix on each file.  This type
> > suffix is compatible with that used by RISC OS systems that access network
> > servers using NFS client software and by RPCemu's host filing system.
> > 
> > Signed-off-by: Stuart Swales <stuart.swales.croftnuisk@gmail.com>
> 
> The patch looks fine to me, but it tells me that you have some knowledge
> and interest in this file system. Adfs is currently one of only a handful
> of modules in the kernel that still uses the big kernel lock, because
> nobody so far had enough motivation to fix this.
> 
> Would you be able to take a look at this? The straightforward approach
> would be to add a mutex to adfs_sb_info and use that in place of
> lock_kernel. It's mostly a matter of testing to make sure that no
> deadlocks get introduced in the process.

Note that write support is very limited.  From memory, the only writing it
supports is changing directory entries and writing data into existing files
(but not extending or truncating them.)

The only thing that's supported is updating of existing directory entries,
for which it has a read/write lock to protect against multiple callers.
I think I assumed at the time that I wouldn't rely on the BKL, so it
should be safe to kill it.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
