Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab2LEGBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 01:01:42 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46492 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab2LEGBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 01:01:40 -0500
MIME-Version: 1.0
In-Reply-To: <87k3sy17vk.fsf@devron.myhome.or.jp>
References: <1353504311-6020-1-git-send-email-linkinjeon@gmail.com>
	<878v9f5ugn.fsf@devron.myhome.or.jp>
	<CAKYAXd-ydXkwDq6vkECEKPUQiNgg2+GKbL+ah9sn+uqr8BT1kQ@mail.gmail.com>
	<87k3sy17vk.fsf@devron.myhome.or.jp>
Date: Wed, 5 Dec 2012 15:01:39 +0900
Message-ID: <CAKYAXd8=7BG8NsVyvUP5xW48Y9FJpD7M95_MiJVGcwYOfYsrLA@mail.gmail.com>
Subject: Re: [PATCH v5 7/8] fat (exportfs): rebuild directory-inode if
 fat_dget() fails
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/4, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> 2012/12/3, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
>>> Namjae Jeon <linkinjeon@gmail.com> writes:
>>>
>>>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>>>
>>>> This patch enables rebuilding of directory inodes which are not present
>>>> in the cache.This is done by traversing the disk clusters to find the
>>>> directory entry of the parent directory and using its i_pos to build
>>>> the
>>>> inode.
>>>> Do this only if the "nostale_ro" nfs mount option is specified.
>>>
>>> This became much better than before. However, we have to consolidate the
>>> code with fat_search_long() finally.
>>>
>>> E.g. this version is having the issue already fixed. If there is
>>> corruption in fat cluster-chain, it lead to infinite
>>> loop. fat_get_cluster() checks infinite loop by limit.
>> since, the focus this time was for NFS functionality for FAT (removing
>> ESTALE error). The changes were made in that context.
>>
>> Later, we can make the changes as part of code reorganizing which can
>> be controlled via. Separate patches which do not have any impact on
>> default functionality and verification can be carried out in that
>> scope.
>
> Right. But non-production code shouldn't go into linus tree. I meant, we
> can test this patch series, but not yet production quality.
Is there any other thing which seems potential issue than offsetof()?
if yes, which problem didn't lead to production quality do you think ?

+#define FAT_FID_SIZE_WITHOUT_PARENT (offsetof(struct fat_fid, \
+					      parent_i_pos_hi)/4)
Since this expression does not result proper integer value, so will it
be correct to directly put the value like
+#define FAT_FID_SIZE_WITHOUT_PARENT 3

Thanks!
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
