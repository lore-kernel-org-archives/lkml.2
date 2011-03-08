Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab1CHTMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 14:12:14 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:60429 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab1CHTMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 14:12:12 -0500
X-Greylist: delayed 813 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Mar 2011 14:12:12 EST
Subject: Re: linux-next: build failure after merge of the nfs tree
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Filz <ffilzlnx@us.ibm.com>, Jeff Layton <jlayton@redhat.com>
In-Reply-To: <20110308120753.8adb3ff6.sfr@canb.auug.org.au>
References: <20110308120753.8adb3ff6.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 13:58:31 -0500
Message-ID: <1299610712.3602.15.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 6 msgs/h 2 sum rcpts/h 7 sum msgs/h 2 total rcpts 1352 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: BA1679F77709015B4784C3342B5FA543273A771C
X-UiO-SPAM-Test: remote_host: 98.250.108.142 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 4 max/h 2 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 12:07 +1100, Stephen Rothwell wrote: 
> Hi Trond,
> 
> After merging the nfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/nfs/inode.c: In function 'nfs_compat_user_ino64':
> fs/nfs/inode.c:93: error: 'compat_ulong_t' undeclared (first use in this function)
> fs/nfs/inode.c:93: error: expected ';' before 'ino'
> fs/nfs/inode.c:100: error: 'ino' undeclared (first use in this function)
> 
> Caused by commit 5fa1ca22302da56ffa568e847100e80be90cc602 ("(try3-resend)
> Fix nfs_compat_user_ino64 so it doesn't cause problems if bit 31 or 63
> are set in fileid").
> 
> I have used the nfs tree from next-20110307 for today.

Thanks Stephen!

It looks to me as if we need to add a '#include <compat.h>'. I'll fix up
the patch...

Cheers
  Trond

