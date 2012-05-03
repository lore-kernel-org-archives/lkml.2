Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab2ECGzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 02:55:42 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40423 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab2ECGzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 02:55:41 -0400
Date: Thu, 03 May 2012 02:54:27 -0400 (EDT)
Message-Id: <20120503.025427.1277785208536786257.davem@davemloft.net>
To: hpa@zytor.com
Cc: torvalds@linux-foundation.org, npiggin@gmail.com, jana@saout.de,
        jlbec@evilplan.org, linux-kernel@vger.kernel.org
Subject: Re: Oops with DCACHE_WORD_ACCESS and ocfs2, autofs4
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FA227FB.7060709@zytor.com>
References: <CAPa8GCANv=-c7HsYvDqM+8JqJq6Gr9muxAivU2Ni16x9Ru5EXw@mail.gmail.com>
	<CA+55aFwPgWqCPA=ao6XmZy56PaJZ4WC+hOZ_CHGWpo_zO425VA@mail.gmail.com>
	<4FA227FB.7060709@zytor.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 02 May 2012 23:54:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 02 May 2012 23:38:51 -0700

> On 05/02/2012 10:57 PM, Linus Torvalds wrote:
>> 
>> There are multiple ways to fix this, including just marking that
>> unaligned word access as being able to take an exception, but I had
>> hoped to avoid having to do that. There are alternatives, like always
>> padding allocations up by 7 bytes, but those are nasty too. So I'd
>> like to understand what triggers this for Jana, it's possible we can
>> just work around that particular issue.
>> 
> 
> Can we do the trick of aligning the pointer and ignoring the start?
> That would allow even architectures that don't have unaligned accesses
> to work, too.

Doing that would flub the hash computation.
