Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab2IXHCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 03:02:41 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56084 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab2IXHCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 03:02:40 -0400
MIME-Version: 1.0
In-Reply-To: <87a9wg53mc.fsf@devron.myhome.or.jp>
References: <1347798148-2660-1-git-send-email-linkinjeon@gmail.com>
	<87lig28fak.fsf@devron.myhome.or.jp>
	<CAKYAXd-6k7=RmrweR=wTOET50hy8Y7LokCSe1c2JtYd7pzPmsQ@mail.gmail.com>
	<87ipb45914.fsf@devron.myhome.or.jp>
	<CAKYAXd9EzKH_x1GaXvSZ7pRebfOcwQqNp6-oEnc2z2evuNo23g@mail.gmail.com>
	<87ehls53ug.fsf@devron.myhome.or.jp>
	<87a9wg53mc.fsf@devron.myhome.or.jp>
Date: Mon, 24 Sep 2012 16:02:39 +0900
Message-ID: <CAKYAXd9_DcS+pqGRuwvHNfHQTpUScSfvM1EDSPHeo4ZP70D0hw@mail.gmail.com>
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
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
>
>> Namjae Jeon <linkinjeon@gmail.com> writes:
>>
>>>> What is problem if i_ino + i_generation is not match? I think, even if
>>>> those didn't match, i_pos in FH should resolve issue, no?
>>> No, It can not resolve issue.
>>> in NFS file handle, there is a reference to the current inode number.
>>> So, if by eviction that is changed - that it will results in "file id
>>> changed" error.
>>
>> Who returns error?
>
> This means - which code returns error?
Sorry, My explanation may be insufficient.

nfs_update_inode()-> on NFS client
if ((fattr->valid & NFS_ATTR_FATTR_FILEID) && nfsi->fileid != fattr->fileid) {
		printk(KERN_ERR "NFS: server %s error: fileid changed\n"
			"fsid %s: expected fileid 0x%Lx, got 0x%Lx\n",
			NFS_SERVER(inode)->nfs_client->cl_hostname,
			inode->i_sb->s_id, (long long)nfsi->fileid,
			(long long)fattr->fileid);
		goto out_err;
	}

that the problem in that case will occur with the file handle on NFS
Client because the file handle on NFS client is still referring the
old inode number even though the i-pos is same

Thanks.

>
>>> even though using the i_pos we can reconstruct and get the INODE on
>>> the Server, but the NFS handle is no more valid. As the inode number
>>> is also changed, iunique() for the file will result in different
>>> number this time.
>
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
