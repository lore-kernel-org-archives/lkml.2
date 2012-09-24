Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab2IXE60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 00:58:26 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50454 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab2IXE6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 00:58:25 -0400
MIME-Version: 1.0
In-Reply-To: <87ipb45914.fsf@devron.myhome.or.jp>
References: <1347798148-2660-1-git-send-email-linkinjeon@gmail.com>
	<87lig28fak.fsf@devron.myhome.or.jp>
	<CAKYAXd-6k7=RmrweR=wTOET50hy8Y7LokCSe1c2JtYd7pzPmsQ@mail.gmail.com>
	<87ipb45914.fsf@devron.myhome.or.jp>
Date: Mon, 24 Sep 2012 13:58:24 +0900
Message-ID: <CAKYAXd9EzKH_x1GaXvSZ7pRebfOcwQqNp6-oEnc2z2evuNo23g@mail.gmail.com>
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
>>> I think we don't need this. Because FH and ino is not necessary to have
>>> relation.
>>>
>>> Can we re-introduce ->encode_fh() handler, and export i_pos again?  With
>>> this, I think we can get i_pos correctly. Otherwise, ino may not contain
>>> all bits of i_pos.
>> I already tried to fix this issue using encode_fh without stable ino
>> before.
>> But I reached conclusion that we should use stable inode number.
>>
>> e.g. If we rebuild inode number using i_pos of fh, inode number is
>> changed by i_unique.
>> And It is not match with inode number of FH on NFS client. So estale
>> error will happen.
>
> What is problem if i_ino + i_generation is not match? I think, even if
> those didn't match, i_pos in FH should resolve issue, no?
No, It can not resolve issue.
in NFS file handle, there is a reference to the current inode number.
So, if by eviction that is changed - that it will results in "file id
changed" error.
even though using the i_pos we can reconstruct and get the INODE on
the Server, but the NFS handle is no more valid. As the inode number
is also changed, iunique() for the file will result in different
number this time.

Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
