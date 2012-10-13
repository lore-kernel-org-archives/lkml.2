Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab2JMOfx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 10:35:53 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:50311 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab2JMOfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 10:35:52 -0400
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
Date: Sat, 13 Oct 2012 23:35:45 +0900
In-Reply-To: <CAKYAXd_vWenGBzRoh9cv_Qet_znyPhe_2QpBp29mZJqqoKEFgg@mail.gmail.com>
	(Namjae Jeon's message of "Sat, 13 Oct 2012 23:03:31 +0900")
Message-ID: <87391i8mny.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> 2012/10/13 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
>> Namjae Jeon <linkinjeon@gmail.com> writes:
>>
>>> +     if (!fat_get_dotdot_entry(child_dir->d_inode, &dotdot_bh, &de)) {
>>> +             parent_logstart = fat_get_start(sbi, de);
>>>               parent_inode = fat_dget(sb, parent_logstart);
>>> +             if (parent_inode || sbi->options.nfs != FAT_NFS_NOSTALE_RO)
>>> +                     goto out;
>>> +             if (!parent_logstart)
>>> +                     /*logstart of dotdot entry is zero if
>>> +                     * if the directory's parent is root
>>> +                     */
>>> +                     parent_inode = sb->s_root->d_inode;
>>
>> get_parent() should not be called for root dir, right?
> Yes.

Ah, actual question was - subdir of root can be passed to this? I guess
it is possible...
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
