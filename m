Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab0HCMsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 08:48:00 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40689 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062Ab0HCMr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 08:47:58 -0400
Message-ID: <4C580FFF.2000605@kernel.dk>
Date: Tue, 03 Aug 2010 14:47:59 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCHv6 00/15] kill unnecessary bdi wakeups + cleanups
References: <1280057365-10297-1-git-send-email-dedekind1@gmail.com>	 <4C580B1C.3020409@kernel.dk> <1280839036.15689.8.camel@localhost>
In-Reply-To: <1280839036.15689.8.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-03 14:37, Artem Bityutskiy wrote:
> On Tue, 2010-08-03 at 14:27 +0200, Jens Axboe wrote:
>> On 2010-07-25 13:29, Artem Bityutskiy wrote:
>>> Hi,
>>>
>>> here is v6 of the patch series which clean-ups bdi threads and substantially
>>> lessens amount of unnecessary kernel wake-ups, which is very important on
>>> battery-powered devices.
>>>
>>> This patch-set is also available at:
>>> git://git.infradead.org/users/dedekind/misc-2.6.git flushers_v6
>>
>> Thanks Artem, for sticking around long enough to get this into
>> shape. I have finally merged it.
> 
> Thanks, but
> 
>>> 1. Use 'spin_lock_bh' for the 'bdi->wb_lock' (changed patch N12)
>>
>> I'd rather not, question is how to avoid it. Either just wakeup the
>> default thread, or punt the lock-and-check bdi->wb.task to a thread.
> 
> you merged this change, do you want me to send a separate patch which
> undo the 'spin_lock_bh' change? I'll think about how to avoid this and
> come back.

Yes, it's not a huge thing, but it would be nice to get rid of. So I
figured it was better to merge it and not have you respin the series yet
again.

-- 
Jens Axboe

