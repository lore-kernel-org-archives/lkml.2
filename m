Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1AGNI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 08:08:26 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56738 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab1AGNI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 08:08:26 -0500
Message-ID: <4D2710DC.9050908@kernel.dk>
Date: Fri, 07 Jan 2011 14:10:52 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Yuehai Xu <yuehaixu@gmail.com>
CC: linux-kernel@vger.kernel.org, cmm@us.ibm.com, rwheeler@redhat.com,
        vgoyal@redhat.com, czoccolo@gmail.com, yhxu@wayne.edu
Subject: Re: Who does determine the number of requests that can be serving
  simultaneously in a storage?
References: <AANLkTimHE35jUOY6Lhd7OnATSD6BeB4poUosaQ+bR61i@mail.gmail.com>	<4D26CCEE.4070508@kernel.dk> <AANLkTingF8jK2Lppng+MCeszB=KFEsqs9uRqBn0Uhdh8@mail.gmail.com>
In-Reply-To: <AANLkTingF8jK2Lppng+MCeszB=KFEsqs9uRqBn0Uhdh8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please don't top-post, thanks.

On 2011-01-07 14:00, Yuehai Xu wrote:
> I add a tracepoint so that I can get nr_sorted and in_flight[0/1] of
> request_queue when request is completed, I consider nr_sorted as the
> number of pending requests and in_flight[0/1] represent the number
> serving in the storage. Does these two parameters stand for what I
> mean?

nr_sorted is the number of requests that reside in the IO scheduler.
That means requests that are not on the dispatch list yet. in_flight is
the number that the driver is currently handling. So I think your
understanding is correct.

If you look at where you added your trace point, there are already a
trace point right there. I would recommend that you use blktrace, and
then use btt to parse it. That will give you all sorts of queueing
information.

> The test benchmark I use is postmark which simulates the email server
> system, over 90% requests are small random write. The storage is Intel
> M SSD. Generally, I think the number of in_flight[0/1] should be much
> greater than 1, but the result shows that this value is almost 1 no
> matter what I/O scheduler(CFQ/DEADLINE/NOOP) or
> filesystem(EXT4/EXT3/BTRFS) it is. Is it normal?

Depends, do you have more requests pending in the IO scheduler? I'm
assuming you already verified that NCQ is active and working for your
drive.


-- 
Jens Axboe

