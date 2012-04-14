Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab2DNKgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 06:36:17 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:49020 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab2DNKgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 06:36:15 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: dedekind1@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: Re: [PATCH v2 4/4] fat: switch to fsinfo_inode
References: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
	<1334326795-2446-5-git-send-email-dedekind1@gmail.com>
	<87fwc6hazv.fsf@devron.myhome.or.jp> <1334399379.2263.8.camel@koala>
Date: Sat, 14 Apr 2012 19:36:12 +0900
In-Reply-To: <1334399379.2263.8.camel@koala> (Artem Bityutskiy's message of
	"Sat, 14 Apr 2012 13:29:37 +0300")
Message-ID: <87bomuha77.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <dedekind1@gmail.com> writes:

>> Hm, does this guarantee to flush FSINFO at umount?
>
> Of course, and I checked it. It is just a dirty inode. If you do not
> worry that any other inode won't get written-beck, then you should not
> worry about this one.
>
>> FSINFO is last part of data dependency. I.e. inode change can dirty
>> FSINFO. So, FSINFO has to be flushed after normal inodes.
>
> Sorry, I do not see how this can be true. You have a just bunch of dirty
> inodes, and it does not matter in which order you flush them. See
> __fat_write_inode() - it does not change the FAT table and does not
> affect the FSINFO block.
>
> Besides, the _current_ code first writes out FSINFO, because VFS calls
> ->sync_fs() first, then it starts writing back, then VFS calls
> ->sync_fs() for the second time.

Common case is delayed allocation though, in the case of FATfs, it would
be only truncate by last iput().
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
