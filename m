Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab0JUOd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:33:56 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:41378 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab0JUOdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:33:54 -0400
Subject: Re: linux-next: build failure after merge of the nfs tree
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bryan Schumaker <bjschuma@netapp.com>
In-Reply-To: <20101021113858.f8b9849f.sfr@canb.auug.org.au>
References: <20101021113858.f8b9849f.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 10:33:47 -0400
Message-ID: <1287671627.3645.13.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 4 msgs/h 1 sum rcpts/h 5 sum msgs/h 1 total rcpts 1054 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 2504E232DF7ADF4D72FDEEDC8EF1492A84FBF3B6
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 422 max/h 7 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 11:38 +1100, Stephen Rothwell wrote:
> Hi Trond,
> 
> After merging the nfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/nfs/dir.c: In function 'nfs_readdir_free_large_page':
> fs/nfs/dir.c:475: error: implicit declaration of function 'vm_unmap_ram'
> fs/nfs/dir.c: In function 'nfs_readdir_large_page':
> fs/nfs/dir.c:496: error: implicit declaration of function 'vm_map_ram'
> fs/nfs/dir.c:496: warning: assignment makes pointer from integer without a cast
> 
> Caused by commit b8aa6064474e186f598584508f9230d49a0004af ("NFS: readdir
> with vmapped pages").  Forgot to include linux/vmalloc.h.  See Rule 1 (in
> Documentation/SubmitChecklist).
> 
> I have used the nfs tree from next-20101020 for today.

Thanks Stephen! Fixed in my linux-next branch.

Bryan, please make sure that you update your patches.

Cheers
  Trond

