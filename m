Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab2JONUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 09:20:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61137 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2JONUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 09:20:15 -0400
MIME-Version: 1.0
In-Reply-To: <87r4p0417r.fsf@devron.myhome.or.jp>
References: <1349598764-3252-1-git-send-email-linkinjeon@gmail.com>
	<877gqu90x1.fsf@devron.myhome.or.jp>
	<CAKYAXd_vWenGBzRoh9cv_Qet_znyPhe_2QpBp29mZJqqoKEFgg@mail.gmail.com>
	<87391i8mny.fsf@devron.myhome.or.jp>
	<CAKYAXd8xdb+t5ZTKtg0W7VjCuuJfYFDDFMwUZNRN8f8fcttDxQ@mail.gmail.com>
	<87r4p271uw.fsf@devron.myhome.or.jp>
	<CAKYAXd-zV+SH4-CqYCxK1Ph34+5CKPKrbG9_rnH1c9rD_wcsng@mail.gmail.com>
	<87r4p0417r.fsf@devron.myhome.or.jp>
Date: Mon, 15 Oct 2012 22:20:14 +0900
Message-ID: <CAKYAXd9Lqw5fwuaY7gEJiFK2qYSRW-WNVP1cEjc1sbJqBLLt+g@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] fat (exportfs): rebuild directory-inode if
 fat_dget() fails
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

2012/10/15 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>> OK, I think I got where is wrong. If it is the subdir of rootdir,
>>> fat_dget() should get the inode of root?
>> That is correct. Whenever fat_dget() is called for sub-directories
>> which is in root folder, we assign root inode as parent inode.
>>>
>>> So, I guess if parent_logstart == 0, it is BUG().
>> Would you explain more why you think it is BUG() ?
>
> Because root dentry is never expired until umount. So, fat_dget()
> shouldn't never fail to get inode for subdir of rootdir. Otherwise,
> "stale_rw" will not be working in the case even if there is cache.
>
> I.e. I think we don't need to check parent_logstart == 0.
Yes, You're right.  I found this condition is really not needed when I
check again.
I will remove this code.
Thanks OGAWA!
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
