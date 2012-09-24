Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab2IXLVC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 07:21:02 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58541 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab2IXLVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 07:21:00 -0400
MIME-Version: 1.0
In-Reply-To: <87y5jz4rio.fsf@devron.myhome.or.jp>
References: <1347798148-2660-1-git-send-email-linkinjeon@gmail.com>
	<87lig28fak.fsf@devron.myhome.or.jp>
	<CAKYAXd-6k7=RmrweR=wTOET50hy8Y7LokCSe1c2JtYd7pzPmsQ@mail.gmail.com>
	<87ipb45914.fsf@devron.myhome.or.jp>
	<CAKYAXd9EzKH_x1GaXvSZ7pRebfOcwQqNp6-oEnc2z2evuNo23g@mail.gmail.com>
	<87ehls53ug.fsf@devron.myhome.or.jp>
	<87a9wg53mc.fsf@devron.myhome.or.jp>
	<CAKYAXd9_DcS+pqGRuwvHNfHQTpUScSfvM1EDSPHeo4ZP70D0hw@mail.gmail.com>
	<87392768dj.fsf@devron.myhome.or.jp>
	<CAKYAXd_fJwoPrX4zKW0sBDGsBGDWUj-_TtkFYws7z3xvgsnuRw@mail.gmail.com>
	<87y5jz4rio.fsf@devron.myhome.or.jp>
Date: Mon, 24 Sep 2012 20:20:59 +0900
Message-ID: <CAKYAXd_OmVgxtmHOLRdi5yr=yTa9ppmatQUf1GO6Qjg5ym8LuA@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] fat: allocate persistent inode numbers
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/24, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>> I see. fileid seems to be stat.ino on nfsd4. inode->i_ino is actually
>>> just a hash key of inode hash (exception is only in audit, iirc).
>>>
>>> So, what happens if we set "stat->ino = i_pos" on fat_getattr().
>>>
>>> int fat_getattr(struct vfsmount *mnt, struct dentry *dentry, struct
>>> kstat
>>> *stat)
>>> {
>>> 	struct inode *inode = dentry->d_inode;
>>> 	generic_fillattr(inode, stat);
>>> 	stat->blksize = MSDOS_SB(inode->i_sb)->cluster_size;
>>> 	if (opts->nfs == FAT_NFS_LIMITED) {
>>> 		/* Use i_pos for ino. This is used as fileid of nfs. */
>>> 		stat->ino = MSDOS_SB(inode->i_sb)->i_pos;
>
> 		stat->ino = fat_i_pos_read(MSDOS_SB(inode->i_sb), inode);
>
> Ouch, I forgot to use fat_i_pos_read().
>
There is some unclear thing.
When I see first mail, I think maybe you don't want to use i_pos for inode->ino.
FAT allocate inode->ino from i_unique on server side and If NFS client
use i_pos for inode->ino in fat_get_attr, inode numbers on each
client/server will still be mismatched.

Would you plz give me hint ?

Thanks OGAWA~.
>>> 	}
>>> 	return 0;
>>> }
>> Okay, Thanks for your help.
>> I will share the result after checking.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
