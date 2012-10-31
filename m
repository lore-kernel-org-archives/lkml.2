Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894Ab2JaAq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:46:58 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:55948 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab2JaAqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:46:55 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH 5/5] fat: add mutex lock to fat_build_inode
References: <1351389223-2628-1-git-send-email-linkinjeon@gmail.com>
	<20121029164936.2022db6c.akpm@linux-foundation.org>
	<CAKYAXd_eA3naT84qnVpPGcc9t4ysc45GqKk5xktXyQWaFp2MOQ@mail.gmail.com>
Date: Wed, 31 Oct 2012 09:46:49 +0900
In-Reply-To: <CAKYAXd_eA3naT84qnVpPGcc9t4ysc45GqKk5xktXyQWaFp2MOQ@mail.gmail.com>
	(Namjae Jeon's message of "Tue, 30 Oct 2012 13:24:26 +0900")
Message-ID: <87390va2o6.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> 2012/10/30, Andrew Morton <akpm@linux-foundation.org>:
>> On Sun, 28 Oct 2012 10:53:43 +0900
>> Namjae Jeon <linkinjeon@gmail.com> wrote:
>>
>>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>>
>>> fat_nfs_get_inode does not hold i_mutex of parent directory.So add
>>> lock to fat_build_inode.
>>
> Hi. Andrew.
>> Well..  why?  Presumably this patch fixes some race.  A good
>> description of that race would be useful - partly because others may
>> then be able to suggest alternative ways of fixing that bug.
> We are making use of fat_build_inode to build the inode using 'i_pos'.
> Since, this function is local to FAT and when mounted over NFS. We can
> make use of FAT parallely from local NFS Server and mounted from NFS
> client. So, in order to avoid race to multiple regeneration for the
> same 'i_pos' - we have introduced this locking.

This lock fixes the NFS patches. FAT inode is embedded into
directory. So usual local ->lookup path is exclusive by
inode->i_mutex. But NFS patches (current -mm, IIRC) introduce the new
path for FH => inode lookup.

So, this lock is introduced.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
