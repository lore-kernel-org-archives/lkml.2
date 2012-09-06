Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab2IFGqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 02:46:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34369 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2IFGqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 02:46:07 -0400
MIME-Version: 1.0
In-Reply-To: <87harc34d9.fsf@devron.myhome.or.jp>
References: <1346774264-8031-1-git-send-email-linkinjeon@gmail.com>
	<20120904161747.GJ23464@ZenIV.linux.org.uk>
	<CAKYAXd_wTxqbC-UxYimCkZtvSddx=f3FG0hoiEY_doMjoxkKog@mail.gmail.com>
	<87harc34d9.fsf@devron.myhome.or.jp>
Date: Thu, 6 Sep 2012 15:46:06 +0900
Message-ID: <CAKYAXd-8aztDe1QiFT=NSQX8J+h_FM+cAWwo+Q+fUQHpNGTctw@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        bfields@fieldses.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/5 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> In this long discusstion about the FAT acceptance over NFS, our belief
>> is still that the objective should be to reduce errors as much as
>> possible and then if there are certain scenarios - at least that could
>> be highlighted as a limitation in Documentation instead of completely
>> discarding the usage of FAT over NFS.  So how about puttting rename
>> scenario as a limitation ? In ideal scenario how many times this is
>> going to happen ?
>
> My understanding of your patches is to introduce the silent corruption
> bug by getting wrong location via ino on some cases, instead of
> ESTALE. And make surprise to userland by change ino.
>
> Why is it safe to change ino? If you are saying to remove the changing
> ino on rename, how handle the case of collision?
Yes, agreed this would lead to collision. So, If we are choosing
'i_pos' as inode
number, We need to have a mechanism to avoid this 'i_pos' being reused.

We can have one thing over here. As a part of avoidance for such scenarios -
We can return EBUSY for this rename operation. i.e., If the inode is being
referenced then in such cases it makes sense to return EBUSY over NFS and
 forcus on the large part of the solution which is making FAT stable.

Let me know your opinion.

Thanks OGAWA.

> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
