Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab0HBLyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 07:54:54 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56451 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab0HBLyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 07:54:53 -0400
Message-ID: <4C56B20A.80306@kernel.dk>
Date: Mon, 02 Aug 2010 13:54:50 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Heinz Diehl <htd@fancy-poultry.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq-iosched: don't allow aliased requests to starve 
 others
References: <x49zkxuaymb.fsf@segfault.boston.devel.redhat.com>	<20100724080459.GA6500@fancy-poultry.org> <4C4ABA55.2000204@kernel.dk> <x49iq42gz65.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49iq42gz65.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-26 15:17, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 07/24/2010 10:04 AM, Heinz Diehl wrote:
>>> On 14.07.2010, Jeff Moyer wrote: 
>>>
>>>> Comments, as always, are welcome.
>>>
>>> This patch, applied to 2.6.35-rc6, increases desktop interactivity
>>> _NOTICEABLY_ on my quadcore machine, and the machine stays rock-stable.
>>> I have now tested this patch with the latest 2.6.35-rc kernels over 
>>> 1 week.
>>>
>>> Unfortunately, I can't provide some testing results which makes this
>>> statement more objective, but I'll do some synthetic testing in the next
>>> days.
>>
>> It is extremely unlikely that this patch will have any impact on
>> "normal" workloads. To even hit a code path where it would make a
>> difference, you would need to use O_DIRECT IO, otherwise you cannot have
>> aliases in the IO scheduler.
> 
> I agree that it shouldn't help normal workloads at all.  I do think
> there is one other case where you can get aliases: doing I/O both
> through the file system and the underlying device.  However, that's
> obviously a bad idea (and maybe open_bdev_exclusive will keep that from
> happening?).

That's correct, you could construct such a test case since you would
get page cache synchronization from different mappings. But again,
not something that the casual user would run into :-)

Exclusive opens only guard against each other, not against "normal"
opens.

-- 
Jens Axboe

