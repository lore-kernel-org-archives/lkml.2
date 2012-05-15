Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab2EOAtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 20:49:40 -0400
Received: from mx2.netapp.com ([216.240.18.37]:8848 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757855Ab2EOAti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 20:49:38 -0400
X-IronPort-AV: E=Sophos;i="4.75,590,1330934400"; 
   d="scan'208";a="647622607"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: Tree for May 10 (fs/inode.c)
Thread-Topic: linux-next: Tree for May 10 (fs/inode.c)
Thread-Index: AQHNLxaJX4VbCL1zREKAzMDxf2GtH5bKgEyA
Date: Tue, 15 May 2012 00:49:01 +0000
Message-ID: <1337042961.2522.53.camel@lade.trondhjem.org>
References: <20120510192635.c6f3a55196bbf65f13956e44@canb.auug.org.au>
	 <4FAC31BE.1060505@xenotime.net>
	 <CAP=VYLrAjGjCHDhxrEypaKcqK1Yx7_XY_TZofsf5V9x7GCGr7g@mail.gmail.com>
In-Reply-To: <CAP=VYLrAjGjCHDhxrEypaKcqK1Yx7_XY_TZofsf5V9x7GCGr7g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <77A7CD94118B214DAA2241AEC8FDABC6@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4F0nwrh007174

On Thu, 2012-05-10 at 21:36 -0400, Paul Gortmaker wrote:
> On Thu, May 10, 2012 at 5:23 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > On 05/10/2012 02:26 AM, Stephen Rothwell wrote:
> >
> >> Hi all,
> >>
> >> Changes since 20120508:
> >
> >
> > when CONFIG_BLOCK is not set:
> >
> > fs/inode.c:1777:6: error: redefinition of 'inode_dio_wait'
> > include/linux/fs.h:2476:20: note: previous definition of 'inode_dio_wait'
> > was here
> 
> Also seen on some arm builds:
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/6291357/
> http://kisskb.ellerman.id.au/kisskb/buildresult/6291378/
> 
> 5eff3957ce8d14c2a254844743dfb84e19e7c2ae is the first bad commit
> commit 5eff3957ce8d14c2a254844743dfb84e19e7c2ae
> Author: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date:   Mon May 7 10:44:29 2012 -0400
> 
>     NFS: Ensure that setattr and getattr wait for O_DIRECT write completion
> 
>     Use the same mechanism as the block devices are using, but move the
>     helper functions from fs/direct-io.c into fs/inode.c to remove the
>     dependency on CONFIG_BLOCK.
> 
>     Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
>     Cc: Christoph Hellwig <hch@infradead.org>
>     Cc: Al Viro <viro@zeniv.linux.org.uk>
>     Cc: Fred Isaman <iisaman@netapp.com>
> 
> :040000 040000 ae33e2ffd172e4d7e2ad6ed219de32de936548cc
> ef2df66b34559dbc0782add108e24a6ef6e4e2ca M      fs
> bisect run success
> 
> P.

Sorry about being so late with this. The changes to include/linux/fs.h
had not been committed in the original branch. Today's linux-next should
have that fixed...

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
