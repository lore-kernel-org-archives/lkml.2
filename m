Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab1DKIp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 04:45:56 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:36497 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab1DKIpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:45:54 -0400
Subject: Re: block: ioc->refcount accessed twice in put_io_context()?
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
Date: Mon, 11 Apr 2011 10:45:24 +0200
In-Reply-To: <4DA2B0FB.8020302@kernel.dk>
References: <1302442907.5366.15.camel@t41.thuisdomein>
	 <BANLkTi=ma7WDo9=kKwZGwuhi=qUEB8EW5g@mail.gmail.com>
	 <4DA2B0FB.8020302@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.0 (3.0.0-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1302511553.29915.12.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 09:42 +0200, Jens Axboe wrote:
> Indeed, there is nothing wrong with having the BUG_ON() there first and
> doing the decrement later.

But what makes sure then that refcount doesn't get decremented by
something else just before the atomic_long_dec_and_test() call. Eg:

Thread 1			Thread 2
========                        ========
BUG_ON()
				BUG_ON()
atomic_long_dec_and_test()
				atomic_long_dec_and_test()
				/* refcount drops to -1 here */

Or is this not possible?

> If the BUG_ON() is hit, then it's not a race
> conditon - it's a plain bug in the code.

I haven't hit that BUG_ON(), I'm just wondering why an atomic variable
is accessed twice in the same function.


Paul Bolle

