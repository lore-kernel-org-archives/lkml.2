Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab2IJOAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:00:19 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:37158 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab2IJOAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 10:00:16 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: "Steven J. Magnani" <steve@digidescorp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        bfields@fieldses.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
References: <1346774264-8031-1-git-send-email-linkinjeon@gmail.com>
	<20120904161747.GJ23464@ZenIV.linux.org.uk>
	<CAKYAXd_wTxqbC-UxYimCkZtvSddx=f3FG0hoiEY_doMjoxkKog@mail.gmail.com>
	<87harc34d9.fsf@devron.myhome.or.jp>
	<CAKYAXd-8aztDe1QiFT=NSQX8J+h_FM+cAWwo+Q+fUQHpNGTctw@mail.gmail.com>
	<87y5knz6l5.fsf@devron.myhome.or.jp>
	<CAKYAXd_mxq26bhRYd-YM9OBjYMO12TD4wHxm6PqHBLjgGFHaZg@mail.gmail.com>
	<CAKYAXd-QtSYy4SQErVTXrxcv=YhFzhOm3PKpj=HoZKmpAG7vGQ@mail.gmail.com>
	<1347020137.2223.13.camel@iscandar.digidescorp.com>
	<87oblfpmnb.fsf@devron.myhome.or.jp>
	<87k3w3ph8d.fsf@devron.myhome.or.jp>
	<CAKYAXd-k4yVV3h8k0kcFMsyGnOVckYRjXi8fkZrLtjuWVi7Eqw@mail.gmail.com>
Date: Mon, 10 Sep 2012 23:00:02 +0900
In-Reply-To: <CAKYAXd-k4yVV3h8k0kcFMsyGnOVckYRjXi8fkZrLtjuWVi7Eqw@mail.gmail.com>
	(Namjae Jeon's message of "Mon, 10 Sep 2012 21:03:46 +0900")
Message-ID: <87har6kmfx.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> Yes, It is  true(current VFAT of -mm tree is not stable). Although we
> set lookupcache=none while mounting, ESTALE error can still occur in
> rename case.
> So there still remain ESTALE error issue from rename case on current -mm tree.
> plz See the step as the following
> 1. on client write to file.
> 2. on client, move/rename file.
> 3. on server, do drop_caches. etc to somehow evict indoe number so
> that it gets new inode number
> 4. on client, resume the program to write to file. write will fail
> (write: Stale NFS file handle)

Since rename() will be disabled on stable ino patches, this will be
unfixable, so rather maybe it is worse.

Did you checked why it returns -ESTALE?  Or rename() issue also is
unfixable on -mm?

> And ......
> If we mount NFS with lookupcache=none, FAT file lookup performance is
> severely dropped.
> LOOKUP performance is very poor on slow network and slow device. I do
> not recommend to disable lookup cache on NFS.
> And that is why reconstructing inode is already implemented in other
> filesystem (e.g. EXT4, XFS etc..)
> Currently lookupcache is enabled by default in NFS, it means users
> already have disclosed and experienced ESTALE issues on NFS over VFAT.
>
> I agree wth you to make NFS over VFAT read-only filesystem to avoid all issues.
> Eventually we can make it writable with rename limitation when we
> decide that it is pretty stable in mainline.
> So, I suggest to add 'nfs_ro' mount option instead of 'nfs' option.

-mm seems to be more stable than I thought. As he said, sounds like
rename() is an only known issue on -mm, true?

And are you tried https://lkml.org/lkml/2012/6/29/381 patches? It sounds
like to improve performance by enabling lookupcache. I'd like to be
knowing the critical reason we have to replace it.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
