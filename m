Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab2JMPOq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 11:14:46 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34945 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab2JMPOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 11:14:45 -0400
MIME-Version: 1.0
In-Reply-To: <87391i8mny.fsf@devron.myhome.or.jp>
References: <1349598764-3252-1-git-send-email-linkinjeon@gmail.com>
	<877gqu90x1.fsf@devron.myhome.or.jp>
	<CAKYAXd_vWenGBzRoh9cv_Qet_znyPhe_2QpBp29mZJqqoKEFgg@mail.gmail.com>
	<87391i8mny.fsf@devron.myhome.or.jp>
Date: Sun, 14 Oct 2012 00:14:43 +0900
Message-ID: <CAKYAXd8xdb+t5ZTKtg0W7VjCuuJfYFDDFMwUZNRN8f8fcttDxQ@mail.gmail.com>
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

2012/10/13 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> 2012/10/13 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
>>> Namjae Jeon <linkinjeon@gmail.com> writes:
>>>
>>>> +     if (!fat_get_dotdot_entry(child_dir->d_inode, &dotdot_bh, &de)) {
>>>> +             parent_logstart = fat_get_start(sbi, de);
>>>>               parent_inode = fat_dget(sb, parent_logstart);
>>>> +             if (parent_inode || sbi->options.nfs != FAT_NFS_NOSTALE_RO)
>>>> +                     goto out;
>>>> +             if (!parent_logstart)
>>>> +                     /*logstart of dotdot entry is zero if
>>>> +                     * if the directory's parent is root
>>>> +                     */
>>>> +                     parent_inode = sb->s_root->d_inode;
>>>
>>> get_parent() should not be called for root dir, right?
>> Yes.
>
> Ah, actual question was - subdir of root can be passed to this? I guess
> it is possible...
Yes, you're right.

Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
