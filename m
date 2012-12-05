Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab2LEJCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 04:02:48 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:45628 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2LEJCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 04:02:43 -0500
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
	<87k3sy17vk.fsf@devron.myhome.or.jp>
	<CAKYAXd8=7BG8NsVyvUP5xW48Y9FJpD7M95_MiJVGcwYOfYsrLA@mail.gmail.com>
Date: Wed, 05 Dec 2012 18:02:40 +0900
In-Reply-To: <CAKYAXd8=7BG8NsVyvUP5xW48Y9FJpD7M95_MiJVGcwYOfYsrLA@mail.gmail.com>
	(Namjae Jeon's message of "Wed, 5 Dec 2012 15:01:39 +0900")
Message-ID: <87txs0x45r.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>>>> This became much better than before. However, we have to consolidate the
>>>> code with fat_search_long() finally.
>>>>
>>>> E.g. this version is having the issue already fixed. If there is
>>>> corruption in fat cluster-chain, it lead to infinite
>>>> loop. fat_get_cluster() checks infinite loop by limit.
>>> since, the focus this time was for NFS functionality for FAT (removing
>>> ESTALE error). The changes were made in that context.
>>>
>>> Later, we can make the changes as part of code reorganizing which can
>>> be controlled via. Separate patches which do not have any impact on
>>> default functionality and verification can be carried out in that
>>> scope.
>>
>> Right. But non-production code shouldn't go into linus tree. I meant, we
>> can test this patch series, but not yet production quality.
> Is there any other thing which seems potential issue than offsetof()?
> if yes, which problem didn't lead to production quality do you think ?
>
> +#define FAT_FID_SIZE_WITHOUT_PARENT (offsetof(struct fat_fid, \
> +					      parent_i_pos_hi)/4)
> Since this expression does not result proper integer value, so will it
> be correct to directly put the value like
> +#define FAT_FID_SIZE_WITHOUT_PARENT 3

The issue is what I explained in the above "E.g.".

Directory traversal logic should be consolidate with fat_search_log().
Otherwise, like this nfs implement, we will introduce already-fixed-problem
again. And we will be bothered to fix same issue in future.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
