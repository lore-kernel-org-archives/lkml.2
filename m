Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab2IXELT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 00:11:19 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34046 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2IXELN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 00:11:13 -0400
MIME-Version: 1.0
In-Reply-To: <87lig28fak.fsf@devron.myhome.or.jp>
References: <1347798148-2660-1-git-send-email-linkinjeon@gmail.com>
	<87lig28fak.fsf@devron.myhome.or.jp>
Date: Mon, 24 Sep 2012 13:11:11 +0900
Message-ID: <CAKYAXd-6k7=RmrweR=wTOET50hy8Y7LokCSe1c2JtYd7pzPmsQ@mail.gmail.com>
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

2012/9/22, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> -	inode->i_ino = iunique(sb, MSDOS_ROOT_INO);
>> +	if (MSDOS_SB(sb)->options.nfs == FAT_NFS_LIMITED)
>> +		inode->i_ino = i_pos;
>> +	else
>> +		inode->i_ino = iunique(sb, MSDOS_ROOT_INO);
>>  	inode->i_version = 1;
>>  	err = fat_fill_inode(inode, de);
>>  	if (err) {
>
> I think we don't need this. Because FH and ino is not necessary to have
> relation.
>
> Can we re-introduce ->encode_fh() handler, and export i_pos again?  With
> this, I think we can get i_pos correctly. Otherwise, ino may not contain
> all bits of i_pos.
I already tried to fix this issue using encode_fh without stable ino before.
But I reached conclusion that we should use stable inode number.

e.g. If we rebuild inode number using i_pos of fh, inode number is
changed by i_unique.
And It is not match with inode number of FH on NFS client. So estale
error will happen.

Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
