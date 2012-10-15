Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab2JOH5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 03:57:20 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:50787 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab2JOH5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 03:57:19 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v4 3/4] fat (exportfs): rebuild directory-inode if fat_dget() fails
References: <1349598764-3252-1-git-send-email-linkinjeon@gmail.com>
	<877gqu90x1.fsf@devron.myhome.or.jp>
	<CAKYAXd_vWenGBzRoh9cv_Qet_znyPhe_2QpBp29mZJqqoKEFgg@mail.gmail.com>
	<87391i8mny.fsf@devron.myhome.or.jp>
	<CAKYAXd8xdb+t5ZTKtg0W7VjCuuJfYFDDFMwUZNRN8f8fcttDxQ@mail.gmail.com>
	<87r4p271uw.fsf@devron.myhome.or.jp>
	<CAKYAXd-zV+SH4-CqYCxK1Ph34+5CKPKrbG9_rnH1c9rD_wcsng@mail.gmail.com>
Date: Mon, 15 Oct 2012 16:57:12 +0900
In-Reply-To: <CAKYAXd-zV+SH4-CqYCxK1Ph34+5CKPKrbG9_rnH1c9rD_wcsng@mail.gmail.com>
	(Namjae Jeon's message of "Mon, 15 Oct 2012 16:28:30 +0900")
Message-ID: <87r4p0417r.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>> OK, I think I got where is wrong. If it is the subdir of rootdir,
>> fat_dget() should get the inode of root?
> That is correct. Whenever fat_dget() is called for sub-directories
> which is in root folder, we assign root inode as parent inode.
>>
>> So, I guess if parent_logstart == 0, it is BUG().
> Would you explain more why you think it is BUG() ?

Because root dentry is never expired until umount. So, fat_dget()
shouldn't never fail to get inode for subdir of rootdir. Otherwise,
"stale_rw" will not be working in the case even if there is cache.

I.e. I think we don't need to check parent_logstart == 0.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
