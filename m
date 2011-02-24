Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab1BXPUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 10:20:36 -0500
Received: from ist.d-labs.de ([213.239.218.44]:36340 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab1BXPUf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 10:20:35 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikhhuUZSryKsrb0LGuyux=zvGf+ncsNZXdj5Xeh@mail.gmail.com>
References: <E1PscUb-0004a3-Qi@pomaz-ex.szeredi.hu>
	<AANLkTikhhuUZSryKsrb0LGuyux=zvGf+ncsNZXdj5Xeh@mail.gmail.com>
Date: Thu, 24 Feb 2011 16:20:31 +0100
Message-ID: <AANLkTim6az_pR53LWzwP_KTe_=31awOKanYUZd_eJQkZ@mail.gmail.com>
Subject: Re: [PATCH] block: fix refcounting in BLKBSZSET
From: Florian Mickler <florian@mickler.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Mike Snitzer <snitzer@redhat.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, kovariadam@gmail.com, rjw@sisk.pl,
        tj@kernel.org, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>, psusi@cfl.rr.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/2/24 Mike Snitzer <snitzer@redhat.com>:
> On Thu, Feb 24, 2011 at 9:48 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> [and lkml cc-d too]
>>
>> This fixes bug 29202 in the 2.6.38 regression list.
>
> It looks like this may fix bug 29792 too.
>
> Mike
>
>> Please apply.
>>
>> Thanks,
>> Miklos
>>
>> ----
>> Subject: block: fix refcounting in BLKBSZSET
>>
>> From: Miklos Szeredi <mszeredi@suse.cz>
>>
>> Adam Kovari and others reported that disconnecting an USB drive with
>> an ntfs-3g filesystem would cause "kernel BUG at fs/inode.c:1421!" to
>> be triggered.
>>
>> The BUG could be traced back to ioctl(BLKBSZSET), which would
>> erroneously decrement the refcount on the bdev.  This is because
>> blkdev_get() expects the refcount to be already incremented and either
>> returns success or decrements the refcount and returns an error.
>>
>> The bug was introduced by e525fd89 (block: make blkdev_get/put()
>> handle exclusive access), which didn't take into account this behavior
>> of blkdev_get().
>>

putting a small reference to the bug reports in the changelog
(it is enough to have the bugnumber in there somewhere, grepping for 5
digit numbers doesn't turn up all too many false positives... )
helps with keeping track of the regressions and letting people know
that a fix / change was posted.

A line like "This fixes bug 29202." is sufficient.

Pasting a complete link( i.e.
https://bugzilla.kernel.org/show_bug.cgi?id=29202 ) would even allow
for an automated note in the bugzilla when it hits Linus tree.

Cheers,
Flo
