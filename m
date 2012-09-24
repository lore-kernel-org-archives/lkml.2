Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab2IXQQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:16:53 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:42562 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab2IXQQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:16:51 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Namjae Jeon <linkinjeon@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v3 2/5] fat: allocate persistent inode numbers
References: <87ipb45914.fsf@devron.myhome.or.jp>
	<CAKYAXd9EzKH_x1GaXvSZ7pRebfOcwQqNp6-oEnc2z2evuNo23g@mail.gmail.com>
	<87ehls53ug.fsf@devron.myhome.or.jp>
	<87a9wg53mc.fsf@devron.myhome.or.jp>
	<CAKYAXd9_DcS+pqGRuwvHNfHQTpUScSfvM1EDSPHeo4ZP70D0hw@mail.gmail.com>
	<87392768dj.fsf@devron.myhome.or.jp>
	<CAKYAXd_fJwoPrX4zKW0sBDGsBGDWUj-_TtkFYws7z3xvgsnuRw@mail.gmail.com>
	<87y5jz4rio.fsf@devron.myhome.or.jp>
	<CAKYAXd_OmVgxtmHOLRdi5yr=yTa9ppmatQUf1GO6Qjg5ym8LuA@mail.gmail.com>
	<87txun4n5r.fsf@devron.myhome.or.jp>
	<20120924145743.GA3301@fieldses.org>
Date: Tue, 25 Sep 2012 01:16:45 +0900
In-Reply-To: <20120924145743.GA3301@fieldses.org> (J. Bruce Fields's message
	of "Mon, 24 Sep 2012 10:57:43 -0400")
Message-ID: <87d31b4cr6.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. Bruce Fields" <bfields@fieldses.org> writes:

>> > There is some unclear thing.
>> > When I see first mail, I think maybe you don't want to use i_pos for inode->ino.
>> > FAT allocate inode->ino from i_unique on server side and If NFS client
>> > use i_pos for inode->ino in fat_get_attr, inode numbers on each
>> > client/server will still be mismatched.
>> >
>> > Would you plz give me hint ?
>> 
>> ->i_ino is long. It can't hold i_pos fully on 32bit arch, so we can't
>> use ->i_no to store i_pos, and changing ->i_ino is unnecessary. If
>> getattr() returned i_pos as ino, nobody see ->i_ino anymore except
>> internal of kernel.
>
> The NFS server must always return the same inode number for the same
> filehandle.  To do otherwise is a bug.
>
>> Furthermore I think there is no issue even if server and client didn't
>> have same ino. Because client just uses FH (nfs4 seems to be using
>> stat.ino though).
>
> The client may expose a different inode number to userspace, but it's
> probably the server-provided inode number that it's checking.
>
> (And even if the Linux client didn't currently happen to do that check,
> this would still be a bug.)

In this context, inode number != inode->i_ino, right? It should be
kstat.ino, and in FAT case, it will return i_pos always. Otherwise 64bit
inode number would not work.

So, I think we are doing right thing for now.

Anyway, thanks for your review.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
