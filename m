Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab1CJL7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 06:59:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43096 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab1CJL66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 06:58:58 -0500
Date: Thu, 10 Mar 2011 11:58:56 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: sedat.dilek@gmail.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] more vfs fixes for final
Message-ID: <20110310115856.GG22723@ZenIV.linux.org.uk>
References: <20110310110931.GF22723@ZenIV.linux.org.uk>
 <AANLkTi=gv+iT6Lc_ADoBu9_P78ivhmOwLh-+Oki7WmD1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=gv+iT6Lc_ADoBu9_P78ivhmOwLh-+Oki7WmD1@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 12:44:37PM +0100, Sedat Dilek wrote:
> On Thu, Mar 10, 2011 at 12:09 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > ?? ?? ?? ??Fix for misplaced include in sysctl.h, fixes for ->d_revalidate()
> > (a bunch of filesystems are unusable with nfsd at the moment; the real fix
> > is to make ->d_revalidate() take flags directly and forget about dereferencing
> > nameidata in most of the instances, but that's obviously for the next window
> > and oopsen really need to be fixed for -final), missing checks in fallocate()
> > and Bruce's patch for inode (temporary) leaks with nfsd. ??Please, pull from
> >
> > git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus
> >
> 
> Did you really push the new commits?
> 
> Last commit here is commit b306419ae08d9def53f2142a37cc0a58622307a8:
> "nd->inode is not set on the second attempt in path_walk()"

Looks like propagation from hera to git.kernel.org is slow tonight...

GIT_DIR=/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ git log for-linus|head -5
commit d891eedbc3b1b0fade8a9ce60cc0eba1cccb59e5
Author: J. Bruce Fields <bfields@fieldses.org>
Date:   Tue Jan 18 15:45:09 2011 -0500

    fs/dcache: allow d_obtain_alias() to return unhashed dentries
