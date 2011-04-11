Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab1DKIxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 04:53:43 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58514 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438Ab1DKIxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:53:43 -0400
Message-ID: <4DA2C197.1060402@kernel.dk>
Date: Mon, 11 Apr 2011 10:53:43 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: block: ioc->refcount accessed twice in put_io_context()?
References: <1302442907.5366.15.camel@t41.thuisdomein>	 <BANLkTi=ma7WDo9=kKwZGwuhi=qUEB8EW5g@mail.gmail.com>	 <4DA2B0FB.8020302@kernel.dk> <1302511553.29915.12.camel@t41.thuisdomein>
In-Reply-To: <1302511553.29915.12.camel@t41.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-11 10:45, Paul Bolle wrote:
> On Mon, 2011-04-11 at 09:42 +0200, Jens Axboe wrote:
>> Indeed, there is nothing wrong with having the BUG_ON() there first and
>> doing the decrement later.
> 
> But what makes sure then that refcount doesn't get decremented by
> something else just before the atomic_long_dec_and_test() call. Eg:
> 
> Thread 1			Thread 2
> ========                        ========
> BUG_ON()
> 				BUG_ON()
> atomic_long_dec_and_test()
> 				atomic_long_dec_and_test()
> 				/* refcount drops to -1 here */
> 
> Or is this not possible?

It's not possible, if it was then that would be the bug - someone
releasing a reference to the ioc that they do not hold. And that is what
the BUG_ON() is there to catch, not a race between two threads.

-- 
Jens Axboe

