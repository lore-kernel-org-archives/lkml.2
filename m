Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018Ab0I0MLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:11:55 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:38770 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658Ab0I0MLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:11:53 -0400
X-Greylist: delayed 1451 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Sep 2010 08:11:53 EDT
Subject: Re: linux-next: build failure after merge of the  tree (nfs tree
 related)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bryan Schumaker <bjschuma@netapp.com>
In-Reply-To: <20100927152304.a6463447.sfr@canb.auug.org.au>
References: <20100927152304.a6463447.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 07:47:35 -0400
Message-ID: <1285588055.19362.7.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 4 msgs/h 1 sum rcpts/h 6 sum msgs/h 1 total rcpts 990 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 3D71DD3DC5CF26B8A5F57FF4CD1C1ADCA1279490
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 391 max/h 7 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 15:23 +1000, Stephen Rothwell wrote:
> Hi Trond,
> 
> After merging the final tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/nfs/dir.c: In function 'nfs_readdir_free_large_page':
> fs/nfs/dir.c:464: error: implicit declaration of function 'vm_unmap_ram'
> fs/nfs/dir.c: In function 'nfs_readdir_large_page':
> fs/nfs/dir.c:485: error: implicit declaration of function 'vm_map_ram'
> fs/nfs/dir.c:485: warning: assignment makes pointer from integer without a cast
> 
> Caused by commit 2af4eb9746092aab7811b5b581d004049c068a02 ("NFS: readdir
> with vmapped pages").
> 
> I have reverted that commit for today.

Agreed: fs/nfs/dir.c needs to #include <vmalloc.h> in order to use those
functions. Bryan, can you please fix that up?

Thanks Stephen!
  Trond

