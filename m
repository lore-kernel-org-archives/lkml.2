Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab2J3EYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 00:24:30 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60933 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2J3EY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 00:24:28 -0400
MIME-Version: 1.0
In-Reply-To: <20121029164936.2022db6c.akpm@linux-foundation.org>
References: <1351389223-2628-1-git-send-email-linkinjeon@gmail.com>
	<20121029164936.2022db6c.akpm@linux-foundation.org>
Date: Tue, 30 Oct 2012 13:24:26 +0900
Message-ID: <CAKYAXd_eA3naT84qnVpPGcc9t4ysc45GqKk5xktXyQWaFp2MOQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] fat: add mutex lock to fat_build_inode
From: Namjae Jeon <linkinjeon@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hirofumi@mail.parknet.co.jp, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/30, Andrew Morton <akpm@linux-foundation.org>:
> On Sun, 28 Oct 2012 10:53:43 +0900
> Namjae Jeon <linkinjeon@gmail.com> wrote:
>
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> fat_nfs_get_inode does not hold i_mutex of parent directory.So add
>> lock to fat_build_inode.
>
Hi. Andrew.
> Well..  why?  Presumably this patch fixes some race.  A good
> description of that race would be useful - partly because others may
> then be able to suggest alternative ways of fixing that bug.
We are making use of fat_build_inode to build the inode using 'i_pos'.
Since, this function is local to FAT and when mounted over NFS. We can
make use of FAT parallely from local NFS Server and mounted from NFS
client. So, in order to avoid race to multiple regeneration for the
same 'i_pos' - we have introduced this locking.

>
> I'll merge these patches for some testing.
>
> I did merge these patches three weekes ago:
>
> fat-modify-nfs-mount-option.patch
> fat-exportfs-rebuild-inode-if-ilookup-fails.patch
> fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
> fat-exportfs-rebuild-directory-inode-if-fat_dget-fails.patch
> documentation-update-nfs-option-in-filesystem-vfattxt.patch
>
> But I have no record of Bruce or Ogawa having reviewed/acked them?
While the patches were sent for review on LKML and also in the
meantime since the functionality was finalised, the patches were
picked for merging in the linux tree. But there few comments which
were later provided by OGAWA. So, these patches are extending the
earlier patch-set by providing some fix-ups and cleanup routines.

Thanks!
>
