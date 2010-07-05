Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320Ab0GEMNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 08:13:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758287Ab0GEMNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 08:13:30 -0400
Date: Mon, 5 Jul 2010 08:15:42 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the vfs tree
Message-ID: <20100705081542.41f6bdc8@corrin.poochiereds.net>
In-Reply-To: <20100705081019.GQ31073@ZenIV.linux.org.uk>
References: <20100705100121.d089bf12.sfr@canb.auug.org.au>
	<20100705081019.GQ31073@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jul 2010 09:10:19 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Mon, Jul 05, 2010 at 10:01:21AM +1000, Stephen Rothwell wrote:
> > Hi Al,
> > 
> > After merging the vfs tree, today's linux-next build (powerpc
> > ppc64_defconfig) produced these warnings:
> > 
> > fs/cifs/cifsfs.c: In function 'cifs_drop_inode':
> > fs/cifs/cifsfs.c:481: warning: 'return' with a value, in function returning void
> > fs/cifs/cifsfs.c:483: warning: 'return' with a value, in function returning void
> > fs/cifs/cifsfs.c: At top level:
> > fs/cifs/cifsfs.c:491: warning: initialization from incompatible pointer type
> > 
> > Introduced by commit 12420ac341533f3715b3deb788637568f22b78ff ("cifs:
> > implement drop_inode superblock op") (which entered Linus' tree on June
> > 28) interacting with commit 1fd3b83deb5125288bee98f32a41c3267b8ed534
> > ("Make ->drop_inode() just return whether inode needs to be dropped")
> > from the vfs tree.  I guess the cifs tree was missed bye the vfs tree
> > update.
> 
> Fixed.  Incidentally, could somebody explain WTF do we put the inodes into
> icache in case !serverino?

Thanks, Al.

We use iunique to generate inode numbers in that case, and I believe
that requires hashed inodes to ensure uniqueness.

-- 
Jeff Layton <jlayton@redhat.com>
