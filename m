Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419Ab2EKBgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 21:36:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42075 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab2EKBgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 21:36:48 -0400
MIME-Version: 1.0
In-Reply-To: <4FAC31BE.1060505@xenotime.net>
References: <20120510192635.c6f3a55196bbf65f13956e44@canb.auug.org.au> <4FAC31BE.1060505@xenotime.net>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 10 May 2012 21:36:16 -0400
X-Google-Sender-Auth: AaEtWhpU49aQGwVx5TyJHsItw2I
Message-ID: <CAP=VYLrAjGjCHDhxrEypaKcqK1Yx7_XY_TZofsf5V9x7GCGr7g@mail.gmail.com>
Subject: Re: linux-next: Tree for May 10 (fs/inode.c)
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Trond.Myklebust@netapp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 5:23 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 05/10/2012 02:26 AM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20120508:
>
>
> when CONFIG_BLOCK is not set:
>
> fs/inode.c:1777:6: error: redefinition of 'inode_dio_wait'
> include/linux/fs.h:2476:20: note: previous definition of 'inode_dio_wait'
> was here

Also seen on some arm builds:

http://kisskb.ellerman.id.au/kisskb/buildresult/6291357/
http://kisskb.ellerman.id.au/kisskb/buildresult/6291378/

5eff3957ce8d14c2a254844743dfb84e19e7c2ae is the first bad commit
commit 5eff3957ce8d14c2a254844743dfb84e19e7c2ae
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Mon May 7 10:44:29 2012 -0400

    NFS: Ensure that setattr and getattr wait for O_DIRECT write completion

    Use the same mechanism as the block devices are using, but move the
    helper functions from fs/direct-io.c into fs/inode.c to remove the
    dependency on CONFIG_BLOCK.

    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
    Cc: Christoph Hellwig <hch@infradead.org>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Fred Isaman <iisaman@netapp.com>

:040000 040000 ae33e2ffd172e4d7e2ad6ed219de32de936548cc
ef2df66b34559dbc0782add108e24a6ef6e4e2ca M      fs
bisect run success

P.
---

>
> Full randconfig file is attached.
>
> --
> ~Randy
