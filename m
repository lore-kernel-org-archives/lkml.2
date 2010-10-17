Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab0JQUTD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 16:19:03 -0400
Received: from verein.lst.de ([213.95.11.210]:35249 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932694Ab0JQUSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 16:18:51 -0400
Date: Sun, 17 Oct 2010 22:18:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Toralf F?rster <toralf.foerster@gmx.de>
Cc: user-mode-linux-devel@lists.sourceforge.net,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Fwd: Re: UML kernel crash of v2.6.36-rcX kernel
Message-ID: <20101017201837.GA16458@lst.de>
References: <201010131328.06465.toralf.foerster@gmx.de> <201010151133.38170.toralf.foerster@gmx.de> <201010171555.40453.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010171555.40453.toralf.foerster@gmx.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 03:55:39PM +0200, Toralf F?rster wrote:
> I bisected it again w/ a fixed test script, got the same bad commit script and
> double checked, that this commit is really the culprit which crashes a user
> mode linux kernel at my 32bix x86 stable Gentoo running 2.6.35.6 vanilla kernel
> as host system and 2/ gcc version 4.4.3 (Gentoo 4.4.3-r2 p1.2) and
> glibc-2.11.2-r1 in the tool chain.

I really can't see any relation to the patch.  Can you try the some
things in the following order, please:

 (1) git-revert 365b18189789bfa1acd9939e6312b8a4b4577b28 on current
     Linus tree and see it it works.
     If it works try the next, else the bisect must have been a weird
     conicidence and I can't really help more.
 (2) re-apply only the changes to include/asm-generic/statfs.h from
     365b18189789bfa1acd9939e6312b8a4b4577b28 and see if that still
     boots.
 (3) re-apply the arch/mips/include/asm/statfs.h and
     arch/s390/include/asm/statfs.h changes and see if it still boots
 (4) re-apply the include/linux/statfs.h changes and see if it still
      boots
 (5) re-apply the fs/statfs.c changes, and by now it really shouldn't
     boot anymore
 (6) verify the code really is the same again as in current Linus' tree

