Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab1FSXCC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 19:02:02 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35133 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab1FSXCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 19:02:00 -0400
Date: Sun, 19 Jun 2011 16:01:50 -0700 (PDT)
Message-Id: <20110619.160150.1199476848151993579.davem@davemloft.net>
To: andi@firstfloor.org
Cc: torvalds@linux-foundation.org, mroos@linux.ee,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: reorganized struct inode results in unaligned accesses
From: David Miller <davem@davemloft.net>
In-Reply-To: <m2boxtfo0d.fsf@firstfloor.org>
References: <alpine.SOC.1.00.1106191927250.4844@math.ut.ee>
	<BANLkTiktb6GS7fcHRRgC=bHJjz8k0hVmPw@mail.gmail.com>
	<m2boxtfo0d.fsf@firstfloor.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 19 Jun 2011 16:01:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Sun, 19 Jun 2011 15:35:30 -0700

> Linus Torvalds <torvalds@linux-foundation.org> writes:
>>
>> Dang. I guess it needs to be made "unsigned long" again. Which is a
>> shame, because we only use a couple of bits from there, and "struct
>> inode" really is much too big already.
> 
> In the past it was usually enough to just align it to alignof(unsigned
> long), not actually make it long. struct page went through this
> a long time ago.

Hmmm, can this scheme actually work out properly on both big and
little endian?  Because endianness determines whether the bits start
in the "lower addressed" 32-bit word or the "higher addressed" 32-bit
word.

If this trick is being attempted elsewhere, I think it could perhaps
account for some strange bugs :-)
