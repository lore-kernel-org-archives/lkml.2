Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992709Ab2KOHSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 02:18:50 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:60400 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab2KOHSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 02:18:48 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 2/3] fat: fix time updates for create and delete
References: <1352642278-2730-1-git-send-email-linkinjeon@gmail.com>
	<874nkw86jz.fsf@devron.myhome.or.jp>
	<CAKYAXd_HBP1ToGunoPwut18v+hwdG=QdfeXyJVSrLUGEt6beSQ@mail.gmail.com>
	<87sj8f5k4m.fsf@devron.myhome.or.jp>
	<87obj35k3a.fsf@devron.myhome.or.jp>
	<CAKYAXd_=wCLo5RZhOaur7Yjw+6MYk-DhRPTjy148Yo0z6z9BcQ@mail.gmail.com>
	<87k3tr5g8v.fsf@devron.myhome.or.jp>
	<87fw4f5g70.fsf@devron.myhome.or.jp>
	<CAKYAXd84jVdb99qAqda_NGEDUg1G1F9aLGQV+Kj3xcTBN=FxwQ@mail.gmail.com>
Date: Thu, 15 Nov 2012 16:18:39 +0900
In-Reply-To: <CAKYAXd84jVdb99qAqda_NGEDUg1G1F9aLGQV+Kj3xcTBN=FxwQ@mail.gmail.com>
	(Namjae Jeon's message of "Thu, 15 Nov 2012 16:02:26 +0900")
Message-ID: <87txsr49m8.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> 1)If we consider the code for FAT and MSDOS to be same with respect to
> timing updates - there there is difference in code as mentioned below:
> a) For:vfat_rmdir()
> 	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
>    For:msdos_rmdir()
> 		inode->i_ctime = CURRENT_TIME_SEC;
> 		
> b) For: vfat_unlink()
> 		inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
>    For: msdos_unlink()
>    		inode->i_ctime = CURRENT_TIME_SEC;
>
> So, atleast the uniformity in the code is missing for MSDOS and VFAT.

MSDOS doesn't have atime.

> 2) Regarding timings information
> Original timings on VFAT:
> #> mkdir parent
> #> stat parent
> File type:                directory
> I-node number:            30
> Mode:                     40755 (octal)
> Link count:               2
> Ownership:                UID=0   GID=0
> Preferred I/O block size: 4096 bytes
> File size:                4096 bytes
> Blocks allocated:         8
> Last status change:       Thu Jan  1 00:01:29 2012
> Last file access:         Thu Jan  1 00:01:29 2012
> Last file modification:   Thu Jan  1 00:01:29 2012

[...]

> As can be seen from the 'stat' information - the timing information
> appears same for VFAT like EXT4/XFS after changes.
> Please let me know your opinion.

You have to think about compatibility with other FAT, not unix fs.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
