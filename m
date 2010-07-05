Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0GEIKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:10:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35054 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab0GEIKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:10:22 -0400
Date: Mon, 5 Jul 2010 09:10:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeff Layton <jlayton@redhat.com>
Subject: Re: linux-next: build warning after merge of the vfs tree
Message-ID: <20100705081019.GQ31073@ZenIV.linux.org.uk>
References: <20100705100121.d089bf12.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100705100121.d089bf12.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 10:01:21AM +1000, Stephen Rothwell wrote:
> Hi Al,
> 
> After merging the vfs tree, today's linux-next build (powerpc
> ppc64_defconfig) produced these warnings:
> 
> fs/cifs/cifsfs.c: In function 'cifs_drop_inode':
> fs/cifs/cifsfs.c:481: warning: 'return' with a value, in function returning void
> fs/cifs/cifsfs.c:483: warning: 'return' with a value, in function returning void
> fs/cifs/cifsfs.c: At top level:
> fs/cifs/cifsfs.c:491: warning: initialization from incompatible pointer type
> 
> Introduced by commit 12420ac341533f3715b3deb788637568f22b78ff ("cifs:
> implement drop_inode superblock op") (which entered Linus' tree on June
> 28) interacting with commit 1fd3b83deb5125288bee98f32a41c3267b8ed534
> ("Make ->drop_inode() just return whether inode needs to be dropped")
> from the vfs tree.  I guess the cifs tree was missed bye the vfs tree
> update.

Fixed.  Incidentally, could somebody explain WTF do we put the inodes into
icache in case !serverino?
