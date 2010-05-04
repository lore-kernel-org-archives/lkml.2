Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531Ab0EDSiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:38:05 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:50936 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab0EDSiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:38:03 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Fredrick Prashanth John Berchmans <fredrickprashanth@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: nfs accesses of FAT fs folders causes deadlock on lock_super
References: <x2gd4f60c3c1005032259p8be864bcucff91618016a0eb@mail.gmail.com>
	<20100504103232.GA25054@infradead.org>
	<m2id4f60c3c1005040705v2e46547axad496769d4d4dbe8@mail.gmail.com>
Date: Wed, 05 May 2010 03:37:56 +0900
In-Reply-To: <m2id4f60c3c1005040705v2e46547axad496769d4d4dbe8@mail.gmail.com>
	(Fredrick Prashanth John Berchmans's message of "Tue, 4 May 2010
	07:05:34 -0700")
Message-ID: <87r5lry0l7.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fredrick Prashanth John Berchmans <fredrickprashanth@gmail.com> writes:

> On Tue, May 4, 2010 at 3:32 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Mon, May 03, 2010 at 10:59:42PM -0700, Fredrick Prashanth John Berchmans wrote:
>>> The box was running kernel version 2.6.27.10.
>>> But I think the FAT code has not changed much.
>>
>> But the nfsd code has and now doesn't call lookup from the filldir
>> callback anymore.
>>
>>
>
> Ah..I just noticed the changes in the nfsd code.
>
> But in 2.6.27.10, can it be fixed by removing the lock_super in the
> vfat_lookup.?

Basically, yes.

> Because I saw some discussions long back of regressions due to
> replacing lock_kernel by lock_super in FAT code.

Yes. Current way is ultra safer side to convert BKL. Another side was
just to remove BKL. However, at least for now, we are using current way.

So, if current way had a problem, just remove it instead of trying to
fix (then, review).

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
