Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab2ECHDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 03:03:53 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40494 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2ECHDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 03:03:52 -0400
Date: Thu, 03 May 2012 03:02:42 -0400 (EDT)
Message-Id: <20120503.030242.2286535518319226860.davem@davemloft.net>
To: hpa@zytor.com
Cc: torvalds@linux-foundation.org, npiggin@gmail.com, jana@saout.de,
        jlbec@evilplan.org, linux-kernel@vger.kernel.org
Subject: Re: Oops with DCACHE_WORD_ACCESS and ocfs2, autofs4
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FA22C75.6010001@zytor.com>
References: <4FA227FB.7060709@zytor.com>
	<20120503.025427.1277785208536786257.davem@davemloft.net>
	<4FA22C75.6010001@zytor.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 03 May 2012 00:02:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 02 May 2012 23:57:57 -0700

> On 05/02/2012 11:54 PM, David Miller wrote:
>>>
>>> Can we do the trick of aligning the pointer and ignoring the start?
>>> That would allow even architectures that don't have unaligned accesses
>>> to work, too.
>> 
>> Doing that would flub the hash computation.
> 
> I guess the shifts would be to expensive?

Yes, barrel-shifting (if that's your idea) would negate much of the
gain from the optimization.

Actually, thinking some more, a barrel-shifting loop would have the
same problem the current code has.  You don't know if you are at the
end of the string until you do the tests on the word.  But if you're
at the end of the page, you need to somehow elide that extra load
to get the word you're going to barrel-shift into the previous word.

