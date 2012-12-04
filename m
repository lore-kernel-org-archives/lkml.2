Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab2LDJbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 04:31:20 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:40258 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2LDJbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 04:31:18 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v5 7/8] fat (exportfs): rebuild directory-inode if fat_dget() fails
References: <1353504311-6020-1-git-send-email-linkinjeon@gmail.com>
	<878v9f5ugn.fsf@devron.myhome.or.jp>
	<CAKYAXd-ydXkwDq6vkECEKPUQiNgg2+GKbL+ah9sn+uqr8BT1kQ@mail.gmail.com>
Date: Tue, 04 Dec 2012 18:31:11 +0900
In-Reply-To: <CAKYAXd-ydXkwDq6vkECEKPUQiNgg2+GKbL+ah9sn+uqr8BT1kQ@mail.gmail.com>
	(Namjae Jeon's message of "Tue, 4 Dec 2012 15:27:34 +0900")
Message-ID: <87k3sy17vk.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> 2012/12/3, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
>> Namjae Jeon <linkinjeon@gmail.com> writes:
>>
>>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>>
>>> This patch enables rebuilding of directory inodes which are not present
>>> in the cache.This is done by traversing the disk clusters to find the
>>> directory entry of the parent directory and using its i_pos to build the
>>> inode.
>>> Do this only if the "nostale_ro" nfs mount option is specified.
>>
>> This became much better than before. However, we have to consolidate the
>> code with fat_search_long() finally.
>>
>> E.g. this version is having the issue already fixed. If there is
>> corruption in fat cluster-chain, it lead to infinite
>> loop. fat_get_cluster() checks infinite loop by limit.
> since, the focus this time was for NFS functionality for FAT (removing
> ESTALE error). The changes were made in that context.
>
> Later, we can make the changes as part of code reorganizing which can
> be controlled via. Separate patches which do not have any impact on
> default functionality and verification can be carried out in that
> scope.

Right. But non-production code shouldn't go into linus tree. I meant, we
can test this patch series, but not yet production quality.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
