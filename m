Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab1ELP0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:26:03 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:60182 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474Ab1ELP0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:26:00 -0400
X-Greylist: delayed 873 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 May 2011 11:26:00 EDT
Subject: Re: linux-next: build failure after merge of the nfs tree
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Stephen Rothwell <sfr@au1.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110512111255.95a765aa.sfr@au.ibm.com>
References: <20110512111255.95a765aa.sfr@au.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 11:11:21 -0400
Message-ID: <1305213081.15566.2.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 4 sum msgs/h 1 total rcpts 1434 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: A58853D3C4B5993627E14C95C0F26ECC70EA094E
X-UiO-SPAM-Test: remote_host: 98.250.108.142 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 39 max/h 2 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 11:12 +1000, Stephen Rothwell wrote:
> Hi Trond,
> 
> After merging the nfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/nfs/write.c: In function 'nfs_flush_multi':
> fs/nfs/write.c:942: error: too many arguments to function 'pnfs_update_layout'
> fs/nfs/write.c: In function 'nfs_flush_one':
> fs/nfs/write.c:1016: error: too many arguments to function 'pnfs_update_layout'
> fs/nfs/read.c: In function 'nfs_pagein_multi':
> fs/nfs/read.c:291: error: too many arguments to function 'pnfs_update_layout'
> fs/nfs/read.c: In function 'nfs_pagein_one':
> fs/nfs/read.c:354: error: too many arguments to function 'pnfs_update_layout'
> 
> Cased by commit 4b386a0fe47b ("NFSv4.1: Ensure that layoutget uses the
> correct gfp modes") which forgot to update the function declaration for
> the !CONFIG_NFS_V4_1 case.
> 
> I have used the nfs tree from next-20110511 for today.

Hi Stephen,

Sorry about that. I thought I had found all occurrences and updated
them. The above issue should now be fixed in the git tree...

Cheers
  Trond

