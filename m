Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab2DNKiA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 06:38:00 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:49025 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab2DNKh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 06:37:59 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: dedekind1@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: Re: [PATCH v2 3/4] fat: mark superblock as dirty less often
References: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
	<1334326795-2446-4-git-send-email-dedekind1@gmail.com>
	<87k41ihdub.fsf@devron.myhome.or.jp> <1334399070.2263.3.camel@koala>
Date: Sat, 14 Apr 2012 19:37:56 +0900
In-Reply-To: <1334399070.2263.3.camel@koala> (Artem Bityutskiy's message of
	"Sat, 14 Apr 2012 13:24:17 +0300")
Message-ID: <877gxiha4b.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <dedekind1@gmail.com> writes:

> On Sat, 2012-04-14 at 18:17 +0900, OGAWA Hirofumi wrote:
>> Artem Bityutskiy <dedekind1@gmail.com> writes:
>> 
>> > From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>> >
>> > This patch is a preparation for further changes. It touches few functions
>> > in fatent.c and prevents them from marking the superblock as dirty
>> > unnecessarily often. Namely, instead of marking it as dirty in the internal
>> > tight loops - do it only once at the end of the functions. And instead of
>> > marking it as dirty while holding the FAT table lock, do it
>> > outside the lock.
>> >
>> > The reason for this patch is that marking the superblock as dirty will soon
>> > become a little bit heavier operation, so it is cleaner to do this
>> > only when it
>> > is necessary.
>> 
>> For it, please use local variable like,
>> 
>> 
>> {
>>        	int fsinfo_dirty = 0;
>> 
>> 	while (1) {
>>         	change free_clusters
>>                 fsinfo_dirty = 1;
>>         }
>> 
>>         if (fsinfo_dirty)
>>         	mark_fsinfo_dirty()
>> }
>> 
>> instead of dirty it always.
>
> But could you please explain why do we need an extra variable? What is
> the problem with doing all our FAT table changes and then marking the
> FSINFO as dirty?

Above example may not be proper. I meant please dirty FSINFO only if
necessary. Your patch seems to be dirty even if code didn't change
FSINFO.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
