Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1EWQbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:31:38 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56936 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab1EWQbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:31:37 -0400
Message-ID: <4DDA8BE7.3090407@kernel.dk>
Date: Mon, 23 May 2011 18:31:35 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Tony Luck <tony.luck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: move bd_set_size() above rescan_partitions() in
 __blkdev_get()
References: <BANLkTin3T8msxSSbTLJOvC5WLNFGspPEcg@mail.gmail.com> <20110519093026.GA627@htj.dyndns.org> <BANLkTinP7txzE2U+8qnJR2JVcGpGybnLrA@mail.gmail.com> <20110523112454.GA17547@htj.dyndns.org> <BANLkTinppQGEyiERCjFG0LYgTZGXbtApBw@mail.gmail.com>
In-Reply-To: <BANLkTinppQGEyiERCjFG0LYgTZGXbtApBw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-23 17:51, Linus Torvalds wrote:
> On Mon, May 23, 2011 at 4:24 AM, Tejun Heo <tj@kernel.org> wrote:
>>
>> 02e352287a4 (block: rescan partitions on invalidated devices on
>> -ENOMEDIA too) relocated partition rescan above explicit bd_set_size()
>> to simplify condition check.  As rescan_partitions() does its own bdev
>> size setting, this doesn't break anything; however,
>> rescan_partitions() prints out the following messages when adjusting
>> bdev size, which can be confusing.
> 
> Applied,

OK, added it when Tejun sent it as well, JFYI.

-- 
Jens Axboe

