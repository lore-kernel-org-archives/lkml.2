Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2IQOOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:14:45 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65471 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab2IQOOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:14:44 -0400
MIME-Version: 1.0
In-Reply-To: <87k3vs6bjm.fsf@devron.myhome.or.jp>
References: <1347798099-2592-1-git-send-email-linkinjeon@gmail.com>
	<87k3vs6bjm.fsf@devron.myhome.or.jp>
Date: Mon, 17 Sep 2012 23:14:42 +0900
Message-ID: <CAKYAXd-1N0gpR3nXmeZGDm_k_K+DXNhEDxv-8YvKD2W9WeCXaA@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] fat: make persistent inode numbers and stablize
 for NFS.
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/17 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> This patch-set eliminates the client side ESTALE errors when a FAT partition
>> exported over NFS has its dentries evicted from the cache.
>>
>> One of the reasons for this error is lack of permanent inode numbers on FAT
>> which makes it difficult to construct persistent file handles.
>> This can be overcome by using the on-disk location of the directory entries
>> (i_pos) as the inode numbers.
>>
>> Once the i_pos is available, it is only a matter of reading the directory
>> entries from the disk clusters to locate the matching entry and rebuild
>> the corresponding inode.
>>
>> We reached the conclusion support stable inode's read-only export first after
>> discussing with OGAWA and Bruce.
>> And will make it writable with some operation(unlink and rename) limitation
>> next time.
>>
>> Namjae Jeon (4)
>>  fat: modify nfs mount option
>>  fat: allocate persistent inode numbers
>>  fat (exportfs): rebuild inode if ilookup() fails
>>  fat (exportfs): rebuild directory-inode if fat_dget() fails
>>  Documentation: update nfs option in filesystem/vfat.txt
>
> Sorry for late, I will review at next weekend.
No, problem. Thanks~
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
