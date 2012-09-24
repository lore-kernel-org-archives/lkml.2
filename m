Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab2IXQWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:22:30 -0400
Received: from fieldses.org ([174.143.236.118]:45055 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab2IXQW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:22:29 -0400
Date: Mon, 24 Sep 2012 12:22:25 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Namjae Jeon <linkinjeon@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v3 2/5] fat: allocate persistent inode numbers
Message-ID: <20120924162225.GB3301@fieldses.org>
References: <87ehls53ug.fsf@devron.myhome.or.jp>
 <87a9wg53mc.fsf@devron.myhome.or.jp>
 <CAKYAXd9_DcS+pqGRuwvHNfHQTpUScSfvM1EDSPHeo4ZP70D0hw@mail.gmail.com>
 <87392768dj.fsf@devron.myhome.or.jp>
 <CAKYAXd_fJwoPrX4zKW0sBDGsBGDWUj-_TtkFYws7z3xvgsnuRw@mail.gmail.com>
 <87y5jz4rio.fsf@devron.myhome.or.jp>
 <CAKYAXd_OmVgxtmHOLRdi5yr=yTa9ppmatQUf1GO6Qjg5ym8LuA@mail.gmail.com>
 <87txun4n5r.fsf@devron.myhome.or.jp>
 <20120924145743.GA3301@fieldses.org>
 <87d31b4cr6.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d31b4cr6.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 01:16:45AM +0900, OGAWA Hirofumi wrote:
> "J. Bruce Fields" <bfields@fieldses.org> writes:
> 
> >> > There is some unclear thing.
> >> > When I see first mail, I think maybe you don't want to use i_pos for inode->ino.
> >> > FAT allocate inode->ino from i_unique on server side and If NFS client
> >> > use i_pos for inode->ino in fat_get_attr, inode numbers on each
> >> > client/server will still be mismatched.
> >> >
> >> > Would you plz give me hint ?
> >> 
> >> ->i_ino is long. It can't hold i_pos fully on 32bit arch, so we can't
> >> use ->i_no to store i_pos, and changing ->i_ino is unnecessary. If
> >> getattr() returned i_pos as ino, nobody see ->i_ino anymore except
> >> internal of kernel.
> >
> > The NFS server must always return the same inode number for the same
> > filehandle.  To do otherwise is a bug.
> >
> >> Furthermore I think there is no issue even if server and client didn't
> >> have same ino. Because client just uses FH (nfs4 seems to be using
> >> stat.ino though).
> >
> > The client may expose a different inode number to userspace, but it's
> > probably the server-provided inode number that it's checking.
> >
> > (And even if the Linux client didn't currently happen to do that check,
> > this would still be a bug.)
> 
> In this context, inode number != inode->i_ino, right? It should be
> kstat.ino, and in FAT case, it will return i_pos always. Otherwise 64bit
> inode number would not work.
> 
> So, I think we are doing right thing for now.

Oh, OK.  On a quick check, yes, the numbers the server returns to
clients are taken from either kstat.ino or the ino argument of the
filldir function.

--b.
