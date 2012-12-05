Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2LEL4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 06:56:42 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60699 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab2LEL4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 06:56:39 -0500
MIME-Version: 1.0
In-Reply-To: <87txs0x45r.fsf@devron.myhome.or.jp>
References: <1353504311-6020-1-git-send-email-linkinjeon@gmail.com>
	<878v9f5ugn.fsf@devron.myhome.or.jp>
	<CAKYAXd-ydXkwDq6vkECEKPUQiNgg2+GKbL+ah9sn+uqr8BT1kQ@mail.gmail.com>
	<87k3sy17vk.fsf@devron.myhome.or.jp>
	<CAKYAXd8=7BG8NsVyvUP5xW48Y9FJpD7M95_MiJVGcwYOfYsrLA@mail.gmail.com>
	<87txs0x45r.fsf@devron.myhome.or.jp>
Date: Wed, 5 Dec 2012 20:56:38 +0900
Message-ID: <CAKYAXd8OP_FXxJWHESW_bCY1hGQuZPMJYOkLkmQ4fOkDhGO8xw@mail.gmail.com>
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

2012/12/5, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>>>> This became much better than before. However, we have to consolidate
>>>>> the
>>>>> code with fat_search_long() finally.
>>>>>
>>>>> E.g. this version is having the issue already fixed. If there is
>>>>> corruption in fat cluster-chain, it lead to infinite
>>>>> loop. fat_get_cluster() checks infinite loop by limit.
>>>> since, the focus this time was for NFS functionality for FAT (removing
>>>> ESTALE error). The changes were made in that context.
>>>>
>>>> Later, we can make the changes as part of code reorganizing which can
>>>> be controlled via. Separate patches which do not have any impact on
>>>> default functionality and verification can be carried out in that
>>>> scope.
>>>
>>> Right. But non-production code shouldn't go into linus tree. I meant, we
>>> can test this patch series, but not yet production quality.
>> Is there any other thing which seems potential issue than offsetof()?
>> if yes, which problem didn't lead to production quality do you think ?
>>
>> +#define FAT_FID_SIZE_WITHOUT_PARENT (offsetof(struct fat_fid, \
>> +					      parent_i_pos_hi)/4)
>> Since this expression does not result proper integer value, so will it
>> be correct to directly put the value like
>> +#define FAT_FID_SIZE_WITHOUT_PARENT 3
>
> The issue is what I explained in the above "E.g.".
>
> Directory traversal logic should be consolidate with fat_search_log().
> Otherwise, like this nfs implement, we will introduce already-fixed-problem
> again. And we will be bothered to fix same issue in future.
Okay, We will check how we can consolidate the 2 paths to avoid any issue.

Thanks OGAWA!
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
